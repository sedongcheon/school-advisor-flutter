import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'sse_event.dart';

/// `text/event-stream` 바이트 스트림을 [SseEvent] 스트림으로 변환한다.
///
/// 백엔드(`/api/v1/chat`) 프레임 포맷:
/// ```text
/// event: <name>\n
/// data: <json>\n
/// \n
/// ```
///
/// - chunk 가 라인 중간에서 잘려 도착해도 정상 누적
/// - 알 수 없는 `event:` 이름은 무시
/// - `data:` JSON 파싱 실패는 무시 (forward-compat)
Stream<SseEvent> decodeSseStream(Stream<List<int>> bytes) async* {
  final buffer = StringBuffer();

  // dio 의 ResponseBody.stream 은 실제로 Stream<Uint8List> 라 utf8.decoder 의
  // StreamTransformer<List<int>, String> 시그니처에 직접 못 붙는다. cast 로 풀어준다.
  await for (final chunk in bytes.cast<List<int>>().transform(utf8.decoder)) {
    buffer.write(chunk);
    final raw = buffer.toString();

    // 프레임 경계: 빈 줄(`\n\n` 또는 `\r\n\r\n`)
    var searchFrom = 0;
    while (true) {
      final boundary = _findFrameBoundary(raw, searchFrom);
      if (boundary == null) break;
      final frame = raw.substring(searchFrom, boundary.start);
      searchFrom = boundary.end;
      final event = _parseFrame(frame);
      if (event != null) yield event;
    }

    // 처리되지 않은 꼬리만 버퍼에 남긴다
    if (searchFrom > 0) {
      final leftover = raw.substring(searchFrom);
      buffer
        ..clear()
        ..write(leftover);
    }
  }

  // 스트림 끝에서 마지막 한 프레임이 boundary 없이 끝났을 가능성
  final tail = buffer.toString().trim();
  if (tail.isNotEmpty) {
    final event = _parseFrame(tail);
    if (event != null) yield event;
  }
}

class _Boundary {
  const _Boundary(this.start, this.end);
  final int start;
  final int end;
}

_Boundary? _findFrameBoundary(String s, int from) {
  final lf = s.indexOf('\n\n', from);
  final crlf = s.indexOf('\r\n\r\n', from);
  if (lf == -1 && crlf == -1) return null;
  if (lf == -1) return _Boundary(crlf, crlf + 4);
  if (crlf == -1) return _Boundary(lf, lf + 2);
  // 둘 다 발견되면 더 빠른 쪽
  return lf < crlf ? _Boundary(lf, lf + 2) : _Boundary(crlf, crlf + 4);
}

SseEvent? _parseFrame(String frame) {
  String? eventName;
  final dataLines = <String>[];

  for (final rawLine in const LineSplitter().convert(frame)) {
    final line = rawLine.trimRight();
    if (line.isEmpty || line.startsWith(':')) {
      // SSE 주석 라인(`:`) 또는 빈 줄은 무시
      continue;
    }
    final colon = line.indexOf(':');
    if (colon == -1) continue;
    final field = line.substring(0, colon);
    // `field: value` 의 첫 공백 한 글자는 표준상 제거
    var value = line.substring(colon + 1);
    if (value.startsWith(' ')) value = value.substring(1);

    switch (field) {
      case 'event':
        eventName = value;
      case 'data':
        dataLines.add(value);
      default:
        // id / retry 등 다른 필드는 무시
        break;
    }
  }

  if (eventName == null) return null;
  final dataRaw = dataLines.join('\n');
  Map<String, dynamic>? data;
  if (dataRaw.isNotEmpty) {
    try {
      final decoded = jsonDecode(dataRaw);
      if (decoded is Map<String, dynamic>) data = decoded;
    } on FormatException catch (e) {
      debugPrint('[sse] data JSON 파싱 실패: $e');
      return null;
    }
  }
  return _toEvent(eventName, data ?? const {});
}

SseEvent? _toEvent(String name, Map<String, dynamic> data) {
  switch (name) {
    case 'text':
      final content = data['content'];
      if (content is String) return SseEvent.text(content: content);
      return null;
    case 'citation':
      final raw = data['chunks'];
      if (raw is! List) return null;
      final chunks = <CitationChunk>[];
      for (final item in raw) {
        if (item is! Map) continue;
        final id = item['id'];
        final law = item['law'];
        if (id is! int || law is! String) continue;
        chunks.add(
          CitationChunk(id: id, law: law, url: item['url'] as String?),
        );
      }
      return SseEvent.citations(chunks: chunks);
    case 'done':
      final convId = data['conversation_id'];
      if (convId is! String) return null;
      final tokens = data['tokens'];
      int? input;
      int? output;
      if (tokens is Map) {
        input = tokens['input'] is int ? tokens['input'] as int : null;
        output = tokens['output'] is int ? tokens['output'] as int : null;
      }
      return SseEvent.done(
        conversationId: convId,
        model: data['model'] as String?,
        inputTokens: input,
        outputTokens: output,
      );
    case 'error':
      final code = data['code'];
      if (code is! String) return null;
      return SseEvent.error(code: code, message: data['message'] as String?);
    default:
      return null;
  }
}

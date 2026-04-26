import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/core/sse/sse_decoder.dart';
import 'package:school_advisor/core/sse/sse_event.dart';

Stream<List<int>> _bytes(List<String> chunks) async* {
  for (final c in chunks) {
    yield utf8.encode(c);
  }
}

void main() {
  group('decodeSseStream', () {
    test('정상 단일 텍스트 프레임을 디코딩한다', () async {
      const raw = 'event: text\ndata: {"content": "안녕하세요"}\n\n';
      final events = await decodeSseStream(_bytes([raw])).toList();

      expect(events, [const SseEvent.text(content: '안녕하세요')]);
    });

    test('chunk 가 라인 중간에서 잘려 도착해도 누적한다', () async {
      final events = await decodeSseStream(
        _bytes(['event: te', 'xt\ndata: {"con', 'tent": "학폭위"}\n', '\n']),
      ).toList();

      expect(events, [const SseEvent.text(content: '학폭위')]);
    });

    test('연속 프레임을 순서대로 emit 한다', () async {
      const raw =
          'event: text\n'
          'data: {"content": "첫번째"}\n'
          '\n'
          'event: text\n'
          'data: {"content": "두번째"}\n'
          '\n'
          'event: done\n'
          'data: {"conversation_id": "00000000-0000-0000-0000-000000000001", '
          '"model": "claude", "tokens": {"input": 10, "output": 20}}\n'
          '\n';
      final events = await decodeSseStream(_bytes([raw])).toList();

      expect(events, [
        const SseEvent.text(content: '첫번째'),
        const SseEvent.text(content: '두번째'),
        const SseEvent.done(
          conversationId: '00000000-0000-0000-0000-000000000001',
          model: 'claude',
          inputTokens: 10,
          outputTokens: 20,
        ),
      ]);
    });

    test('`data:` 의 선행 공백 1글자만 제거한다', () async {
      final a = await decodeSseStream(
        _bytes(['event: text\ndata:{"content":"x"}\n\n']),
      ).toList();
      final b = await decodeSseStream(
        _bytes(['event: text\ndata: {"content":"x"}\n\n']),
      ).toList();
      expect(a, b);
      expect(a.single, const SseEvent.text(content: 'x'));
    });

    test('알 수 없는 event 이름은 무시한다', () async {
      const raw =
          'event: ping\ndata: {}\n\n'
          'event: text\ndata: {"content":"hi"}\n\n';
      final events = await decodeSseStream(_bytes([raw])).toList();

      expect(events, [const SseEvent.text(content: 'hi')]);
    });

    test('error 이벤트의 code 를 추출한다', () async {
      const raw =
          'event: error\ndata: {"code":"quota_exceeded","message":"한도 초과"}\n\n';
      final events = await decodeSseStream(_bytes([raw])).toList();

      expect(events, [
        const SseEvent.error(code: 'quota_exceeded', message: '한도 초과'),
      ]);
    });

    test('citation 의 chunks 배열을 매핑한다', () async {
      const raw =
          'event: citation\n'
          'data: {"chunks":['
          '{"id":1,"law":"학폭예방법 제17조 제1항","url":"https://law.go.kr/x"},'
          '{"id":2,"law":"학폭예방법 시행령 제22조","url":null}'
          ']}\n'
          '\n';
      final events = await decodeSseStream(_bytes([raw])).toList();

      expect(events, [
        const SseEvent.citations(
          chunks: [
            CitationChunk(
              id: 1,
              law: '학폭예방법 제17조 제1항',
              url: 'https://law.go.kr/x',
            ),
            CitationChunk(id: 2, law: '학폭예방법 시행령 제22조'),
          ],
        ),
      ]);
    });

    test('CRLF 경계도 정상 처리한다', () async {
      const raw = 'event: text\r\ndata: {"content":"crlf"}\r\n\r\n';
      final events = await decodeSseStream(_bytes([raw])).toList();

      expect(events, [const SseEvent.text(content: 'crlf')]);
    });

    test('주석 라인(`:`)은 무시한다', () async {
      const raw = ': keep-alive\nevent: text\ndata: {"content":"k"}\n\n';
      final events = await decodeSseStream(_bytes([raw])).toList();

      expect(events, [const SseEvent.text(content: 'k')]);
    });
  });
}

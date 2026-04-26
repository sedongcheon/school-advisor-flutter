import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'sse_decoder.dart';
import 'sse_event.dart';

/// 백엔드의 `text/event-stream` POST 엔드포인트를 호출해 [SseEvent] 스트림으로 반환.
///
/// - `dio.post(...)` 의 `ResponseType.stream` 으로 raw byte 스트림을 받고
/// - [decodeSseStream] 으로 도메인 이벤트로 변환한다.
/// - 4xx 응답도 SSE 본문일 수 있으므로 일단 받은 뒤 디코더에 위임 (백엔드는
///   400 device_id_required 시에도 SSE 프레임으로 error 를 보냄).
class SseClient {
  const SseClient(this._dio);

  final Dio _dio;

  Stream<SseEvent> postStream(
    String path, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async* {
    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        path,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            if (headers != null) ...headers,
          },
          // 백엔드가 device_id_required 등으로 400 + SSE 본문을 줄 수 있으므로
          // 모든 status 를 일단 통과시키고 본문(error 프레임)을 디코더가 처리한다.
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (e) {
      debugPrint(
        '[sse] POST $path failed before stream: type=${e.type} '
        'status=${e.response?.statusCode} message=${e.message}',
      );
      rethrow;
    }

    final stream = response.data?.stream;
    if (stream == null) {
      debugPrint('[sse] POST $path returned null stream');
      return;
    }

    yield* decodeSseStream(stream);
  }
}

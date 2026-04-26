import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/core/http/device_id_interceptor.dart';

class _Capturer extends RequestInterceptorHandler {
  RequestOptions? captured;

  @override
  void next(RequestOptions options) {
    captured = options;
  }
}

void main() {
  test('요청 헤더에 X-Device-ID 가 부착된다', () {
    final sut = DeviceIdInterceptor('device-abc-123');
    final h = _Capturer();

    sut.onRequest(RequestOptions(path: '/x'), h);

    expect(h.captured?.headers['X-Device-ID'], 'device-abc-123');
  });
}

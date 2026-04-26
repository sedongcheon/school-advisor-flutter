import 'package:dio/dio.dart';

/// 모든 요청에 `X-Device-ID` 를 부착한다.
///
/// 비동기 로딩이 끝난 ID 만 받기 위해 생성 시점에 String 을 받는다.
/// (Riverpod 의 `deviceIdProvider` 가 await 한 값으로 인스턴스화)
class DeviceIdInterceptor extends Interceptor {
  DeviceIdInterceptor(this._deviceId);

  final String _deviceId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Device-ID'] = _deviceId;
    handler.next(options);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../env.dart';
import '../storage/device_id_provider.dart';
import 'device_id_interceptor.dart';
import 'error_interceptor.dart';

/// Device ID 부착 + 에러 변환 인터셉터가 끼워진 단일 Dio 인스턴스.
///
/// `deviceIdProvider` 를 watch 하므로, ID 가 준비되기 전엔 `AsyncLoading`.
/// 호출 측은 `ref.watch(dioProvider).when(...)` 으로 분기하거나,
/// `ref.read(dioProvider.future)` 로 awaited 인스턴스를 얻는다.
final dioProvider = FutureProvider<Dio>((ref) async {
  final deviceId = await ref.watch(deviceIdProvider.future);

  final dio =
      Dio(
          BaseOptions(
            baseUrl: Env.apiBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.addAll([
          DeviceIdInterceptor(deviceId),
          const ErrorInterceptor(),
          if (kDebugMode)
            LogInterceptor(
              requestBody: false,
              responseBody: false,
              requestHeader: true,
              responseHeader: false,
              logPrint: (obj) => debugPrint('[dio] $obj'),
            ),
        ]);

  return dio;
});

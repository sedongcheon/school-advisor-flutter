import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/dio_provider.dart';
import 'user_status_dto.dart';

abstract interface class UserRepository {
  Future<UserStatus> fetchStatus({CancelToken? cancelToken});
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserStatus> fetchStatus({CancelToken? cancelToken}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/api/v1/user/status',
      cancelToken: cancelToken,
    );
    return UserStatus.fromJson(res.data!);
  }
}

final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return UserRepositoryImpl(dio);
});

/// 채팅 송신 후 갱신되는 사용량 상태. AsyncNotifier 로 수동 새로고침.
final userStatusProvider =
    AsyncNotifierProvider<UserStatusNotifier, UserStatus?>(
      UserStatusNotifier.new,
    );

class UserStatusNotifier extends AsyncNotifier<UserStatus?> {
  @override
  Future<UserStatus?> build() async {
    return _fetch();
  }

  Future<UserStatus?> refresh() async {
    final next = await AsyncValue.guard(_fetch);
    state = next;
    return next.valueOrNull;
  }

  Future<UserStatus?> _fetch() async {
    final repo = await ref.read(userRepositoryProvider.future);
    return repo.fetchStatus();
  }
}

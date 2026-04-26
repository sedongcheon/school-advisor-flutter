import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 면책 동의 플래그를 SharedPreferences 에 영속화한다.
///
/// - 키: `disclaimer_accepted_v1` (버전 suffix 는 약관 개정 시 무효화 용도)
/// - 동의 전까지 라우터가 `/onboarding/disclaimer` 로 강제 이동시킨다.
const String disclaimerKey = 'disclaimer_accepted_v1';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final disclaimerAcceptedProvider =
    AsyncNotifierProvider<DisclaimerNotifier, bool>(DisclaimerNotifier.new);

class DisclaimerNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getBool(disclaimerKey) ?? false;
  }

  Future<void> accept() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(disclaimerKey, true);
    state = const AsyncData(true);
  }

  /// 디버그/테스트용. 일반 사용자 시나리오에서는 호출되지 않는다.
  @visibleForTesting
  Future<void> reset() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.remove(disclaimerKey);
    state = const AsyncData(false);
  }
}

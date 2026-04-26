import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/push/push_messaging_service.dart';
import '../../onboarding/application/disclaimer_notifier.dart'
    show sharedPreferencesProvider;

const String _notificationsEnabledKey = 'notifications_enabled_v1';

/// 사용자가 토글한 알림 활성화 상태. 시스템 권한 거부 시 false 로 강제 유지.
final notificationsEnabledProvider =
    NotifierProvider<NotificationsNotifier, bool>(NotificationsNotifier.new);

class NotificationsNotifier extends Notifier<bool> {
  @override
  bool build() {
    Future.microtask(_load);
    return false;
  }

  Future<void> _load() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final wasEnabled = prefs.getBool(_notificationsEnabledKey) ?? false;
    state = wasEnabled;
    // 이전에 사용자가 켰다면 앱 재시작 시 핸들러 자동 재등록
    // (시스템 권한이 살아있으면 다시 ON, 그 사이 OS 설정에서 거부됐으면 OFF 로 동기화)
    if (wasEnabled) {
      try {
        final svc = ref.read(pushMessagingServiceProvider);
        final ok = await svc.enable();
        if (!ok) {
          state = false;
          await prefs.setBool(_notificationsEnabledKey, false);
        }
      } on Object catch (e) {
        debugPrint('[push] auto-enable on launch failed: $e');
      }
    }
  }

  Future<bool> setEnabled(bool value) async {
    final svc = ref.read(pushMessagingServiceProvider);
    final prefs = await ref.read(sharedPreferencesProvider.future);
    if (value) {
      final ok = await svc.enable();
      if (!ok) {
        // 권한 거부됨 — 토글은 다시 off
        state = false;
        await prefs.setBool(_notificationsEnabledKey, false);
        return false;
      }
      state = true;
      await prefs.setBool(_notificationsEnabledKey, true);
      return true;
    } else {
      try {
        await svc.disable();
      } on Object catch (e) {
        debugPrint('[push] disable failed: $e');
      }
      state = false;
      await prefs.setBool(_notificationsEnabledKey, false);
      return true;
    }
  }
}

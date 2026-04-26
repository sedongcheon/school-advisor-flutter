import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/application/disclaimer_notifier.dart'
    show sharedPreferencesProvider;

/// 사용자 역할. 부팅 시점의 역할 선택 화면에서 결정된다.
enum UserRole {
  student('student', '학생'),
  guardian('guardian', '보호자'),
  teacher('teacher', '교사 · 전담기구');

  const UserRole(this.code, this.label);
  final String code;
  final String label;

  static UserRole? fromCode(String? code) {
    return switch (code) {
      'student' => UserRole.student,
      'guardian' => UserRole.guardian,
      'teacher' => UserRole.teacher,
      _ => null,
    };
  }
}

const String _userRoleKey = 'user_role_v1';

/// `null` = 아직 선택 안 함 (역할 선택 화면으로 진입해야 함).
final userRoleProvider = NotifierProvider<UserRoleNotifier, UserRole?>(
  UserRoleNotifier.new,
);

class UserRoleNotifier extends Notifier<UserRole?> {
  @override
  UserRole? build() {
    Future.microtask(_load);
    return null;
  }

  Future<void> _load() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    state = UserRole.fromCode(prefs.getString(_userRoleKey));
  }

  Future<void> set(UserRole role) async {
    state = role;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_userRoleKey, role.code);
  }

  /// 디버그/설정 — 역할 재선택을 강제한다.
  @visibleForTesting
  Future<void> reset() async {
    state = null;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_userRoleKey);
  }
}

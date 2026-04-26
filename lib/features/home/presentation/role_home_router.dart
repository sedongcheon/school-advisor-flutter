import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../role/application/user_role_notifier.dart';
import 'guardian_home_screen.dart';
import 'home_screen.dart';
import 'teacher_home_screen.dart';

/// `/` 진입점 — 영속화된 [UserRole] 에 따라 적절한 홈을 노출.
///
/// 라우터 redirect 가 이미 `userRole == null` 인 경우 역할 선택 화면으로
/// 보내므로, 여기 도달했다면 role 이 있다고 가정한다.
class RoleHomeRouter extends ConsumerWidget {
  const RoleHomeRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);
    return switch (role) {
      UserRole.student => const HomeScreen(),
      UserRole.guardian => const GuardianHomeScreen(),
      UserRole.teacher => const TeacherHomeScreen(),
      null => const HomeScreen(), // 안전 fallback (redirect 가 작동하기 전 한 프레임)
    };
  }
}

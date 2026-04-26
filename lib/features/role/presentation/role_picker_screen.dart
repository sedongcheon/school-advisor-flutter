import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../application/user_role_notifier.dart';

class RolePickerScreen extends ConsumerStatefulWidget {
  const RolePickerScreen({super.key});

  @override
  ConsumerState<RolePickerScreen> createState() => _RolePickerScreenState();
}

class _RolePickerScreenState extends ConsumerState<RolePickerScreen> {
  UserRole _selected = UserRole.student;

  static const _entries = <_RoleEntry>[
    _RoleEntry(
      role: UserRole.student,
      title: '학생',
      sub: '내가 직접 도움이 필요해요',
      icon: Icons.person_outline,
      accent: AppTokens.lPrimary,
      tint: AppTokens.lTileTint,
    ),
    _RoleEntry(
      role: UserRole.guardian,
      title: '보호자',
      sub: '자녀의 사안을 함께 살펴요',
      icon: Icons.people_outline,
      accent: AppTokens.lAccent,
      tint: Color(0xFFFAEAD0),
    ),
    _RoleEntry(
      role: UserRole.teacher,
      title: '교사 · 전담기구',
      sub: '학교에서 사안을 처리해요',
      icon: Icons.school_outlined,
      accent: Color(0xFF7A5A2E),
      tint: Color(0xFFF1ECE2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.lBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTokens.lHeroTop, AppTokens.lHeroBottom],
                      ),
                    ),
                    child: const Icon(
                      Icons.explore_outlined,
                      color: AppTokens.lPrimaryDeep,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    '어떤 분이세요?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTokens.lInk,
                      letterSpacing: -0.5,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '역할에 맞춰 화면과 도구를 보여드릴게요.\n나중에 설정에서 바꿀 수 있어요.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: AppTokens.lSub,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                itemCount: _entries.length,
                itemBuilder: (_, i) {
                  final e = _entries[i];
                  final selected = _selected == e.role;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = e.role),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTokens.lCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? e.accent : AppTokens.lLine,
                            width: selected ? 1.5 : 1,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: e.accent.withValues(alpha: 0.25),
                                    blurRadius: 22,
                                    offset: const Offset(0, 8),
                                    spreadRadius: -12,
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: e.tint,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Icon(e.icon, color: e.accent, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppTokens.lInk,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    e.sub,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppTokens.lSub,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: selected ? e.accent : Colors.transparent,
                                shape: BoxShape.circle,
                                border: selected
                                    ? null
                                    : Border.all(
                                        color: AppTokens.lLine,
                                        width: 1.5,
                                      ),
                              ),
                              child: selected
                                  ? const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await ref.read(userRoleProvider.notifier).set(_selected);
                    if (!context.mounted) return;
                    context.go(AppRoutes.home);
                  },
                  child: const Text('시작하기  →'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleEntry {
  const _RoleEntry({
    required this.role,
    required this.title,
    required this.sub,
    required this.icon,
    required this.accent,
    required this.tint,
  });
  final UserRole role;
  final String title;
  final String sub;
  final IconData icon;
  final Color accent;
  final Color tint;
}

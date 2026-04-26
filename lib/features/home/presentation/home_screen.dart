import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _entries = <_HomeEntry>[
    _HomeEntry(
      label: '대화 시작하기',
      subtitle: '학교폭력 관련 질문을 편하게',
      path: AppRoutes.chat,
      icon: Icons.chat_bubble_outline,
    ),
    _HomeEntry(
      label: '법령 조문 찾기',
      subtitle: '학교폭력예방법 · 시행령',
      path: AppRoutes.laws,
      icon: Icons.menu_book_outlined,
    ),
    _HomeEntry(
      label: '절차 흐름도',
      subtitle: '신고부터 심의까지 한눈에',
      path: AppRoutes.flow,
      icon: Icons.account_tree_outlined,
    ),
    _HomeEntry(
      label: '자주 묻는 질문',
      subtitle: '학생·학부모가 가장 많이 묻는 것',
      path: AppRoutes.faq,
      icon: Icons.help_outline,
    ),
    _HomeEntry(
      label: '설정',
      subtitle: '알림 · 글자 크기 · 테마',
      path: AppRoutes.settings,
      icon: Icons.settings_outlined,
    ),
    _HomeEntry(
      label: '헬스체크',
      subtitle: '디버그 — 시스템 상태 확인',
      path: AppRoutes.debugHealth,
      icon: Icons.health_and_safety_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _BackgroundGlow()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(),
                  const SizedBox(height: 12),
                  const _HeroTitle(),
                  const SizedBox(height: 14),
                  const _HeroSubtitle(),
                  const SizedBox(height: 24),
                  _MenuList(entries: _entries),
                  const SizedBox(height: 16),
                  const _EmergencyBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      // 다크 모드: scaffoldBackgroundColor 그대로 사용 (글로우 생략)
      return const SizedBox.shrink();
    }
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.6, -1.1),
          colors: [homeGlow, homeBaseBg],
          stops: [0, 0.7],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      '학교폭력 안내 · 학폭 나침반',
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.outline,
        letterSpacing: -0.1,
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w800,
      height: 1.25,
      color: inkColor(context),
      letterSpacing: -0.5,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('잘 왔어요.', style: headline),
        Text('천천히 살펴봐요.', style: headline),
      ],
    );
  }
}

class _HeroSubtitle extends StatelessWidget {
  const _HeroSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      '무엇이든 물어볼 수 있어요. 모든 대화는 기기에만 저장돼요.',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.outline,
        height: 1.45,
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList({required this.entries});
  final List<_HomeEntry> entries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i != 0)
              Divider(
                height: 0,
                indent: 16,
                endIndent: 16,
                color: scheme.outlineVariant.withValues(alpha: 0.6),
              ),
            _MenuRow(entry: entries[i]),
          ],
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.entry});
  final _HomeEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.push(entry.path),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
        child: Row(
          children: [
            Icon(entry.icon, color: scheme.primary, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: inkColor(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.outline,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.outline, size: 20),
          ],
        ),
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner();

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: '117');
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: emergencyBg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: _call,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '긴급할 땐 117',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '학교폭력 신고센터 · 24시간',
                      style: TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '전화',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeEntry {
  const _HomeEntry({
    required this.label,
    required this.subtitle,
    required this.path,
    required this.icon,
  });

  final String label;
  final String subtitle;
  final String path;
  final IconData icon;
}

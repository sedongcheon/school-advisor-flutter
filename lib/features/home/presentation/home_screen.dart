import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';

/// 학폭 나침반 홈 — 새 디자인 가이드(`flutter_export/home_screen.dart`) 기반.
///
/// 구조: MiniHeader → HeroCard(챗봇 진입 + 추천 칩) → 2x2 도구 그리드 → 117 배너
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _heroChips = ['신고 절차', '심의가 궁금해요', '보호조치'];

  static const _gridItems = <_HomeMenuItem>[
    _HomeMenuItem(
      label: '법령 조문 찾기',
      subtitle: '학교폭력예방법 · 시행령',
      path: AppRoutes.laws,
      icon: Icons.menu_book_outlined,
    ),
    _HomeMenuItem(
      label: '절차 흐름도',
      subtitle: '신고부터 심의까지 한눈에',
      path: AppRoutes.flow,
      icon: Icons.account_tree_outlined,
    ),
    _HomeMenuItem(
      label: '자주 묻는 질문',
      subtitle: '학생·학부모가 가장 많이 묻는 것',
      path: AppRoutes.faq,
      icon: Icons.help_outline,
    ),
    _HomeMenuItem(
      label: '대화 이력',
      subtitle: '지난 대화 다시 보기',
      path: AppRoutes.history,
      icon: Icons.history,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.lBg,
      body: SafeArea(
        child: Column(
          children: [
            const _MiniHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    _HeroCard(chips: _heroChips),
                    const _SectionLabel('다른 도구'),
                    _Grid2x2(items: _gridItems),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const _EmergencyBanner(),
          ],
        ),
      ),
    );
  }
}

class _HomeMenuItem {
  const _HomeMenuItem({
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

// ── 미니 헤더 (로고 + 설정 진입) ─────────────────────────────
class _MiniHeader extends StatelessWidget {
  const _MiniHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDCEBDF), Color(0xFFA8C7B0)],
              ),
            ),
            child: const Icon(
              Icons.explore_outlined,
              size: 17,
              color: AppTokens.lPrimary,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '학폭 나침반',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppTokens.lInk,
            ),
          ),
          const Spacer(),
          Material(
            color: AppTokens.lCard,
            shape: const CircleBorder(),
            elevation: 1.5,
            shadowColor: Colors.black12,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.push(AppRoutes.settings),
              child: const SizedBox(
                width: 34,
                height: 34,
                child: Icon(
                  Icons.settings_outlined,
                  size: 18,
                  color: AppTokens.lSub,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero 카드 (챗봇 진입 + 추천 칩) ─────────────────────────
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.chips});
  final List<String> chips;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTokens.lHeroTop, AppTokens.lHeroBottom],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '지금 바로',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: AppTokens.lInk.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '무엇이 궁금하세요?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: AppTokens.lInk,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '편하게 물어보세요. 모든 대화는 기기에만 저장돼요.',
              style: TextStyle(
                fontSize: 12,
                color: AppTokens.lInk.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            const _ChatInputStub(),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final q in chips) _HeroChip(label: q)],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputStub extends StatelessWidget {
  const _ChatInputStub();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTokens.lCard,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () => context.push(AppRoutes.chat),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '학교폭력에 대해 물어보세요…',
                  style: TextStyle(fontSize: 13.5, color: Color(0xFF9AAA9F)),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppTokens.lPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTokens.lChipBg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: () => context.push(AppRoutes.chat),
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppTokens.lInk,
            ),
          ),
        ),
      ),
    );
  }
}

// ── 섹션 라벨 ───────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: AppTokens.lSub,
          ),
        ),
      ),
    );
  }
}

// ── 2x2 도구 그리드 ─────────────────────────────────────────
class _Grid2x2 extends StatelessWidget {
  const _Grid2x2({required this.items});
  final List<_HomeMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.65,
        children: [for (final m in items) _Tile(item: m)],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item});
  final _HomeMenuItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTokens.lCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(item.path),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 1),
              ),
              BoxShadow(
                color: AppTokens.lPrimary.withValues(alpha: 0.08),
                offset: const Offset(0, 6),
                blurRadius: 18,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppTokens.lTileTint,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(item.icon, size: 18, color: AppTokens.lPrimary),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: AppTokens.lInk,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppTokens.lSub),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 117 긴급 배너 ───────────────────────────────────────────
class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner();

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: '117');
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Material(
        color: AppTokens.lEmBg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _call,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                const Icon(
                  Icons.phone_in_talk_outlined,
                  size: 16,
                  color: AppTokens.lAccent,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '긴급할 땐 117',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' · 24시간 신고센터'),
                      ],
                    ),
                    style: TextStyle(fontSize: 12.5, color: AppTokens.lEmFg),
                  ),
                ),
                const Text(
                  '전화 →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.lAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

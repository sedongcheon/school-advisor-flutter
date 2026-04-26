import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';

/// 보호자 모드 홈 — 자녀 진행 카드 + 보호자 메뉴 + 117 배너.
/// 자녀/사안 정보는 현재 mock. Stage 3 의 백엔드/SQLite 통합 후 실데이터로 교체.
class GuardianHomeScreen extends StatelessWidget {
  const GuardianHomeScreen({super.key});

  static const _menus = <_GuardianMenu>[
    _GuardianMenu(
      title: '학교와 소통하기',
      sub: '담임·전담기구 연락처 한눈에',
      accent: AppTokens.lPrimary,
    ),
    _GuardianMenu(
      title: '진술서 작성 가이드',
      sub: '심의 전 꼭 알아야 할 8가지',
      accent: AppTokens.lAccent,
    ),
    _GuardianMenu(
      title: '재심·행정심판 안내',
      sub: '결과 통지 후 17일 이내',
      accent: Color(0xFF7A5A2E),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.lBg,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            const _ChildProgressCard(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '보호자가 할 수 있는 일',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppTokens.lSub,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                children: [for (final m in _menus) _MenuRow(m: m)],
              ),
            ),
            const _Banner117(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '보호자 모드',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTokens.lSub,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '안녕하세요, 보호자님',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppTokens.lInk,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppTokens.lCard,
            shape: const CircleBorder(),
            elevation: 1.5,
            shadowColor: Colors.black12,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.push(AppRoutes.notifications),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  Icons.notifications_none,
                  size: 18,
                  color: AppTokens.lInk,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildProgressCard extends StatelessWidget {
  const _ChildProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTokens.lHeroTop, AppTokens.lHeroBottom],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '자녀 진행 상황',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTokens.lPrimaryDeep,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppTokens.lCard,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '민',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTokens.lPrimaryDeep,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '김민수 · 중2',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppTokens.lInk,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'R-2026-0428-1147 · 사안 조사 중',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppTokens.lPrimaryDeep,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(right: i == 3 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: i <= 1
                        ? AppTokens.lPrimary
                        : const Color(0x383F7C6A),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '접수',
                style: TextStyle(fontSize: 10, color: AppTokens.lPrimaryDeep),
              ),
              Text(
                '조사',
                style: TextStyle(fontSize: 10, color: AppTokens.lPrimaryDeep),
              ),
              Text(
                '심의',
                style: TextStyle(fontSize: 10, color: AppTokens.lPrimaryDeep),
              ),
              Text(
                '조치',
                style: TextStyle(fontSize: 10, color: AppTokens.lPrimaryDeep),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuardianMenu {
  const _GuardianMenu({
    required this.title,
    required this.sub,
    required this.accent,
  });
  final String title;
  final String sub;
  final Color accent;
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.m});
  final _GuardianMenu m;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTokens.lCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTokens.lLine),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 36,
            decoration: BoxDecoration(
              color: m.accent,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppTokens.lInk,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  m.sub,
                  style: const TextStyle(fontSize: 11.5, color: AppTokens.lSub),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: AppTokens.lSub),
        ],
      ),
    );
  }
}

class _Banner117 extends StatelessWidget {
  const _Banner117();

  Future<void> _call() async {
    await launchUrl(Uri(scheme: 'tel', path: '117'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Material(
        color: AppTokens.lEmBg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _call,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTokens.lCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: AppTokens.lEmFg,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '117 학교폭력 신고센터',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppTokens.lEmFg,
                        ),
                      ),
                      Text(
                        '24시간 상담 · 통화료 무료',
                        style: TextStyle(fontSize: 11, color: AppTokens.lEmFg),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppTokens.lEmFg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '전화',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
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

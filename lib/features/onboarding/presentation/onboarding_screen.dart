import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';

/// 학폭 나침반 — 새 디자인 가이드 기반의 3단계 온보딩.
/// 마지막에 "시작하기" 누르면 역할 선택 화면으로 이동.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _idx = 0;

  static const _slides = <_OBSlide>[
    _OBSlide(
      eyebrow: '학교폭력 안내',
      title: ['길을 잃지 않게,', '곁에서 안내해요.'],
      desc: '학교폭력에 대해 무엇이든 편하게 물어보세요. 차분히, 한 단계씩.',
      art: Icons.explore_outlined,
    ),
    _OBSlide(
      eyebrow: '비밀 보장',
      title: ['모든 대화는', '기기에만 저장돼요.'],
      desc: '서버에 보내지 않아요. 누구도 볼 수 없도록 안전하게 보관해요.',
      art: Icons.lock_outline,
    ),
    _OBSlide(
      eyebrow: '시작하기',
      title: ['지금 바로', '편하게 물어봐요.'],
      desc: '신고·심의·보호조치까지. 학교폭력예방법을 근거로 안내해 드려요.',
      art: Icons.chat_bubble_outline,
    ),
  ];

  void _finish() => context.go(AppRoutes.rolePicker);

  void _next() {
    if (_idx == _slides.length - 1) {
      _finish();
    } else {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.lBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_idx < _slides.length - 1)
                    GestureDetector(
                      onTap: _finish,
                      child: const Text(
                        '건너뛰기',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTokens.lSub,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _idx = i),
                itemBuilder: (_, i) => _OBPage(slide: _slides[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  Row(
                    children: List.generate(_slides.length, (i) {
                      final active = i == _idx;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 6,
                        margin: EdgeInsets.only(
                          right: i == _slides.length - 1 ? 0 : 6,
                        ),
                        width: active ? 28 : 12,
                        decoration: BoxDecoration(
                          color: active
                              ? AppTokens.lPrimary
                              : const Color(0x383F7C6A),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      child: Text(
                        _idx == _slides.length - 1 ? '시작하기  →' : '다음  →',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OBSlide {
  const _OBSlide({
    required this.eyebrow,
    required this.title,
    required this.desc,
    required this.art,
  });
  final String eyebrow;
  final List<String> title;
  final String desc;
  final IconData art;
}

class _OBPage extends StatelessWidget {
  const _OBPage({required this.slide});
  final _OBSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 340),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTokens.lHeroTop, AppTokens.lHeroBottom],
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  slide.art,
                  size: 130,
                  color: AppTokens.lPrimaryDeep,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            slide.eyebrow,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: AppTokens.lPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${slide.title[0]}\n${slide.title[1]}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTokens.lInk,
              height: 1.25,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            slide.desc,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppTokens.lSub,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

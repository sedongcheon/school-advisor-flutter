import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';

class IntroPagesScreen extends StatefulWidget {
  const IntroPagesScreen({super.key});

  @override
  State<IntroPagesScreen> createState() => _IntroPagesScreenState();
}

class _IntroPagesScreenState extends State<IntroPagesScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = <_IntroPage>[
    _IntroPage(
      icon: Icons.gavel_outlined,
      title: '학폭위 절차, 처음이라 막막하다면',
      body: 'AI 자문이 관련 법령과 절차를 쉬운 말로 안내해 드려요.',
    ),
    _IntroPage(
      icon: Icons.menu_book_outlined,
      title: '근거가 되는 법령 조문까지 함께',
      body: '답변에 인용된 조문을 한 번 탭하면 원문을 바로 확인할 수 있어요.',
    ),
    _IntroPage(
      icon: Icons.shield_moon_outlined,
      title: '익명으로 안전하게',
      body: '실명·민감정보 입력 없이도 이용할 수 있도록 설계했어요.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _skip() => context.go(AppRoutes.home);

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        actions: [TextButton(onPressed: _skip, child: const Text('건너뛰기'))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _pages[i],
              ),
            ),
            _Dots(count: _pages.length, current: _index),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(isLast ? '시작하기' : '다음'),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 96, color: theme.colorScheme.primary),
          const SizedBox(height: 32),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? scheme.primary : scheme.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:school_advisor/features/onboarding/presentation/onboarding_screen.dart';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/onboarding/intro',
    routes: [
      GoRoute(
        path: '/onboarding/intro',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const Scaffold(body: Text('home')),
      ),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('첫 슬라이드는 "건너뛰기" 와 "다음" 을 보여준다', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('학교폭력 안내'), findsOneWidget);
    expect(find.text('건너뛰기'), findsOneWidget);
    expect(find.textContaining('다음'), findsOneWidget);
  });

  testWidgets('건너뛰기 누르면 홈으로 이동', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('건너뛰기'));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });
}

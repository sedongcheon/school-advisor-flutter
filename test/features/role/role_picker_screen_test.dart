import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:school_advisor/features/role/presentation/role_picker_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/role',
    routes: [
      GoRoute(path: '/role', builder: (_, __) => child),
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

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('RolePickerScreen 의 3개 역할 카드와 시작 버튼이 보인다', (tester) async {
    await tester.pumpWidget(_wrap(const RolePickerScreen()));
    await tester.pumpAndSettle();

    expect(find.text('어떤 분이세요?'), findsOneWidget);
    expect(find.text('학생'), findsOneWidget);
    expect(find.text('보호자'), findsOneWidget);
    expect(find.text('교사 · 전담기구'), findsOneWidget);
    expect(find.textContaining('시작하기'), findsOneWidget);
  });

  testWidgets('역할 카드 탭 시 체크 표시가 이동한다', (tester) async {
    await tester.pumpWidget(_wrap(const RolePickerScreen()));
    await tester.pumpAndSettle();

    // 보호자 카드 탭
    await tester.tap(find.text('보호자'));
    await tester.pumpAndSettle();
    // 카드는 선택 상태로 변경 (체크 아이콘이 보임 — 학생 카드의 빈 원과는 다름)
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('시작하기 버튼이 활성 상태로 보인다', (tester) async {
    await tester.pumpWidget(_wrap(const RolePickerScreen()));
    await tester.pumpAndSettle();

    final btn = find.byType(FilledButton);
    expect(btn, findsOneWidget);
    final widget = tester.widget<FilledButton>(btn);
    expect(widget.onPressed, isNotNull);
  });
}

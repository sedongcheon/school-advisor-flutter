import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/chat_screen.dart';
import '../../features/chat/presentation/history_screen.dart';
import '../../features/debug/presentation/health_check_screen.dart';
import '../../features/faq/presentation/faq_screen.dart';
import '../../features/flowchart/presentation/procedure_flow_screen.dart';
import '../../features/home/presentation/case_detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/laws/presentation/law_search_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/application/disclaimer_notifier.dart';
import '../../features/onboarding/presentation/disclaimer_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/purchase/presentation/purchase_screen.dart';
import '../../features/report/presentation/report_done_screen.dart';
import '../../features/report/presentation/report_form_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/status/presentation/status_lookup_screen.dart';

/// 라우트 경로 상수. 화면 추가 시 이 곳에서 한 곳만 수정.
class AppRoutes {
  const AppRoutes._();
  static const home = '/';
  static const chat = '/chat';
  static const laws = '/laws';
  static const flow = '/flow';
  static const faq = '/faq';
  static const settings = '/settings';
  static const debugHealth = '/debug/health';
  static const disclaimer = '/onboarding/disclaimer';
  static const onboarding = '/onboarding/intro';
  static const history = '/chat/history';
  static const purchase = '/purchase';
  static const report = '/report';
  static const reportDone = '/report/done';
  static const statusLookup = '/status';
  static const notifications = '/notifications';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final accepted =
          ref.read(disclaimerAcceptedProvider).valueOrNull ?? false;
      final loc = state.matchedLocation;

      // 면책 동의 안 됨 → 면책 화면 강제
      if (!accepted) {
        return loc == AppRoutes.disclaimer ? null : AppRoutes.disclaimer;
      }

      return null;
    },
    refreshListenable: _BootListenable(ref),
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.disclaimer,
        builder: (context, state) => const DisclaimerScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) {
          final prefill = state.uri.queryParameters['prefill'];
          return ChatScreen(prefill: prefill);
        },
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.purchase,
        builder: (context, state) => const PurchaseScreen(),
      ),
      GoRoute(
        path: AppRoutes.laws,
        builder: (context, state) => const LawSearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.flow,
        builder: (context, state) => const ProcedureFlowScreen(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.report,
        builder: (context, state) => const ReportFormScreen(),
        routes: [
          GoRoute(
            path: 'done',
            builder: (context, state) {
              final receipt = state.uri.queryParameters['receipt'] ?? '';
              return ReportDoneScreen(receiptNo: receipt);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.statusLookup,
        builder: (context, state) => const StatusLookupScreen(),
        routes: [
          GoRoute(
            path: ':receiptNo',
            builder: (context, state) {
              final r = state.pathParameters['receiptNo'] ?? '';
              return CaseDetailScreen(receiptNo: r);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.debugHealth,
        builder: (context, state) => const HealthCheckScreen(),
      ),
    ],
  );
});

/// 면책동의 변화를 감지해 라우터 redirect 재평가.
class _BootListenable extends ChangeNotifier {
  _BootListenable(Ref ref) {
    _disclaimerSub = ref.listen<AsyncValue<bool>>(
      disclaimerAcceptedProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
    ref.onDispose(_disclaimerSub.close);
  }
  late final ProviderSubscription<AsyncValue<bool>> _disclaimerSub;
}

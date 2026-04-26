import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/chat_screen.dart';
import '../../features/chat/presentation/history_screen.dart';
import '../../features/debug/presentation/health_check_screen.dart';
import '../../features/faq/presentation/faq_screen.dart';
import '../../features/flowchart/presentation/procedure_flow_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/laws/presentation/law_search_screen.dart';
import '../../features/onboarding/application/disclaimer_notifier.dart';
import '../../features/onboarding/presentation/disclaimer_screen.dart';
import '../../features/onboarding/presentation/intro_pages_screen.dart';
import '../../features/purchase/presentation/purchase_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

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
  static const intro = '/onboarding/intro';
  static const history = '/chat/history';
  static const purchase = '/purchase';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final accepted =
          ref.read(disclaimerAcceptedProvider).valueOrNull ?? false;
      final loc = state.matchedLocation;
      final isOnboarding =
          loc == AppRoutes.disclaimer || loc == AppRoutes.intro;

      if (!accepted && !isOnboarding) {
        return AppRoutes.disclaimer;
      }
      if (accepted && loc == AppRoutes.disclaimer) {
        return AppRoutes.home;
      }
      return null;
    },
    refreshListenable: _DisclaimerListenable(ref),
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
        path: AppRoutes.intro,
        builder: (context, state) => const IntroPagesScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) => const ChatScreen(),
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
        path: AppRoutes.debugHealth,
        builder: (context, state) => const HealthCheckScreen(),
      ),
    ],
  );
});

/// `disclaimerAcceptedProvider` 의 변화에 따라 GoRouter 가 redirect 를 재평가하도록 알린다.
class _DisclaimerListenable extends ChangeNotifier {
  _DisclaimerListenable(Ref ref) {
    _sub = ref.listen<AsyncValue<bool>>(
      disclaimerAcceptedProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
    ref.onDispose(() {
      _sub.close();
    });
  }
  late final ProviderSubscription<AsyncValue<bool>> _sub;
}

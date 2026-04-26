import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/push/notification_payload.dart';
import 'core/push/push_messaging_service.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/laws/presentation/law_article_sheet.dart';
import 'features/settings/application/notifications_notifier.dart';
import 'features/settings/application/theme_mode_notifier.dart';
import 'shared/utils/citation_parser.dart';

class SchoolAdvisorApp extends ConsumerStatefulWidget {
  const SchoolAdvisorApp({super.key});

  @override
  ConsumerState<SchoolAdvisorApp> createState() => _SchoolAdvisorAppState();
}

class _SchoolAdvisorAppState extends ConsumerState<SchoolAdvisorApp> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // 영속화된 알림 토글이 true 면 자동으로 enable 호출
    ref.read(notificationsEnabledProvider);
  }

  void _handlePending(NotificationPayload? payload) {
    if (payload == null) return;
    final router = ref.read(appRouterProvider);
    final ctx = router.routerDelegate.navigatorKey.currentContext;
    if (ctx == null) return;

    switch (payload) {
      case NotificationPayloadLawArticle(:final lawName, :final articleNo):
        showLawArticleSheet(
          ctx,
          ref: CitationRef(lawName: lawName, articleNo: articleNo),
        );
      case NotificationPayloadOpen():
        // 단순히 앱 열림. 라우팅 변경 없음.
        break;
    }
    // 처리 완료 → 큐 비우기
    ref.read(pendingPushPayloadProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    ref.listen<NotificationPayload?>(pendingPushPayloadProvider, (_, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handlePending(next);
      });
    });

    return MaterialApp.router(
      title: '학폭 나침반',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
    );
  }
}

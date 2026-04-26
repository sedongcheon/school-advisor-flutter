import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../env.dart';

/// Sentry 를 (있다면) 초기화한 뒤 앱을 실행한다.
///
/// `--dart-define=SENTRY_DSN=...` 가 없으면 init 을 건너뛰고 앱만 실행한다.
/// 모든 zone 미잡힌 예외와 `FlutterError.onError` 를 자동으로 보고한다.
Future<void> bootstrap(FutureOr<void> Function() runApp) async {
  if (!Env.sentryEnabled) {
    await runApp();
    return;
  }

  await SentryFlutter.init((options) {
    options
      ..dsn = Env.sentryDsn
      ..environment = Env.appEnv
      ..tracesSampleRate = kDebugMode ? 1.0 : 0.2
      ..attachStacktrace = true;
  }, appRunner: () async => runApp());
}

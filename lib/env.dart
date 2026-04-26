/// `--dart-define` 으로 주입되는 환경변수.
///
/// 빌드 명령 예:
/// ```sh
/// flutter build apk --debug \
///   --dart-define=API_BASE_URL=https://school-advisor.sedoli.co.kr \
///   --dart-define=APP_ENV=dev
/// ```
class Env {
  const Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://school-advisor.sedoli.co.kr',
  );

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  /// `--dart-define=SEED_DEMO=true` 시 첫 실행에서 mock reports/inbox 자동 적재.
  /// 개발 빌드 데모용. prod 빌드는 끄고 사용.
  static const bool seedDemo = bool.fromEnvironment(
    'SEED_DEMO',
    defaultValue: false,
  );

  static bool get isDev => appEnv == 'dev';
  static bool get isProd => appEnv == 'prod';
  static bool get sentryEnabled => sentryDsn.isNotEmpty;
}

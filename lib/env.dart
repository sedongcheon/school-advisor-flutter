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

  static bool get isDev => appEnv == 'dev';
  static bool get isProd => appEnv == 'prod';
  static bool get sentryEnabled => sentryDsn.isNotEmpty;
}

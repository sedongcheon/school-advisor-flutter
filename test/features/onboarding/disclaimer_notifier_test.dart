import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_advisor/features/onboarding/application/disclaimer_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('초기 상태는 false (동의 안 함)', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final accepted = await container.read(disclaimerAcceptedProvider.future);
    expect(accepted, isFalse);
  });

  test('accept 호출 시 true 로 전환되고 영속화된다', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(disclaimerAcceptedProvider.future);
    await container.read(disclaimerAcceptedProvider.notifier).accept();

    expect(container.read(disclaimerAcceptedProvider).value, isTrue);

    // 새 컨테이너에서도 영속된 값을 읽는다
    final next = ProviderContainer();
    addTearDown(next.dispose);
    final persisted = await next.read(disclaimerAcceptedProvider.future);
    expect(persisted, isTrue);
  });
}

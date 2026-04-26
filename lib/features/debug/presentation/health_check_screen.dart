import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/error_mapper.dart';
import '../../../core/http/dio_provider.dart';
import '../../../env.dart';

/// `/health` 호출 결과를 상태로 들고 있는 Notifier.
final healthCheckProvider =
    AsyncNotifierProvider.autoDispose<HealthCheckController, HealthResult?>(
      HealthCheckController.new,
    );

class HealthResult {
  const HealthResult({required this.statusCode, required this.body});
  final int statusCode;
  final String body;
}

class HealthCheckController extends AutoDisposeAsyncNotifier<HealthResult?> {
  @override
  Future<HealthResult?> build() async => null;

  Future<void> ping() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = await ref.read(dioProvider.future);
      final res = await dio.get<dynamic>(
        '/health',
        options: Options(
          responseType: ResponseType.plain,
          // 비-2xx 도 일단 받아서 화면에 노출
          validateStatus: (_) => true,
        ),
      );
      return HealthResult(
        statusCode: res.statusCode ?? -1,
        body: res.data?.toString() ?? '',
      );
    });
  }
}

class HealthCheckScreen extends ConsumerWidget {
  const HealthCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(healthCheckProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('헬스체크 (디버그)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _InfoRow(label: 'API_BASE_URL', value: Env.apiBaseUrl),
            const _InfoRow(label: 'APP_ENV', value: Env.appEnv),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(healthCheckProvider.notifier).ping(),
              icon: const Icon(Icons.network_check),
              label: const Text('GET /health 호출'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.when(
                data: (result) {
                  if (result == null) {
                    return Center(
                      child: Text(
                        '아직 호출하지 않았어요.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }
                  final ok =
                      result.statusCode >= 200 && result.statusCode < 300;
                  return _ResultView(
                    statusCode: result.statusCode,
                    body: result.body,
                    ok: ok,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => _ErrorView(message: mapErrorToMessage(err)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.statusCode,
    required this.body,
    required this.ok,
  });
  final int statusCode;
  final String body;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final color = ok
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(ok ? Icons.check_circle : Icons.error_outline, color: color),
            const SizedBox(width: 8),
            Text(
              'HTTP $statusCode',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: SelectableText(
              body.isEmpty ? '(빈 응답)' : body,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

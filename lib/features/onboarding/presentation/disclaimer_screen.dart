import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../application/disclaimer_notifier.dart';

class DisclaimerScreen extends ConsumerStatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  ConsumerState<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends ConsumerState<DisclaimerScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 이용 안내'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '본 앱은 학교폭력 관련 법령·절차에 대한 일반적인 정보 안내 서비스입니다.',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      const _Bullet(
                        '본 앱이 제공하는 답변은 법률 자문이나 변호사의 조력을 대체하지 않습니다.',
                      ),
                      const _Bullet('실제 사건의 처리·구제는 학교, 교육청, 법률 전문가와 상담해 주세요.'),
                      const _Bullet(
                        '답변은 AI 가 생성하며, 사실과 다를 수 있습니다. 출처 인용을 항상 확인해 주세요.',
                      ),
                      const _Bullet(
                        '실명·주민등록번호 등 개인정보는 입력하지 마세요. 입력 시 자동 마스킹될 수 있습니다.',
                      ),
                      const _Bullet(
                        '대화 내용은 서비스 품질 개선을 위해 익명 처리 후 일정 기간 보관될 수 있습니다.',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '※ 위 내용에 동의하셔야 서비스를 이용하실 수 있습니다.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CheckboxListTile(
                value: _agreed,
                onChanged: (v) => setState(() => _agreed = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('위 내용을 모두 확인했으며 동의합니다.'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _agreed
                    ? () async {
                        await ref
                            .read(disclaimerAcceptedProvider.notifier)
                            .accept();
                        if (!context.mounted) return;
                        context.go(AppRoutes.onboarding);
                      }
                    : null,
                child: const Text('동의하고 시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

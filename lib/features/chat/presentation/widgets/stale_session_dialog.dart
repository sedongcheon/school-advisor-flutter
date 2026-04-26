import 'package:flutter/material.dart';

import '../../data/last_session_dto.dart';

enum StaleSessionChoice { resume, newChat }

/// 마지막 대화가 7일 이상 오래된 경우 띄우는 다이얼로그.
Future<StaleSessionChoice?> showStaleSessionDialog(
  BuildContext context,
  LastSessionMeta meta,
) {
  return showDialog<StaleSessionChoice>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final scheme = Theme.of(ctx).colorScheme;
      return AlertDialog(
        title: const Text('지난 대화가 있어요'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${meta.daysAgo}일 전에 이런 질문을 하셨어요.',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                meta.lastUserQuery,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '이어서 진행할까요?',
              style: Theme.of(
                ctx,
              ).textTheme.bodySmall?.copyWith(color: scheme.outline),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(StaleSessionChoice.newChat),
            child: const Text('새 대화'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(StaleSessionChoice.resume),
            child: const Text('이어가기'),
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/user_repository.dart';
import '../data/user_status_dto.dart';

/// 채팅 화면 AppBar 액션 자리에 표시되는 사용량 칩.
/// `남은 N/M` + 임박 시 색상 변경.
class UsageIndicator extends ConsumerWidget {
  const UsageIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userStatusProvider);
    return state.when(
      data: (status) =>
          status == null ? const SizedBox.shrink() : _Chip(status: status),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.status});
  final UserStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color color;
    if (status.isExhausted) {
      color = scheme.error;
    } else if (status.isNearLimit) {
      color = scheme.tertiary;
    } else {
      color = scheme.primary;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              '${status.questionsRemaining}/${status.questionsLimit}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

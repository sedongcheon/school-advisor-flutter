import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/color_scheme.dart';
import '../../features/notifications/data/inbox_repository.dart';

/// 학생/보호자 홈에서 hero 아래 노출되는 "최근 알림" 미니 카드.
/// 인박스에 항목이 없으면 아무것도 그리지 않는다.
class InboxPreview extends ConsumerWidget {
  const InboxPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(inboxRepositoryProvider);
    return StreamBuilder<List<InboxRow>>(
      stream: repo.watchAll(),
      builder: (context, snap) {
        final list = snap.data ?? const <InboxRow>[];
        if (list.isEmpty) return const SizedBox.shrink();
        final top = list.first;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Material(
            color: AppTokens.lCard,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => context.push(AppRoutes.notifications),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTokens.lLine),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppTokens.lTileTint,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        size: 15,
                        color: AppTokens.lPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Text(
                                '최근 알림',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  color: AppTokens.lPrimary,
                                ),
                              ),
                              const Spacer(),
                              if (list.length > 1)
                                Text(
                                  '+${list.length - 1}건 더',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTokens.lSub,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            top.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: top.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              color: AppTokens.lInk,
                            ),
                          ),
                          if (top.detail.isNotEmpty) ...[
                            const SizedBox(height: 1),
                            Text(
                              top.detail,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTokens.lSub,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppTokens.lSub,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

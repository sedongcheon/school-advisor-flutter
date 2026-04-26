import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/app_database.dart';
import '../../../core/theme/color_scheme.dart';
import '../application/chat_notifier.dart';
import '../data/conversation_repository.dart';

/// 로컬 SQLite 에 저장된 대화 목록.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(conversationRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('대화 이력')),
      body: SafeArea(
        child: StreamBuilder<List<ConversationRow>>(
          stream: repo.watchAll(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snap.data ?? const [];
            if (items.isEmpty) {
              return _Empty();
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: items.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i == items.length - 1 ? 0 : 10,
                  ),
                  child: _ConversationCard(row: items[i]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 56, color: scheme.outline),
            const SizedBox(height: 12),
            Text(
              '아직 대화가 없어요.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: inkColor(context)),
            ),
            const SizedBox(height: 4),
            Text(
              '대화 화면에서 첫 질문을 보내면 여기에 저장돼요.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: scheme.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationCard extends ConsumerWidget {
  const _ConversationCard({required this.row});
  final ConversationRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final title = row.title.isEmpty ? '제목 없는 대화' : row.title;
    final preview = row.lastPreview.isEmpty ? '(메시지 없음)' : row.lastPreview;
    return Card(
      child: InkWell(
        onTap: () async {
          await ref
              .read(chatNotifierProvider.notifier)
              .loadConversation(row.id);
          if (!context.mounted) return;
          context.pop();
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: inkColor(context),
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatRelative(row.updatedAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: scheme.outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.outline,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: scheme.outline,
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('대화를 삭제할까요?'),
                      content: const Text('이 대화의 모든 메시지가 기기에서 지워져요.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('취소'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('삭제'),
                        ),
                      ],
                    ),
                  );
                  if (ok ?? false) {
                    await ref
                        .read(conversationRepositoryProvider)
                        .delete(row.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatRelative(DateTime when) {
  final now = DateTime.now();
  final d = now.difference(when);
  if (d.inMinutes < 1) return '방금 전';
  if (d.inHours < 1) return '${d.inMinutes}분 전';
  if (d.inDays < 1) return '${d.inHours}시간 전';
  if (d.inDays < 7) return '${d.inDays}일 전';
  return '${when.year % 100}.${when.month}.${when.day}';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/error_mapper.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/sse/sse_event.dart';
import '../../../shared/utils/citation_parser.dart';
import '../../../shared/utils/pii_detector.dart';
import '../../../shared/widgets/pii_warning_dialog.dart';
import '../../feedback/presentation/message_actions_sheet.dart';
import '../../feedback/presentation/rating_dialog.dart';
import '../../feedback/presentation/report_sheet.dart';
import '../../laws/presentation/law_article_sheet.dart';
import '../../user/presentation/usage_indicator.dart';
import '../application/chat_notifier.dart';
import '../data/chat_dto.dart';
import 'widgets/input_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/stale_session_dialog.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({this.prefill, super.key});

  /// 홈의 추천 칩 등에서 진입할 때 자동 송신할 메시지.
  final String? prefill;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();
  bool _prefillSent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await ref
          .read(chatNotifierProvider.notifier)
          .maybeAutoResume(
            onPromptStale: (meta) async {
              if (!mounted) return false;
              final choice = await showStaleSessionDialog(context, meta);
              return choice == StaleSessionChoice.resume;
            },
          );
      if (!mounted) return;
      final p = widget.prefill;
      if (!_prefillSent && p != null && p.trim().isNotEmpty) {
        _prefillSent = true;
        await _handleSubmit(p);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSubmit(String raw) async {
    final scan = PiiDetector.scan(raw);
    var toSend = raw;

    if (scan.hasAny) {
      final choice = await showPiiWarningDialog(context, scan);
      if (!mounted) return;
      switch (choice) {
        case PiiDialogChoice.cancel:
          return;
        case PiiDialogChoice.mask:
          toSend = PiiDetector.mask(raw);
        case PiiDialogChoice.sendAsIs:
          toSend = raw;
      }
    }

    await ref.read(chatNotifierProvider.notifier).send(toSend);
  }

  Future<void> _onCitationTap(CitationChunk chunk, CitationRef? ref) async {
    if (ref == null) return;
    await showLawArticleSheet(context, ref: ref);
  }

  Future<void> _onLongPress(ChatMessage message) async {
    if (message.role != ChatRole.assistant ||
        message.conversationId == null ||
        message.isStreaming) {
      return;
    }
    final action = await showMessageActionsSheet(context);
    if (action == null || !mounted) return;
    switch (action) {
      case MessageAction.rate:
        await _handleRating(message);
      case MessageAction.report:
        await _handleReport(message);
    }
  }

  Future<void> _handleRating(ChatMessage message) async {
    final result = await showRatingDialog(context);
    if (result == null || !mounted) return;
    try {
      final ok = await ref
          .read(chatNotifierProvider.notifier)
          .sendRating(
            messageId: message.id,
            rating: result.rating,
            comment: result.comment,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? '평가를 보내주셔서 감사합니다.' : '평가를 보낼 수 없는 메시지예요.')),
      );
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapErrorToMessage(e))));
    }
  }

  Future<void> _handleReport(ChatMessage message) async {
    final result = await showReportSheet(context);
    if (result == null || !mounted) return;
    try {
      final ok = await ref
          .read(chatNotifierProvider.notifier)
          .report(
            messageId: message.id,
            reason: result.reason,
            comment: result.comment,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? '신고가 접수되었습니다. 감사합니다.' : '신고를 보낼 수 없는 메시지예요.'),
        ),
      );
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapErrorToMessage(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatNotifierProvider);
    ref.listen(chatNotifierProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: const Text('대화'),
        actions: [
          IconButton(
            tooltip: '대화 이력',
            icon: const Icon(Icons.history),
            onPressed: () => context.push(AppRoutes.history),
          ),
          IconButton(
            tooltip: '새 대화',
            icon: const Icon(Icons.edit_note_outlined),
            onPressed: () async {
              if (state.messages.isEmpty) {
                ref.read(chatNotifierProvider.notifier).startNewConversation();
                return;
              }
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('새 대화를 시작할까요?'),
                  content: const Text('지금 대화는 이력에 저장되어 나중에 다시 볼 수 있어요.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('취소'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('새 대화'),
                    ),
                  ],
                ),
              );
              if (ok ?? false) {
                ref.read(chatNotifierProvider.notifier).startNewConversation();
              }
            },
          ),
          const UsageIndicator(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.messages.length,
                    itemBuilder: (context, i) => MessageBubble(
                      message: state.messages[i],
                      onCitationTap: _onCitationTap,
                      onLongPress: _onLongPress,
                    ),
                  ),
          ),
          InputBar(enabled: !state.isComposing, onSubmit: _handleSubmit),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '무엇이든 편하게 물어보세요.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '학교폭력 절차·법령을 안내해 드릴게요. 실명·민감정보는 입력하지 마세요.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

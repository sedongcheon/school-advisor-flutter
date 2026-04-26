import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../../../core/sse/sse_event.dart';
import '../../../../shared/utils/citation_parser.dart';
import '../../data/chat_dto.dart';
import 'citations_strip.dart';
import 'disclaimer_banner.dart';
import 'streaming_indicator.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.onCitationTap,
    required this.onLongPress,
    super.key,
  });

  final ChatMessage message;
  final void Function(CitationChunk chunk, CitationRef? ref) onCitationTap;
  final void Function(ChatMessage message) onLongPress;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    if (isUser) {
      return _UserBubble(content: message.content);
    }
    return _AssistantBlock(
      message: message,
      onCitationTap: onCitationTap,
      onLongPress: onLongPress,
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onPrimary,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }
}

class _AssistantBlock extends StatelessWidget {
  const _AssistantBlock({
    required this.message,
    required this.onCitationTap,
    required this.onLongPress,
  });

  final ChatMessage message;
  final void Function(CitationChunk chunk, CitationRef? ref) onCitationTap;
  final void Function(ChatMessage message) onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasError = message.errorMessage != null;
    final showLeadingIndicator =
        message.isStreaming && message.content.isEmpty && !hasError;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.92,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: () => onLongPress(message),
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: hasError
                      ? scheme.errorContainer
                      : scheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: hasError
                    ? Text(
                        message.errorMessage!,
                        style: TextStyle(color: scheme.onErrorContainer),
                      )
                    : showLeadingIndicator
                    ? const StreamingIndicator()
                    : _MarkdownBody(
                        content: message.content,
                        isStreaming: message.isStreaming,
                      ),
              ),
            ),
            if (!hasError &&
                !message.isStreaming &&
                message.conversationId != null &&
                message.content.isNotEmpty)
              _ActionsRow(onTap: () => onLongPress(message)),
            if (!hasError && message.citations.isNotEmpty)
              CitationsStrip(
                citations: message.citations,
                onTap: onCitationTap,
              ),
            if (!hasError && !message.isStreaming && message.content.isNotEmpty)
              const DisclaimerBanner(),
          ],
        ),
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.more_horiz, size: 18, color: scheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    '평가 · 신고',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: scheme.outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkdownBody extends StatelessWidget {
  const _MarkdownBody({required this.content, required this.isStreaming});
  final String content;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      listBullet: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      h1: theme.textTheme.titleLarge,
      h2: theme.textTheme.titleMedium,
      h3: theme.textTheme.titleSmall,
      blockquoteDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(6),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MarkdownBody(data: content, selectable: true, styleSheet: styleSheet),
        if (isStreaming) ...[
          const SizedBox(height: 6),
          const StreamingIndicator(),
        ],
      ],
    );
  }
}

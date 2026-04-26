import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../../../core/sse/sse_event.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../shared/utils/citation_parser.dart';
import '../../data/chat_dto.dart';
import 'citations_strip.dart';
import 'disclaimer_banner.dart';
import 'streaming_indicator.dart';

/// 메시지 버블. 새 디자인 가이드 (compass 아바타 + rounded bubble + tile-tint citation).
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

// ── 사용자 메시지 ─────────────────────────────────────────────
class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.78,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: AppTokens.lPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 어시스턴트 블록 (아바타 + 버블 + 인용/배너 + 액션) ───────
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
    final hasError = message.errorMessage != null;
    final showLeadingIndicator =
        message.isStreaming && message.content.isEmpty && !hasError;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BotAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.78,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onLongPress: () => onLongPress(message),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: hasError
                            ? Theme.of(context).colorScheme.errorContainer
                            : AppTokens.lCard,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: hasError
                          ? Text(
                              message.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                                fontSize: 13.5,
                                height: 1.5,
                              ),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: CitationsStrip(
                        citations: message.citations,
                        onTap: onCitationTap,
                      ),
                    ),
                  if (!hasError &&
                      !message.isStreaming &&
                      message.content.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: DisclaimerBanner(),
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

// ── 봇 아바타 (compass gradient + explore icon) ──────────────
class _BotAvatar extends StatelessWidget {
  const _BotAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(top: 2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDCEBDF), Color(0xFFA8C7B0)],
        ),
      ),
      child: const Icon(
        Icons.explore_outlined,
        size: 15,
        color: AppTokens.lPrimary,
      ),
    );
  }
}

// ── 평가 · 신고 액션 ─────────────────────────────────────────
class _ActionsRow extends StatelessWidget {
  const _ActionsRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.more_horiz, size: 16, color: AppTokens.lSub),
              const SizedBox(width: 4),
              Text(
                '평가 · 신고',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppTokens.lSub),
              ),
            ],
          ),
        ),
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
      p: theme.textTheme.bodyMedium?.copyWith(
        height: 1.5,
        fontSize: 13.5,
        color: AppTokens.lInk,
      ),
      listBullet: theme.textTheme.bodyMedium?.copyWith(
        height: 1.5,
        fontSize: 13.5,
        color: AppTokens.lInk,
      ),
      h1: theme.textTheme.titleLarge,
      h2: theme.textTheme.titleMedium,
      h3: theme.textTheme.titleSmall,
      strong: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 13.5,
        color: AppTokens.lInk,
      ),
      blockquoteDecoration: BoxDecoration(
        color: AppTokens.lTileTint,
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

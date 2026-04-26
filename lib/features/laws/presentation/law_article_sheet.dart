import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/error_mapper.dart';
import '../../../shared/utils/citation_parser.dart';
import '../data/law_dto.dart';
import '../data/laws_repository.dart';

/// 인용 칩 탭 시 띄우는 바텀시트.
Future<void> showLawArticleSheet(
  BuildContext context, {
  required CitationRef ref,
  String? highlightParagraph,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _LawSheetBody(
      lawName: ref.lawName,
      articleNo: ref.articleNo,
      highlightParagraph: highlightParagraph ?? ref.paragraph,
    ),
  );
}

class _LawSheetBody extends ConsumerStatefulWidget {
  const _LawSheetBody({
    required this.lawName,
    required this.articleNo,
    this.highlightParagraph,
  });

  final String lawName;
  final String articleNo;
  final String? highlightParagraph;

  @override
  ConsumerState<_LawSheetBody> createState() => _LawSheetBodyState();
}

class _LawSheetBodyState extends ConsumerState<_LawSheetBody> {
  late Future<LawArticle?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<LawArticle?> _load() async {
    final repo = await ref.read(lawsRepositoryProvider.future);
    return repo.fetchArticle(
      lawName: widget.lawName,
      articleNo: widget.articleNo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return FutureBuilder<LawArticle?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _ErrorView(message: mapErrorToMessage(snapshot.error!));
            }
            final article = snapshot.data;
            if (article == null) {
              return const _EmptyView();
            }
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                Text(
                  article.lawName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.title == null
                      ? article.articleNo
                      : '${article.articleNo}  ${article.title}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.docType,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                if (widget.highlightParagraph != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '인용 위치: ${widget.highlightParagraph}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SelectableText(
                  article.content,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
                if (article.sourceUrl != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    '출처: ${article.sourceUrl}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 36,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '해당 조문을 찾을 수 없어요.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

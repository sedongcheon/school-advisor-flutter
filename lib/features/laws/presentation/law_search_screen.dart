import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/error_mapper.dart';
import '../../../core/theme/color_scheme.dart';
import '../../../shared/utils/citation_parser.dart';
import '../data/law_index_dto.dart';
import '../data/law_index_repository.dart';
import 'law_article_sheet.dart';

class LawSearchScreen extends ConsumerStatefulWidget {
  const LawSearchScreen({super.key});

  @override
  ConsumerState<LawSearchScreen> createState() => _LawSearchScreenState();
}

class _LawSearchScreenState extends ConsumerState<LawSearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _open(LawGroup group, LawArticleEntry article) {
    showLawArticleSheet(
      context,
      ref: CitationRef(lawName: group.lawName, articleNo: article.articleNo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final indexState = ref.watch(lawIndexProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('법령 조문 찾기')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: TextField(
                controller: _ctrl,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: '법령명, 조문번호, 키워드로 검색',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _ctrl.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              child: indexState.when(
                data: (index) => _Results(
                  groups: filterLawIndex(index, _query),
                  onTap: _open,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => _ErrorView(message: mapErrorToMessage(e)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.groups, required this.onTap});
  final List<LawGroup> groups;
  final void Function(LawGroup group, LawArticleEntry article) onTap;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const _EmptyView();
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: groups.length,
      itemBuilder: (context, gi) {
        final g = groups[gi];
        return Padding(
          padding: EdgeInsets.only(bottom: gi == groups.length - 1 ? 0 : 16),
          child: _GroupCard(group: g, onTap: onTap),
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.onTap});
  final LawGroup group;
  final void Function(LawGroup g, LawArticleEntry a) onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.docType,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: scheme.outline),
                ),
                const SizedBox(height: 2),
                Text(
                  group.shortName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: inkColor(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          for (var i = 0; i < group.articles.length; i++) ...[
            if (i != 0)
              Divider(
                height: 0,
                indent: 18,
                endIndent: 18,
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            _ArticleRow(
              entry: group.articles[i],
              onTap: () => onTap(group, group.articles[i]),
            ),
          ],
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({required this.entry, required this.onTap});
  final LawArticleEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
        child: Row(
          children: [
            SizedBox(
              width: 76,
              child: Text(
                entry.articleNo,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Text(
                entry.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: inkColor(context)),
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: scheme.outline),
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
        padding: const EdgeInsets.all(32),
        child: Text(
          '검색 결과가 없어요.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
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
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

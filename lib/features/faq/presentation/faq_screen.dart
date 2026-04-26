import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/error_mapper.dart';
import '../../../core/theme/color_scheme.dart';
import '../data/faq_dto.dart';
import '../data/faq_repository.dart';

class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  ConsumerState<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(faqIndexProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('자주 묻는 질문')),
      body: SafeArea(
        child: state.when(
          data: (index) {
            final selected = _selectedId == null
                ? index.categories.first
                : index.categories.firstWhere(
                    (c) => c.id == _selectedId,
                    orElse: () => index.categories.first,
                  );
            return Column(
              children: [
                _CategoryChips(
                  categories: index.categories,
                  selectedId: selected.id,
                  onSelect: (id) => setState(() => _selectedId = id),
                ),
                const SizedBox(height: 4),
                Expanded(child: _ItemsList(items: selected.items)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(mapErrorToMessage(e), textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedId,
    required this.onSelect,
  });

  final List<FaqCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = categories[i];
          final selected = c.id == selectedId;
          return ChoiceChip(
            label: Text(c.label),
            selected: selected,
            onSelected: (_) => onSelect(c.id),
            shape: const StadiumBorder(),
          );
        },
      ),
    );
  }
}

class _ItemsList extends StatelessWidget {
  const _ItemsList({required this.items});
  final List<FaqItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: items.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 12),
          child: _FaqCard(item: items[i]),
        );
      },
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.item});
  final FaqItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: theme.textTheme.bodyMedium?.copyWith(
        height: 1.55,
        color: inkColor(context),
      ),
      listBullet: theme.textTheme.bodyMedium?.copyWith(
        height: 1.55,
        color: inkColor(context),
      ),
      h3: theme.textTheme.titleSmall,
      strong: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: inkColor(context),
      ),
    );
    return Card(
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          shape: const Border(),
          title: Text(
            item.question,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: inkColor(context),
              height: 1.4,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: MarkdownBody(
                data: item.answer,
                selectable: true,
                styleSheet: styleSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

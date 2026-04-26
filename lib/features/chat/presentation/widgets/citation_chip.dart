import 'package:flutter/material.dart';

import '../../../../core/sse/sse_event.dart';
import '../../../../shared/utils/citation_parser.dart';

class CitationChip extends StatelessWidget {
  const CitationChip({required this.chunk, required this.onTap, super.key});

  final CitationChunk chunk;
  final void Function(CitationChunk chunk, CitationRef? ref) onTap;

  @override
  Widget build(BuildContext context) {
    final ref = CitationParser.parse(chunk.law);
    final scheme = Theme.of(context).colorScheme;
    final tappable = ref != null;
    return ActionChip(
      avatar: Icon(
        Icons.menu_book_outlined,
        size: 16,
        color: tappable ? scheme.primary : scheme.outline,
      ),
      label: Text(chunk.law, overflow: TextOverflow.ellipsis),
      onPressed: tappable ? () => onTap(chunk, ref) : null,
      tooltip: tappable ? '조문 보기' : '조회 불가',
      shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
      backgroundColor: scheme.surface,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/sse/sse_event.dart';
import '../../../../shared/utils/citation_parser.dart';
import 'citation_chip.dart';

/// 답변 메시지 하단에 인용 칩들을 가로 스크롤로 노출.
class CitationsStrip extends StatelessWidget {
  const CitationsStrip({
    required this.citations,
    required this.onTap,
    super.key,
  });

  final List<CitationChunk> citations;
  final void Function(CitationChunk chunk, CitationRef? ref) onTap;

  @override
  Widget build(BuildContext context) {
    if (citations.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '출처',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final c in citations) CitationChip(chunk: c, onTap: onTap),
            ],
          ),
        ],
      ),
    );
  }
}

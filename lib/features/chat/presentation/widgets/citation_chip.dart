import 'package:flutter/material.dart';

import '../../../../core/sse/sse_event.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../shared/utils/citation_parser.dart';

/// 인용 칩. 새 가이드 톤 (📖 + tile tint 배경 + primaryDeep 텍스트).
class CitationChip extends StatelessWidget {
  const CitationChip({required this.chunk, required this.onTap, super.key});

  final CitationChunk chunk;
  final void Function(CitationChunk chunk, CitationRef? ref) onTap;

  @override
  Widget build(BuildContext context) {
    final ref = CitationParser.parse(chunk.law);
    final tappable = ref != null;
    return Material(
      color: AppTokens.lTileTint,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: tappable ? () => onTap(chunk, ref) : null,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📖', style: TextStyle(fontSize: 11.5)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  chunk.law,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: tappable ? AppTokens.lPrimaryDeep : AppTokens.lSub,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

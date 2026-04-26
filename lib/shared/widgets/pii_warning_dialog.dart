import 'package:flutter/material.dart';

import '../utils/pii_detector.dart';

enum PiiDialogChoice { mask, sendAsIs, cancel }

/// PII 가 감지됐을 때 띄우는 다이얼로그.
///
/// 반환값:
/// - [PiiDialogChoice.mask]      → 자동 마스킹 후 전송
/// - [PiiDialogChoice.sendAsIs]  → 그대로 전송 (사용자 명시 동의)
/// - [PiiDialogChoice.cancel]    → 전송 취소 (다이얼로그 dismiss 포함)
Future<PiiDialogChoice> showPiiWarningDialog(
  BuildContext context,
  PiiScanResult result,
) async {
  final choice = await showDialog<PiiDialogChoice>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('개인정보가 포함된 것 같아요'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('다음이 감지되었습니다: ${result.labels.join(', ')}'),
            const SizedBox(height: 12),
            Text(
              '실명·민감정보는 답변 품질에 도움이 되지 않으며, 익명으로 질문하시는 것을 권장해요.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
          ],
        ),
        actionsOverflowDirection: VerticalDirection.down,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(PiiDialogChoice.cancel),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(PiiDialogChoice.sendAsIs),
            child: const Text('그대로 보내기'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(PiiDialogChoice.mask),
            child: const Text('자동 가리기'),
          ),
        ],
      );
    },
  );
  return choice ?? PiiDialogChoice.cancel;
}

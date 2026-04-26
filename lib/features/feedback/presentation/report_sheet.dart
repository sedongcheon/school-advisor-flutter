import 'package:flutter/material.dart';

import '../data/feedback_dto.dart';

class ReportResult {
  const ReportResult({required this.reason, this.comment});
  final ReportReason reason;
  final String? comment;
}

/// 답변 신고 바텀시트.
Future<ReportResult?> showReportSheet(BuildContext context) {
  return showModalBottomSheet<ReportResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _ReportSheetBody(),
  );
}

class _ReportSheetBody extends StatefulWidget {
  const _ReportSheetBody();

  @override
  State<_ReportSheetBody> createState() => _ReportSheetBodyState();
}

class _ReportSheetBodyState extends State<_ReportSheetBody> {
  ReportReason? _reason;
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('이 답변 신고', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            '신고 사유를 알려주시면 답변 품질 개선에 활용됩니다.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 12),
          RadioGroup<ReportReason>(
            groupValue: _reason,
            onChanged: (v) => setState(() => _reason = v),
            child: Column(
              children: [
                for (final r in ReportReason.values)
                  RadioListTile<ReportReason>(
                    value: r,
                    title: Text(r.label),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentCtrl,
            minLines: 2,
            maxLines: 4,
            maxLength: 2000,
            decoration: const InputDecoration(
              labelText: '추가 설명 (선택)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _reason == null
                ? null
                : () => Navigator.of(context).pop(
                    ReportResult(
                      reason: _reason!,
                      comment: _commentCtrl.text.trim().isEmpty
                          ? null
                          : _commentCtrl.text.trim(),
                    ),
                  ),
            child: const Text('신고하기'),
          ),
        ],
      ),
    );
  }
}

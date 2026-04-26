import 'package:flutter/material.dart';

class RatingResult {
  const RatingResult({required this.rating, this.comment});
  final int rating;
  final String? comment;
}

/// 답변 평가 다이얼로그 (별점 1~5 + 선택 코멘트).
Future<RatingResult?> showRatingDialog(BuildContext context) {
  return showDialog<RatingResult>(
    context: context,
    builder: (_) => const _RatingDialogBody(),
  );
}

class _RatingDialogBody extends StatefulWidget {
  const _RatingDialogBody();

  @override
  State<_RatingDialogBody> createState() => _RatingDialogBodyState();
}

class _RatingDialogBodyState extends State<_RatingDialogBody> {
  int _rating = 0;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('답변이 도움이 되었나요?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < _rating;
              return IconButton(
                onPressed: () => setState(() => _rating = i + 1),
                icon: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 32,
                  color: filled ? Colors.amber : scheme.outline,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ctrl,
            minLines: 2,
            maxLines: 4,
            maxLength: 2000,
            decoration: const InputDecoration(
              labelText: '한 줄 의견 (선택)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _rating == 0
              ? null
              : () => Navigator.of(context).pop(
                  RatingResult(
                    rating: _rating,
                    comment: _ctrl.text.trim().isEmpty
                        ? null
                        : _ctrl.text.trim(),
                  ),
                ),
          child: const Text('보내기'),
        ),
      ],
    );
  }
}

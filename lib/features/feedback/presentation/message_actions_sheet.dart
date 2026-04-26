import 'package:flutter/material.dart';

enum MessageAction { rate, report }

/// 어시스턴트 메시지 롱프레스 시 띄우는 액션 시트.
Future<MessageAction?> showMessageActionsSheet(BuildContext context) {
  return showModalBottomSheet<MessageAction>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.star_outline_rounded),
            title: const Text('답변 평가하기'),
            subtitle: const Text('별점과 의견을 남겨주세요'),
            onTap: () => Navigator.of(sheetContext).pop(MessageAction.rate),
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('답변 신고하기'),
            subtitle: const Text('부정확하거나 부적절한 내용일 때'),
            onTap: () => Navigator.of(sheetContext).pop(MessageAction.report),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/app_database.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../../notifications/data/inbox_repository.dart';
import '../../report/data/reports_repository.dart';
import '../../role/application/user_role_notifier.dart';

/// 사안 상세 (교사용) — receiptNo 로 reports 에서 조회 + 단계 진행 버튼.
/// reportsAllProvider 를 watch 해서 statusCode 변경 시 자동 갱신.
class CaseDetailScreen extends ConsumerWidget {
  const CaseDetailScreen({required this.receiptNo, super.key});
  final String receiptNo;

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ReportRow row,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('사안을 삭제할까요?'),
        content: Text(
          '${row.receiptNo} 의 모든 정보가 기기에서 사라집니다.\n'
          '되돌릴 수 없습니다.',
          style: const TextStyle(fontSize: 13.5, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final removed = await ref
        .read(reportsRepositoryProvider)
        .deleteByReceiptNo(row.receiptNo);
    if (!context.mounted) return;
    if (removed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('사안이 삭제되었어요.')));
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  Future<void> _advance(
    BuildContext context,
    WidgetRef ref,
    ReportRow row,
  ) async {
    final next = ReportsRepository.nextStatus(row.statusCode);
    if (next == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('다음 단계로 진행할까요?'),
          content: Text(
            '${ReportsRepository.statusLabel(row.statusCode)} → '
            '${ReportsRepository.statusLabel(next)}',
            style: const TextStyle(fontSize: 13.5, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('진행'),
            ),
          ],
        );
      },
    );
    if (ok != true || !context.mounted) return;
    final result = await ref
        .read(reportsRepositoryProvider)
        .advanceStatus(receiptNo);
    if (result == null) return;
    final (from, to) = result;
    await ref
        .read(inboxRepositoryProvider)
        .create(
          kind: 'milestone',
          title: ReportsRepository.milestoneTitle(from, to),
          detail: '$receiptNo · ${ReportsRepository.statusLabel(to)}',
          receiptNo: receiptNo,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${ReportsRepository.statusLabel(to)} 단계로 변경되었어요.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(reportsAllProvider).value ?? const <ReportRow>[];
    ReportRow? report;
    for (final r in all) {
      if (r.receiptNo == receiptNo) {
        report = r;
        break;
      }
    }
    final role = ref.watch(userRoleProvider);
    final isTeacher = role == UserRole.teacher;

    return Scaffold(
      backgroundColor: AppTokens.lBg,
      appBar: AppBar(
        backgroundColor: AppTokens.lBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppTokens.lInk,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: Text(
          '#${receiptNo.split('-').last}',
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: AppTokens.lInk,
          ),
        ),
        centerTitle: true,
        actions: [
          if (isTeacher)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: AppTokens.lInk),
              onSelected: (key) async {
                final r = report;
                if (key == 'delete' && r != null) {
                  await _confirmDelete(context, ref, r);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 10),
                      Text('사안 삭제'),
                    ],
                  ),
                ),
              ],
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.more_horiz, color: AppTokens.lInk),
            ),
        ],
      ),
      body: SafeArea(
        child: report == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    '해당 번호의 사안을 찾을 수 없어요.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              )
            : _Body(
                report: report,
                isTeacher: isTeacher,
                onAdvance: () => _advance(context, ref, report!),
                onAskAi: () {
                  final r = report!;
                  final prompt =
                      '내 사안(${ReportsRepository.statusLabel(r.statusCode)} 단계)에서 '
                      '지금 가장 먼저 해야 할 일이 뭔가요?';
                  context.push(
                    '${AppRoutes.chat}?prefill=${Uri.encodeQueryComponent(prompt)}',
                  );
                },
              ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.report,
    required this.isTeacher,
    required this.onAdvance,
    required this.onAskAi,
  });
  final ReportRow report;
  final bool isTeacher;
  final VoidCallback onAdvance;
  final VoidCallback onAskAi;

  @override
  Widget build(BuildContext context) {
    final stage = ReportsRepository.stageIndex(report.statusCode);
    final next = ReportsRepository.nextStatus(report.statusCode);
    final canAdvance = next != null;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        _StatusCard(report: report),
        const SizedBox(height: 14),
        if (report.body.isNotEmpty) ...[
          const _SectionLabel('신고 내용'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTokens.lCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTokens.lLine),
            ),
            child: Text(
              report.body,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppTokens.lInk,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        const _SectionLabel('체크리스트'),
        _CheckRow(text: '신고 접수 확인', done: stage >= 0),
        _CheckRow(text: '피해학생 면담', done: stage >= 1),
        _CheckRow(text: '관련학생 진술서 수령', done: stage >= 1),
        _CheckRow(text: '심의위원회 개최', done: stage >= 2),
        _CheckRow(text: '조치 결정 통보', done: stage >= 3),
        const SizedBox(height: 14),
        const _SectionLabel('타임라인'),
        _Timeline(report: report),
        const SizedBox(height: 16),
        if (isTeacher)
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: canAdvance ? onAdvance : null,
                  child: Text(
                    canAdvance
                        ? '${ReportsRepository.statusLabel(next)} 단계로 진행'
                        : '처리 완료',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTokens.lCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTokens.lLine),
                ),
                child: const Text(
                  '보고서',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.lPrimary,
                  ),
                ),
              ),
            ],
          )
        else
          FilledButton.icon(
            onPressed: onAskAi,
            icon: const Icon(Icons.chat_bubble_outline, size: 16),
            label: const Text('AI에 다음 단계 물어보기'),
          ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.report});
  final ReportRow report;

  @override
  Widget build(BuildContext context) {
    final types = ReportsRepository.decodeTypes(report.typesJson);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTokens.lHeroTop, AppTokens.lHeroBottom],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.receiptNo,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppTokens.lInk,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAEAD0),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  ReportsRepository.statusLabel(report.statusCode),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppTokens.lAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${report.gradeBand}학생 · ${types.join('·')}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppTokens.lPrimaryDeep,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: AppTokens.lSub,
      ),
    ),
  );
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.text, this.done = false});
  final String text;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTokens.lCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTokens.lLine),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: done ? AppTokens.lPrimary : Colors.transparent,
              shape: BoxShape.circle,
              border: done
                  ? null
                  : Border.all(color: AppTokens.lLine, width: 1.5),
            ),
            child: done
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: done ? AppTokens.lInk : AppTokens.lSub,
              fontWeight: FontWeight.w600,
              decoration: done ? TextDecoration.lineThrough : null,
              decorationColor: AppTokens.lSub,
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.report});
  final ReportRow report;

  @override
  Widget build(BuildContext context) {
    String fmt(DateTime t) =>
        '${t.month}/${t.day} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    final stage = ReportsRepository.stageIndex(report.statusCode);
    final updated = stage > 0 ? fmt(report.updatedAt) : '-';
    final items = <(String, String, bool)>[
      (fmt(report.createdAt), '신고 접수', stage >= 0),
      (stage >= 1 ? updated : '-', '사안 조사 시작', stage >= 1),
      (stage >= 2 ? updated : '-', '심의위원회 회부', stage >= 2),
      (stage >= 3 ? updated : '-', '조치 결정 통보', stage >= 3),
    ];
    return Column(
      children: [
        for (final it in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  decoration: BoxDecoration(
                    color: it.$3
                        ? AppTokens.lPrimaryDeep
                        : const Color(0x403F7C6A),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    it.$1,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppTokens.lSub,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    it.$2,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: it.$3 ? AppTokens.lInk : AppTokens.lSub,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

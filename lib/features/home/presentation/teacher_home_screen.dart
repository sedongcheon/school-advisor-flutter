import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/app_database.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../../report/data/reports_repository.dart';
import 'case_detail_screen.dart';

/// 교사·전담기구 홈 — KPI / 최근 사안 (모두 reports LIVE) / 빠른 도구.
class TeacherHomeScreen extends ConsumerWidget {
  const TeacherHomeScreen({super.key});

  static const _quick = ['양식 다운로드', '심의 일정표', '법령 검색'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsAllProvider).value ?? const <ReportRow>[];
    final kpi = ref.watch(reportsKpiProvider);
    return Scaffold(
      backgroundColor: AppTokens.lBg,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            _KpiRow(kpi: kpi),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '최근 사안',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: AppTokens.lSub,
                    ),
                  ),
                  Text(
                    '전체 보기 →',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.lPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: reports.isEmpty
                  ? const _EmptyCases()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      children: [
                        for (final r in reports.take(8)) _CaseCard(report: r),
                      ],
                    ),
            ),
            const _QuickTools(items: _quick),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '교사 모드 · 전담기구',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTokens.lSub,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '오늘의 사안',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppTokens.lInk,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppTokens.lCard,
            shape: const CircleBorder(),
            elevation: 1.5,
            shadowColor: Colors.black12,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.push(AppRoutes.notifications),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  Icons.notifications_none,
                  size: 18,
                  color: AppTokens.lInk,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppTokens.lCard,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => context.push(AppRoutes.report),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppTokens.lLine),
                ),
                child: const Text(
                  '+ 새 사안',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.lPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.kpi});
  final ReportsKpi kpi;

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String)>[
      (kpi.inProgress.toString(), '진행 중', '오늘 기준'),
      (kpi.reviewSoon.toString(), '심의 임박', '7일 이내'),
      (kpi.total.toString(), '전체', '누적'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i == items.length - 1 ? 0 : 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTokens.lCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTokens.lLine),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[i].$1,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTokens.lInk,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      items[i].$2,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.lInk,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[i].$3,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppTokens.lSub,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.report});
  final ReportRow report;

  @override
  Widget build(BuildContext context) {
    final tail = report.receiptNo.split('-').last;
    final created = report.createdAt;
    final mm = created.month.toString().padLeft(2, '0');
    final dd = created.day.toString().padLeft(2, '0');
    final hh = created.hour.toString().padLeft(2, '0');
    final mi = created.minute.toString().padLeft(2, '0');
    final meta = '$mm/$dd $hh:$mi · ${report.role}';

    final statusColor = switch (report.statusCode) {
      'received' => AppTokens.lPrimary,
      'investigating' => AppTokens.lAccent,
      'review' => const Color(0xFF7A5A2E),
      'concluded' => AppTokens.lSub,
      _ => AppTokens.lPrimary,
    };

    return GestureDetector(
      onTap: () => Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => CaseDetailScreen(receiptNo: report.receiptNo),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTokens.lCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTokens.lLine),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppTokens.lTileTint,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                tail.substring(0, 2),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTokens.lPrimaryDeep,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#$tail',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppTokens.lInk,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '· ${report.gradeBand}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTokens.lSub,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4ECE2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          ReportsRepository.statusLabel(report.statusCode),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppTokens.lSub,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCases extends StatelessWidget {
  const _EmptyCases();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_open_outlined,
              size: 56,
              color: AppTokens.lSub,
            ),
            const SizedBox(height: 12),
            const Text(
              '아직 접수된 사안이 없어요.',
              style: TextStyle(fontSize: 13.5, color: AppTokens.lInk),
            ),
            const SizedBox(height: 4),
            Text(
              '신고가 들어오면 여기에 나타납니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11.5, color: AppTokens.lSub),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTools extends StatelessWidget {
  const _QuickTools({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: AppTokens.lCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTokens.lLine),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: i < items.length - 1
                        ? const BorderSide(color: AppTokens.lLine)
                        : BorderSide.none,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  items[i],
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.lPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

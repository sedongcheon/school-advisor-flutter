import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/theme/color_scheme.dart';
import '../../report/data/reports_repository.dart';

/// 진행 상황 상세 — 상태 진행 바 + 타임라인 (mock).
class StatusDetailScreen extends ConsumerWidget {
  const StatusDetailScreen({required this.receiptNo, super.key});
  final String receiptNo;

  static const _stages = ['접수', '조사', '심의', '조치'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(reportsRepositoryProvider);
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
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          receiptNo,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: AppTokens.lInk,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<ReportRow?>(
          future: repo.findByReceiptNo(receiptNo),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final report = snap.data;
            if (report == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    '해당 번호의 메모를 찾을 수 없어요.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                _StatusCard(report: report),
                const SizedBox(height: 14),
                const _SectionLabel('진행 단계'),
                _StageBar(stages: _stages, currentIdx: _stageIdx(report)),
                const SizedBox(height: 16),
                const _SectionLabel('타임라인'),
                _Timeline(report: report),
              ],
            );
          },
        ),
      ),
    );
  }

  static int _stageIdx(ReportRow r) {
    return switch (r.statusCode) {
      'received' => 0,
      'investigating' => 1,
      'review' => 2,
      'concluded' => 3,
      _ => 0,
    };
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.report});
  final ReportRow report;

  @override
  Widget build(BuildContext context) {
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
                  _statusLabel(report.statusCode),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppTokens.lAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ReportsRepository.decodeTypes(report.typesJson).join('·'),
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppTokens.lPrimaryDeep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(String code) => switch (code) {
    'received' => '접수 완료',
    'investigating' => '사안 조사 중',
    'review' => '심의 진행',
    'concluded' => '조치 완료',
    _ => '진행 중',
  };
}

class _StageBar extends StatelessWidget {
  const _StageBar({required this.stages, required this.currentIdx});
  final List<String> stages;
  final int currentIdx;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: AppTokens.lCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTokens.lLine),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(stages.length, (i) {
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(
                    right: i == stages.length - 1 ? 0 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: i <= currentIdx
                        ? AppTokens.lPrimary
                        : const Color(0x383F7C6A),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final s in stages)
                Text(
                  s,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTokens.lPrimaryDeep,
                    fontWeight: FontWeight.w700,
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

class _Timeline extends StatelessWidget {
  const _Timeline({required this.report});
  final ReportRow report;

  @override
  Widget build(BuildContext context) {
    final created = report.createdAt;
    final formatted =
        '${created.month}/${created.day} ${created.hour.toString().padLeft(2, '0')}:${created.minute.toString().padLeft(2, '0')}';
    final items = <(String, String, bool)>[
      (formatted, '사안 노트 저장', true),
      ('-', '피해학생 면담 (예정)', false),
      ('-', '관련학생 면담 (예정)', false),
      ('-', '심의위원회 (예정)', false),
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

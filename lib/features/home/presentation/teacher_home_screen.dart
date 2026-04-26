import 'package:flutter/material.dart';

import '../../../core/theme/color_scheme.dart';
import 'case_detail_screen.dart';

/// 교사·전담기구 홈 — KPI / 최근 사안 / 빠른 도구.
/// 모든 데이터는 mock. Stage 3 에서 SQLite 또는 백엔드와 연결.
class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  static const _kpis = <_Kpi>[
    _Kpi(value: '12', label: '진행 중', sub: '+2 today'),
    _Kpi(value: '3', label: '심의 임박', sub: '7일 이내'),
    _Kpi(value: '5', label: '내 담당', sub: '미열람 1'),
  ];
  static const _cases = <_Case>[
    _Case(
      name: '김ㅇㅇ',
      grade: '2-3',
      status: '사안 조사',
      statusColor: AppTokens.lAccent,
      meta: 'D+6 · 마감 D-2',
    ),
    _Case(
      name: '이ㅇㅇ',
      grade: '1-5',
      status: '접수',
      statusColor: AppTokens.lPrimary,
      meta: '오늘 09:14',
    ),
    _Case(
      name: '박ㅇㅇ',
      grade: '3-1',
      status: '심의 예정',
      statusColor: Color(0xFF7A5A2E),
      meta: '5/8 14:00',
    ),
  ];
  static const _quick = ['양식 다운로드', '심의 일정표', '법령 검색'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.lBg,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            const _KpiRow(kpis: _kpis),
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                children: [for (final c in _cases) _CaseCard(c: c)],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTokens.lCard,
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
        ],
      ),
    );
  }
}

class _Kpi {
  const _Kpi({required this.value, required this.label, required this.sub});
  final String value;
  final String label;
  final String sub;
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.kpis});
  final List<_Kpi> kpis;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          for (var i = 0; i < kpis.length; i++)
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i == kpis.length - 1 ? 0 : 8),
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
                      kpis[i].value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTokens.lInk,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      kpis[i].label,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.lInk,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      kpis[i].sub,
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

class _Case {
  const _Case({
    required this.name,
    required this.grade,
    required this.status,
    required this.statusColor,
    required this.meta,
  });
  final String name;
  final String grade;
  final String status;
  final Color statusColor;
  final String meta;
}

class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.c});
  final _Case c;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => CaseDetailScreen(name: c.name, grade: c.grade),
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
                c.name[0],
                style: const TextStyle(
                  fontSize: 13,
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
                        c.name,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppTokens.lInk,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '· ${c.grade}',
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
                          c.status,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: c.statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    c.meta,
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

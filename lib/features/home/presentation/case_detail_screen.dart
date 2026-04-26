import 'package:flutter/material.dart';

import '../../../core/theme/color_scheme.dart';

/// 사안 상세 (교사용) — 상태/관련학생/체크리스트/타임라인.
/// 현재 모든 데이터 mock. Stage 3 에서 SQLite/백엔드 연결.
class CaseDetailScreen extends StatelessWidget {
  const CaseDetailScreen({required this.name, required this.grade, super.key});

  final String name;
  final String grade;

  @override
  Widget build(BuildContext context) {
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
          '$name · $grade',
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: AppTokens.lInk,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_horiz, color: AppTokens.lInk),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const _StatusCard(),
            const SizedBox(height: 14),
            const _SectionLabel('관련 학생'),
            const _PersonRow(name: '김민수', role: '피해 학생 · 2-3', isPeace: true),
            const _PersonRow(name: '이ㅇㅇ', role: '관련 학생 · 2-3'),
            const _PersonRow(name: '박ㅇㅇ', role: '관련 학생 · 2-1'),
            const SizedBox(height: 14),
            const _SectionLabel('체크리스트'),
            const _CheckRow(text: '피해학생 면담 완료', done: true),
            const _CheckRow(text: '관련학생 진술서 수령', done: true),
            const _CheckRow(text: '증거자료 정리'),
            const _CheckRow(text: '보호자 통보'),
            const SizedBox(height: 14),
            const _SectionLabel('타임라인'),
            const _Timeline(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTokens.lPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '진술서 작성',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

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
          const Text(
            'R-2026-0428-1147',
            style: TextStyle(
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
                child: const Text(
                  '사안 조사 중',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppTokens.lAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '마감 D-2 · 사이버폭력',
                style: TextStyle(fontSize: 11.5, color: AppTokens.lPrimaryDeep),
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
  Widget build(BuildContext context) {
    return Padding(
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
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.name,
    required this.role,
    this.isPeace = false,
  });
  final String name;
  final String role;
  final bool isPeace;

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
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppTokens.lTileTint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name[0],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppTokens.lPrimaryDeep,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.lInk,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(fontSize: 10.5, color: AppTokens.lSub),
                ),
              ],
            ),
          ),
          if (isPeace)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTokens.lTileTint,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                '피해',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTokens.lPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
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
  const _Timeline();

  static const _items = <_TLItem>[
    _TLItem('4/22 11:47', '신고 접수', done: true),
    _TLItem('4/24 14:20', '피해학생 면담', done: true),
    _TLItem('4/26 16:00', '관련학생 면담', done: true),
    _TLItem('5/2', '증거자료 정리 마감'),
    _TLItem('5/6 10:00', '심의위원회 (예정)'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final it in _items)
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
                    color: it.done
                        ? AppTokens.lPrimaryDeep
                        : const Color(0x403F7C6A),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 78,
                  child: Text(
                    it.when,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppTokens.lSub,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    it.text,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: it.done ? AppTokens.lInk : AppTokens.lSub,
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

class _TLItem {
  const _TLItem(this.when, this.text, {this.done = false});
  final String when;
  final String text;
  final bool done;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../../notifications/data/inbox_repository.dart';
import '../data/reports_repository.dart';

class ReportFormScreen extends ConsumerStatefulWidget {
  const ReportFormScreen({super.key});

  @override
  ConsumerState<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends ConsumerState<ReportFormScreen> {
  int _step = 0;
  bool _submitting = false;

  // step 0
  String _role = '피해 학생 본인';
  String _grade = '중';
  // step 1
  final Set<String> _types = {'사이버폭력'};
  // step 2
  String _when = '이번 주';
  String _where = '온라인';
  final _bodyCtrl = TextEditingController();
  bool _anonymous = true;

  static const _roles = ['피해 학생 본인', '목격자', '보호자', '교사', '기타'];
  static const _grades = ['초', '중', '고'];
  static const _typeList = [
    ('사이버폭력', 'SNS·단톡·게시글'),
    ('언어폭력', '욕설·비하·협박'),
    ('신체폭력', '때리기·밀치기'),
    ('따돌림', '집단 배제·무시'),
    ('강요·갈취', '돈·물건 요구'),
    ('성폭력', '신체접촉·언어'),
  ];
  static const _whens = ['오늘', '어제', '이번 주', '지난 주', '직접 입력'];
  static const _wheres = ['교실', '복도', '운동장', '온라인', '학교 밖', '기타'];

  @override
  void dispose() {
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final repo = ref.read(reportsRepositoryProvider);
      final report = await repo.create(
        role: _role,
        gradeBand: _grade,
        types: _types,
        whenLabel: _when,
        whereLabel: _where,
        body: _bodyCtrl.text.trim(),
        anonymous: _anonymous,
      );
      // 인박스에 milestone 알림 자동 추가
      await ref
          .read(inboxRepositoryProvider)
          .create(
            kind: 'milestone',
            title: '신고가 접수되었어요',
            detail: '${report.receiptNo} · 곧 사안 조사가 시작돼요',
            receiptNo: report.receiptNo,
          );
      if (!mounted) return;
      context.pushReplacement(
        '${AppRoutes.report}/done?receipt=${report.receiptNo}',
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

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
          onPressed: () {
            if (_step == 0) {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            } else {
              setState(() => _step--);
            }
          },
        ),
        title: const Text(
          '신고하기',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: AppTokens.lInk,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: Text(
                '${_step + 1}/3',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.lSub,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: switch (_step) {
                  0 => _Step0(
                    role: _role,
                    grade: _grade,
                    onRole: (v) => setState(() => _role = v),
                    onGrade: (v) => setState(() => _grade = v),
                    roles: _roles,
                    grades: _grades,
                  ),
                  1 => _Step1(
                    selected: _types,
                    items: _typeList,
                    onToggle: (label) => setState(() {
                      if (_types.contains(label)) {
                        _types.remove(label);
                      } else {
                        _types.add(label);
                      }
                    }),
                  ),
                  _ => _Step2(
                    when: _when,
                    where: _where,
                    whens: _whens,
                    wheres: _wheres,
                    onWhen: (v) => setState(() => _when = v),
                    onWhere: (v) => setState(() => _where = v),
                    bodyCtrl: _bodyCtrl,
                    anonymous: _anonymous,
                    onAnonymous: (v) => setState(() => _anonymous = v),
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting || !_canProceed() ? null : _next,
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_step == 2 ? '제출하기  →' : '다음  →'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    return switch (_step) {
      0 => _role.isNotEmpty && _grade.isNotEmpty,
      1 => _types.isNotEmpty,
      _ => _when.isNotEmpty && _where.isNotEmpty,
    };
  }
}

// ── Step 0: 역할 + 학년대 ────────────────────────────────
class _Step0 extends StatelessWidget {
  const _Step0({
    required this.role,
    required this.grade,
    required this.onRole,
    required this.onGrade,
    required this.roles,
    required this.grades,
  });
  final String role;
  final String grade;
  final ValueChanged<String> onRole;
  final ValueChanged<String> onGrade;
  final List<String> roles;
  final List<String> grades;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('1단계'),
        const SizedBox(height: 6),
        const Text(
          '어떤 분이 신고하시나요?',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTokens.lInk,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 16),
        const _SectionLabel('역할'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final r in roles)
              _ChoiceChip(
                label: r,
                selected: role == r,
                onTap: () => onRole(r),
              ),
          ],
        ),
        const SizedBox(height: 18),
        const _SectionLabel('학년대'),
        Row(
          children: [
            for (final g in grades) ...[
              Expanded(
                child: _SegBtn(
                  label: '$g학생',
                  selected: grade == g,
                  onTap: () => onGrade(g),
                ),
              ),
              if (g != grades.last) const SizedBox(width: 6),
            ],
          ],
        ),
      ],
    );
  }
}

// ── Step 1: 유형 (multi-select) ─────────────────────────
class _Step1 extends StatelessWidget {
  const _Step1({
    required this.selected,
    required this.items,
    required this.onToggle,
  });
  final Set<String> selected;
  final List<(String, String)> items;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('2단계'),
        const SizedBox(height: 6),
        const Text(
          '어떤 일이 있었나요?',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTokens.lInk,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '여러 개를 선택할 수 있어요.',
          style: TextStyle(fontSize: 12.5, color: AppTokens.lSub),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (e) => _TypeRow(
            label: e.$1,
            sub: e.$2,
            selected: selected.contains(e.$1),
            onTap: () => onToggle(e.$1),
          ),
        ),
      ],
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTokens.lCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppTokens.lPrimary : AppTokens.lLine,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTokens.lInk,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      sub,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppTokens.lSub,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: selected ? AppTokens.lPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: selected
                      ? null
                      : Border.all(color: AppTokens.lLine, width: 1.5),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step 2: 시점/장소/본문/익명 ─────────────────────────
class _Step2 extends StatelessWidget {
  const _Step2({
    required this.when,
    required this.where,
    required this.whens,
    required this.wheres,
    required this.onWhen,
    required this.onWhere,
    required this.bodyCtrl,
    required this.anonymous,
    required this.onAnonymous,
  });
  final String when;
  final String where;
  final List<String> whens;
  final List<String> wheres;
  final ValueChanged<String> onWhen;
  final ValueChanged<String> onWhere;
  final TextEditingController bodyCtrl;
  final bool anonymous;
  final ValueChanged<bool> onAnonymous;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('3단계'),
        const SizedBox(height: 6),
        const Text(
          '언제·어디서 있었나요?',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTokens.lInk,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 16),
        const _SectionLabel('시점'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final w in whens)
              _ChoiceChip(
                label: w,
                selected: when == w,
                onTap: () => onWhen(w),
              ),
          ],
        ),
        const SizedBox(height: 14),
        const _SectionLabel('장소'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final w in wheres)
              _ChoiceChip(
                label: w,
                selected: where == w,
                onTap: () => onWhere(w),
              ),
          ],
        ),
        const SizedBox(height: 18),
        const _SectionLabel('상황 설명 (선택)'),
        TextField(
          controller: bodyCtrl,
          minLines: 4,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: '편하게 적어주세요. 누가, 무엇을, 어떻게…',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '익명으로 신고',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.lInk,
                    ),
                  ),
                  Text(
                    '신고자의 신원은 학교에 공개되지 않아요.',
                    style: TextStyle(fontSize: 11.5, color: AppTokens.lSub),
                  ),
                ],
              ),
            ),
            Switch(value: anonymous, onChanged: onAnonymous),
          ],
        ),
      ],
    );
  }
}

// ── 공용 위젯 ───────────────────────────────────────────
class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: AppTokens.lPrimary,
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 2),
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

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTokens.lPrimary : AppTokens.lCard,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppTokens.lPrimary : AppTokens.lLine,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppTokens.lInk,
            ),
          ),
        ),
      ),
    );
  }
}

class _SegBtn extends StatelessWidget {
  const _SegBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTokens.lPrimary : AppTokens.lCard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTokens.lPrimary : AppTokens.lLine,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppTokens.lInk,
            ),
          ),
        ),
      ),
    );
  }
}

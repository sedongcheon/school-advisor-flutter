import 'package:flutter/material.dart';

import '../../../core/theme/color_scheme.dart';
import '../../../shared/utils/citation_parser.dart';
import '../../laws/presentation/law_article_sheet.dart';

class ProcedureFlowScreen extends StatelessWidget {
  const ProcedureFlowScreen({super.key});

  static const _steps = <_FlowStep>[
    _FlowStep(
      title: '사안 발생 · 인지',
      body: '학교폭력이 발생하거나 인지된 시점입니다. 피해학생 보호가 최우선이에요.',
      relatedLaw: '학교폭력예방 및 대책에 관한 법률 제20조',
    ),
    _FlowStep(
      title: '신고 · 접수',
      body: '학교(담임·책임교사·전담기구), 117 신고센터, 경찰 등 어디에든 신고할 수 있어요. 익명 신고도 가능해요.',
      relatedLaw: '학교폭력예방 및 대책에 관한 법률 제20조',
    ),
    _FlowStep(
      title: '사안조사 · 보호조치',
      body: '학교 전담기구가 사실관계를 조사하고, 동시에 피해학생 긴급보호조치(분리·심리상담 등)를 즉시 시행해요.',
      relatedLaw: '학교폭력예방 및 대책에 관한 법률 제16조',
    ),
    _FlowStep(
      title: '학교장 자체해결 vs 심의위원회 회부',
      body:
          '4가지 요건을 모두 충족하고 피해학생 측이 동의하면 학교장이 자체해결, 그렇지 않으면 교육지원청 심의위원회로 회부돼요.',
      relatedLaw: '학교폭력예방 및 대책에 관한 법률 제13조의2',
    ),
    _FlowStep(
      title: '심의 · 조치 결정',
      body:
          '심의위원회가 사안을 심의하고 가해학생에 대한 조치(1~9호)를 결정해요. 통상 21일 이내(7일 연장 가능)에 진행돼요.',
      relatedLaw: '학교폭력예방 및 대책에 관한 법률 제17조',
    ),
    _FlowStep(
      title: '조치 이행 · 이의신청',
      body: '결정된 조치가 이행되며, 이의가 있으면 통지일로부터 90일 이내 행정심판을 청구할 수 있어요.',
      relatedLaw: '학교폭력예방 및 대책에 관한 법률 제17조의2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('절차 흐름도')),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: _steps.length,
          itemBuilder: (context, i) => _StepCard(
            index: i + 1,
            step: _steps[i],
            isLast: i == _steps.length - 1,
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.index,
    required this.step,
    required this.isLast,
  });

  final int index;
  final _FlowStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: scheme.outlineVariant),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: inkColor(context),
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step.body,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _LawChip(label: step.relatedLaw),
                    ],
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

class _LawChip extends StatelessWidget {
  const _LawChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ref = CitationParser.parse(label);
    final tappable = ref != null;
    return ActionChip(
      avatar: Icon(
        Icons.menu_book_outlined,
        size: 16,
        color: tappable ? scheme.primary : scheme.outline,
      ),
      label: Text(label, overflow: TextOverflow.ellipsis),
      onPressed: tappable ? () => showLawArticleSheet(context, ref: ref) : null,
      shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
      backgroundColor: scheme.surface,
    );
  }
}

class _FlowStep {
  const _FlowStep({
    required this.title,
    required this.body,
    required this.relatedLaw,
  });

  final String title;
  final String body;
  final String relatedLaw;
}

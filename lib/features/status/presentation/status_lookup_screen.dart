import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../../report/data/reports_repository.dart';

class StatusLookupScreen extends ConsumerStatefulWidget {
  const StatusLookupScreen({super.key});

  @override
  ConsumerState<StatusLookupScreen> createState() => _StatusLookupScreenState();
}

class _StatusLookupScreenState extends ConsumerState<StatusLookupScreen> {
  final _ctrl = TextEditingController();
  String? _error;
  bool _checking = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    final raw = _ctrl.text.trim();
    final receipt = raw.startsWith('R-') ? raw : 'R-$raw';
    if (raw.isEmpty) {
      setState(() => _error = '접수 번호를 입력해 주세요.');
      return;
    }
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      final row = await ref
          .read(reportsRepositoryProvider)
          .findByReceiptNo(receipt);
      if (!mounted) return;
      if (row == null) {
        setState(() => _error = '해당 번호의 신고를 찾을 수 없어요.');
        return;
      }
      await context.push<void>('${AppRoutes.statusLookup}/${row.receiptNo}');
    } finally {
      if (mounted) setState(() => _checking = false);
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
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text(
          '진행 상황',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: AppTokens.lInk,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                '접수 번호로 조회',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTokens.lInk,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Text(
                '신고 시 발급된 번호를 입력하면 현재 진행 단계를 확인할 수 있어요.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppTokens.lSub,
                  height: 1.55,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppTokens.lCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTokens.lLine),
                ),
                child: Row(
                  children: [
                    const Text(
                      'R-',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTokens.lPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: '2026-0428-1147',
                          hintStyle: TextStyle(color: Color(0xFF9AAA9F)),
                        ),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.lInk,
                          letterSpacing: 0.5,
                        ),
                        onSubmitted: (_) {
                          _lookup();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                '※ 익명 신고도 번호로 조회 가능해요.',
                style: TextStyle(fontSize: 11.5, color: AppTokens.lSub),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                  _error!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _checking ? null : _lookup,
                  child: _checking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('조회하기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

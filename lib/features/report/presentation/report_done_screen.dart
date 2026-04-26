import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';

/// 신고 완료 — R-번호 안내 + 다음 단계.
class ReportDoneScreen extends StatelessWidget {
  const ReportDoneScreen({required this.receiptNo, super.key});
  final String receiptNo;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: receiptNo));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('접수 번호를 복사했어요.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.lBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTokens.lHeroTop, AppTokens.lHeroBottom],
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 44,
                    color: AppTokens.lPrimaryDeep,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '접수가 완료되었어요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTokens.lInk,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '곧 사안 조사가 시작됩니다.\n진행 상황은 아래 번호로 언제든 조회할 수 있어요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTokens.lSub,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppTokens.lCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTokens.lLine),
                ),
                child: Column(
                  children: [
                    const Text(
                      '접수 번호',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        color: AppTokens.lSub,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      receiptNo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTokens.lPrimaryDeep,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => _copy(context),
                      icon: const Icon(Icons.copy, size: 14),
                      label: const Text('번호 복사'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTokens.lPrimary,
                        side: const BorderSide(color: AppTokens.lLine),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.statusLookup),
                child: const Text('진행 상황 보기'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text(
                  '홈으로 돌아가기',
                  style: TextStyle(
                    color: AppTokens.lSub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

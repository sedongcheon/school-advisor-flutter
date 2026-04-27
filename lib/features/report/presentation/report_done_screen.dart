import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/color_scheme.dart';

/// 사안 노트 저장 완료 — 메모 번호 안내 + 다음 단계 안내.
class ReportDoneScreen extends StatelessWidget {
  const ReportDoneScreen({required this.receiptNo, super.key});
  final String receiptNo;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: receiptNo));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('메모 번호를 복사했어요.')));
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
                '사안 노트가 저장되었어요',
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
                '본인 기기에만 저장된 메모예요.\n학교·교육청에 자동 전달되지 않으니, 실제 신고는 학교 전담기구 또는 117 로 연락해 주세요.',
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
                      '메모 번호',
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
                      label: const Text('메모 번호 복사'),
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
                child: const Text('내 사안 노트 보기'),
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

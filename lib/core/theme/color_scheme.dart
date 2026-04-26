import 'package:flutter/material.dart';

/// 앱 색상 시드. 차분하고 신뢰감 있는 Mint Sage.
const Color appSeedColor = Color(0xFF5C8F73);

/// 홈 베이스 배경 — 거의 흰색에 가까운 옅은 그린.
const Color homeBaseBg = Color(0xFFF6F8F2);

/// 좌상단 매우 옅은 글로우. 너무 강하지 않게.
const Color homeGlow = Color(0xFFE9F0E2);

/// 본문 헤드라인용 짙은 그린-그레이 (라이트 전용).
const Color textInk = Color(0xFF1F2A1A);

/// 라이트/다크 모두 적절한 본문 잉크 색을 반환.
///
/// 라이트에서는 [textInk], 다크에서는 colorScheme.onSurface 를 사용한다.
Color inkColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Theme.of(context).colorScheme.onSurface : textInk;
}

/// 긴급 배너 배경 (짙은 모스 그린).
const Color emergencyBg = Color(0xFF2E5D4E);

ColorScheme buildLightColorScheme() =>
    ColorScheme.fromSeed(seedColor: appSeedColor, brightness: Brightness.light);

ColorScheme buildDarkColorScheme() =>
    ColorScheme.fromSeed(seedColor: appSeedColor, brightness: Brightness.dark);

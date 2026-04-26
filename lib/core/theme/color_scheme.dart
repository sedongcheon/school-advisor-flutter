import 'package:flutter/material.dart';

/// 학폭 나침반 — Calm Green 디자인 시스템 토큰.
///
/// Mint Sage 에서 새 가이드(`docs/flutter_export/`) 의 Calm Green +
/// Earth Ochre 팔레트로 전환됨 (2026-04-26).
class AppTokens {
  const AppTokens._();

  // ── Light ─────────────────────────────────────────────
  static const lBg = Color(0xFFEEF5EE);
  static const lInk = Color(0xFF1B3A2E);
  static const lSub = Color(0xFF6B8478);
  static const lPrimary = Color(0xFF3F7C6A);
  static const lPrimaryDeep = Color(0xFF2A5C4D);
  static const lAccent = Color(0xFFC8893A);
  static const lCard = Color(0xFFFFFFFF);
  static const lTileTint = Color(0xFFE5EFE7);
  static const lHeroTop = Color(0xFFDBEBDF);
  static const lHeroBottom = Color(0xFFB9D3BF);
  static const lLine = Color(0x1A3F7C6A);
  static const lChipBg = Color(0x141B3A2E);
  static const lEmBg = Color(0xFFFFE7D6);
  static const lEmFg = Color(0xFF5B3A22);

  // ── Dark ──────────────────────────────────────────────
  static const dBg = Color(0xFF0F1A14);
  static const dInk = Color(0xFFE8EFE9);
  static const dSub = Color(0xFF8FA396);
  static const dPrimary = Color(0xFF9FCAA8);
  static const dPrimaryDeep = Color(0xFF6FA67F);
  static const dAccent = Color(0xFFE0AE6A);
  static const dCard = Color(0xFF1A2820);
  static const dTileTint = Color(0x1A9FCAA8);
  static const dHeroTop = Color(0xFF1F4A3D);
  static const dHeroBottom = Color(0xFF153328);
  static const dLine = Color(0x14FFFFFF);
  static const dEmBg = Color(0xFF3A2A1A);
  static const dEmFg = Color(0xFFE0AE6A);
}

/// 시드 (FromSeed 보조용 — 실제 primary/secondary 는 명시 override 함).
const Color appSeedColor = AppTokens.lPrimary;

/// 라이트 전용 짙은 잉크. 다크에선 [inkColor] 헬퍼가 onSurface 로 분기.
const Color textInk = AppTokens.lInk;

/// 홈 베이스 배경. Stage 1 이후 `AppTokens.lBg` 와 동일.
const Color homeBaseBg = AppTokens.lBg;
const Color homeGlow = AppTokens.lHeroTop;
const Color leadingTint = AppTokens.lTileTint;

/// 긴급 배너 배경 — peach 톤으로 변경 (이전: 짙은 모스 그린).
const Color emergencyBg = AppTokens.lEmBg;
const Color emergencyFg = AppTokens.lEmFg;

ColorScheme buildLightColorScheme() => ColorScheme.fromSeed(
  seedColor: appSeedColor,
  brightness: Brightness.light,
  primary: AppTokens.lPrimary,
  secondary: AppTokens.lAccent,
  surface: AppTokens.lCard,
);

ColorScheme buildDarkColorScheme() => ColorScheme.fromSeed(
  seedColor: appSeedColor,
  brightness: Brightness.dark,
  primary: AppTokens.dPrimary,
  secondary: AppTokens.dAccent,
  surface: AppTokens.dCard,
);

/// 라이트/다크 모두 적절한 본문 잉크 색.
Color inkColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? AppTokens.dInk : AppTokens.lInk;
}

/// 보조 텍스트 색 (라이트/다크 분기).
Color subColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? AppTokens.dSub : AppTokens.lSub;
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 앱 텍스트 테마.
///
/// 새 디자인 가이드는 `Pretendard` 를 사용하지만, ttf 자산이
/// `assets/fonts/pretendard/` 에 번들되기 전까지는 google_fonts 의
/// Noto Sans KR 로 fallback 한다 (런타임 다운로드).
///
/// Pretendard ttf 가 들어오면:
/// 1. `pubspec.yaml` 의 `flutter.fonts` 주석 해제
/// 2. 본 함수의 `_useNotoFallback` 을 `false` 로 전환
/// Pretendard ttf 가 `assets/fonts/pretendard/` 에 번들되면 false 로 변경.
const bool _useNotoFallback = true;

TextTheme buildAppTextTheme(TextTheme base) {
  // ignore: dead_code
  if (_useNotoFallback) {
    final styled = GoogleFonts.notoSansKrTextTheme(base);
    return styled.copyWith(
      titleLarge: styled.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: styled.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: styled.bodyLarge?.copyWith(height: 1.5),
      bodyMedium: styled.bodyMedium?.copyWith(height: 1.5),
      labelLarge: styled.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
  return base
      .apply(fontFamily: 'Pretendard')
      .copyWith(
        titleLarge: base.titleLarge?.copyWith(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          fontFamily: 'Pretendard',
          height: 1.5,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontFamily: 'Pretendard',
          height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
        ),
      );
}

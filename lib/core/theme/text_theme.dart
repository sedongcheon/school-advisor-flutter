import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 앱 텍스트 테마. Noto Sans KR 을 한국어 본문 폰트로 사용.
///
/// 향후 Pretendard ttf 를 `assets/fonts/Pretendard-*.ttf` 로 번들하면
/// 이 파일을 `TextStyle(fontFamily: 'Pretendard')` 기반으로 교체.
TextTheme buildAppTextTheme(TextTheme base) {
  final styled = GoogleFonts.notoSansKrTextTheme(base);
  return styled.copyWith(
    titleLarge: styled.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    titleMedium: styled.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    bodyLarge: styled.bodyLarge?.copyWith(height: 1.5),
    bodyMedium: styled.bodyMedium?.copyWith(height: 1.5),
    labelLarge: styled.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}

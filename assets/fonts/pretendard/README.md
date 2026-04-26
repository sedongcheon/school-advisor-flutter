# Pretendard 폰트 자산

이 폴더는 Pretendard 한글 폰트(OFL 라이선스) 를 번들하는 곳입니다.
새 디자인 가이드(`flutter_export/`) 가 `fontFamily: 'Pretendard'` 를 사용합니다.

## 다운로드 (1회)

[Pretendard GitHub Release](https://github.com/orioncactus/pretendard/releases/latest)
에서 **Pretendard-1.x.x.zip** 을 받아서, 안에 있는 `public/static/woff2` 또는
`public/static/ttf` 폴더의 `.ttf` 4개를 이 폴더(`assets/fonts/pretendard/`)
에 복사하세요.

필요한 weight (4개):
- `Pretendard-Regular.ttf`  (400)
- `Pretendard-Medium.ttf`   (500)
- `Pretendard-SemiBold.ttf` (600)
- `Pretendard-Bold.ttf`     (700)

`pubspec.yaml` 의 `flutter.fonts` 섹션이 자동으로 이 파일들을 픽업합니다.
**ttf 가 없는 동안에는 빌드가 깨지지 않도록 fonts 섹션이 주석 처리되어
있습니다.** ttf 를 넣은 뒤 `pubspec.yaml` 의 해당 주석을 해제해 주세요.

## 라이선스

Pretendard 는 SIL Open Font License 1.1 — 상업/비상업 모두 사용 가능,
재배포·수정 허용. 앱에 번들 시 별도 라이선스 표기 의무는 없으나
설정 → 오픈소스 라이선스 페이지에 노출 권장.

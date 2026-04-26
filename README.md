# school_advisor (Flutter 클라이언트)

학교폭력대책심의위원회(학폭위) 자문 모바일 앱의 Flutter 프론트엔드.
백엔드(`school-advisor`, FastAPI + RAG) 가 제공하는 SSE 스트리밍 답변을 모바일 UX 로 풀어낸다.

> 자세한 개발 지시는 루트의 `CLAUDE.md`, API 명세는 `docs/02_api_integration_spec.md` 참고.

---

## 요구 사항

- Flutter 3.22 이상 (현재 stable 채널 권장)
- Dart 3.4 이상
- Android SDK 33+ / Android Studio (Sprint 1 ~ 5 는 Android 만 타깃)

---

## 설치 & 실행

```sh
flutter pub get

# 개발 (운영 도메인 호출)
flutter run \
  --dart-define=API_BASE_URL=https://school-advisor.sedoli.co.kr \
  --dart-define=APP_ENV=dev

# 디버그 APK 빌드
flutter build apk --debug \
  --dart-define=API_BASE_URL=https://school-advisor.sedoli.co.kr \
  --dart-define=APP_ENV=dev
```

빌드 산출물: `build/app/outputs/flutter-apk/app-debug.apk`

---

## `--dart-define` 환경변수

| 키 | 기본값 | 설명 |
|---|---|---|
| `API_BASE_URL` | `https://school-advisor.sedoli.co.kr` | 백엔드 베이스 URL. 로컬 개발 시 `http://10.0.2.2:8000` (Android 에뮬레이터 → 호스트) |
| `APP_ENV` | `dev` | 환경 식별자 (`dev` / `staging` / `prod`) |
| `SENTRY_DSN` | `""` | 비어 있으면 Sentry 초기화 건너뜀. 운영 빌드에 주입 권장 |

## 패키지명

- Android `applicationId` / `namespace`: **`kr.co.sedoli.schooladvisor`** (도메인 reverse DNS)
- 앱 라벨: 학폭 나침반
- 변경 위치: `android/app/build.gradle.kts`, `android/app/src/main/kotlin/kr/co/sedoli/schooladvisor/MainActivity.kt`, `android/app/src/main/AndroidManifest.xml`

---

## 검증 명령

```sh
flutter analyze                            # 0 issue 유지
dart format --set-exit-if-changed lib test # 포맷 검증
flutter test                               # 단위 테스트

# 모델 변경 후 freezed/json_serializable 코드 재생성
dart run build_runner build --delete-conflicting-outputs
```

---

## 디렉토리 구조 (Sprint 3 시점)

```
lib/
├── main.dart / app.dart / env.dart
├── core/
│   ├── http/                  # Dio + Device ID/Error 인터셉터
│   ├── error/                 # AppException, error_mapper
│   ├── storage/               # Secure Storage 기반 Device ID
│   ├── theme/                 # Material 3 라이트/다크
│   ├── routing/               # go_router (면책 게이트 redirect)
│   └── sse/                   # SseClient + decoder + SseEvent 유니온
└── features/
    ├── onboarding/            # 면책 동의 + 인트로 3페이지
    ├── chat/                  # 실연동 SSE + 마크다운 + 인용 칩 + 신고
    ├── laws/                  # GET /laws + 조문 바텀시트
    ├── user/                  # GET /user/status + 사용량 칩
    ├── feedback/              # POST /feedback (신고)
    └── debug/                 # /health 디버그 화면
shared/
├── utils/
│   ├── pii_detector.dart      # 주민번호/휴대폰/학교명 정규식
│   └── citation_parser.dart   # "학폭예방법 제17조 제1항" 분해
└── widgets/pii_warning_dialog.dart
```

---

## 첫 실행 흐름

1. **면책 동의** (`/onboarding/disclaimer`) — 체크박스 동의 후 진행 가능. `SharedPreferences` 키 `disclaimer_accepted_v1` 로 영속화.
2. **인트로 3페이지** (`/onboarding/intro`) — 서비스 소개 페이지뷰. "건너뛰기" 또는 "시작하기".
3. **역할 선택** (`/role-picker`) — 학생 / 보호자 / 교사. `userRoleProvider` 로 영속화.
4. **홈** (`/`) — 역할별 진입 화면 (학생: 챗봇·신고하기·진행 상황 / 보호자: 자녀 카드 / 교사: 사안 리스트).

> 동의·역할 선택 전까지 라우터 redirect 로 다른 경로 진입을 막는다.

### 전체 사용자 흐름

```
[면책] → [인트로] → [역할 선택]
                      │
       ┌──────────────┼─────────────────┐
       ▼              ▼                 ▼
   [학생 홈]      [보호자 홈]        [교사 홈]
       │              │                 │
       │  ┌──────────┴───────┐          │
       ▼  ▼                  ▼          ▼
   [챗봇]  [신고하기 3-step] [진행 상황]   [사안 리스트]
       │       │               │           │
       │       ▼               ▼           ▼
       │   [R-번호 발급]   [사안 상세]  [사안 상세]
       │                       │
       ▼                       ▼
   [법령 검색]            [단계 진행 / 삭제]
   [FAQ / 절차도]
   [알림 인박스] ◀──── (단계 변경 / 결제 / 푸시)
   [설정 → 결제 / 알림 / 테마]
```

### 데모 모드

`--dart-define=SEED_DEMO=true` 빌드 첫 실행 시 mock reports 3건 + inbox 3건이 자동 적재된다 (`lib/core/dev/demo_seeder.dart`). 운영 빌드는 항상 no-op.

---

## 채팅 화면 (Sprint 3 — 실연동)

- **PII 감지**: 입력 텍스트에서 주민번호/휴대폰/학교명을 정규식으로 탐지 → 전송 전 다이얼로그 ("자동 가리기" / "그대로 보내기" / "취소")
- **SSE 송신**: `POST /api/v1/chat` → `Stream<SseEvent>` (text/citation/done/error)
- **마크다운 렌더**: `flutter_markdown_plus` 로 답변 본문 표시
- **인용 칩**: 답변 하단에 `CitationsStrip` 으로 출처 칩 노출 → 탭 시 `GET /api/v1/laws` 조회 후 바텀시트
- **면책 배너**: 어시스턴트 답변 완료 시 자동 부착
- **사용량 인디케이터**: AppBar 액션에 `남은 N/M` 칩. 채팅 송신 직후 1회 폴링
- **답변 신고**: 어시스턴트 메시지 롱프레스 → 신고 사유 선택 → `POST /api/v1/feedback` (rating: 1, issue_type: reason)

---

## 디버그 헬스체크

홈 → "헬스체크 (디버그)" 항목 → "GET /health 호출" 버튼.
`API_BASE_URL` 로 지정된 백엔드 `/health` 가 200 을 돌려주면 응답 본문을 화면에 표시한다.

---

## Sprint 4 — 부가 화면

- **법령 조문 찾기** (`/laws`) — `assets/laws/index.json` 기반 검색 + 그룹별 카드 + 조문 바텀시트
- **자주 묻는 질문** (`/faq`) — `assets/faq/faq_seed.json` 기반 카테고리 칩 + ExpansionTile (마크다운 답변)
- **절차 흐름도** (`/flow`) — 6단계 정적 위젯 + 단계별 관련 조문 칩
- **답변 평가/신고 분리** — 어시스턴트 메시지 롱프레스 → 액션 시트 (평가 / 신고) → 별점 다이얼로그 또는 사유 시트
- **긴급 배너** — 홈 하단 짙은 그린 배너 → tap 시 `tel:117`

## Sprint 5 (현재 시점) — 다듬기 + 출시 준비

- **패키지명**: `kr.co.sedoli.schooladvisor` (도메인 reverse DNS)
- **한국어 폰트**: `google_fonts` 의 Noto Sans KR 적용. 추후 Pretendard ttf 로 교체하려면 `assets/fonts/` 에 ttf 추가 후 `core/theme/text_theme.dart` 수정.
- **Sentry**: `--dart-define=SENTRY_DSN=...` 주입 시 자동 초기화. zone 미잡힌 예외 + `FlutterError.onError` 모두 보고.
- **앱 아이콘 / 스플래시**: `assets/branding/icon.png`, `assets/branding/splash.png` placeholder 적용. 디자이너 시안 받으면 같은 경로에 덮어쓴 뒤:
  ```sh
  flutter pub run flutter_launcher_icons
  dart run flutter_native_splash:create
  ```
- **설정 화면** (`/settings`):
  - 테마 모드 (시스템 / 라이트 / 다크) — `SharedPreferences` 영속화
  - 서비스 이용 안내(면책) 다시 보기
  - 오픈소스 라이선스 (`showLicensePage`)
  - 앱 버전 (`package_info_plus`)
- **다크 모드 점검**: 라이트 전용 상수(`textInk`, `homeGlow`, `homeBaseBg`)는 `inkColor(context)` 헬퍼와 `brightness` 분기로 다크 모드 안전 처리.
- **Play 가이드 문서**: [docs/05_play_release_guide.md](docs/05_play_release_guide.md)

## Phase 3.1 (현재 시점) — 대화 이력 (로컬 SQLite)

- **drift + drift_flutter** 로 로컬 SQLite (`school_advisor.db`)
- 테이블:
  - `Conversations` — sessionId, conversationId, title, lastPreview, createdAt, updatedAt
  - `Messages` — conversationLocalId(FK cascade), role, content, citationsJson, errorMessage
- 채팅 화면 진입 시 빈 상태 → 첫 송신 시점에 conversation row 자동 생성
- SSE 종료 시점에 어시스턴트 메시지 영속화 (스트리밍 청크별 write 안 함)
- AppBar 액션:
  - **이력 아이콘** → `/chat/history` (대화 카드 목록, 시간 표시, 삭제)
  - **새 대화 아이콘** → 확인 다이얼로그 → `startNewConversation()`
- 이력 화면에서 대화 탭 → `loadConversation(localId)` 로 in-memory 복원

## Phase 3.4 — iOS 빌드 (현재 시점)

- **Bundle ID**: `kr.co.sedoli.schooladvisor` (Android 와 일치)
- **표시 이름**: 학폭 나침반 (`CFBundleDisplayName`)
- **최소 iOS**: 13.0 (`Podfile` + `IPHONEOS_DEPLOYMENT_TARGET`)
- **언어**: 한국어 (`CFBundleLocalizations: ko`)
- **`tel:` / `https:` queries**: `LSApplicationQueriesSchemes` 에 등록
- **시뮬레이터 빌드 검증 완료**: `flutter build ios --simulator --no-codesign` 통과
- **iOS 아이콘 / 스플래시**: `flutter_launcher_icons` / `flutter_native_splash` 의 `ios: true` 활성화 + `remove_alpha_ios` (App Store 요구)
- **출시 가이드**: [docs/06_ios_release_guide.md](docs/06_ios_release_guide.md)

> 실기기 / TestFlight / App Store 는 Apple Developer Program 멤버십 필요.

## Phase 3.3 — Firebase Cloud Messaging (현재 시점)

- Firebase 프로젝트: **`school-advisor-app`** (display name: School Advisor)
- 자격 증명 파일 (모두 `.gitignore` 처리됨, 커밋 금지):
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
  - `lib/firebase_options.dart`
- 패키지: `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, `permission_handler`
- 핵심 컴포넌트:
  - `core/push/push_messaging_service.dart` — 토큰 발급, 권한 요청, 포어그라운드/백그라운드/종료 상태 메시지 핸들러
  - `core/push/notification_payload.dart` — `type` 별 페이로드 파싱 (`law_article`, `notice`, `open`)
  - `features/settings/application/notifications_notifier.dart` — 설정 토글 영속화 + 권한 거부 시 자동 off
- 진입: **설정 → "푸시 알림 받기" 토글** (사용자 의지로 활성화, 침습적 자동 요청 없음)
- Android 알림 채널: `general` (high importance)
- 현재 상태:
  - **클라이언트 완성** — Firebase Console "테스트 메시지 보내기" 로 검증 가능
  - 백엔드 `POST /api/v1/user/push_token` 호출은 **stub** (디버그 출력만). 백엔드 엔드포인트 추가 후 `_postTokenToBackend` 활성화

### 사용자 작업 (실기기 검증 시점)

- **iOS 푸시**: Apple Developer Console 에서 APNs 인증 키 발급 → Firebase Console → 프로젝트 설정 → Cloud Messaging → APNs 키 업로드
- **테스트 메시지**:
  1. 설정 화면에서 푸시 알림 토글 ON
  2. 콘솔에 `[push] FCM token: <token>` 출력 확인
  3. Firebase Console → Cloud Messaging → 새 캠페인 → 토큰 직접 입력 → 메시지 발송

## 다음 단계 (Phase 3.2)

- Phase 3.2: 인앱결제 — **백엔드 `/api/v1/purchase/verify` 추가됨 (2026-04-26)**, 클라이언트 호출 스펙 정합 후 통합 예정

## 부록 docs

| 문서 | 용도 |
|---|---|
| [docs/02_api_integration_spec.md](docs/02_api_integration_spec.md) | 백엔드 API 스펙 (진실의 원천) |
| [docs/07_changelog.md](docs/07_changelog.md) | 누적 변경 이력 |
| [docs/10_store_listing.md](docs/10_store_listing.md) | Play Console / App Store 등록 카피 (한국어) |
| [docs/11_error_catalog.md](docs/11_error_catalog.md) | 사용자 노출 에러/안내 메시지 단일 정리표 |

## 변경 이력

전체 누적 변경 내역은 [docs/07_changelog.md](docs/07_changelog.md) 참고.

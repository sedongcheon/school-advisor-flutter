# 변경 이력 (Changelog)

> 학폭 나침반 (Flutter 클라이언트) 의 누적 변경 내역.
> 백엔드(`school-advisor`)는 별도 레포에서 관리되며 본 문서는 클라이언트 변경에 집중한다.

---

## 2026-04-27 — 모델 D: "개인 사안 노트" 카피 재정렬

신고서가 학교/교육청에 자동 전달된다는 인상을 주는 카피를 정직하게 수정.
실제 동작은 그대로 (로컬 SQLite 저장, 단계는 본인이 수동 진행).

### 의도
- 다중 사용자/학교 간 라우팅·권한 격리 없이 "신고를 받는다"고 표현하면 사용자 신뢰 손상 + 정책 리스크
- 코드/백엔드 변경 없이 카피만으로 "개인용 사안 노트" 로 포지셔닝
- 보호자/교사 모드는 "데이터가 다른" 게 아니라 "관점·톤이 다른" 같은 노트로 명시

### 클라이언트 카피 변경
- `role_picker_screen.dart` — 역할 sub: "직접 도움이 필요해요" → "직접 알아보고 정리해요" 등, 헤더 보조문에 "어떤 역할을 골라도 같은 기능" 명시
- `report_form_screen.dart`
  - 타이틀 "신고하기" → "사안 정리하기"
  - Step0 질문 "어떤 분이 신고하시나요?" → "어떤 분의 사안인가요?"
  - 익명 토글 "익명으로 신고" → "이름 없이 메모"
  - 마지막 버튼 "제출하기" → "저장하기"
  - 인박스 milestone "신고가 접수되었어요" → "사안 노트를 저장했어요"
  - **Step0 상단에 `_LocalSaveNotice` 배너 신설** — 본인 기기 저장·자동 전달 안 됨·실제 신고는 학교/117 명시
- `report_done_screen.dart` — "접수가 완료되었어요" → "사안 노트가 저장되었어요" + 자동 전달 안 됨 안내 추가, "접수 번호" → "메모 번호", "진행 상황 보기" → "내 사안 노트 보기"
- `status_lookup_screen.dart` — "진행 상황 / 접수 번호로 조회" → "내 사안 노트 / 메모 번호로 찾기", "조회하기" → "메모 열기", "익명 신고도 조회 가능" → "본인 기기에만 저장된 메모예요. 자동 전달되지 않아요."
- `status_detail_screen.dart` — 타임라인 "신고 접수" → "사안 노트 저장"
- `home_screen.dart` — 메뉴 "신고하기/익명으로 안전하게" → "사안 정리하기/본인 기기에 메모"
- `guardian_home_screen.dart` — 헤더에 "이 기기에 정리한 사안 노트를 보여드려요" 보조문 추가, 카드 "진행 중인 사안" → "내가 정리한 사안 노트", 빈 카드 "신고하기로 시작" → "\"사안 정리하기\"로 첫 메모를 시작"
- `teacher_home_screen.dart` — "오늘의 사안" → "내가 정리하는 사안 노트", "이 기기에 저장된 메모만 보여드려요. 학교에서 안내·교육 자료로 활용해 주세요." 보조문 추가, 빈 상태 "신고가 들어오면" → "\"사안 정리하기\"로 학교에 안내할 사례를 메모해 보세요"
- `notifications_screen.dart` — 빈 상태 "신고나 사안 진행" → "사안 노트 저장·단계 변경이나 가이드 안내"

### 문서 변경
- `docs/10_store_listing.md` — 짧은/자세한 설명 전면 재작성, "[ 중요 — 신고 책임 분리 ]" 섹션 신설, 키워드에서 "신고/익명신고" 제거, 스크린샷 캡션·출시 노트 갱신
- `docs/11_error_catalog.md` — 사안/빈 상태 메시지 동기화

### 변경하지 않은 것
- 라우트 경로(`AppRoutes.report` 등) — 내부 식별자
- 데이터 모델 / DB 스키마 / 엔드포인트 — 코드 무변경
- 117 / 면책 / PII 마스킹 — 그대로
- 테스트(`role_picker_screen_test`, `onboarding_screen_test`) — 영향 없음, 58/58 통과

---

## 2026-04-27 — 자산 보강 + 데모 시드 + 스토어 메타 + 백엔드 연동 활성화

### 자산
- `assets/laws/index.json` v2 — 학폭예방법·시행령·시행규칙 조문 확장
- `assets/faq/faq_seed.json` v2 — `cyber` 카테고리 신설 + 항목 보강

### 데모 모드
- `lib/core/dev/demo_seeder.dart` — `--dart-define=SEED_DEMO=true` 빌드 첫 실행 시 mock reports 3건 + inbox 3건 자동 적재 (운영 빌드는 항상 no-op)
- `lib/env.dart` — `Env.seedDemo` 상수 추가
- `lib/app.dart` — `initState` 에서 `Future.microtask(() => DemoSeeder.maybeSeed(ref))`

### 문서
- `docs/10_store_listing.md` — Play Console / App Store 등록 카피 (한국어, 4000자 자세한 설명·키워드·스크린샷 캡션·등급 답변·데이터 보안 양식)
- `docs/11_error_catalog.md` — 사용자 노출 에러/안내 메시지 단일 정리표 (네트워크·SSE·PII·결제·푸시·사안·평가·빈상태·면책)
- `README.md` — 사용자 흐름 ASCII 다이어그램, 역할 선택 단계, 데모 모드, 부록 docs 링크
- `docs/01_claude_code_dev_prompt.md` — 루트 `/CLAUDE.md` 와의 이중 관리 회피를 위해 포인터로 축소
- `docs/README.md` — 11개 docs 인덱스로 전면 갱신, 아키텍처 도식 현재 코드 반영

### 백엔드 연동 활성화 (직전 커밋 누락분 보정)
- `lib/features/purchase/application/purchase_notifier.dart` — `platform` 하드코딩 `'android'` → `Platform.isIOS ? 'ios' : 'android'` 분기
- `lib/core/push/push_messaging_service.dart` — `_postTokenToBackend` stub 해제, `POST /api/v1/user/push_token` 실제 호출 (실패 시 non-blocking debugPrint)

---

## 2026-04-26 — 인앱결제 클라이언트 (앱 담당 6)

- `in_app_purchase: ^3.2.0` 패키지 도입
- `features/purchase/data/`:
  - `purchase_product.dart` — 카탈로그(`advisor_7day` / `advisor_30day` / `advisor_teacher`) + planCode 매핑
  - `purchase_repository.dart` — `POST /api/v1/purchase/verify` 호출 + sealed 에러(`PurchaseTokenInvalid` / `PurchaseTokenAlreadyUsed` / `PurchaseProviderError` / `PurchaseUnknownError`)
- `features/purchase/application/purchase_notifier.dart` — `InAppPurchase` 가용성 체크 + `queryProductDetails` + `purchaseStream` 구독 + 검증 + `completePurchase`
- `features/purchase/presentation/purchase_screen.dart` — Mint Sage 톤 헤더 + 3개 플랜 카드 + Play 가격 표시(상품 미등록 시 "곧 출시 예정") + 결제 진행 중 로딩 + 성공/실패 스낵바
- 라우트 `/purchase` 추가
- `usage_indicator` 가 칩 → `/purchase` 로 진입점 제공
- 검증 성공 시 `userStatusProvider.refresh()` fire-and-forget 으로 사용량 즉시 반영

## 2026-04-26 — 멀티턴 다이얼로그 + 7일 컷오프 (앱 담당 4·5)

- `LastSessionMeta` (freezed) — `GET /api/v1/chat/last_session` 응답 (`session_id`, `last_message_at`, `last_user_query`, `days_ago`)
- `chat_repository.fetchLastSession()` 추가
- `conversation_repository.findBySessionId()` — 로컬 SQLite 에서 백엔드 sessionId 로 conversation 검색
- `ChatNotifier.maybeAutoResume(onPromptStale)`:
  - 빈 상태일 때만 1회 호출 (`_autoResumeAttempted` 가드)
  - `null` (이력 없음) → 새 대화 유지
  - `daysAgo <= 7` → 자동 이어가기 (`_resumeWithSessionId` — 로컬 DB 일치 row 있으면 메시지 복원, 없으면 sessionId 만 보존)
  - `daysAgo > 7` → `onPromptStale` 콜백 → 다이얼로그 → 사용자 선택
- `startNewConversation()` 도 `_autoResumeAttempted = true` 로 표시 → 명시적 새 대화 후 재시도 차단
- `stale_session_dialog.dart` — "지난 대화가 있어요" / "이어가기 / 새 대화"
- `ChatScreen.initState` 의 `addPostFrameCallback` 으로 `maybeAutoResume` 호출

## 2026-04-26 — Play Console 출시 준비

- `android/app/build.gradle.kts` — `key.properties` 가 있으면 release 키, 없으면 debug 키로 fallback
- `android/key.properties.example` 템플릿 추가 (`.gitignore` 처리됨)
- 릴리스 AAB 빌드 검증 완료: `build/app/outputs/bundle/release/app-release.aab` (54.4 MB)
- 개인정보 처리방침 한국어 초안: `docs/08_privacy_policy.md`
- GitHub 초기 커밋 + push (`https://github.com/sedongcheon/school-advisor-flutter`)

---

## 2026-04-26 — 앱 명칭 변경: "학폭가이드" → **"학폭 나침반"**

- `MaterialApp.title`, `AndroidManifest android:label`, `Info.plist CFBundleDisplayName/CFBundleName`, 홈 헤로 라벨, 설정 화면 표기, 라이선스 페이지 applicationName 모두 통일
- 문서(`README.md`, `docs/05_play_release_guide.md`, `docs/06_ios_release_guide.md`) 동기화
- 변경하지 않은 것: 패키지 ID(`kr.co.sedoli.schooladvisor`), Dart 패키지 식별자(`school_advisor`), Firebase 프로젝트 display name(`School Advisor`)

---

## Phase 3.4 — iOS 빌드 (2026-04-25)

- iOS Bundle ID 통일: `kr.co.sedoli.schooladvisor`
- `Info.plist` — 한국어 표시명, `CFBundleLocalizations: [ko]`, `LSApplicationQueriesSchemes: [tel, https]`
- `Podfile` — `platform :ios, '13.0'` 명시 (sentry / drift 호환)
- `flutter_launcher_icons` / `flutter_native_splash` 의 iOS 활성화 (`remove_alpha_ios: true`)
- iOS 시뮬레이터 빌드 검증 완료
- 출시 가이드 문서 추가: `docs/06_ios_release_guide.md`

## Phase 3.3 — Firebase Cloud Messaging (2026-04-26)

### 인프라
- `firebase-tools` + `flutterfire_cli` 전역 설치
- Firebase 프로젝트 **`school-advisor-app`** 생성
- `flutterfire configure` 자동 실행으로 다음 생성:
  - `lib/firebase_options.dart`
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
  - Android `google-services` 플러그인 자동 적용
- 자격 증명 파일 모두 `.gitignore` 처리

### 패키지
- `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, `permission_handler` 추가

### 코드
- `core/push/push_messaging_service.dart` — 토큰 발급, 권한 요청, 포어그라운드/백그라운드/종료 상태 메시지 핸들러
- `core/push/notification_payload.dart` — `type` 별 sealed 모델 (`law_article`, `notice`, `open`)
- `pendingPushPayloadProvider` — 알림 탭 페이로드 큐
- `features/settings/application/notifications_notifier.dart` — 토글 영속화 + 앱 시작 시 자동 재활성화
- 설정 화면에 **"푸시 알림 받기" 토글 카드** 추가

### 딥링크
- `SchoolAdvisorApp` (Stateful 로 전환) 가 `pendingPushPayloadProvider` 를 listen
- `LawArticle` 페이로드 → `showLawArticleSheet` 자동 호출
- `Open` → 단순 앱 열림

### 네이티브 설정
- `AndroidManifest.xml` — `POST_NOTIFICATIONS` (Android 13+), `INTERNET` 권한
- `android/app/build.gradle.kts` — core library desugaring 활성화 (`flutter_local_notifications` 요구)

### 백엔드 연동
- `_postTokenToBackend` 가 `POST /api/v1/user/push_token` 호출 (2026-04-27 활성화, 실패 시 non-blocking)
- 실 토큰 검증: Firebase Console "테스트 메시지 보내기" 로 확인됨 (포어그라운드 알림 수신)

---

## Phase 3.1 — 대화 이력 (로컬 SQLite, 2026-04-25)

- `drift: ^2.21.0` + `drift_flutter: ^0.2.4` 도입, `drift_dev` 코드 생성
- 테이블:
  - `Conversations(id, sessionId, conversationId?, title, lastPreview, createdAt, updatedAt)`
  - `Messages(id, conversationLocalId FK cascade, role, content, citationsJson, errorMessage, createdAt)`
- `ConversationRepository` — watchAll/create/findById/updateMeta/addMessage/updateMessage/getMessages/delete
- `ChatNotifier` 통합:
  - 첫 송신 시점에 conversation 자동 생성 (title = 첫 사용자 메시지 30자)
  - SSE 종료/에러 시점에 어시스턴트 메시지 일괄 영속화 (스트리밍 청크별 write 안 함)
  - `startNewConversation()` / `loadConversation(localId)` 메서드
  - `ChatMessage.dbId`, `ChatState.conversationLocalId` 추가
- `HistoryScreen` (`/chat/history`):
  - `watchAll` 스트림 기반 카드 목록
  - 상대 시간 포맷, 항목 탭 시 복원, 우측 휴지통 → 확인 → 삭제
- ChatScreen AppBar 에 이력/새 대화 아이콘 추가

---

## Sprint 5 — 다듬기 + 출시 준비 (2026-04-25)

### 패키지명
- Android `applicationId`/`namespace`: `com.sedoli.school_advisor` → **`kr.co.sedoli.schooladvisor`** (도메인 reverse DNS 정통)
- `MainActivity.kt` 디렉토리 이동 + 패키지 선언 동기화
- 앱 라벨: 학폭가이드(이후 학폭 나침반으로 재변경)

### 한국어 폰트
- `google_fonts` 의 Noto Sans KR 적용
- Pretendard 는 Google Fonts 미등재 — `assets/fonts/` 번들 가이드만 README 에 명시

### Sentry
- `sentry_flutter` 추가, `core/observability/sentry_init.dart`
- `--dart-define=SENTRY_DSN=...` 비어 있으면 init skip
- `bootstrap()` 가 zone 미잡힌 예외 + `FlutterError.onError` 자동 보고

### 설정 화면
- 테마 모드 (시스템/라이트/다크) SegmentedButton + `SharedPreferences` 영속화
- 서비스 이용 안내 다시 보기, 오픈소스 라이선스, 앱 버전(`package_info_plus`)

### 앱 아이콘 / 스플래시
- `flutter_launcher_icons` + `flutter_native_splash` 도입
- 사용자 제공 아이콘 자산(`assets/branding/{icon, android-adaptive-bg, android-adaptive-fg, splash}.png`)으로 양 플랫폼 일괄 생성

### 다크 모드 안전화
- `inkColor(BuildContext)` 헬퍼 도입 — 라이트는 `textInk`, 다크는 `colorScheme.onSurface`
- 모든 화면의 `color: textInk` 일괄 치환
- 홈의 라디얼 글로우는 다크에서 생략

### 문서
- `docs/05_play_release_guide.md` — 키스토어 / `key.properties` / 서명 빌드 / AAB / Play Console / 체크리스트

---

## Sprint 4 — 부가 화면 (2026-04-25)

- **법령 조문 찾기** (`/laws`) — `assets/laws/index.json` 인덱스 기반 검색 + 그룹별 카드 + 조문 바텀시트
- **자주 묻는 질문** (`/faq`) — `assets/faq/faq_seed.json` 카테고리 칩 + ExpansionTile (마크다운 답변)
- **절차 흐름도** (`/flow`) — 6단계 정적 위젯 + 단계별 관련 조문 칩
- **답변 평가/신고 분리** — 어시스턴트 메시지 롱프레스 → 액션 시트(평가/신고) → 별점 다이얼로그 또는 사유 시트
- **긴급 배너** — 홈 하단 짙은 그린 배너 → tap 시 `tel:117`
- **답변 액션 ⋯ 버튼** — 메시지 박스 우측 하단 "평가 · 신고" 라벨 (롱프레스 fallback 유지)

---

## Sprint 3 — 채팅 실연동 + 안전장치 (2026-04-25)

### 백엔드 정합 재설계
- `event: citation` → 단일이 아니라 `chunks: List<CitationChunk>` 배열로 수정
- `event: done` → `conversation_id`/`model`/`tokens` 필드 매핑
- `CitationChunk{id, law, url}` 단일 문자열 라벨로 보존, `CitationParser` 가 `/laws` 호출 시 정규식으로 분해

### 핵심 흐름
- `chat_repository` → `POST /api/v1/chat` SSE 호출
- `chat_notifier` 의 `text/citations/done/error` 분기, `conversationId` 보관
- 마크다운 렌더(`flutter_markdown_plus`), 면책 배너 자동 부착, 인용 칩 strip

### 안전장치
- `pii_detector.dart` — 주민번호/휴대폰/학교명 정규식 + 마스킹
- `pii_warning_dialog.dart` — 자동 가리기 / 그대로 / 취소
- `usage_indicator.dart` — AppBar 칩, 임박/소진 시 색상 변경, 송신 직후 1회 폴링
- `feedback_repository` — `report(reason)` (rating: 1 자동 주입), `sendRating(1~5)`

### 트러블슈팅
- SSE 디코더의 `Stream<Uint8List>` → `utf8.decoder` 캐스팅 누락으로 `_TypeError` 발생 → `bytes.cast<List<int>>().transform(utf8.decoder)` 로 해결
- `ErrorInterceptor` 가 stream 구간에서 우회되는 경우 raw `DioException` 이 `unknown` 으로 매핑되던 문제 → `mapErrorToMessage` 가 `DioException` 을 직접 받으면 `type`/status 로 코드 추론하도록 보강

---

## Sprint 2 — 면책 + 온보딩 + SSE 골격 (2026-04-25)

- 의존성 결정: freezed 3.x 채택을 위해 `riverpod_generator`/`riverpod_lint`/`custom_lint` 제거 (raw provider 만 사용)
- `core/sse/{sse_event, sse_decoder}.dart` — text/event-stream 디코더 (단위 테스트 9개)
- 면책 동의 (`SharedPreferences` 영속화) + go_router redirect 게이트
- 인트로 3페이지 (PageView)
- 채팅 화면 셸 + 더미 글자 단위 스트리밍

---

## Sprint 1 — 부트스트랩 (2026-04-25)

- Flutter 3.41.6 / Dart 3.11.4 환경
- 의존성: `flutter_riverpod`, `go_router`, `dio`, `flutter_secure_storage`, `shared_preferences`, `uuid`, `freezed`, `json_serializable`, `very_good_analysis`
- 디렉토리 구조: `core/{http,error,storage,theme,routing}` + `features/`
- `Dio` 단일 인스턴스 + Device ID/Error 인터셉터
- Material 3 라이트/다크 테마 (시드 색은 이후 Mint Sage 로 변경)
- go_router 셸 + 디버그 헬스체크 화면
- 단위 테스트: error_mapper, error_interceptor, device_id_interceptor

---

## 백엔드 (참고)

본 클라이언트와 같이 동작하는 백엔드 변경은 `school-advisor` 레포에서 별도 관리.

| 엔드포인트 | 백엔드 추가 | 클라이언트 활성화 |
|---|---|---|
| `POST /api/v1/purchase/verify` (Phase 3.2) | 2026-04-26 | 2026-04-27 (Android/iOS 자동 분기) |
| `POST /api/v1/user/push_token` (Phase 3.3) | 2026-04-26 | 2026-04-27 (실패 non-blocking) |

# Claude Code 개발 지시 프롬프트 — Flutter 클라이언트

> **용도**: 학폭 자문 앱의 **Flutter 모바일 앱**을 Claude Code에게 맡길 때 사용
> **사용법**: 이 파일을 프로젝트 루트에 `CLAUDE.md`로 복사 후 `claude` 실행 → "이 파일 읽고 Sprint 1부터 시작해줘"
> **백엔드**: `/Users/cheonsedong/Documents/appProject/school-advisor/` (FastAPI · 이미 운영 중)

---

## 🎯 프로젝트 개요

학교폭력대책심의위원회(학폭위) 관련 법령·절차·조치사항을 안내하는 **RAG 기반 AI 자문 모바일 앱**의 Flutter 프론트엔드를 구현한다.

**한 줄 요약**: 백엔드(FastAPI + RAG)가 제공하는 SSE 스트리밍 답변을 자연스러운 모바일 UX로 풀어내는 Flutter 앱.

**중요 — 이 레포의 책임 범위**
- ✅ **포함**: Flutter 코드, 화면, 상태관리, API 연동, 결제, 면책 UI, 인앱 라우팅
- ❌ **제외**: 백엔드 코드(이미 별도 레포), RAG 로직, LLM 호출, DB 마이그레이션
- ❌ **금지**: 클라이언트에서 LLM API 직접 호출, API 키 보관, 법령 데이터 직접 가공

---

## 📌 당신의 역할

당신은 이 프로젝트의 **시니어 Flutter 엔지니어**다. 다음 원칙을 지켜라:

1. **코드를 쓰기 전에 반드시 계획을 세우고 내게 확인받는다.** 특히 디렉토리 구조, 패키지 선택, 라우팅 설계는 합의 먼저.
2. **한 번에 한 단계씩 진행한다.** 한 번에 10개 위젯을 만들지 말고, 화면 하나씩 완성하고 검증받아라.
3. **에러를 임시방편으로 가리지 않는다.** `try { ... } catch (_) {}` 금지, 사용자에게 의미 있는 메시지로 매핑.
4. **테스트 가능한 코드를 쓴다.** Repository는 인터페이스로 분리, Notifier는 mock repository로 단위 테스트.
5. **모르면 추측하지 말고 묻는다.** 백엔드 응답 포맷이 모호하면 `school-advisor/app/schemas/*.py` 또는 실제 호출로 확인.
6. **한국어로 소통한다.** 코드 주석·커밋 메시지·UI 카피·문서 모두 한국어.
7. **백엔드는 진실의 원천이다.** API 스펙은 백엔드 Pydantic 스키마를 기준으로 한다. 앱 코드를 위해 백엔드를 바꾸지 마라.

---

## 🏗 기술 스택 (확정)

### 프레임워크 / 언어
- **Flutter**: 3.x (안정 채널)
- **Dart**: 3.x (sound null safety)
- **상태관리**: **Riverpod** (`flutter_riverpod` + `riverpod_annotation` 코드 생성)
- **라우팅**: `go_router` (선언적, 딥링크 호환)

### HTTP / 스트리밍
- **HTTP 클라이언트**: `dio`
- **SSE**: 직접 구현 (`dio` + `Stream<List<int>>`) 또는 `flutter_client_sse` — 실제 호환성 확인 후 선택
  - 이유: 백엔드는 `text/event-stream`을 표준 프레임으로 보냄. 패키지 선택 전에 실제 호환성 확인.
- **JSON 직렬화**: `freezed` + `json_serializable`

### 저장소 / 시크릿
- **Device ID**: `flutter_secure_storage` (앱 재설치 시까지 유지)
- **로컬 캐시**: `shared_preferences` (FAQ, 설정)
- **세션 이력 (유료)**: 로컬 SQLite (`drift`) — Phase 2에서 도입

### UI / UX
- **테마**: Material 3, 시스템 테마 자동 추종
- **폰트**: Pretendard (한국어 가독성, OFL 라이선스)
- **마크다운 렌더링**: `flutter_markdown` (답변 본문 + 인용 출처 렌더)
- **아이콘**: Material Icons + 커스텀 SVG (`flutter_svg`)

### 결제 (Phase 3)
- `in_app_purchase` (Google Play 공식)
- 구매 토큰은 **반드시 백엔드 `/api/v1/purchase/verify`로 검증 후 활성화** — 클라이언트 단독 신뢰 금지

### 관측 / 분석
- **에러**: `sentry_flutter` (백엔드 SENTRY_DSN과 별도 프로젝트)
- **사용 분석**: Firebase Analytics 또는 PostHog (추후 결정)

### 테스트
- `flutter_test` (위젯 테스트)
- `mocktail` (Mock)
- `integration_test` (E2E, 빌드 가능 시)

---

## 📁 디렉토리 구조 (이대로 만들어라)

```
school-advisor-flutter/
├── pubspec.yaml
├── analysis_options.yaml          # very_good_analysis 또는 lints 권장
├── README.md
├── CLAUDE.md                      # 이 파일의 사본
├── docs/                          # 이 docs 폴더 (참고용 유지)
├── android/
├── ios/
├── assets/
│   ├── fonts/                     # Pretendard
│   ├── icons/                     # 앱 아이콘 원본
│   ├── faq/faq_seed.json          # FAQ 사전 답변 (LLM 미호출)
│   └── flowchart/procedure.json   # 절차 흐름도 데이터
├── lib/
│   ├── main.dart                  # runApp + ProviderScope + Sentry
│   ├── app.dart                   # MaterialApp.router + Theme
│   ├── env.dart                   # --dart-define 으로 주입되는 상수
│   │
│   ├── core/
│   │   ├── http/
│   │   │   ├── dio_provider.dart            # Dio 싱글톤 + Interceptors
│   │   │   ├── device_id_interceptor.dart   # X-Device-ID 자동 부착
│   │   │   └── error_interceptor.dart       # DioException → AppException
│   │   ├── sse/
│   │   │   └── sse_client.dart              # POST + text/event-stream 디코더
│   │   ├── error/
│   │   │   ├── app_exception.dart           # NetworkError, QuotaExceeded, ...
│   │   │   └── error_mapper.dart            # code → 사용자 메시지
│   │   ├── storage/
│   │   │   └── device_id_provider.dart      # Secure Storage UUID
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── color_scheme.dart
│   │   │   └── text_theme.dart
│   │   └── routing/
│   │       └── app_router.dart              # go_router
│   │
│   ├── features/
│   │   ├── onboarding/
│   │   │   ├── application/disclaimer_notifier.dart
│   │   │   └── presentation/
│   │   │       ├── disclaimer_screen.dart    # 면책 고지 (체크 필수)
│   │   │       └── intro_pages_screen.dart   # 3단계 페이지 스와이프
│   │   ├── chat/
│   │   │   ├── data/
│   │   │   │   ├── chat_dto.dart             # freezed
│   │   │   │   └── chat_repository.dart      # SSE 호출
│   │   │   ├── application/
│   │   │   │   └── chat_notifier.dart        # AsyncNotifier
│   │   │   └── presentation/
│   │   │       ├── chat_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── message_bubble.dart
│   │   │       │   ├── citation_chip.dart
│   │   │       │   ├── disclaimer_banner.dart
│   │   │       │   ├── suggestion_chips.dart
│   │   │       │   └── input_bar.dart
│   │   ├── laws/
│   │   │   ├── data/laws_repository.dart
│   │   │   └── presentation/
│   │   │       ├── law_search_screen.dart
│   │   │       └── law_article_sheet.dart    # 인용 칩 탭 시 바텀시트
│   │   ├── flowchart/
│   │   │   └── presentation/procedure_flow_screen.dart
│   │   ├── faq/
│   │   │   ├── data/faq_repository.dart      # 자산에서 로드
│   │   │   └── presentation/faq_screen.dart
│   │   ├── feedback/
│   │   │   ├── data/feedback_repository.dart
│   │   │   └── presentation/feedback_dialog.dart
│   │   ├── user/
│   │   │   ├── data/user_repository.dart
│   │   │   └── presentation/usage_indicator.dart
│   │   └── purchase/                         # Phase 3
│   │       └── ...
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── error_view.dart
│       │   ├── loading_dots.dart
│       │   └── pii_warning.dart              # 개인정보 입력 감지 다이얼로그
│       ├── utils/
│       │   ├── pii_detector.dart             # 정규식 기반 (이름/학교/주민번호)
│       │   └── markdown_renderer.dart
│       └── models/
│           └── ...
└── test/
    ├── core/
    ├── features/
    └── widget/
```

> 폴더 명명: feature 안은 **`data` / `application` / `presentation`** 3계층으로 분리. UI는 항상 `presentation/`만 의존하고, `data/`는 외부 IO만 책임지며, `application/`이 둘을 묶는다.

---

## 🔌 백엔드 API 요약 (자세한 명세는 `docs/02_api_integration_spec.md`)

| 메서드 | 경로 | 용도 | 헤더 |
|---|---|---|---|
| POST | `/api/v1/chat` | SSE 스트리밍 답변 | `X-Device-ID` |
| GET | `/api/v1/laws` | 조문 직접 조회 | - |
| POST | `/api/v1/feedback` | 답변 평가 | - |
| GET | `/api/v1/user/status` | 이용권·사용량 | `X-Device-ID` |
| GET | `/health` | 헬스체크 | - |

- **Base URL (예시)**: `https://school-advisor.sedoli.co.kr` — 실제 값은 `--dart-define=API_BASE_URL=...` 으로 주입.
- **Rate Limit**: 분당 5회. 초과 시 `429`.
- **이용권 한도 초과**: `/chat` SSE 스트림 내 `event: error / code: quota_exceeded`로 도달 (HTTP 200 유지).

---

## 🛡 절대 안전장치 (타협 불가)

### 1. 면책 고지 (Disclaimer)
- **첫 실행**: 전체화면 면책 동의, 체크박스 동의 안 하면 진행 불가
- **모든 답변 하단**: `DisclaimerBanner` 자동 부착 (백엔드 답변에 이미 면책 문구 포함되어 있어도 시각적 강조)
- **설정 → 약관**: 상시 열람 가능

### 2. 개인정보 입력 차단
- 입력창 `onChanged`에서 정규식으로 다음 패턴 감지:
  - 주민번호: `\d{6}[-\s]?[1-4]\d{6}`
  - 휴대폰: `01[016-9][-\s]?\d{3,4}[-\s]?\d{4}`
  - 학교명: "○○초등학교/중학교/고등학교" 패턴 (실명 추정)
- 감지 시 **전송 전** 다이얼로그로 경고 + 자동 마스킹 옵션 제시.
- **백엔드도 `sanitize_input`으로 마스킹하므로 이중 방어** — 앱은 UX 차원에서, 백엔드는 보존 차원에서.

### 3. 답변 신고 기능 (Play 정책 필수)
- 답변 메시지 롱프레스 → "신고" 메뉴 → `POST /api/v1/feedback`에 `issue_type=report` 로 전송.

### 4. 사용량 가시성
- 채팅 화면 상단/입력바 옆에 `남은 횟수 N/M` 표시 (`/api/v1/user/status` 폴링은 채팅 송신 직후 1회).
- 무료 사용자가 한도 임박 시 (남은 1회) 결제 안내 칩 노출.

### 5. 에러 메시지 일관성
- `core/error/error_mapper.dart`에 `code → 사용자 문구` 단일 소스.
- 예: `quota_exceeded → "일일 이용 한도에 도달했어요. 이용권을 확인해 주세요."`
- 콘솔 스택트레이스를 사용자에게 노출 금지.

### 6. Device ID 영속화
- 첫 실행 시 `Uuid().v4()`로 생성 → `flutter_secure_storage`에 저장.
- 앱 재설치 시 새 ID 발급되는 것은 **의도된 동작** (익명성 유지).

### 7. 결제 검증 (Phase 3)
- `purchase.purchaseDetails.verificationData.serverVerificationData`를 백엔드 `/api/v1/purchase/verify`에 POST.
- 검증 성공 응답 후에만 유료 기능 토글.
- 클라이언트 단독으로 `entitlement = paid` 상태 부여 절대 금지.

---

## 🚀 개발 순서 (이 순서로 진행)

### Sprint 1: 부트스트랩 (1~2일)
1. `flutter create` + `pubspec.yaml` (필수 패키지만)
2. `analysis_options.yaml` (`very_good_analysis` 또는 `flutter_lints`)
3. `main.dart` + `app.dart` + ProviderScope + 다크/라이트 테마
4. `env.dart` (`--dart-define` 기반 BASE_URL)
5. `go_router` 기본 셸 (`/`, `/chat`, `/laws`, `/flow`, `/faq`, `/settings`)
6. `Dio` Provider + Device ID Interceptor + 에러 Interceptor
7. `/health` 호출하여 백엔드 연결 검증 (디버그 화면에서)
8. **중단점**: 빌드 OK + 헬스체크 200 확인 → 내가 검토

### Sprint 2: 면책 + 온보딩 + 채팅 골격 (3일)
1. 첫 실행 면책 동의 화면 (`SharedPreferences` 플래그)
2. 3단계 인트로 페이지뷰
3. 채팅 화면 셸 (입력바 + 메시지 리스트)
4. **SSE 클라이언트** 구현 — `event: text/citation/done/error` 디코더 단위 테스트 필수
5. 더미 응답으로 메시지 버블 + 스트리밍 점멸 효과
6. **중단점**: SSE 디코더 테스트 통과 + 더미 채팅 흐름 확인

### Sprint 3: 채팅 실연동 + 인용 칩 + 면책 배너 (3일)
1. `chat_repository.dart` — 실제 `/api/v1/chat` POST + SSE 소비
2. 인용 출처 칩 → 탭 시 `/api/v1/laws` 호출 → 바텀시트
3. 면책 배너 위젯 (답변 메시지 하단 자동)
4. 개인정보 입력 감지 다이얼로그
5. 사용량 인디케이터 (`/api/v1/user/status`)
6. **중단점**: 실제 백엔드와 E2E 흐름 확인

### Sprint 4: 부가 화면 (3일)
1. 조문 검색 화면 (목록 + 검색 + 상세)
2. FAQ 퀵 탭 (자산 JSON 기반, LLM 미호출)
3. 절차 흐름도 (정적 위젯, 6단계)
4. 답변 피드백 다이얼로그 (1~5점 + 옵션 코멘트)
5. 답변 신고 메뉴
6. **중단점**: 모든 핵심 화면 동작 확인

### Sprint 5: 다듬기 + 출시 준비 (2일)
1. 한국어 카피 통일 (UX writing 패스)
2. 다크/라이트 모드 검수
3. 에러 메시지 매핑표 정리
4. Sentry 연동
5. 앱 아이콘 + 스플래시 (`flutter_native_splash`, `flutter_launcher_icons`)
6. Android 릴리스 빌드 + Play Console 내부테스트 업로드 가이드 작성

### Phase 3 (별도 트랙)
- 인앱결제 (`in_app_purchase`) + 백엔드 검증 연동
- 대화 이력 저장 (`drift`)
- 푸시 알림 (법령 개정 알림)
- iOS 빌드

---

## ✅ 완료 기준 (Definition of Done)

각 Sprint 종료 시:

- [ ] **분석**: `flutter analyze` 0 issue
- [ ] **포맷**: `dart format --set-exit-if-changed lib test`
- [ ] **테스트**: `flutter test` 통과 (핵심 Repository / Notifier 단위 테스트 + SSE 디코더)
- [ ] **빌드**: Android Debug APK 생성 성공
- [ ] **README**: 신규 화면·환경변수·실행 명령 추가
- [ ] **커밋**: Conventional Commits (`feat(chat): ...`, `fix(sse): ...`)

---

## ⚠️ 하지 말아야 할 것

- ❌ **`setState` 대규모 사용** — Riverpod로 통일. `StatefulWidget`은 진짜 위젯 로컬 상태(애니메이션 컨트롤러 등)에만.
- ❌ **`Dio` 인스턴스 여러 개 생성** — `dioProvider` 하나만.
- ❌ **`Future.microtask` / 임의 비동기 패치로 race condition 회피** — `AsyncNotifier`의 `state = AsyncLoading()` 패턴 준수.
- ❌ **JSON을 손으로 파싱** — 반드시 `freezed` + `json_serializable`.
- ❌ **인앱결제 영수증 검증을 클라이언트만으로 처리** — 백엔드 검증 필수.
- ❌ **API Key·시크릿 코드에 하드코딩** — `--dart-define`만.
- ❌ **`print()` 디버깅 잔재** — `debugPrint` 또는 Sentry breadcrumb.
- ❌ **거대한 PR** — 화면 단위로 쪼개라.
- ❌ **법령 데이터를 앱에 번들** — 일부 FAQ 시드만 허용. 본 데이터는 백엔드.
- ❌ **답변 본문에 클라이언트가 임의 후처리** — 금칙어·면책 부착은 백엔드 책임. 앱은 표시만.

---

## 📋 시작할 때 할 일

1. 이 파일을 끝까지 읽었는지 확인하고, 이해한 내용을 **3문장**으로 요약해 말해줘.
2. **Sprint 1 계획**을 세워서 내게 보여줘 (실제 코드 쓰기 전):
   - 추가할 패키지 목록과 버전
   - `pubspec.yaml` 초안
   - `analysis_options.yaml` 초안
   - `--dart-define` 환경변수 키 목록
3. 백엔드 BASE_URL 확인 — 도메인이 운영 단계인지(`school-advisor.sedoli.co.kr`) 또는 로컬 개발 중인지(`http://localhost:8000`) 내게 묻고 진행.
4. 내 승인 후 Sprint 1 구현 시작.

질문이 있으면 코드 쓰기 전에 물어라. **불명확한 채로 진행하는 게 가장 나쁜 선택이다.**

---

## 📚 참고 문서

- API 연동 명세: `docs/02_api_integration_spec.md`
- UI/UX 설계 가이드: `docs/03_ui_ux_design_prompt.md`
- 백엔드 레포: `/Users/cheonsedong/Documents/appProject/school-advisor/`
  - 엔드포인트 원본: `app/api/{chat,laws,feedback,user,health}.py`
  - 스키마(JSON 진실의 원천): `app/schemas/*.py`
  - 시스템 프롬프트(답변 톤 참고): `docs/02_system_prompt.md`
  - 제품 기획 원본: `docs/학폭위_자문앱_PRD_v1.0.docx`
- Flutter 공식: https://docs.flutter.dev
- Riverpod: https://riverpod.dev
- go_router: https://pub.dev/packages/go_router

---

## 변경 이력

| 버전 | 날짜 | 변경 내역 |
|---|---|---|
| v1.0 | 2026-04-25 | 초기 작성 (백엔드 Sprint 1~5 완료 시점) |

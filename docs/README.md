# 학폭 나침반 — 문서 인덱스

> 학폭위 자문 Flutter 클라이언트 (`school-advisor-flutter`) 의 문서 모음.
> 백엔드(`school-advisor`, FastAPI + RAG, AWS 서울)는 별도 레포에서 운영 중이며, 본 문서들은 **클라이언트 관점**에서 정리됩니다.

---

## 📂 문서 구성

| 파일 | 용도 | 상태 |
|---|---|---|
| [`01_claude_code_dev_prompt.md`](01_claude_code_dev_prompt.md) | Claude Code 개발 지시 프롬프트 — 루트 [`/CLAUDE.md`](../CLAUDE.md) 의 포인터 | 📌 항시 |
| [`02_api_integration_spec.md`](02_api_integration_spec.md) | 백엔드 API 연동 명세 (엔드포인트·SSE 프레임·DTO) | 📌 항시 |
| [`03_ui_ux_design_prompt.md`](03_ui_ux_design_prompt.md) | UI/UX 설계 프롬프트 (초기 디자인 원본) | 📚 참고 |
| [`04_prd_context_prompt.md`](04_prd_context_prompt.md) | PRD 컨텍스트 (타 AI 위임 시) | 📚 참고 |
| [`05_play_release_guide.md`](05_play_release_guide.md) | Play Console 출시 가이드 (키스토어·AAB·내부테스트) | 📌 항시 |
| [`06_ios_release_guide.md`](06_ios_release_guide.md) | iOS 출시 가이드 (Bundle·서명·TestFlight) | 📌 항시 |
| [`07_changelog.md`](07_changelog.md) | 누적 변경 이력 | 📌 항시 |
| [`08_privacy_policy.md`](08_privacy_policy.md) | 개인정보 처리방침 (공개 게시 본문) | 📌 항시 |
| [`09_ios_smoke_checklist.md`](09_ios_smoke_checklist.md) | iOS 실기기 스모크 체크리스트 | 📌 항시 |
| [`10_store_listing.md`](10_store_listing.md) | Play Console / App Store 등록 카피 (한국어) | 📌 항시 |
| [`11_error_catalog.md`](11_error_catalog.md) | 사용자 노출 에러/안내 메시지 단일 정리표 | 📌 항시 |

> **항시** = 코드와 함께 갱신 / **참고** = 초기 결정 자료, 박제

---

## 🚀 빠른 시작

새 환경에서 작업할 때:

```bash
cd /Users/cheonsedong/Documents/appProject/school-advisor-flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run --dart-define=API_BASE_URL=https://school-advisor.sedoli.co.kr --dart-define=APP_ENV=dev
```

상세 실행/빌드 명령은 루트 [`README.md`](../README.md) 참고.

---

## 🏗 아키텍처 (현재 시점)

```
┌────────────────────────────────────────────────────────────┐
│                   Flutter App (이 레포)                     │
│                                                            │
│  Presentation (Widgets) ─ Riverpod Notifier ─ Repository   │
│                                       │                    │
│                                       ▼                    │
│                  Dio + 자체 SSE 디코더 + drift (로컬)       │
│                  Firebase Messaging + in_app_purchase      │
└──────────────────────────────────┬─────────────────────────┘
                                   │ HTTPS
                                   ▼
┌────────────────────────────────────────────────────────────┐
│        FastAPI 백엔드 (school-advisor / AWS 서울)           │
│   /api/v1/{chat, laws, feedback, user, purchase, ...}       │
│       │                                                    │
│       ├─ HybridRetriever (pgvector + tsvector RRF)         │
│       ├─ Generator (Claude Sonnet 4.6 / Haiku 4.5)         │
│       └─ Guardrail (PII 마스킹 + 금칙어 + 면책 고지)         │
└────────────────────────────────────────────────────────────┘
```

- **인증/식별**: `X-Device-ID` 헤더 (회원가입 없는 익명 식별)
- **스트리밍**: 자체 SSE 디코더 (`text/event-stream` → `event: text|citation|done|error`)
- **상태관리**: Riverpod (`NotifierProvider` / `FutureProvider` / `StreamProvider`)
- **HTTP**: Dio + DeviceID/Error Interceptor
- **로컬 저장소**: drift (대화 이력, 사안 정리 노트, 알림 인박스) + flutter_secure_storage (Device ID)
- **결제**: `in_app_purchase` (Android/iOS 자동 분기) → 백엔드 `/api/v1/purchase/verify` 검증
- **푸시**: Firebase Cloud Messaging + flutter_local_notifications, 토큰은 백엔드 `/api/v1/user/push_token` 등록

---

## ⚠️ 절대 원칙 (앱 단에서 강제)

1. **면책 고지 의무** — 답변마다 `DisclaimerBanner` 자동 부착, 첫 실행 전체화면 동의 (`SharedPreferences` 영속화)
2. **개인정보 입력 차단** — 주민번호/휴대폰/학교명 정규식 감지 → 다이얼로그 → 자동 마스킹 옵션 (`shared/utils/pii_detector.dart`)
3. **앱 단 사용량 가시성** — `usage_indicator` 가 `/api/v1/user/status` 폴링 → AppBar 칩
4. **결제 검증 우선** — Play/StoreKit 토큰은 반드시 백엔드 검증 후 활성화 (클라이언트 단독 신뢰 금지)
5. **에러 메시지 한국어 일관성** — `core/error/error_mapper.dart` 단일 소스 → 카탈로그는 [`11_error_catalog.md`](11_error_catalog.md)
6. **다크모드 의무** — 시스템 테마 자동 추종, `inkColor()` 헬퍼로 라이트/다크 동시 검수

---

## 🧭 포지셔닝 — 모델 D + 옵션 A (개인 사안 노트, 단일 홈)

본 앱의 **사안 정리** 기능은 신고 접수 시스템이 아니라 **본인 기기에 저장하는 개인용 메모**입니다 (2026-04-27 결정).

- 사안 노트는 학교·교육청·경찰에 자동 전달되지 않음 — `reports_remote_repository.dart` 는 stub
- 단계 변경은 외부 채널(학교/117)과 본인이 진행한 결과를 노트에 표시하는 체크리스트 (피사체가 학교가 아닌 본인)
- **역할 선택(학생/보호자/교사) 제거** — 라벨만 다르고 데이터·기능이 같았기에 검토 리스크 + 사용자 거짓 약속 발생. 단일 홈으로 통합.
- 실제 신고는 학교 학교폭력 전담기구 또는 117 외부 채널

이 결정의 배경과 대안 모델은 `docs/07_changelog.md` 참고:
- 2026-04-27 모델 D — A(가족/학교 코드), B(정식 회원체계), C(신고 제거), **D(개인 노트, 채택)**
- 2026-04-27 옵션 A — 역할 모드 제거 (모델 D 의 자연스러운 귀결)

---

## 🗂 주요 디렉토리

```
lib/
├── main.dart / app.dart               # bootstrap + ProviderScope + Router
├── env.dart                           # --dart-define 상수
├── core/
│   ├── http/                          # Dio + DeviceID/Error Interceptor
│   ├── sse/                           # 자체 SSE 디코더
│   ├── error/                         # AppException + error_mapper
│   ├── push/                          # FCM + 로컬 알림 + 페이로드 라우팅
│   ├── db/                            # drift AppDatabase
│   ├── theme/                         # Material 3 + Calm Green
│   ├── routing/                       # go_router
│   ├── observability/                 # Sentry init
│   └── dev/demo_seeder.dart           # SEED_DEMO 빌드 mock 데이터
├── features/
│   ├── onboarding/                    # 면책 + 인트로 (역할 선택 단계 없음)
│   ├── home/                          # 단일 홈 + 사안 노트 상세
│   ├── chat/                          # SSE 채팅 + 인용 칩 + 멀티턴
│   ├── conversation/                  # 대화 이력 (drift)
│   ├── laws/                          # 조문 검색 + 바텀시트
│   ├── flowchart/                     # 절차 흐름도
│   ├── faq/                           # 사전 캐시 답변
│   ├── feedback/                      # 평가/신고
│   ├── user/                          # 이용권·사용량
│   ├── report/                        # 사안 정리 노트 3-step + 메모 번호 (본인 기기 저장, 모델 D)
│   ├── notifications/                 # 인박스 + 푸시 토글
│   ├── settings/                      # 테마·알림·라이선스
│   └── purchase/                      # 인앱결제
└── shared/                            # 공용 위젯/모델/유틸
```

---

## ✅ 출시 체크리스트

세부 체크리스트는 별도 문서로 분리되어 있습니다:

- **Play Console** → [`05_play_release_guide.md`](05_play_release_guide.md)
- **App Store / TestFlight** → [`06_ios_release_guide.md`](06_ios_release_guide.md)
- **iOS 실기기 스모크** → [`09_ios_smoke_checklist.md`](09_ios_smoke_checklist.md)
- **스토어 등록 카피** → [`10_store_listing.md`](10_store_listing.md)

---

| 버전 | 날짜 | 변경 내역 |
|---|---|---|
| v1.0 | 2026-04-25 | 초기 작성 (Sprint 1~5 완료 시점) |
| v2.0 | 2026-04-27 | 11개 docs 인덱스로 전면 갱신, 아키텍처 도식 현재 코드 반영 |

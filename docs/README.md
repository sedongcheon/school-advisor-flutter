# 학폭 자문 앱 — Flutter 프론트엔드 프롬프트 세트

학폭위 자문 앱(`school-advisor`)의 **Flutter 클라이언트**를 자작하기 위한 프롬프트·가이드 모음.
백엔드(FastAPI + RAG, AWS 서울 배포)는 이미 완료되어 운영 중이며, 이 문서들은 그 백엔드를 **소비하는 모바일 앱**을 만드는 데 집중한다.

---

## 📂 파일 구성

| 파일 | 용도 | 사용 시점 |
|---|---|---|
| `01_claude_code_dev_prompt.md` | **개발 지시 프롬프트** — Flutter 코드를 Claude Code에게 맡길 때 사용 | 프로젝트 루트 `CLAUDE.md`로 복사 후 `claude` 실행 |
| `02_api_integration_spec.md` | **API 연동 명세** — 백엔드 엔드포인트·SSE 프레임·에러 코드·DTO | Repository / Service 레이어 구현 시 |
| `03_ui_ux_design_prompt.md` | **UI/UX 설계 프롬프트** — 화면 목록·플로우·카피·디자인 토큰 | 화면 구현·디자이너 협업 시 |
| `04_prd_context_prompt.md` | **PRD 컨텍스트 프롬프트** — 타 AI(ChatGPT/Gemini)에 기획·QA·마케팅 위임 시 | 모집글·이용약관·테스트 케이스 작성 등 |
| `README.md` | 이 파일 — 인덱스 및 시작 가이드 | 항상 |

---

## 🚀 빠른 시작

### 1. Flutter 프로젝트 부트스트랩
```bash
cd /Users/cheonsedong/Documents/appProject/school-advisor-flutter
flutter create . \
  --org com.sedoli \
  --project-name school_advisor \
  --platforms=android,ios \
  --description "학폭위 자문 앱"
```

### 2. 개발 지시 프롬프트를 루트에 복사
```bash
cp docs/01_claude_code_dev_prompt.md ./CLAUDE.md
```

### 3. Claude Code 시작
```bash
claude
```
첫 메시지:
```
CLAUDE.md 읽고 Sprint 1부터 시작해줘.
```

---

## 🏗 아키텍처 한눈에 보기

```
┌────────────────────────────────────────────────────────────┐
│                  Flutter App (이 레포)                      │
│                                                            │
│  Presentation (Widgets) ─ Riverpod Notifier ─ Repository   │
│                                       │                    │
│                                       ▼                    │
│                          Dio + flutter_client_sse          │
└──────────────────────────────────┬─────────────────────────┘
                                   │ HTTPS
                                   ▼
┌────────────────────────────────────────────────────────────┐
│        FastAPI 백엔드 (school-advisor / AWS 서울)           │
│   /api/v1/chat (SSE)  /laws  /feedback  /user/status       │
│       │                                                    │
│       ├─ HybridRetriever (pgvector + tsvector RRF)         │
│       ├─ Generator (Claude Sonnet 4.6 / Haiku 4.5)         │
│       └─ Guardrail (PII 마스킹 + 금칙어 + 면책 고지)         │
└────────────────────────────────────────────────────────────┘
```

- **인증/식별**: `X-Device-ID` 헤더 (회원가입 없는 익명 식별)
- **스트리밍**: SSE (`event: text|citation|done|error`)
- **상태관리**: Riverpod (AsyncNotifier 중심)
- **HTTP**: Dio + Interceptor (Device ID, 에러 매핑)
- **결제**: Google Play 인앱결제 (`in_app_purchase` 패키지)

---

## ⚠️ 절대 원칙 (앱 단에서 강제)

1. **면책 고지 의무** — 답변마다 자동 부착, 첫 실행 전체화면 동의
2. **개인정보 입력 차단** — 이름·학교명·주민번호 패턴 감지 시 입력 단계에서 경고
3. **앱 단 Rate Hint** — 백엔드 429 도착 전, 앱이 일 사용량 표시
4. **결제 검증 우선** — 구매 토큰은 반드시 백엔드 검증 후 활성화 (Phase 3)
5. **에러 메시지 한국어 일관성** — `code → 사용자 친화 문구` 매핑 테이블 단일화
6. **다크모드 의무** — 시스템 테마 따라가기

---

## 🗂 권장 디렉토리 (참고)

```
lib/
├── main.dart
├── app.dart                       # MaterialApp + Router
├── core/
│   ├── config/                    # env, base_url, flavor
│   ├── http/                      # Dio + interceptors
│   ├── sse/                       # SSE 클라이언트 (chat 전용)
│   ├── error/                     # AppException, error_mapper
│   ├── theme/                     # ColorScheme, TextTheme, tokens
│   └── routing/                   # go_router config
├── features/
│   ├── onboarding/                # 면책 고지, 3단계 소개
│   ├── chat/                      # 대화형 Q&A (SSE 소비)
│   ├── laws/                      # 조문 검색·조회
│   ├── flowchart/                 # 절차 플로우 (정적)
│   ├── faq/                       # 사전 캐시 답변
│   ├── feedback/                  # 1~5점 평가
│   ├── user/                      # 이용권 상태, 사용량 표시
│   └── purchase/                  # 인앱결제 (Phase 3)
├── shared/
│   ├── widgets/                   # 재사용 위젯 (DisclaimerBanner 등)
│   ├── models/                    # JSON serializable
│   └── utils/                     # PII 패턴, device id
└── l10n/                          # 향후 다국어
```

---

## 📚 참고 (백엔드 레포 위치)

API 변경·엔드포인트 추가 확인이 필요하면 백엔드 레포의 다음 파일을 참고:

```
/Users/cheonsedong/Documents/appProject/school-advisor/
├── app/api/chat.py        # SSE 프레임 포맷 원본
├── app/api/laws.py
├── app/api/feedback.py
├── app/api/user.py
├── app/schemas/*.py       # Pydantic 모델 = JSON 스키마 진실의 원천
└── docs/
    ├── 02_system_prompt.md   # 답변 톤·금칙어 — 앱 가드레일과 중복 안 되게 참고
    └── 학폭위_자문앱_PRD_v1.0.docx  # 제품 기획 원본
```

---

## ✅ 체크리스트 (앱 출시 전)

### 기능
- [ ] 첫 실행 면책 동의 화면 (체크 안 하면 진행 불가)
- [ ] 채팅 SSE 정상 수신 (text/citation/done/error 4종)
- [ ] 인용 칩 탭 → 원문 시트 (`/api/v1/laws` 호출)
- [ ] 사용량 인디케이터 (남은 횟수 / 일 한도)
- [ ] FAQ 퀵 탭 (LLM 미호출, 로컬 자산)
- [ ] 절차 흐름도 (정적 위젯, 6단계)
- [ ] 답변 피드백 (1~5점)
- [ ] AI 답변 신고 기능 (Play 정책 필수)

### 비기능
- [ ] 면책 문구가 답변마다 자동 노출
- [ ] 개인정보 패턴 감지 시 입력 차단 또는 마스킹
- [ ] 다크모드 / 라이트모드 모두 검수
- [ ] 한국어 폰트 가독성 (Pretendard 권장)
- [ ] 네트워크 끊김 시 재시도 UI
- [ ] 앱 첫 실행에서 Device ID 생성·영구 저장 (Secure Storage)

### Play Console (Phase 3)
- [ ] Data Safety 섹션 정확히 작성
- [ ] AI Content 정책 — 답변 신고 기능 명시
- [ ] 14일 내부테스트 요건 충족 (테스터 20명 이상)
- [ ] 인앱결제 상품 등록 (`sa_7day`, `sa_30day`, `sa_teacher_monthly`)

---

| 버전 | 날짜 | 변경 내역 |
|---|---|---|
| v1.0 | 2026-04-25 | 초기 작성 (백엔드 Sprint 1~5 완료 시점 기준) |

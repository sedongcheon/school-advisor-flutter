# API 연동 명세 — Flutter ↔ FastAPI 백엔드

> **용도**: Flutter 앱이 백엔드(`school-advisor`)와 주고받는 모든 HTTP/SSE 인터페이스의 단일 명세
> **진실의 원천**: 백엔드 Pydantic 스키마 (`/Users/cheonsedong/Documents/appProject/school-advisor/app/schemas/*.py`)
> **버전 관리**: 백엔드 변경 시 이 문서도 동시 업데이트. 앱 코드 위해 백엔드를 바꾸지 말 것.

---

## 0. 공통

### 0.1 Base URL
- **운영**: `https://school-advisor.sedoli.co.kr`
- **로컬 개발**: `http://localhost:8000`
- 앱은 `--dart-define=API_BASE_URL=...` 으로 주입받아 사용

### 0.2 공통 헤더
| 헤더 | 값 | 적용 엔드포인트 |
|---|---|---|
| `X-Device-ID` | UUID v4 (앱이 생성·영속화) | `/chat`, `/user/status` 필수, 그 외 권장 |
| `Content-Type` | `application/json` | POST 요청 |
| `Accept` | `application/json` (또는 `text/event-stream` for chat) | 모든 요청 |

### 0.3 공통 응답
- **성공**: 2xx + JSON 또는 SSE 스트림
- **검증 오류**: `400` + `{"detail": [...]}` (FastAPI 표준 422 또는 400)
- **인증 오류**: `401` + `{"detail": "X-Device-ID 헤더가 필요합니다."}`
- **분당 한도 초과**: `429` + slowapi 표준 응답
- **서버 오류**: `500` + Sentry로 자동 보고
- **`/chat`만 예외**: 일일 한도 초과는 HTTP 200 + SSE `event: error` 스트림으로 도달

### 0.4 Rate Limit
- **분당**: 5회 (Device ID 기준, 슬라이딩 윈도우)
- **일일**: 50/150/500회 (free / 7day / 30day plan, `user_entitlements`로 차감)
- 초과 시 클라이언트는 `error_mapper`로 사용자 친화 메시지 표시

---

## 1. `POST /api/v1/chat` — 대화 SSE 스트리밍

### 1.1 요청

```http
POST /api/v1/chat HTTP/1.1
Host: school-advisor.sedoli.co.kr
Content-Type: application/json
Accept: text/event-stream
X-Device-ID: 8f4a...

{
  "query": "학폭위 조치 5호가 뭐야?",
  "session_id": "00000000-0000-0000-0000-000000000001",
  "device_id": "8f4a..."
}
```

| 필드 | 타입 | 필수 | 제약 | 설명 |
|---|---|---|---|---|
| `query` | string | ✓ | 1~2000자 | 사용자 질문 본문 |
| `session_id` | UUID | ✓ | UUID v4 | 클라이언트가 생성, 동일 대화 묶음 식별자 |
| `device_id` | string? | (헤더 없을 때만 ✓) | 1~100자 | 헤더 `X-Device-ID`가 우선, 없으면 body 사용 |

> 앱은 항상 **헤더로 전송**한다. body의 `device_id`는 `null` 또는 생략. (테스트·디버깅용으로 백엔드가 fallback 지원)

### 1.2 응답: `text/event-stream`

프레임 포맷 (표준 SSE):
```
event: <name>
data: <json>\n
\n
```

#### 1.2.1 `event: text` — 답변 텍스트 청크
```
event: text
data: {"content": "학폭위 조치 5호는 "}
```
- 모델이 토큰을 생성할 때마다 1개 이상 도착
- 클라이언트는 누적 버퍼에 `content`를 이어붙여 메시지 버블 갱신

#### 1.2.2 `event: citation` — 인용 출처
```
event: citation
data: {
  "chunks": [
    {"id": 106, "law": "학폭예방법 제17조 제1항", "url": "https://www.law.go.kr/..."},
    {"id": 132, "law": "학교생활기록 작성 및 관리지침 제7조", "url": null}
  ]
}
```
- 답변 본문 스트림이 끝난 직후 1회 도착 (이후 `done`)
- 앱은 메시지 하단에 **출처 칩 리스트**로 렌더. 탭 시 `/api/v1/laws`로 원문 조회.

#### 1.2.3 `event: done` — 종료
```
event: done
data: {
  "conversation_id": "9b7f...",
  "model": "claude-haiku-4-5",
  "tokens": {"input": 4676, "output": 408, "cache_read": 0, "cache_create": 0}
}
```
- `conversation_id` — 피드백 전송 시 사용 (`/feedback` body에 첨부)
- `model`, `tokens` — 디버그·관리자 화면용 (사용자에게 보여줄 필요 없음)

#### 1.2.4 `event: error` — 스트림 도중 오류
```
event: error
data: {"code": "quota_exceeded", "message": "일일 이용 한도 초과 (50/50)"}
```

| `code` | 의미 | 앱 처리 |
|---|---|---|
| `device_id_required` | 헤더/body 모두 비어 있음 | 사실상 발생 안 함(앱이 항상 헤더 부착). 발생 시 Sentry 보고 |
| `quota_exceeded` | 일일 한도 초과 | 결제 안내 시트로 유도 |
| `internal_error` | 그 외 모든 예외 | "잠시 후 다시 시도해 주세요" + 재시도 버튼 |

> ⚠️ HTTP 상태는 항상 `200` (스트림이 시작된 이상). HTTP 4xx는 스트림 시작 전(파싱 실패) 케이스만.

### 1.3 SSE 디코더 의사코드 (Dart)

```dart
Stream<SseEvent> consume(Stream<List<int>> body) async* {
  final decoder = utf8.decoder;
  final buffer = StringBuffer();

  await for (final chunk in body.transform(decoder)) {
    buffer.write(chunk);
    while (true) {
      final raw = buffer.toString();
      final terminator = raw.indexOf('\n\n');
      if (terminator < 0) break;

      final frame = raw.substring(0, terminator);
      buffer.clear();
      buffer.write(raw.substring(terminator + 2));

      String? event;
      String? data;
      for (final line in frame.split('\n')) {
        if (line.startsWith('event:')) event = line.substring(6).trim();
        if (line.startsWith('data:')) data = line.substring(5).trim();
      }
      if (event != null && data != null) {
        yield SseEvent(event, jsonDecode(data) as Map<String, dynamic>);
      }
    }
  }
}
```

> 단위 테스트로 다음 케이스를 반드시 커버: ① 한 청크에 여러 프레임, ② 프레임이 청크 경계에서 잘린 경우, ③ `event` 누락, ④ 한국어 multibyte 경계.

---

## 2. `GET /api/v1/laws` — 조문 직접 조회

### 2.1 요청
```
GET /api/v1/laws?law=학교폭력예방%20및%20대책에%20관한%20법률&article_no=제17조
```

| 쿼리 | 타입 | 필수 | 제약 | 설명 |
|---|---|---|---|---|
| `law` | string | ✓ | 1~200자 | 법령 정식명. 인용 칩의 `law` 라벨 앞부분(예: `학폭예방법`)을 그대로 보내면 매칭 안 될 수 있어 **정식명** 또는 약칭 매핑 테이블 필요 |
| `article_no` | string | ✓ | 1~20자 | `제17조`, `제16조의2` 형식 |

### 2.2 응답
```json
{
  "law_name": "학교폭력예방 및 대책에 관한 법률",
  "article_no": "제17조",
  "title": "가해학생에 대한 조치",
  "doc_type": "법률",
  "content": "① 심의위원회는 피해학생의 보호와 가해학생의 선도·교육을 위하여...",
  "effective_date": "2024-03-01",
  "source_url": "https://www.law.go.kr/..."
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `law_name` | string | 법령 정식명 |
| `article_no` | string | 조 번호 |
| `title` | string? | 조 제목 (없을 수 있음) |
| `doc_type` | string | "법률" / "대통령령" / "고시" 등 |
| `content` | string | 조 전체 본문 (항·호 포함, 줄바꿈 보존) |
| `effective_date` | string? (ISO date) | 시행일 |
| `source_url` | string? | 국가법령정보센터 원문 URL |

### 2.3 에러
- `404 Not Found` + `{"detail": "해당 조문을 찾을 수 없습니다."}`
- 앱은 바텀시트에서 "원문을 찾을 수 없어요. 잠시 후 다시 시도해 주세요." 표시.

### 2.4 약칭 → 정식명 매핑 (앱 내부 테이블)
인용 칩의 `law` 필드는 사람이 읽기 좋은 라벨이므로 직접 쿼리에 쓸 수 없다. 다음 매핑을 앱에 두자:

```dart
const lawNameAliases = {
  '학폭예방법': '학교폭력예방 및 대책에 관한 법률',
  '학폭예방법 시행령': '학교폭력예방 및 대책에 관한 법률 시행령',
  // 필요시 확장
};
```

> 인용 칩 라벨은 `"학폭예방법 제17조 제1항"` 형태. 공백으로 split → 첫 토큰을 약칭으로 보고 매핑 → 두 번째 토큰(`제17조`)을 `article_no`로 사용.

---

## 3. `POST /api/v1/feedback` — 답변 피드백

### 3.1 요청
```http
POST /api/v1/feedback
Content-Type: application/json

{
  "conversation_id": "9b7f...",
  "rating": 5,
  "issue_type": null,
  "comment": "정확해요"
}
```

| 필드 | 타입 | 필수 | 제약 | 설명 |
|---|---|---|---|---|
| `conversation_id` | UUID | ✓ | - | `/chat` `done` 이벤트의 ID |
| `rating` | int | ✓ | 1~5 | 별점 |
| `issue_type` | string? | - | ≤50자 | `report` (신고), `wrong_citation`, `outdated`, `other` 등 — 자유 문자열 |
| `comment` | string? | - | ≤2000자 | 사용자 코멘트 |

### 3.2 응답
```http
HTTP/1.1 201 Created
{"id": 42}
```

### 3.3 사용 규약
- 별점 1~5는 `feedback_dialog`에서 수집
- "신고" 메뉴는 별점 없이 `rating=1, issue_type="report", comment=...`로 전송 (별점이 필수라 1로 고정)

---

## 4. `GET /api/v1/user/status` — 이용권·사용량

### 4.1 요청
```
GET /api/v1/user/status
X-Device-ID: 8f4a...
```

### 4.2 응답
```json
{
  "device_id": "8f4a...",
  "plan": "free",
  "questions_used": 2,
  "questions_limit": 50,
  "expires_at": null,
  "last_reset_date": "2026-04-25"
}
```

| 필드 | 타입 | 설명 |
|---|---|---|
| `device_id` | string | 요청 헤더 그대로 |
| `plan` | string | `free` / `7day` / `30day` / `teacher` |
| `questions_used` | int | 오늘 사용량 (자정 자동 리셋) |
| `questions_limit` | int | 현재 플랜의 일일 한도 |
| `expires_at` | string? (ISO datetime) | 유료 플랜 만료 시각 |
| `last_reset_date` | string (ISO date) | 마지막 자동 리셋 날짜 |

### 4.3 호출 시점
- 채팅 화면 진입 시 1회
- 채팅 답변 완료(`event: done`) 후 1회 (사용량 갱신)
- 결제 직후 1회 (Phase 3)

### 4.4 화면 표시 규칙
- `plan == 'free'`: `남은 ${limit - used}회 / 일 ${limit}회`
- `plan != 'free'`: `만료까지 ${남은 일수}일 · 남은 ${limit - used}회`
- 남은 횟수 0이면 결제 안내 모달

---

## 5. `GET /health` — 헬스체크

```json
{"status": "ok", "db": "ok", "llm": "ok"}
```

- 부팅 디버그 화면에서 1회 호출하여 BASE_URL 정확성 확인
- 사용자 화면에서는 사용 안 함

---

## 6. `POST /api/v1/purchase/verify` — 인앱결제 검증 (Phase 3)

> **현재 백엔드 미구현** — Phase 3에서 추가될 예정. 이 섹션은 합의된 계약 초안.

### 6.1 요청
```json
{
  "platform": "google_play",
  "product_id": "sa_7day",
  "purchase_token": "abc123...",
  "order_id": "GPA.xxxx-xxxx-xxxx-xxxxx"
}
```

### 6.2 응답
```json
{
  "verified": true,
  "plan": "7day",
  "expires_at": "2026-05-02T00:00:00Z",
  "questions_limit": 150
}
```

- 검증 실패 시 `verified: false` + `reason`
- 앱은 검증 성공 응답 후에만 유료 기능 활성화

---

## 7. 에러 코드 → 사용자 메시지 매핑 (단일 소스)

```dart
const errorMessages = {
  // SSE 에러 코드
  'quota_exceeded':    '일일 이용 한도에 도달했어요. 이용권을 확인해 주세요.',
  'device_id_required':'기기 등록에 문제가 있어요. 앱을 재시작해 주세요.',
  'internal_error':    '일시적인 오류가 발생했어요. 잠시 후 다시 시도해 주세요.',

  // HTTP 매핑
  '400':               '요청을 다시 확인해 주세요.',
  '401':               '기기 인증이 필요해요. 앱을 재시작해 주세요.',
  '404':               '요청한 정보를 찾을 수 없어요.',
  '429':               '잠시만요. 너무 빠르게 요청하셨어요. 1분 뒤 다시 시도해 주세요.',
  '500':               '서버에 일시적인 문제가 있어요. 잠시 후 다시 시도해 주세요.',
  'network':           '인터넷 연결을 확인해 주세요.',
  'timeout':           '응답이 느려요. 다시 시도해 주세요.',
};
```

---

## 8. 보안·관측 노트

### 8.1 헤더 위생
- 앱이 추가 헤더(`User-Agent`, `Accept-Language`)는 자유롭게 부착 가능
- 절대 보내지 말 것: `Authorization` (사용 안 함), 사용자 PII가 담긴 커스텀 헤더

### 8.2 로그
- 앱 디버그 빌드: 요청 method+path만 로그. body 마스킹.
- 릴리스 빌드: Dio 로깅 인터셉터 비활성, Sentry breadcrumb만.

### 8.3 인증서
- 운영은 ACM(AWS) 발급 인증서. 핀닝 미적용(Phase 4 이후 검토).

---

## 9. 호환성·버전 정책

- API 경로 prefix는 `/api/v1`로 고정 (백엔드 `API_V1_PREFIX` 설정).
- Breaking change 시 `/api/v2`로 신설 + 앱은 점진 마이그레이션.
- SSE 이벤트명/필드 추가는 비파괴. 앱은 **모르는 이벤트는 무시**.

---

## 10. 진실의 원천 파일 인덱스

| 영역 | 백엔드 파일 |
|---|---|
| `/chat` 라우터 | `app/api/chat.py` |
| `/laws` 라우터 | `app/api/laws.py` |
| `/feedback` 라우터 | `app/api/feedback.py` |
| `/user/status` 라우터 | `app/api/user.py` |
| `/health` 라우터 | `app/api/health.py` |
| 채팅 스키마 | `app/schemas/chat.py` |
| 법령 스키마 | `app/schemas/law.py` |
| 피드백 스키마 | `app/schemas/feedback.py` |
| 사용자 스키마 | `app/schemas/user.py` |
| Rate Limit 정책 | `app/rate_limit.py` |
| 가드레일 (참고) | `app/rag/guardrail.py` |

> 명세 충돌이 의심되면 항상 위 파일을 먼저 확인. 의심나면 백엔드 담당자에게 PR 요청.

---

## 변경 이력

| 버전 | 날짜 | 변경 내역 |
|---|---|---|
| v1.0 | 2026-04-25 | 초기 작성 (백엔드 Sprint 4 완료 시점) |

# 에러 메시지 카탈로그

> 사용자에게 노출되는 모든 에러/안내 메시지의 단일 정리표.
> 진실의 원천은 `lib/core/error/error_mapper.dart` + 각 화면의 인라인 메시지.

---

## 1. 네트워크 / 백엔드 (`error_mapper.dart`)

| `AppException.code` | 사용자 노출 한국어 메시지 | 발생 상황 |
|---|---|---|
| `network_error` | "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해 주세요." | DioExceptionType.connectionError / badCertificate / 알 수 없는 transport |
| `timeout` | "응답이 너무 오래 걸렸어요. 다시 시도해 주세요." | connectionTimeout / sendTimeout / receiveTimeout (10s/10s/30s) |
| `unauthorized` | "기기 인증에 실패했어요. 앱을 재실행해 주세요." | 401 — `X-Device-ID` 누락 또는 무효 |
| `rate_limited` | "잠깐 천천히 부탁드려요. 잠시 후 다시 질문해 주세요." | 429 — 분당 5회 한도 (백엔드 slowapi) |
| `quota_exceeded` | "일일 이용 한도에 도달했어요. 이용권을 확인해 주세요." | SSE error 이벤트 — `code: quota_exceeded` |
| `server_error` | "일시적인 오류가 발생했어요. 잠시 후 다시 시도해 주세요." | 5xx |
| `validation_error` | "입력값을 다시 확인해 주세요." | 400 / 422 — Pydantic 검증 실패 |
| `unknown` (fallback) | "알 수 없는 오류가 발생했어요. 잠시 후 다시 시도해 주세요." | 위에 매칭 안 되는 모든 raw exception |

> raw `DioException` 이 ErrorInterceptor 를 우회해도 `mapErrorToMessage` 가
> `DioException.type` / `response.statusCode` 로 코드를 추론한다.

---

## 2. SSE 채팅 — 백엔드 SSE error 이벤트

`/api/v1/chat` 의 `event: error` 페이로드 → `ChatNotifier._appExceptionForCode`:

| `code` | 매핑된 AppException | 노출 메시지 |
|---|---|---|
| `quota_exceeded` | QuotaExceededException | "일일 이용 한도에 도달했어요…" |
| `rate_limited` | RateLimitException | "잠깐 천천히 부탁드려요…" |
| `device_id_required` | UnauthorizedException | "기기 인증에 실패했어요…" |
| `internal_error` | ServerException | "일시적인 오류가 발생했어요…" |
| (그 외) | UnknownException | "알 수 없는 오류가 발생했어요…" |

답변 메시지 버블이 errorContainer 색으로 표시된다.

---

## 3. PII 입력 감지 (`pii_warning_dialog.dart`)

| 트리거 | 노출 메시지 |
|---|---|
| 주민번호/휴대폰/학교명 정규식 매치 | "개인정보가 포함된 것 같아요" / "다음이 감지되었습니다: …" |
| 다이얼로그 액션 | "취소" / "그대로 보내기" / "자동 가리기" |

`PiiDetector.mask` 는 `[주민번호]`, `[전화번호]`, `[학교명초등학교]` 등으로 치환.

---

## 4. 결제 (`purchase_repository.dart` + `purchase_notifier.dart`)

백엔드 `/api/v1/purchase/verify` 응답 매핑:

| HTTP | sealed 에러 | 노출 메시지 |
|---|---|---|
| 400 / 402 / 422 | PurchaseTokenInvalid | "결제 영수증이 유효하지 않아요. 다시 시도해 주세요." |
| 409 | PurchaseTokenAlreadyUsed | "이미 사용된 결제예요. 고객센터에 문의해 주세요." |
| 502 | PurchaseProviderError | "결제 검증 서버가 일시적으로 응답하지 않아요. 잠시 후 다시 시도해 주세요." |
| 그 외 | PurchaseUnknownError | "결제 검증 중 알 수 없는 오류가 발생했어요." |

Play Billing 자체 실패:
| Play 상태 | 노출 메시지 |
|---|---|
| `error` | "결제가 완료되지 않았어요. 다시 시도해 주세요." |
| 진입 실패 | "결제 창을 띄울 수 없어요. 잠시 후 다시 시도해 주세요." |
| 스트림 onError | "결제 스트림에 오류가 발생했어요." |

---

## 5. 푸시 (`notifications_notifier.dart` / `push_messaging_service.dart`)

| 트리거 | 노출 메시지 |
|---|---|
| 알림 토글 ON 시 시스템 권한 거부 | "알림 권한이 꺼져 있어요. 시스템 설정에서 허용해 주세요." (스낵바) |
| FCM 토큰 발급 실패 | (콘솔 디버그만, 사용자 미노출) |
| 백엔드 토큰 등록 실패 | (non-blocking, 콘솔 디버그만) |

---

## 6. 사안 / 진행 (`status_lookup_screen.dart` / `case_detail_screen.dart`)

| 트리거 | 노출 메시지 |
|---|---|
| R-번호 미입력 | "메모 번호를 입력해 주세요." |
| R-번호 매칭 실패 | "해당 번호의 메모를 찾을 수 없어요." |
| (사안 상세) reports 에 없음 | "해당 번호의 메모를 찾을 수 없어요." |
| 사안 삭제 성공 | "사안 메모가 삭제되었어요." (스낵바) |
| 단계 진행 성공 | "{새 단계} 단계로 변경되었어요." (스낵바) |

---

## 7. 신고 / 평가 (`feedback_*`)

| 액션 | 노출 메시지 |
|---|---|
| 평가 송신 성공 | "평가를 보내주셔서 감사합니다." |
| 평가 송신 실패 (메시지에 conversationId 없음) | "평가를 보낼 수 없는 메시지예요." |
| 신고 송신 성공 | "신고가 접수되었습니다. 감사합니다." |
| 신고 송신 실패 | "신고를 보낼 수 없는 메시지예요." |

---

## 8. 헬스체크 / 디버그

| 경로 | 메시지 |
|---|---|
| `/health` 호출 전 | "아직 호출하지 않았어요." |
| 응답 본문 없음 | "(빈 응답)" |
| 호출 실패 | `error_mapper` 의 매핑 메시지 |

---

## 9. 빈 상태 (각 화면)

| 화면 | 메시지 |
|---|---|
| 채팅 (메시지 0개) | "무엇이든 편하게 물어보세요." / "학교폭력 절차·법령을 안내해 드릴게요. 실명·민감정보는 입력하지 마세요." |
| 대화 이력 | "아직 대화가 없어요." / "대화 화면에서 첫 질문을 보내면 여기에 저장돼요." |
| 알림 인박스 | "아직 알림이 없어요." / "사안 노트 저장·단계 변경이나 가이드 안내가 있을 때 여기에 알려드릴게요." |
| 보호자 자녀 카드 (없음) | "아직 정리한 사안이 없어요" / "\"사안 정리하기\" 로 첫 메모를 시작해 보세요." |
| 교사 사안 리스트 (없음) | "아직 정리한 사안 메모가 없어요." / "\"사안 정리하기\" 로 학교에 안내할 사례를 메모해 보세요." |
| 법령 검색 결과 0건 | "검색 결과가 없어요." |

---

## 10. 면책 / 신뢰 메시지 (모든 답변 하단)

`disclaimer_banner.dart`:
```
본 답변은 일반적인 정보 안내이며 법률 자문이 아닙니다.
실제 사건은 학교·교육청·법률 전문가와 상담해 주세요.
```

---

## 11. 새 메시지 추가 시 절차

1. `lib/core/error/error_mapper.dart` 에 `code` 추가 + 한국어 메시지 정의
2. `AppException` 서브타입 필요하면 `lib/core/error/app_exception.dart` 에 추가
3. 본 카탈로그 갱신
4. 백엔드 SSE error 이벤트 코드와 매핑되는 경우 백엔드 docs 와 동기화

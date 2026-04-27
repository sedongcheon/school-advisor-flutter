# iOS 실기기 스모크 검증 체크리스트

> 시뮬레이터 빌드는 자동 검증됨. 다음은 **실기기에서만 정확히 검증 가능**한 항목.
> Apple Developer 멤버십 + Xcode signing 후 진행.

---

## 0. 사전 준비

```sh
cd ios && pod install
flutter build ios --release \
  --dart-define=API_BASE_URL=https://school-advisor.sedoli.co.kr \
  --dart-define=APP_ENV=prod \
  --dart-define=SENTRY_DSN=<sentry-dsn>
```

Xcode `Runner.xcworkspace` 열고 **Signing & Capabilities** 의 Team 설정 후
실기기 연결 → ▶ Run.

---

## 1. 부팅 흐름

- [ ] 첫 실행 — **면책 동의** 화면 정상 표시 (체크박스 동의 후 활성화)
- [ ] **온보딩 3 슬라이드** PageView 좌우 스와이프 동작
- [ ] **역할 선택** — 학생/보호자/교사·전담기구 카드 선택 → 시작하기
- [ ] 두 번째 실행 — 면책+역할 영속화되어 바로 역할별 홈 진입

## 2. 학생 모드

- [ ] **홈 hero 카드** — 챗봇 stub tap → /chat 이동
- [ ] **추천 칩** ("신고 절차" 등) tap → 챗봇 + 첫 메시지 자동 송신
- [ ] **2x3 grid** 6개 카드 모두 정상 진입 ("사안 정리하기" / "내 사안 노트" / 법령 / 절차 / FAQ / 대화 이력)
- [ ] **117 긴급 배너** tap → iOS 전화 앱 호출 시트 → 통화 동작
- [ ] 사안 정리 후 grid 두 번째 카드가 "**내 사안 노트**" 로 자동 변경 (statusLabel 서브타이틀)
- [ ] **대화 이력** — SQLite 영속화 → 앱 재시작 후에도 유지

## 3. 사안 정리 / 노트 / 알림 (Stage 3 + 4, 모델 D)

- [ ] **사안 정리하기 3-step** 폼 — 모든 chip / multi-select / TextField 동작
- [ ] **Step0 상단 안내 배너** — "본인 기기에만 저장돼요…실제 신고는 학교/117" 노출 확인
- [ ] 저장 → "**사안 노트가 저장되었어요**" 화면 → **메모 번호 복사** (iOS 클립보드 작동)
- [ ] 인박스에 milestone "사안 노트를 저장했어요" 자동 적재
- [ ] 학생/보호자: **사안 노트 상세** 화면에 read-only + "AI에 다음 단계 물어보기" 버튼
- [ ] 교사: 사안 노트 상세 → "**다음 단계로 진행**" → 인박스 milestone 추가 + KPI 갱신
- [ ] 교사: 우상단 ⋯ → **사안 메모 삭제** → 확인 → 목록에서 사라짐
- [ ] 알림 인박스 4 탭(전체/진행/일정/가이드) 필터링
- [ ] **모두 읽음** 버튼 → 굵기 변경 + dot 사라짐

## 4. 챗봇 (SSE)

- [ ] 메시지 송신 → 토큰 단위 스트리밍
- [ ] 인용 칩 tap → 조문 시트 (드래그 가능)
- [ ] 답변 메시지 우측 ⋯ "평가 · 신고" → 시트 → 별점/사유 송신
- [ ] PII 입력 (010-1234-5678 등) → 다이얼로그
- [ ] **사용량 칩** AppBar 우상단 (역할별 홈에선 자체 헤더 사용 — 챗봇 화면에서만)

## 5. FCM 푸시

- [ ] 설정 → 푸시 알림 토글 ON → iOS 권한 다이얼로그 → 허용
- [ ] **APNs 인증 키** Firebase 업로드 후 토큰 발급 (logcat 대신 Console.app 또는 Xcode console 에서 `[push] FCM token` 확인)
- [ ] Firebase Console "테스트 메시지" → 포어그라운드 알림 표시
- [ ] 백그라운드 → 시스템 알림 → 탭 → 앱 진입 + payload 처리
- [ ] 종료 상태 → 시스템 알림 → 탭 → 앱 cold start + getInitialMessage 처리

## 6. 인앱결제 (Phase 3.2)

- [ ] App Store Connect 에 구독 상품 등록 후
- [ ] 설정/사용량 칩 → 결제 화면 → Play 가격 표시 (iOS는 StoreKit 가격)
- [ ] 구매 → 영수증 검증 → 사용량 갱신
- [ ] (현재 백엔드 검증은 Android 만, iOS 는 백엔드 verify 의 platform 파라미터 확장 필요)

## 7. 다크 모드 검수

- [ ] 설정 → 테마 모드 → 다크 → 모든 화면 색상 정상
- [ ] 홈 hero gradient, 117 배너, 카드 보더, 텍스트 모두 시인성 확보

## 8. 폰트

- [ ] **Pretendard** 적용 확인 — 한글 본문이 부드러운 sans-serif (NotoSansKR 와 비교 시 차이 시인 가능)
- [ ] iOS 시스템 폰트 fallback 안 됨 (자산 번들 정상)

## 9. 가로 회전 / iPad

- [ ] iPhone portrait 외 회전 안 깨짐 (또는 portrait lock 의도 확인)
- [ ] iPad 에선 화면이 너무 늘어지지 않는지 (필요 시 maxWidth 제약)

## 10. 보고할 항목

각 체크 옆에 다음 형식으로 코멘트 남기기:

```
- [x] 부팅 흐름 OK (iPhone 14, iOS 17.2)
- [ ] 117 전화 → 안 열림 (시뮬레이터 한정 가능성)
- [x] 다크 모드 — 사안 상세 statusCard 그라데이션 가독성 ⚠
```

이슈는 `git issue` 또는 사내 트래커에 옮겨주세요.

---

## 출시 전 차단 조건

다음이 안 되면 출시 보류:

- 부팅 흐름 진입 불가
- 117 전화 동작 안 함
- 챗봇 SSE 끊김 (실기기 통신)
- FCM 푸시 수신 불가 (APNs 키 미설정 또는 잘못된 Bundle ID)
- 다크 모드에서 텍스트 시인성 불가능 수준

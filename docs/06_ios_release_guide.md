# iOS TestFlight / App Store 출시 가이드

> **Bundle ID**: `kr.co.sedoli.schooladvisor`
> **표시 이름**: 학폭 나침반
> **언어**: 한국어 (`CFBundleLocalizations: ko`)
> **최소 iOS**: 13.0 (sentry_flutter / drift / flutter_native_splash 호환)

이 문서는 macOS + Xcode 환경에서 iOS 빌드 / TestFlight 업로드 / App Store 심사를 위한 절차입니다.

---

## 1. 사전 준비

- macOS (현재 머신)
- Xcode 최신 stable
- **Apple Developer Program 멤버십** ($99/year) — 실기기 / TestFlight / App Store 모두 필요
- App Store Connect 에 앱 등록:
  - Bundle ID: `kr.co.sedoli.schooladvisor`
  - 기본 언어: 한국어
  - 카테고리: 교육 / 참고 (Reference)

---

## 2. 시뮬레이터 빌드 (이미 검증됨)

```sh
flutter build ios --simulator --no-codesign \
  --dart-define=API_BASE_URL=https://school-advisor.sedoli.co.kr \
  --dart-define=APP_ENV=dev
```

산출물: `build/ios/iphonesimulator/Runner.app`

```sh
open -a Simulator
flutter run -d <simulator-id>
```

> SSE / 결제 / 푸시 / `tel:` 동작은 **실기기에서 검증 권장**.

---

## 3. 실기기 / 릴리스 빌드

### 3.1 Signing & Capabilities

Xcode 에서 `ios/Runner.xcworkspace` 를 열고 (반드시 `.xcodeproj` 가 아닌 **`.xcworkspace`**):

1. `Runner` 타깃 → **Signing & Capabilities**
2. **Team** 드롭다운 → 본인 Apple Developer Team 선택
3. **Automatic manage signing** 활성화 권장 (provisioning profile 자동 발급)
4. Bundle Identifier 가 `kr.co.sedoli.schooladvisor` 로 표시되는지 확인

> 현재 `project.pbxproj` 의 `DEVELOPMENT_TEAM = K55ECMWQM5` 로 박혀 있음. 다른 팀이라면 위 GUI 에서 갱신.

### 3.2 Capability 추가 (필요 시)

현재까지 추가 capability 없음. 향후:
- 인앱결제(Phase 3.2) → **In-App Purchase**
- 푸시(Phase 3.3) → **Push Notifications** + Background Modes (Remote notifications)

### 3.3 릴리스 IPA 빌드

```sh
flutter build ipa --release \
  --dart-define=API_BASE_URL=https://school-advisor.sedoli.co.kr \
  --dart-define=APP_ENV=prod \
  --dart-define=SENTRY_DSN=<sentry-dsn>
```

산출물: `build/ios/ipa/school_advisor.ipa`

또는 Xcode 에서:
1. **Product → Scheme → Edit Scheme** → Run 의 Build Configuration 을 `Release` 로 변경
2. **Product → Destination → Any iOS Device (arm64)**
3. **Product → Archive** → Window → Organizer 에서 Archive 확인

---

## 4. TestFlight 업로드

### 4.1 Transporter 또는 Xcode Organizer

**Transporter (권장)**:
1. Mac App Store 에서 [Transporter](https://apps.apple.com/app/transporter/id1450874784) 설치
2. 위 `school_advisor.ipa` drag & drop
3. **Deliver** → 검증 후 App Store Connect 에 업로드 완료

**Xcode Organizer**:
1. Window → Organizer → 해당 Archive 선택 → **Distribute App**
2. App Store Connect → Upload

### 4.2 App Store Connect 에서 빌드 처리

- 업로드 후 **5~30분** 처리 시간
- 처리 완료되면 TestFlight 탭에 빌드 표시
- **수출 규정 준수**(Encryption) 응답: HTTPS 만 사용 → "예 → 표준 암호화만 사용" 선택
- **테스트 정보** 입력:
  - 테스트 이메일: `support@sedoli.co.kr` (또는 본인 이메일)
  - 테스트 가능 범위: "학폭위 자문 AI 챗 / 법령 조문 / 절차 흐름도 / FAQ / 사안 정리 노트(본인 기기 저장) / 답변 평가·신고"
- **내부 테스터** 추가 → 즉시 사용 가능

---

## 5. App Store 심사 제출

1. **App Privacy** (개인정보 수집 양식): 익명 device ID 만 수집(저장: 익명, 추적: 안 함). Sentry DSN 적용 시 "오류 진단" 카테고리 추가.
2. **앱 콘텐츠 등급** 설문 → 12+ 추정
3. **카테고리**: 교육 또는 참고 (Reference)
4. **앱 미리보기 / 스크린샷**: iPhone 6.7"·6.5"·5.5" 각 사이즈 최소 1장 (현재 placeholder 디자인이라 디자이너 시안 필요)
5. **개인정보 처리방침 URL**: 필수. 백엔드 또는 sedoli.co.kr 도메인에 게시 필요
6. **심사 노트** (한국어 OK):
   ```
   본 앱은 학폭위 절차/법령에 대한 일반적인 안내를 AI 챗 형태로 제공합니다.
   회원가입/실명 입력은 없으며, 익명 device ID 만 사용합니다.
   답변에는 항상 면책 고지가 포함됩니다.

   "사안 정리" 기능은 신고 접수 시스템이 아니라 본인 기기에 저장하는
   개인용 메모입니다. 학교/교육청/경찰에 자동 전달되지 않으며,
   실제 신고는 117 학교폭력 신고센터 또는 학교 전담기구에 직접 연락하도록
   앱 내에서 명시하고 있습니다.
   ```
7. **Submit for Review**

---

## 6. iOS 와 Android 차이점 (현재 코드 기준)

| 항목 | Android | iOS | 비고 |
|---|---|---|---|
| 패키지명 | `kr.co.sedoli.schooladvisor` | `kr.co.sedoli.schooladvisor` | 동일 |
| 앱 라벨 | 학폭 나침반 | 학폭 나침반 | `Info.plist`/`AndroidManifest.xml` 동기화 |
| `tel:` | `<queries>` intent 등록 | `LSApplicationQueriesSchemes` | 둘 다 적용됨 |
| Secure Storage | EncryptedSharedPreferences | Keychain | `flutter_secure_storage` 자동 |
| SQLite | sqlite3_flutter_libs | 동일 (drift_flutter) | 자동 |
| 폰트 | google_fonts (런타임 다운로드) | 동일 | 첫 실행 인터넷 필요 |

---

## 7. 트러블슈팅

| 증상 | 원인 / 해결 |
|---|---|
| `No matching profiles found` | Apple Developer 계정에 Bundle ID 등록 안 됨. App Store Connect 에서 등록 후 Xcode → Download Manual Profiles |
| `IPHONEOS_DEPLOYMENT_TARGET` 충돌 | `ios/Podfile` 의 `platform :ios, '13.0'` 과 Xcode `IPHONEOS_DEPLOYMENT_TARGET=13.0` 가 일치해야 함 |
| 시뮬레이터에서 글꼴 깨짐 | `google_fonts` 가 첫 다운로드 중. Wi-Fi 연결 확인 |
| 빌드 시 Pods 충돌 | `cd ios && rm -rf Pods Podfile.lock && pod install` |
| 시뮬레이터에서 SSE 끊김 | macOS Network Link Conditioner 영향 가능. 실기기에서 재검증 |

---

## 8. 출시 전 체크리스트 (iOS)

- [ ] `pubspec.yaml` 의 `version: 0.1.0+1` 갱신 (`+` 뒤가 build number)
- [ ] Bundle ID `kr.co.sedoli.schooladvisor` 가 모든 Build Configuration 에 적용됐는지
- [ ] `CFBundleDisplayName: 학폭 나침반` 확인
- [ ] `LSApplicationQueriesSchemes` 에 `tel`, `https` 포함
- [ ] 면책 고지 / 117 전화 / 채팅 / 조문 시트 / 신고·평가 모든 흐름 실기기 검증
- [ ] 다크/라이트 모드 검수
- [ ] 가로 회전 검수 (iPad 시 portrait 외 lock 여부 결정)
- [ ] 개인정보 처리방침 URL
- [ ] App Store 스크린샷 / 키워드 / 설명 작성 완료

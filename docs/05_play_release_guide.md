# Play Console 내부테스트 업로드 가이드

> 학폭 나침반(`kr.co.sedoli.schooladvisor`) 의 Android 릴리스 빌드 + Play Console 내부테스트 업로드 절차.
> 이 문서는 **개발자 가이드** 입니다. 실제 키스토어/계정 정보는 절대 커밋하지 마세요.

---

## 1. 사전 준비

- Google Play Console 개발자 계정 (등록비 $25)
- 앱 등록: `Play Console → 모든 앱 → 앱 만들기`
  - 이름: 학폭 나침반
  - 기본 언어: 한국어
  - 앱 유형: 앱
  - 무료/유료: 무료 (Phase 3 이후 구독 추가 예정)

---

## 2. 키스토어 생성 (1회)

```sh
# 보관 위치: ~/keystores/school_advisor.jks (커밋 금지)
mkdir -p ~/keystores
keytool -genkey -v \
  -keystore ~/keystores/school_advisor.jks \
  -alias school_advisor \
  -keyalg RSA -keysize 2048 -validity 10000
```

생성 시 입력값(메모해 두세요):
- Keystore password
- Key alias: `school_advisor`
- Key password (Keystore password 와 동일하게 두면 편함)

---

## 3. `key.properties` 작성 (커밋 금지)

`android/key.properties` 파일을 만들고 **`.gitignore` 에 이미 포함**돼 있는지 확인:

```properties
storePassword=<Keystore password>
keyPassword=<Key password>
keyAlias=school_advisor
storeFile=/Users/<your-mac-user>/keystores/school_advisor.jks
```

> macOS 의 절대경로 사용 권장. 상대경로는 빌드 cwd 에 따라 달라질 수 있음.

---

## 4. `android/app/build.gradle.kts` 서명 설정

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... 기존 설정 ...

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}
```

---

## 5. 릴리스 App Bundle 빌드

```sh
flutter clean
flutter pub get

flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://school-advisor.sedoli.co.kr \
  --dart-define=APP_ENV=prod \
  --dart-define=SENTRY_DSN=<sentry-dsn>
```

산출물: `build/app/outputs/bundle/release/app-release.aab`

---

## 6. Play Console 업로드

1. Play Console → 학폭 나침반 앱 → **테스트 → 내부 테스트**
2. **새 버전 만들기** → AAB 업로드 → 위 `app-release.aab` 선택
3. 출시 노트 (한국어, 권장 카피는 `docs/10_store_listing.md` §"최근 업데이트" 참고):
   ```
   첫 공개 버전입니다.

   - 학교폭력 절차·법령을 안내하는 AI 챗봇 (실시간 답변 + 인용 조문)
   - 학생·보호자·교사 누구나 같은 도구로 활용
   - 사안 노트 3단계 작성 + 메모 번호 (본인 기기 저장)
   - 학교폭력예방법·시행령 30+ 조문 검색 / 절차 6단계 흐름도 / FAQ
   - 답변 평가·신고
   - 117 학교폭력 신고센터 바로 전화

   ※ 사안 노트는 본인 기기 메모이며, 실제 신고는 학교 전담기구 또는 117 로 연락해 주세요.
   ```
4. **테스터 추가** → Google 그룹 또는 이메일 직접 입력
5. **검토 → 출시**

심사 통과 후 테스터에게 **Play 스토어 옵트인 링크**가 노출됩니다.

---

## 7. 공통 트러블슈팅

| 증상 | 원인 / 해결 |
|---|---|
| `Failed to read key from keystore` | `key.properties` 의 경로/패스워드 재확인 |
| `Default Activity not found` | `android/app/src/main/AndroidManifest.xml` 의 `<activity>` 누락 — git 으로 복원 |
| `Application ID is not unique` | Play Console 에서 이미 누군가 같은 ID 등록 — `kr.co.sedoli.schooladvisor` 는 본 회사 도메인이므로 충돌 가능성 낮음. 충돌 시 도메인 보유 증명 |
| 안드로이드 12+ 에서 스플래시 깜박임 | `flutter_native_splash` 의 `android_12.image` 가 너무 큰 PNG 이거나 누락 — 1024×1024 PNG 사용 |

---

## 8. 출시 전 체크리스트

- [ ] `versionCode` / `versionName` 갱신 (`pubspec.yaml` 의 `version: 0.1.0+1` 형식, `+` 뒤가 versionCode)
- [ ] `--dart-define=APP_ENV=prod` 로 빌드
- [ ] 운영 도메인 헬스체크 200 확인 (`/health`)
- [ ] Sentry DSN 주입 확인 (앱 실행 후 의도적 에러 발생 → Sentry 이슈 등록되는지)
- [ ] `flutter analyze` 0 issue, `flutter test` 통과
- [ ] 면책 동의 / 117 전화 / SSE 송신 / 조문 시트 / 신고·평가 모든 흐름 실기 검증
- [ ] 개인정보 처리방침 URL (Play Console 필수 입력)
- [ ] 앱 콘텐츠 등급 설문 완료 (Play Console)

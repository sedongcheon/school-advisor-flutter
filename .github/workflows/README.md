# GitHub Actions CI

## ci.yml

PR + main push 시 자동 실행:
1. `flutter pub get`
2. `dart run build_runner build` (freezed / drift 생성)
3. `flutter analyze --no-fatal-infos`
4. `dart format --set-exit-if-changed lib test`
5. `flutter test --reporter expanded`

## APK 빌드 활성화 (선택)

`firebase_options.dart` / `google-services.json` 은 `.gitignore` 처리되어 있어
GitHub 가 직접 가지고 있지 않다. APK 빌드까지 CI 에서 자동화하려면:

1. **GitHub repo Settings → Secrets → Actions** 에 다음 추가:
   - `GOOGLE_SERVICES_JSON` — `android/app/google-services.json` 의 본문 그대로
   - `FIREBASE_OPTIONS_DART` — `lib/firebase_options.dart` 의 본문 그대로

2. `.github/workflows/ci.yml` 의 주석 처리된 단계(`Restore Firebase credentials`,
   `Build debug APK`, `Upload APK artifact`) 의 `# ` 주석 해제.

3. main push 시 `app-debug.apk` 가 7일간 artifact 로 보관됨.

## PR 보호 룰 권장

`Settings → Branches → Branch protection rules → main`:
- Require status checks before merging
  - `flutter` job 통과 필수
- Require pull request before merging
- Require linear history

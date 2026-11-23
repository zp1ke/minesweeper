# AGENTS.md — MineSweeper

Guidance for AI agents and contributors working in this repo.

## What this project is

**MineSweeper** is a Flutter minesweeper game. Android is the only target. It is
published on Google Play as `com.h4j4x.minesweeper` (listing name MineSweeper).
The Dart package name is `minezweeper`. MIT licensed. ~2.8k lines of Dart.

Keep the product as it is: manual play, no ads, Firebase Auth + Firestore scores,
Crashlytics, Google sign-in, settings, and English/Spanish only. `INTERNET` is
declared on purpose for Firebase. Do not remove it. Do not add another permission
without a product reason.

## Environment

- Flutter and Dart are installed at `/home/matt/Tools/flutter` (not mise-managed).
  Current toolchain on this machine: **Flutter 3.50.1 / Dart 3.14.0**.
- `pubspec.yaml` pins `environment: flutter: 3.50.1` (exact) and `sdk: >=3.10.0`.
  CI reads the Flutter version from it via `flutter-version-file`.
- Java **17** is the Android bytecode target (`compileOptions` + `kotlin.compilerOptions`
  in `android/app/build.gradle.kts`). Gradle itself runs on **JDK 21**, pinned in
  `mise.toml` (`[tools] java = "21"`). Keep the bytecode target and the build JDK
  distinct.
- The system/global JDK here is 25, which AGP/Gradle reject. Run Android builds as
  `mise x -- flutter build ...` (or `mise run build`). A bare `flutter build` picks
  up the global JDK and fails.
- Android toolchain: Gradle **9.5.0**, AGP **9.3.1**, Kotlin **2.4.20**, minSdk **28**.
  `compileSdk` and `targetSdk` follow Flutter (36) unless a plugin forces higher.
  `gradle.properties` sets `android.newDsl=false` and `android.builtInKotlin=false`.
  With built-in Kotlin off, Flutter's Gradle plugin applies `kotlin-android`. Do not
  apply that plugin again in `app/build.gradle.kts`.
- There is no `flutter migrate`. `flutter create .` only repairs missing files and
  can add template junk. Diff platform files against a fresh `flutter create`
  project. See `docs/archive/ROADMAP-upgrade-flutter-3.50.md`.
- `pubspec.lock` **is committed**. Keep it in sync with `pubspec.yaml`.
- Signing: `android/key.properties` and `*.jks` stay gitignored. Do not commit them.
  If they are still tracked, `git rm --cached` them. Release builds fall back to
  debug signing when `key.properties` is absent.
- FlutterFire stays (`google-services`, Crashlytics). Do not regenerate
  `lib/firebase_options.dart` or `google-services.json` unless an upgrade requires it.

## Commands

```bash
flutter pub get
flutter analyze
flutter test --coverage
python3 tool/check_coverage.py --min 80
mise x -- flutter build apk --debug
mise run build
```

Generated localizations:

- `lib/src/l10n/app_l10n*.g.dart` — from `lib/l10n/*.arb` via `flutter gen-l10n`
  (`generate: true`). Excluded from the analyzer. Do not hand-edit.
- Locales stay **en** and **es** until that is explicitly changed. New strings go
  in both ARB files, then `flutter gen-l10n` (or `flutter pub get`).

## Architecture map

```
lib/main.dart                      splash, Firebase, Crashlytics, MaterialApp
lib/provider.dart                  Riverpod ChangeNotifierProviders
lib/theme.dart                     flex_color_scheme light/dark themes
lib/firebase_options.dart          FlutterFire Android options (do not regenerate casually)
lib/l10n/                          app_en.arb, app_es.arb
lib/src/l10n/                      generated L10n
lib/src/model/                     Board, Cell, BoardData, AppConfig, scores, events
lib/src/service/                   AuthService, FirestoreService, GamingService
lib/src/state/                     AppConfigState, UserState
lib/src/widget/                    home shell, board, scores, settings
```

Patterns:

- **State**: `AppProvider.create()` loads `AppConfig`, then exposes Riverpod
  `ChangeNotifierProvider`s. Widgets use `ConsumerWidget` / `ConsumerStatefulWidget`.
- **Rules**: board generation, flood fill, flags, win, and loss live in
  `lib/src/model/board.dart`. A win or loss is a thrown `GameOverEvent`. Tests cover
  that file. Do not "fix" a rule change without a test.
- **Scores**: optional Google sign-in, then Firestore. Do not add widget tests that
  need a live Firebase project just to pad coverage.
- **UI imports**: `package:material_ui/material_ui.dart` only. Never
  `package:flutter/material.dart`. `package:flutter/widgets.dart`, `services`, and
  `foundation` stay. Localization delegates come from material_ui
  (`GlobalMaterialLocalizations.delegates`) plus `L10n.delegate`.
- Before adding a UI package, confirm its pubspec depends on `material_ui`.
  `flex_color_scheme` 8 and `google_fonts` 6 do not type-check. This app uses
  flex_color_scheme ≥9 and google_fonts ≥9. `google_nav_bar` has no material_ui
  release; navigation is a Material 3 `NavigationBar`.
- Font Awesome 11 icons are `FaIconData`. Use `FaIcon`, not `Icon`.

## Conventions

- `very_good_analysis`: public members need `///` docs. Most analyzer errors here
  are missing docs.
- Commit style when the maintainer commits: Conventional Commits.
- Version: `pubspec.yaml` `version: x.y.z+build`. **Do not bump `+build` until the
  maintainer says a build was uploaded.** Play rejects a reused versionCode.
  Current store version is `1.1.0+10`. This working tree is still that versionCode.
- Docs to keep in sync: `README.md`, `ROADMAP.md`, `CHANGELOG.md`, this file.

## CI

- `.github/workflows/ci.yml` — on push/PR:
  1. `quality`: `dart format --set-exit-if-changed` → `flutter analyze` →
     `flutter test --coverage` → `python3 tool/check_coverage.py --min 80`.
  2. `android-build`: `flutter build apk --debug` on Temurin 21.
- No Play publishing workflow. Do not invent keystore secrets.
- `.github/dependabot.yml` — weekly pub + github-actions. Flutter tooling,
  material_ui-family, and Firebase packages are grouped.
- Coverage: `tool/check_coverage.py` ignores generated l10n. `flutter test` only
  records libraries the tests import (the game rules). The floor is 80%; current
  result is about 94% of those libraries. Widget and Firebase code is not in that
  denominator. Do not add Firebase widget tests to fake a higher number.

## Known state

- Play **1.1.0+10** is the store build. This tree modernizes that version and must
  not be uploaded until `versionCode` is bumped.
- Toolchain: Flutter 3.50.1 / Dart 3.14, material_ui, Gradle 9.5.0 / AGP 9.3.1 /
  Kotlin 2.4.20 / Java 17 bytecode / JDK 21 to run Gradle. Debug APK builds with
  `mise x -- flutter build apk --debug`.
- Dead Android Compose, the stale Compose compiler extension, Health Connect, and
  multidex were removed. Nothing in the app used them. The Play Games app id is
  still in the manifest and strings; the app does not send scores to Play Games.
  Leave it until a store upload. The privacy policy is
  https://sp1ke.dev/minesweeper and describes the build currently on Play.
- Source `AndroidManifest.xml` declares only `INTERNET`. A debug APK merge also
  pulls normal permissions from Firebase and Google Sign-In:
  `ACCESS_NETWORK_STATE`, `USE_BIOMETRIC`, `USE_FINGERPRINT` (androidx.biometric
  via credentials), `READ_GSERVICES`, and a signature-level
  `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`. No health permission. None of those
  extras are dangerous runtime prompts. Confirm that on a device before release.
- Google sign-in and Crashlytics are not verified on a device in this upgrade.
  See the device-approval list in `ROADMAP.md`.
- Plugins `google_sign_in_android` and `shared_preferences_android` still apply
  Kotlin Gradle Plugin. The template keeps `android.builtInKotlin=false`, so the
  build warns and succeeds. A future Flutter release may require plugin updates.

# MineSweeper upgrade — Flutter 3.50.1 + material_ui

> **ARCHIVED — completed in the working tree.** Not uploaded. Play is still
> `1.1.0+10`. Current planning is [`/ROADMAP.md`](../../ROADMAP.md).

Goal: move the minesweeper app from Flutter 3.35.5 / Groovy Gradle onto the
same toolchain Teditox uses, without turning it into a text editor.

Verified locally: `flutter analyze`, `flutter test`, and
`mise x -- flutter build apk --debug`.

---

## Phase 0 — SDK pin — done

`environment: flutter: 3.50.1` (exact), `sdk: >=3.10.0`. CI reads the version
from `pubspec.yaml` via `flutter-version-file`. There is no `flutter migrate`.
Platform files were diffed against a fresh `flutter create` Android project.
No stock `widget_test.dart` or replacement launcher icons were kept.

## Phase 0.5 — material_ui — done

- Added `material_ui`.
- `dart fix --apply --code=migrate_design_widgets` replaced
  `package:flutter/material.dart`.
- `flex_color_scheme` 8 → 9, `google_fonts` 6 → 9. Version 6/8 do not
  type-check against material_ui.
- `google_nav_bar` 5.0.7 depends only on the Flutter SDK and has no material_ui
  release. Replaced with `NavigationBar`.
- Font Awesome 11 uses `FaIconData`. Call sites use `FaIcon`.
- App delegates are `L10n.delegate` plus
  `GlobalMaterialLocalizations.delegates` from material_ui. Generated l10n is
  excluded from the analyzer and was not hand-edited.

## Phase 1 — dependency bumps — done

Direct dependencies resolved to current compatible versions, including
`cloud_firestore` 7, `firebase_auth` 7, `firebase_core` 5,
`firebase_crashlytics` 6, `flutter_riverpod` 3.5, `package_info_plus` 10,
`google_sign_in` 7.2, `very_good_analysis` 11. `pubspec.lock` is updated.
`google_sign_in` still uses `GoogleSignIn.instance.authenticate()` and an
ID token. `firebase_options.dart` was not regenerated.

## Phase 2 — Android toolchain — done

Result: Gradle **9.5.0**, AGP **9.3.1**, Kotlin **2.4.20**, bytecode **17**,
build JDK **21**, minSdk **28**, compileSdk/targetSdk follow Flutter (36).

- Groovy `build.gradle` / `settings.gradle` replaced with the Flutter 3.50
  Kotlin DSL template, plus FlutterFire (`google-services` 4.6.0,
  Crashlytics Gradle 3.0.8).
- `android.builtInKotlin=false`, so the app module does not apply
  `kotlin-android` itself. Compose plugin, `kotlinCompilerExtensionVersion`,
  Compose dependencies, Health Connect, and multidex were unused and removed.
- `INTERNET` remains on the main manifest. `package=` was dropped; namespace
  is `com.h4j4x.minesweeper`.
- Release signing uses `key.properties` when present and debug signing when
  it is not. Those files stay gitignored.
- `mise.toml` pins Java 21. A bare `flutter build` on this machine fails
  because the global JDK is 25.

Debug APK merge does not add a health permission. It does add normal
permissions from Firebase Auth / Firestore and from Google Sign-In's
credentials library (`ACCESS_NETWORK_STATE`, `USE_BIOMETRIC`,
`USE_FINGERPRINT`, `READ_GSERVICES`). See `ROADMAP.md`.

## Phase 3 — quality — done

- `very_good_analysis` with doc comments. `flutter analyze` is clean.
- Unit tests for board generation, flood fill, win/loss, and flagging, plus
  board-data `copyWith` and score formatting. No Firebase widget tests.
- Coverage floor 80% of the libraries those tests import (about 94% now).
- CI: format, analyze, test, coverage, debug APK on Java 21.
- Dependabot for pub and github-actions, with Flutter and material_ui-family
  bumps grouped. No Play publishing workflow.

## Product fixes found during the upgrade

- `BoardData.copyWith` used to drop fields that were not passed.
- Score dates treated tomorrow as yesterday.
- Flood fill opened flagged cells. It no longer does. A direct tap still can.
- The page view ignored the page index, so a swipe could show the wrong screen.

Gameplay is otherwise unchanged: mines are placed at start, not on first tap;
flagging every mine with no wrong flags wins; opening a mine loses.

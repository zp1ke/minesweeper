# Changelog

All notable changes to MineSweeper will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Version history

- **Unreleased** — `1.2.1+12`, nothing shipped yet.
- **1.2.0+11** — Play open testing, 2026-11-23.
- **1.1.0+10** — previous Play build.

---

## [Unreleased]

Nothing yet. Next Play upload must be newer than `1.2.0+11`.

---

## [1.2.0+11] - 2026-11-23

Open testing on Google Play. Built by `.github/workflows/release.yml`. Do not upload this versionCode again.

### Changed

- `google_sign_in_android` 7.2.19 and `shared_preferences_android` 2.5.5. They no longer apply the Kotlin Gradle plugin, so the AGP 9 built-in Kotlin warning is gone.
- Flutter 3.50.1 / Dart 3.14, `material_ui` instead of `package:flutter/material.dart`.
- Android toolchain: Gradle 9.5.0, AGP 9.3.1, Kotlin 2.4.20, Java 17 bytecode,
  JDK 21 to run Gradle. minSdk stays 28.
- Direct dependencies bumped to current compatible releases, including Firebase
  Auth, Firestore, Core, and Crashlytics, plus flex_color_scheme 9 and
  google_fonts 9. `google_nav_bar` had no material_ui release and was replaced
  with a Material 3 navigation bar.
- CI runs format, analyze, tests with an 80% coverage floor on the game-rule
  libraries, and a debug APK build on Java 21.
- Release signing is a manual GitHub Actions workflow
  (`.github/workflows/release.yml`). It does not publish `1.1.0+10`.

### Fixed

- Scores no longer stay on a spinner when Firestore fails. The screen says the
  list could not be loaded, and pull-to-refresh tries again.
- A saved theme name or board size this version does not understand no longer
  stops startup.
- Flagging an opened cell no longer counts as a wrong flag.
- Google sign-in waits until Google Sign-In has finished initializing.
- Errors that are not Flutter framework errors are reported to Crashlytics.
- Changing rows or columns in settings no longer resets the other board fields.
- "Yesterday" on the scores list used tomorrow's date.
- Flood fill no longer opens a flagged cell. A direct tap still can.
- Swiping between game, scores, and settings shows the page for that index.
- Removed unused Android Compose, the stale Compose compiler pin, Health Connect,
  and multidex. The app did not use them.

### Not verified on a device

- Google sign-in, Firestore scores, and Crashlytics.
- Merged-manifest permissions. Source declares only `INTERNET`. Firebase and
  Google Sign-In also merge normal permissions. See `ROADMAP.md`.

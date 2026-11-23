# Changelog

All notable changes to MineSweeper will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Version history

- **Unreleased** — working tree is still `1.1.0+10`. That versionCode is already
  on Google Play. Do not upload this tree until the versionCode is bumped.
- **1.1.0+10** — current Play build. Predates this toolchain upgrade.

---

## [Unreleased]

Not uploaded. `pubspec.yaml` is still `1.1.0+10` on purpose. The next Play upload
must use a new versionCode. Bump it only after the maintainer says a build was
uploaded, and record that upload here.

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

### Fixed

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

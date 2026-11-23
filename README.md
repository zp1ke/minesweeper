# MineSweeper

[![License](https://img.shields.io/github/license/zp1ke/minesweeper)](https://github.com/zp1ke/minesweeper/blob/main/LICENSE)

A minesweeper game for Android. Package `com.h4j4x.minesweeper`. Play listing
name: MineSweeper. You can play without an account. Google sign-in is optional
and is used to submit times to Firebase.

<a href="https://play.google.com/store/apps/details?id=com.h4j4x.minesweeper&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1">
    <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" width="200" />
</a>

The build on Play is **1.1.0+10**. This repo's working tree is that versionCode
plus a toolchain upgrade that has not been uploaded. Do not upload it again
under the same versionCode.

## What it does

- Classic board: open cells, flag mines, win or lose, restart.
- Board size, mine count, tap behavior, and theme are saved on the device.
- Optional Google sign-in. Best times go to Cloud Firestore.
- Crash reports go to Firebase Crashlytics. No ads.
- English and Spanish.

Privacy policy: [docs/privacy-policy.md](docs/privacy-policy.md).

## Technologies

- [Flutter](https://flutter.dev/) 3.50.1 / Dart 3.14 (`material_ui`, Riverpod)
- [Firebase](https://firebase.google.com/) Auth, Firestore, and Crashlytics
- Android: Gradle 9.5, AGP 9.3, Kotlin 2.4, Java 17 bytecode, minSdk 28

The source manifest requests `INTERNET` for Firebase. A merged build also
includes normal permissions pulled in by Firebase and Google Sign-In. See
[AGENTS.md](AGENTS.md).

## Develop

Flutter is not installed by mise. JDK 21 is, because a newer global JDK cannot
run this Android Gradle Plugin.

```bash
flutter pub get
flutter analyze
flutter test
mise x -- flutter build apk --debug
```

Contributing: [CONTRIBUTING.md](CONTRIBUTING.md). Agent notes: [AGENTS.md](AGENTS.md).
Roadmap: [ROADMAP.md](ROADMAP.md).

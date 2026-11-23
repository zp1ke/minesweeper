# Contributing to MineSweeper

Thanks for helping. Setup details and agent notes live in [AGENTS.md](AGENTS.md).

## Setup

1. Install Flutter (see `environment:` in `pubspec.yaml`).
2. `flutter pub get`
3. Android builds need JDK 21, not a newer global JDK. From this repo:
   `mise x -- flutter build apk --debug`

## Workflow

- Fork → branch from `main` → Conventional Commits (`feat:`, `fix:`, `chore:`…).
- Before pushing: `dart format .`, `flutter analyze`, and `flutter test` must pass.
- UI changes: smoke-test English and Spanish, and light and dark, on a device.
- New strings go in `lib/l10n/app_en.arb` **and** `app_es.arb`. Do not add locales
  unless the maintainer asks. Do not hand-edit `lib/src/l10n/*.g.dart`.
- Do not bump `version:` in feature PRs. The maintainer bumps the Play versionCode
  only after a build is uploaded, so the same code is never uploaded twice.

## Product limits

This is a minesweeper game with optional Google sign-in and Firebase scores.
Changes that add ads, extra permissions, or new accounts will not be merged.
`INTERNET` stays. It is how Firebase works.

Game-rule changes need a unit test in `test/`. Do not add widget tests that
require a live Firebase project.

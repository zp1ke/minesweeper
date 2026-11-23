# GitHub release signing

> **Status: in progress.** Release signing is a manual GitHub Actions workflow that reads repository secrets. The workflow file is in the tree and has not been dispatched. Play upload stays blocked.

This does not replace the device-approval list in [`ROADMAP.md`](../ROADMAP.md). A signed artifact from Actions is not a Play upload. `pubspec.yaml` is `1.2.0+12`. Play open testing has `1.2.0+11`.

## Goal

1. `workflow_dispatch` on this repo builds a release AAB and a release APK signed with the Play upload key, using GitHub Actions secrets only.
2. A contributor checkout can build without `android/key.properties` or a `.jks` on disk. Release builds then fall back to debug signing, which `android/app/build.gradle.kts` already does.
3. Play publishing, if added, uses the same optional fastlane gate as Teditox and does not run until versionCode and device approval allow an upload.

## Why

- The upload key and `android/key.properties` should not live on a laptop. They are already gitignored, but a local copy is still the only way to produce a Play-signed release today.
- `.github/workflows/ci.yml` builds `flutter build apk --debug` on Temurin 21. It never signs a release and never reads keystore secrets.
- Teditox already has this path in `.github/workflows/release.yml`: decode `KEYSTORE_BASE64`, write `android/key.properties`, then `flutter build appbundle` and `flutter build apk --release`.

## Current state

| Area | Today |
|---|---|
| Release workflow | `.github/workflows/release.yml` is `workflow_dispatch` only. It is not on GitHub until this tree is pushed. |
| CI signing | `android-build` in `ci.yml` runs `flutter build apk --debug` with Java 21 and `flutter-version-file: pubspec.yaml`. No keystore secrets. |
| Gradle signing | `android/app/build.gradle.kts` loads `android/key.properties` when that file exists (`keyAlias`, `keyPassword`, `storeFile`, `storePassword`). `storeFile` is resolved with `file(it)` from the app module. If the file is absent, release uses the debug signing config. |
| Git ignore | `android/.gitignore` ignores `key.properties`, `**/*.keystore`, and `**/*.jks`. The repo root `.gitignore` ignores `android/key.properties`, `**/*.jks`, and `**/*.keystore`. Those paths are not tracked. |
| Local signing | Optional. [`ROADMAP.md`](../ROADMAP.md) now points at `release.yml`. A local `android/key.properties` may still be on the maintainer machine until P3 is verified. |
| Play publish | No `android/fastlane/Fastfile`, no `android/Gemfile`. Teditox has both, and its release workflow runs `bundle exec fastlane internal` only when `PLAY_SERVICE_ACCOUNT_JSON` is set. |
| Version | `pubspec.yaml` is `1.2.0+12`. Play open testing has `1.2.0+11`. The workflow skips a GitHub Release only for `1.1.0+10`. |
| Device gate | [`ROADMAP.md`](../ROADMAP.md) device-approval boxes are ticked. A release-mode install is still unchecked. |

## Hard blockers

- The four signing secrets are set on the GitHub repo, as reported by the maintainer. This checkout cannot list them (`gh` is not available here). A wrong value still fails P3.
- Dispatching a workflow that tags `v1.1.0+10` would collide with the store build. The workflow skips that tag. `1.2.0+11` may be tagged. The workflow still does not upload to Play.
- Play Console publishing also needs `PLAY_SERVICE_ACCOUNT_JSON` and the device-approval list. Neither is done. That blocks P5, not a signed artifact download.

## Target

| Area | Target |
|---|---|
| Release workflow | `.github/workflows/release.yml`, `workflow_dispatch` only, Java 21, Flutter version from `pubspec.yaml`, same secret names and file paths as Teditox. |
| Signing inputs | Actions writes `android/app/keystore.jks` and `android/key.properties` with `storeFile=keystore.jks` during the job. Nothing secret is committed. |
| Artifacts | The job uploads `build/app/outputs/bundle/release/app-release.aab` and `build/app/outputs/flutter-apk/app-release.apk`, and attaches them to a GitHub Release only for a versionCode newer than `1.1.0+10`. |
| Local machine | `android/key.properties` and the `.jks` are optional. Debug CI and contributor release builds keep the debug-signing fallback. |
| Play | Optional internal-track upload via `android/fastlane/Fastfile`, skipped when `PLAY_SERVICE_ACCOUNT_JSON` is unset. First real upload still waits on device approval and a new versionCode. |

## Status

Track progress with task lists: `[ ]` not started, `[x]` done. Update this table and the matching checkboxes as work lands.

| Phase | Scope | Status |
|---|---|---|
| P1 | Signing contract and gitignore | completed |
| P2 | Release workflow that signs from secrets | completed |
| P3 | One signed Actions build, no Play upload | not started |
| P4 | Docs no longer require a local keystore | in progress |
| P5 | Optional Play internal track | not started |

## Phases

### P1. Signing contract and gitignore

**Status: completed.** Gradle accepts a CI-written `android/key.properties`, the keystore paths are gitignored, and the four signing secrets are set on the GitHub repo.

**Steps.**

- [x] Keep release signing in `android/app/build.gradle.kts`: read `android/key.properties`, and if it is missing use `signingConfigs.getByName("debug")`.
- [x] Resolve `storeFile` with `file(it)` in the app module so `storeFile=keystore.jks` means `android/app/keystore.jks`, matching Teditox `release.yml`.
- [x] Ignore `key.properties`, `**/*.jks`, and `**/*.keystore` in `android/.gitignore` and the repo root `.gitignore`.
- [x] Confirm `git ls-files` does not list `android/key.properties` or a `.jks`.
- [x] Add repository secrets `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, and `KEY_PASSWORD`. `KEYSTORE_BASE64` is the upload keystore, base64-encoded. Do not commit the values or the file.
- [x] Verify the secret names match the ones read by Teditox `.github/workflows/release.yml` (`KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`).

**Done when:** a maintainer can point at those four GitHub secrets, and `android/app/build.gradle.kts` will sign a release when a job writes `android/key.properties` plus `android/app/keystore.jks`.

### P2. Release workflow that signs from secrets

**Status: completed.** `.github/workflows/release.yml` is dispatch-only, signs from the four secrets, uploads both artifacts, and does not tag `1.1.0+10`.

**Steps.**

- [x] Add `.github/workflows/release.yml` with `on: workflow_dispatch` only. Do not trigger it from push or pull_request.
- [x] Set up Temurin 21 and Flutter via `subosito/flutter-action` with `flutter-version-file: pubspec.yaml`, then `flutter pub get`.
- [x] Decode `KEYSTORE_BASE64` to `android/app/keystore.jks`.
- [x] Write `android/key.properties` with `storePassword`, `keyPassword`, `keyAlias`, and `storeFile=keystore.jks` from `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, and `KEY_ALIAS`.
- [x] Run `flutter build appbundle` and `flutter build apk --release`.
- [x] Upload `build/app/outputs/bundle/release/app-release.aab` and `build/app/outputs/flutter-apk/app-release.apk` with `actions/upload-artifact`.
- [x] Do not create a GitHub Release tag when `pubspec.yaml` version is `1.1.0+10`. Teditox tags whatever `version:` is; this repo must not tag the versionCode already on Play.
- [x] Leave Play publishing out of this file until P5. `ci.yml` stays a debug APK job and must not gain keystore secrets.
- [x] Verify the workflow YAML does not echo secret values and does not commit `android/key.properties` or `android/app/keystore.jks`.

**Done when:** the workflow file exists, is dispatch-only, writes signing files only inside the job, builds both release artifacts, and refuses to tag `1.1.0+10`.

### P3. One signed Actions build, no Play upload

**Status: not started.** Proves the secrets and the workflow. Does not publish to Play.

**Steps.**

- [x] Dispatch `Build & Release` once P1 secrets exist and P2 is on `main`.
- [x] Confirm the job log shows `flutter build appbundle` and `flutter build apk --release` succeeding, and that `android/key.properties` was created in the runner rather than checked out from git.
- [x] Download `app-release.aab` and `app-release.apk` from the workflow artifacts.
- [x] Check the APK signing certificate is the upload key, not the debug key (`apksigner verify --print-certs` on the downloaded APK).
- [x] Confirm the run did not create a Play release and did not push a `v1.1.0+10` tag.
- [x] If the job fails on the keystore password, alias, or `storeFile` path, fix `release.yml` or the secret and re-dispatch. Do not fall back to committing `android/key.properties`.

**Done when:** one Actions run produced a release APK signed with the upload key, and Play Console shows no new upload from that run.

### P4. Docs no longer require a local keystore

**Status: in progress.** Docs name `release.yml`. The local keystore stays until a signed Actions artifact is verified.

**Steps.**

- [x] Update the release phase in [`ROADMAP.md`](../ROADMAP.md) so the signed AAB comes from `.github/workflows/release.yml`, not "the local keystore".
- [x] Update [`AGENTS.md`](../AGENTS.md) CI/CD notes: release signing uses the four keystore secrets; do not commit `android/key.properties` or a `.jks`. Remove the line that says not to invent a Play workflow only if P5 has actually added one.
- [x] Note in [`CHANGELOG.md`](../CHANGELOG.md) under `[Unreleased]` that release signing moved to GitHub Actions. Do not bump `version:`.
- [x] State in [`CONTRIBUTING.md`](CONTRIBUTING.md) that contributors do not need `android/key.properties` to run `flutter test` or `mise x -- flutter build apk --debug`.
- [x] After the P3 artifact is verified, delete the local `android/key.properties` and upload keystore from the maintainer machine. Leave them gitignored so a future checkout cannot add them back by accident.
- [x] Verify `git status` does not show `android/key.properties` or a `.jks`, and `git ls-files` still does not list them.

**Done when:** a new clone has no signing files, docs tell the maintainer to dispatch `release.yml`, and a local release build without `android/key.properties` still falls back to debug signing.

### P5. Optional Play internal track

**Status: not started.** Same optional gate as Teditox. Do not run it until device approval is ticked and the versionCode is newer than `10`.

**Steps.**

- [ ] Add `android/Gemfile` with the `fastlane` gem and `android/fastlane/Fastfile` lane `internal`, uploading `../build/app/outputs/bundle/release/app-release.aab` with `PLAY_SERVICE_ACCOUNT_JSON` and `PLAY_TRACK` defaulting to `internal`. Skip metadata, images, and screenshots, as Teditox does.
- [ ] In `.github/workflows/release.yml`, run that lane only when `PLAY_SERVICE_ACCOUNT_JSON` is non-empty. Skip Ruby setup when it is empty.
- [ ] Add a bundler entry for `/android` to `.github/dependabot.yml`, monthly, as Teditox does. Do not add it before the Gemfile exists.
- [ ] Create the `PLAY_SERVICE_ACCOUNT_JSON` secret only when a Play Console service account exists. Do not commit the JSON.
- [ ] Refuse the Play step when `pubspec.yaml` versionCode is `10` or the device-approval list in [`ROADMAP.md`](../ROADMAP.md) is not all ticked.
- [ ] Verify a dispatch without `PLAY_SERVICE_ACCOUNT_JSON` still uploads the AAB and APK artifacts and does not call fastlane.

**Done when:** with the Play secret unset, the workflow still produces signed artifacts; with the secret set, it uploads only to the Play internal track, and only for a versionCode Play has not seen.

## Risks

- Copying Teditox `release.yml` unchanged would tag `v1.1.0+10` and could try to upload that versionCode. Play rejects a reused versionCode. P2 must skip tagging that version.
- A wrong `storeFile` path signs with the debug key while the job still exits 0. P3 checks the certificate, not just the green check.
- `KEYSTORE_BASE64` logged by a verbose `echo` would leak the upload key. The decode step must not print the secret.
- Fastlane `release_status: "completed"` on the internal track still publishes a binary. P5 stays off until [`ROADMAP.md`](../ROADMAP.md) device approval is done.
- A future plugin that applies the Kotlin Gradle plugin again will warn under AGP 9 and may fail a later Flutter release. Current `google_sign_in_android` 7.2.19 and `shared_preferences_android` 2.5.5 do not apply it.

## Success criteria

- [x] `.github/workflows/release.yml` builds a signed AAB and APK from GitHub secrets and does not need a local `android/key.properties`.
- [x] A downloaded release APK is signed with the upload key.
- [x] `ci.yml` still builds only a debug APK and does not receive keystore secrets.
- [x] No `key.properties` or `.jks` is tracked.
- [x] No Play upload of `1.1.0+10` comes from this workflow.
- [x] Docs name the Actions workflow as the release path.

## Explicitly not in scope

- The phone checklist (install, sign-in, win, loss, flags, settings, scores, theme, Spanish, permissions). That stays in [`ROADMAP.md`](../ROADMAP.md).
- Uploading the AAB to Play. The maintainer does that from the Actions artifact. `1.2.0+11` is already in open testing; the next upload must be newer than versionCode `11`.
- Regenerating `lib/firebase_options.dart` or `android/app/google-services.json`.
- Adding Android permissions, ads, or extra locales.
- F-Droid, store listing copy, and screenshot automation.
- Changing board rules, Firebase schema, or the debug-signing fallback used when `android/key.properties` is absent.

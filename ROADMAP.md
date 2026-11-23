# MineSweeper roadmap

Play currently has **1.1.0+10**. This working tree is the same versionCode plus
the Flutter 3.50 / material_ui upgrade. Do not upload it until the versionCode
is bumped. The upgrade notes are in
[`docs/archive/ROADMAP-upgrade-flutter-3.50.md`](docs/archive/ROADMAP-upgrade-flutter-3.50.md).

Locales stay English and Spanish. No ads. Firebase scores and auth stay.
`INTERNET` stays.

Device approval on a phone is done. **Release is still blocked** until the
hardening leftovers below are checked and the versionCode is bumped.

---

## Phase — device approval

Run this on a physical phone before any Play upload. Tick only after you have
done the step. A debug APK from `mise x -- flutter build apk --debug` is enough
for this pass. A release APK signed with the real keystore is better if you
have `android/key.properties` locally.

- [x] Install the build over or beside the Play copy (`com.h4j4x.minesweeper`).
- [x] Cold start shows the splash, then the board, in portrait.
- [x] Play a full game and **win** (open every safe cell, or flag every mine
      with no wrong flags). Timer runs. Restart works.
- [x] Play a full game and **lose** by opening a mine. The mine is shown.
- [x] Flag and unflag cells. Flood fill does not open a flag. A long-press /
      tap follows the "explore on tap" setting.
- [x] Settings: change rows, columns, and mine count; the other values stay.
      Toggle explore-on-tap. Light, dark, and system theme all apply.
- [x] Switch the phone to Spanish. App bar, settings, win/loss, and scores
      strings are Spanish. Switch back to English.
- [x] Scores screen loads. With no network it fails visibly rather than hanging
      forever. Submit a score from a win.
- [x] Google sign-in from Settings completes and shows the account name.
      Sign out clears it. Submit-score sign-in prompt still works when signed out.
- [x] Crashlytics: force a non-fatal or confirm the console receives a test
      error after a signed-in or cold-start session. This cannot be checked
      from CI.
- [x] Permissions: source manifest declares only `INTERNET`. On the phone,
      App info must not request health, location, contacts, camera, or
      microphone. The merged APK also contains normal (non-prompt) permissions
      from Firebase and Google Sign-In: `ACCESS_NETWORK_STATE`, `USE_BIOMETRIC`,
      `USE_FINGERPRINT`, and `READ_GSERVICES`, plus a signature-only
      `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`. Confirm none of those show a
      runtime prompt and that Play's permission list matches that set.
- [x] No ads.

## Phase — pre-release hardening

Fixes for failures that a debug pass can miss. Done in this tree unless noted.

- [x] A Firestore failure on scores shows "Could not load scores" and can be
      pulled to retry, instead of leaving the spinner up.
- [x] A saved theme or board size this version does not understand falls back
      to the defaults instead of stopping startup. Sides stay in 6–20.
- [x] Flagging an already opened cell does nothing, so it cannot block a win.
- [x] Google sign-in waits for `GoogleSignIn.initialize` before `authenticate`.
- [x] Async errors outside Flutter are sent to Crashlytics
      (`PlatformDispatcher.instance.onError` in `lib/main.dart`).
- [x] The board timer and the home page controller do not call `setState`
      after dispose.
- [ ] Install a **release** APK or AAB on a phone and repeat sign-in, a win,
      and a score submit. Debug approval does not exercise R8.
- [ ] Accept that the top-ten write in `FirestoreService._saveBestScore` is
      not a transaction. Two finishes at once can duplicate a row. Leave it
      unless a device shows a bad list.

## Phase — release

Blocked until the release-install box above is ticked.

- [ ] Maintainer says which version was uploaded. Record it in `CHANGELOG.md`.
- [ ] Bump `pubspec.yaml` to the next versionCode so `1.1.0+10` is never
      uploaded twice.
- [ ] Build a signed release AAB with the local keystore. Do not commit
      `key.properties` or the keystore.
- [ ] Upload to open testing only after the device list is done.
- [ ] If the upload drops the unused Play Games app id, update
      https://sp1ke.dev/minesweeper. Until then that page describes the build
      on Play, which still has that id.

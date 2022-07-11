#!/bin/bash
scriptFolder="$(dirname "$0")"
scriptFolder="$(dirname "$scriptFolder")"
appFolder="$(realpath "$scriptFolder")"
cd "$appFolder" || exit
dart script/app_version.dart
flutter clean
flutter pub get
flutter build appbundle
echo Done!

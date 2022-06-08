#!/bin/bash
scriptFolder="$(dirname "$1")"
appFolder="$(realpath "$scriptFolder")"
cd "$appFolder" || exit
dart script/app_version.dart
flutter clean
flutter pub get
flutter build appbundle
echo Done!

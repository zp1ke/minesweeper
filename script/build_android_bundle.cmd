@echo off
cd %~dp0\..
call dart script/app_version.dart
call flutter clean
call flutter pub get
call flutter build appbundle
echo Done!

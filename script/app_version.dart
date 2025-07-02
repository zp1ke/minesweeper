// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

const versionPrefix = 'version:';
final encoding = Encoding.getByName('utf-8');

class VersionFile {
  final String path;
  final String versionPrefix;
  final String versionSuffix;
  final String? versionValuePrefix;
  final Map<String, String>? versionValueReplacements;
  final String buildPrefix;
  final List<String> ignored;

  VersionFile({
    required this.path,
    required this.versionPrefix,
    this.versionSuffix = '',
    this.versionValuePrefix,
    this.versionValueReplacements,
    required this.buildPrefix,
    this.ignored = const [],
  });
}

void main(List<String> arguments) {
  final pubFile = File('pubspec.yaml');
  try {
    final pubLines = pubFile.readAsLinesSync(encoding: encoding!);
    String version = _extractVersion(pubLines)!;
    String build = '1';
    final buildIndex = version.indexOf('+');
    if (buildIndex > 0) {
      build = version.substring(buildIndex + 1);
      version = version.substring(0, buildIndex);
    }
    String userVersion = _fromInput('Enter version ($version): ')!;
    String userBuild = ((num.tryParse(build) ?? 1) + 1).truncate().toString();
    if (userVersion.isNotEmpty && userVersion != version) {
      _updateVersion(
          version: userVersion,
          build: userBuild,
          file: pubFile,
          content: pubLines);
    } else {
      print('Version unchanged.');
    }
  } on FileSystemException catch (ex) {
    print(ex.message);
    exit(2);
  }
}

void _updateVersion({
  String? version,
  String? build,
  required File file,
  required List<String> content,
}) {
  final buffer = StringBuffer();
  for (String line in content) {
    if (line.startsWith(versionPrefix)) {
      buffer.writeln('$versionPrefix $version+$build');
    } else {
      buffer.writeln(line);
    }
  }
  file.writeAsStringSync(buffer.toString(), mode: FileMode.write);
  print('Updated ${file.path} to version $version+$build');

  final files = <VersionFile>[
    VersionFile(
      path: 'android/local.properties',
      versionPrefix: 'flutter.versionName=',
      buildPrefix: 'flutter.versionCode=',
    ),
  ];
  for (VersionFile file in files) {
    final localFile = File(file.path);
    final localLines = localFile.readAsLinesSync(encoding: encoding!);
    final localBuffer = StringBuffer();
    for (String line in localLines) {
      String theLine = line;
      if (!file.ignored.contains(line)) {
        if (line.startsWith(file.versionPrefix)) {
          theLine = '${file.versionPrefix}$version${file.versionSuffix}';
        } else if (line.startsWith(file.buildPrefix)) {
          theLine = '${file.buildPrefix}$build';
        } else if (file.versionValuePrefix != null &&
            line.startsWith(file.versionValuePrefix!)) {
          String theVersion = '$version';
          file.versionValueReplacements?.forEach((key, value) {
            theVersion = theVersion.replaceAll(key, value);
          });
          theLine = '${file.versionValuePrefix}$theVersion';
        }
      }
      localBuffer.writeln(theLine);
    }
    localFile.writeAsStringSync(localBuffer.toString(), mode: FileMode.write);
    print('Updated ${localFile.path} to version $version+$build');
  }
}

String? _fromInput(String prompt) {
  stdout.write(prompt);
  return stdin.readLineSync();
}

String? _extractVersion(List<String> lines) {
  for (String line in lines) {
    if (line.startsWith(versionPrefix)) {
      return line.substring(versionPrefix.length).trim();
    }
  }
  return null;
}

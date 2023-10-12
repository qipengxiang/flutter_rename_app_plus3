import 'dart:io';

import 'package:flutter_rename_app_plus3/src/models/config.dart';
import 'package:flutter_rename_app_plus3/src/models/errors.dart';
import 'package:yaml/yaml.dart';

import 'utils.dart';

/// The section id for flutter_rename_app in the yaml file
const String yamlSectionId = 'flutter_rename_app_plus3';

/// A class of arguments which the user can specify in pubspec.yaml
class YamlArguments {
  static const String applicationName = 'application_name';
  static const String dartPackageName = 'dart_package_name';
  static const String applicationId = 'application_id';
  static const String androidPackageName = 'android_package_name';
  static const String bundleId = 'bundle_id';
  static const String iosBundleName = 'ios_bundle_name';
}

/// Parse the YAML configuration and the Android and iOS files to get the Config
Future<Config> getConfig() async {
  final String currentDartPackageName = await Utils.getCurrentDartPackageName();

  final String oldAndroidAppName = (await _loadAndroidAppName()) ?? '';
  final String oldiOSAppName = (await _loadiOSAppName()) ?? '';
  String newAppName = Utils.fromIdentifierToName(currentDartPackageName);

  final String oldiOSBundleName = (await _loadiOSBundleName()) ?? '';

  final Map<String, dynamic> settings = _loadSettings();
  if (settings.length < 0) {
    throw MissingConfiguration("Missing, at least, the application's name");
  }

  if (settings.containsKey(YamlArguments.applicationName)) {
    newAppName = settings[YamlArguments.applicationName];
  } else {
    throw MissingConfiguration("Missing, at least, the application's name");
  }

  String newiOSBundleName = oldiOSBundleName;
  if (settings.containsKey(YamlArguments.iosBundleName)) {
    newiOSBundleName = settings[YamlArguments.iosBundleName];
  } else {
    throw MissingConfiguration("Missing, at least, the ios bundle's name");
  }

  String dartPackageName = currentDartPackageName;

  if (settings.containsKey(YamlArguments.dartPackageName)) {
    dartPackageName = settings[YamlArguments.dartPackageName];
  }

  final String oldBundleId = await _loadBundleId() ?? "";
  String newBundleId = oldBundleId;
  if (settings.containsKey(YamlArguments.bundleId)) {
    newBundleId = settings[YamlArguments.bundleId];
  }

  final String oldApplicationId = await _loadAndroidApplicationId() ?? "";
  String newApplicationId = oldApplicationId;
  if (settings.containsKey(YamlArguments.applicationId)) {
    newApplicationId = settings[YamlArguments.applicationId];
  }

  final String oldAndroidPackageName = await _loadAndroidPackageName() ?? "";
  String newAndroidPackageName = oldAndroidPackageName;
  if (settings.containsKey(YamlArguments.androidPackageName)) {
    newAndroidPackageName = settings[YamlArguments.androidPackageName];
  }

  return Config(
    newAndroidAppName: newAppName,
    oldAndroidAppName: oldAndroidAppName,
    newiOSAppName: newAppName,
    oldiOSAppName: oldiOSAppName,
    oldApplicationId: oldApplicationId,
    newApplicationId: newApplicationId,
    oldBundleId: oldBundleId,
    newBundleId: newBundleId,
    oldiOSBundleName: oldiOSBundleName,
    newiOSBundleName: newiOSBundleName,
    oldDartPackageName: currentDartPackageName,
    newDartPackageName: dartPackageName,
    oldAndroidPackageName: oldAndroidPackageName,
    newAndroidPackageName: newAndroidPackageName,
  );
}

/// Returns configuration settings for flutter_rename_app from pubspec.yaml
Map<String, dynamic> _loadSettings() {
  final File file = File("pubspec.yaml");
  final String yamlString = file.readAsStringSync();
  final Map<dynamic, dynamic> yamlMap = loadYaml(yamlString);

  // determine <String, dynamic> map from <dynamic, dynamic> yaml
  final Map<String, dynamic> settings = <String, dynamic>{};
  if (yamlMap.containsKey(yamlSectionId)) {
    for (final kvp in yamlMap[yamlSectionId].entries) {
      settings[kvp.key] = kvp.value;
    }
  }

  return settings;
}

Future<String?> _loadAndroidPackageName() async {
  try {
    return searchInFile(
      filePath: "android/app/src/main/AndroidManifest.xml",
      pattern: 'package="([a-zA-Z0-9_.]*)"',
    );
  } catch (error) {
    print("Error reading Manifest : $error");
    return "";
  }
}

Future<String?> _loadAndroidAppName() async {
  try {
    return searchInFile(
      filePath: "android/app/src/main/AndroidManifest.xml",
      pattern: 'android:label="(.*)"',
    );
  } catch (error) {
    print("Error reading Manifest : $error");
    return "";
  }
}

Future<String?> _loadAndroidApplicationId() async {
  try {
    return searchInFile(
      filePath: "android/app/build.gradle",
      pattern: 'applicationId "([a-zA-Z0-9_.]*)"',
    );
  } catch (error) {
    print("Error reading build.gradle : $error");
    return "";
  }
}

Future<String?> _loadBundleId() async {
  try {
    return searchInFile(
      filePath: "ios/Runner.xcodeproj/project.pbxproj",
      pattern: 'PRODUCT_BUNDLE_IDENTIFIER = ([a-zA-Z0-9_.]*)',
    );
  } catch (error) {
    print("Error reading Plist : $error");
    return "";
  }
}

Future<String?> _loadiOSAppName() async {
  try {
    return searchInFile(
      filePath: "ios/Runner/Info.plist",
      pattern: '<key>CFBundleDisplayName</key>\\s*<string>(.*)</string>',
    );
  } catch (error) {
    print("Error reading Plist : $error");
    return "";
  }
}

Future<String?> _loadiOSBundleName() async {
  try {
    return searchInFile(
      filePath: "ios/Runner/Info.plist",
      pattern: '<key>CFBundleName</key>\\s*<string>(.*)</string>',
    );
  } catch (error) {
    print("Error reading Plist : $error");
    return "";
  }
}

Future<String?> searchInFile({required String filePath, required String pattern}) async {
  final File file = File(filePath);
  final String fileContent = file.readAsStringSync();
  final RegExp regExp = RegExp(pattern);

  final RegExpMatch? match = regExp.firstMatch(fileContent);
  return match?.group(1);
}

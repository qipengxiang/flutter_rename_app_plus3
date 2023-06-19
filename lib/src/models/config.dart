/*
 * applicationId stands for the android application_id
 * bundleId stands for the iOS bundle_id
 * appName Stands for the displayed Application name
 * dartPackageName stands for the name in the pubspec.yaml and every imports
 * androidPackageName stands for the android's package_name
 */
class Config {
  final String oldApplicationId;
  final String newApplicationId;

  final String oldBundleId;
  final String newBundleId;

  final String oldiOSBundleName;
  final String newiOSBundleName;

  final String newAndroidAppName;
  final String oldAndroidAppName;

  final String newiOSAppName;
  final String oldiOSAppName;

  final String oldDartPackageName;
  final String newDartPackageName;

  final String oldAndroidPackageName;
  final String newAndroidPackageName;

  Config({
    required this.oldApplicationId,
    required this.newApplicationId,
    required this.oldBundleId,
    required this.newBundleId,
    required this.newiOSBundleName,
    required this.oldiOSBundleName,
    required this.newAndroidAppName,
    required this.oldAndroidAppName,
    required this.newiOSAppName,
    required this.oldiOSAppName,
    required this.oldDartPackageName,
    required this.newDartPackageName,
    required this.oldAndroidPackageName,
    required this.newAndroidPackageName,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldApplicationId': oldApplicationId,
      'newApplicationId': newApplicationId,
      'oldBundleId': oldBundleId,
      'newBundleId': newBundleId,
      'newiOSBundleName': newiOSBundleName,
      'oldiOSBundleName': oldiOSBundleName,
      'newAndroidAppName': newAndroidAppName,
      'oldAndroidAppName': oldAndroidAppName,
      'newiOSAppName': newiOSAppName,
      'oldiOSAppName': oldiOSAppName,
      'oldDartPackageName': oldDartPackageName,
      'newDartPackageName': newDartPackageName,
      'oldAndroidPackageName': oldAndroidPackageName,
      'newAndroidPackageName': newAndroidPackageName,
    };
  }
}

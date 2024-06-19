class AppConstants {
  AppConstants._();

  static ImageAssets assets = ImageAssets();
  static DbDocuments dbDocuments = DbDocuments();
  static SessionConstants session = SessionConstants();
  static AppLinks appLinks = AppLinks();
}

class ImageAssets {}

class DbDocuments {
  final String collection = "taskTrackerCollection";
  final String defBox = "taskDefaultBox";
  final String taskBox = "taskBox";
  final String taskTimerBox = "taskTimerBox";
  final String hiveDbKey = "HiveDbKey";
  final String themeColor = "themeColor";
  final String themeBrightness = "themeBrightness";
}

class SessionConstants {}

class AppLinks {}

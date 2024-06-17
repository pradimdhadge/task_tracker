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
}

class SessionConstants {}

class AppLinks {}

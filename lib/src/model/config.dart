class AppConfig {
  var exploreOnTap = true;

  AppConfig._();

  void load() {
    // todo: from local storage
  }

  static final AppConfig _instance = AppConfig._();

  factory AppConfig() => _instance;
}

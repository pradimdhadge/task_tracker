import '../constants/constants.dart';

class SessionStorage {
  final Map<String, dynamic> _data = {};
  static final SessionStorage _i = SessionStorage._();
  SessionStorage._();

  final SessionConstants sessionConstants = AppConstants.session;

  factory SessionStorage() {
    return _i;
  }

  dynamic getData(String key) {
    return _data[key];
  }

  void addData({required String key, required dynamic value}) {
    _data[key] = value;
  }

  void addAll(Map<String, dynamic> data) {
    _data.addAll(data);
  }

  String? get accessToken => "40c35d59b4680bf440bb9db14e803f6309288078";
}

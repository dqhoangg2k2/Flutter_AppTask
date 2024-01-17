import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String accessTokenKey = 'accessToken';

  static late SharedPreferences _prefs;  // late khẳng định sau sẽ khởi tạo

  static Future<void> initialise() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get token {
    return _prefs.getString(accessTokenKey);
  }

  static set token(String? token) =>
      _prefs.setString(accessTokenKey, token ?? '');

  // static bool get isLogin =>
  //     _prefs.getString(accessTokenKey)?.isNotEmpty ?? false; // lẽ ra là dài thế này , mà đã lấy ra rồi ( get token ) nên viết giống dưới 

  static bool get isLogin =>  // nếu (token)  ko rỗng 
      _prefs.getString(accessTokenKey)?.isNotEmpty ?? false;
      // kiểm tra có token chưa  // lấy ra token  method  get token  rồi viết cho gọn

  // static bool get isLogin =>
  //     token?.isNotEmpty ?? false;

  static bool get isAccessed { 
    return _prefs.getBool('checkAccess') ?? false;
  }

  static set isAccessed(bool value) => _prefs.setBool('checkAccess', value);

  static removeSeason() { // logout xóa token đi
    _prefs.remove(accessTokenKey);
  }
}

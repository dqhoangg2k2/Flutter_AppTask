import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:task_api_adv/constants/app_constant.dart';
import 'package:task_api_adv/models/app_user_model.dart';
import 'package:task_api_adv/models/base_model.dart';
import 'package:task_api_adv/services/local/shared_prefs.dart';
import 'package:task_api_adv/services/remote/body/profile_body.dart';
import 'package:task_api_adv/services/remote/code_error.dart';

abstract class ImplAccountServices {
  Future<AppUserModel> getProfile();
  Future<http.Response> updateProfile(ProfileBody body);
}

class AccountServices implements ImplAccountServices {
  static final httpLog = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  @override
  Future<AppUserModel> getProfile() async {
    const url = AppConstant.endPointGetProfile;

    try {
      final response = await httpLog.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${SharedPrefs.token}',
        },
      );

      final data = BaseModel<AppUserModel>.fromJson(
        jsonDecode(response.body),
        fromJsonT: (jsonT) =>
            AppUserModel.fromJson(jsonT as Map<String, dynamic>),
      );

      if (data.success == true) {
        return data.body ?? AppUserModel();
      } else {
        throw Exception(data.message.toLang);
      }
    } on http.ClientException catch (_) {
      throw Exception();
    }
  }

  @override
  Future<http.Response> updateProfile(ProfileBody body) async {
    const url = AppConstant.endPointUpdateProfile;

    http.Response response = await httpLog.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${SharedPrefs.token}',
      },
      body: jsonEncode(body.toJson()),
    );
    return response;
  }
}

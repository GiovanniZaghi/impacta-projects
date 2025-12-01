import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import 'i_login_repository.dart';

class LoginRepository implements ILoginRepository {
  late SharedPreferences prefs;
  LoginRepository();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();

      var url = 'http://10.0.2.2:3000/users/login';
      final body = jsonEncode({"email": email, "password": password});

      var response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      var jsonData = jsonDecode(response.body);

      var res = UserModel.fromJson(jsonData['user']);

      await prefs.setInt('id', jsonData['user']['id']);
      await prefs.setString(
        'name',
        jsonData['user']['name'].toString().toLowerCase(),
      );
      await prefs.setString(
        'email',
        jsonData['user']['email'].toString().toLowerCase(),
      );

      return res;
    } catch (e) {
      log(e.toString());

      return UserModel(name: '', email: '', birthday: '');
    }
  }
}

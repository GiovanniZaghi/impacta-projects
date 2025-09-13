import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import 'i_register_repository.dart';

class RegisterRepository implements IRegisterRepository {
  late SharedPreferences prefs;
  RegisterRepository();

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String birthday,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();

      var url = 'http://10.0.2.2:3000/users/register';
      final body = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "birthday": birthday,
      });
      print("Body > ${body}");

      var response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      var jsonData = jsonDecode(response.body);
      print("Json > ${jsonData}");

      var res = UserModel.fromJson(jsonData);

      return res;
    } catch (e) {
      log(e.toString());

      return UserModel(name: '', email: '', birthday: '');
    }
  }
}

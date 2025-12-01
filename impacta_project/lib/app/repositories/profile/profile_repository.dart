import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import 'i_profile_repository.dart';

class ProfileRepository implements IProfileRepository {
  late SharedPreferences prefs;
  ProfileRepository();

  final String baseUrl = "http://10.0.2.2:3000/users";

  @override
  Future<UserModel> editProfile(
    int id,
    String? name,
    String? email,
    String? password,
  ) async {
    try {
      prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      final url = "$baseUrl/$userId";

      final body = jsonEncode({
        "name": name?.isNotEmpty == true ? name : null,
        "email": email?.isNotEmpty == true ? email : null,
        password?.isNotEmpty == true ? "password" : password: null,
      });

      final response = await http.put(
        Uri.parse(url),
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception("Erro ao atualizar perfil: ${response.body}");
      }

      final jsonData = jsonDecode(response.body);

      final res = UserModel.fromJson(jsonData);

      if (res.name.isNotEmpty) {
        await prefs.setString('name', res.name.toLowerCase());
      }
      if (res.email.isNotEmpty) {
        await prefs.setString('email', res.email.toLowerCase());
      }

      return res;
    } catch (e) {
      log("Erro em editProfile: $e");

      return UserModel(name: '', email: '', birthday: '');
    }
  }

  @override
  Future<void> removeUser(int id) async {
    try {
      prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      final url = "$baseUrl/$userId";

      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Erro ao deletar usuário: ${response.body}");
      }

      prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      log("Erro em removeUser: $e");
    }
  }
}

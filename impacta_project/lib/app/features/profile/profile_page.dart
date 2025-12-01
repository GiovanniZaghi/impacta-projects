import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:impacta_project/app/features/profile/cubit/profile_bloc_cubit.dart';
import 'package:impacta_project/app/features/profile/cubit/profile_bloc_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/messages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with Messages<ProfilePage> {
  String fullName = "";
  String email = "";
  int userId = 0;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  void getSharedPref() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      fullName = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      userId = prefs.getInt('id') ?? 0;
    });
  }

  String getInitials(String fullName) {
    if (fullName.trim().isEmpty) return "";
    List<String> parts = fullName.trim().split(" ");
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    } else {
      String first = parts.first[0].toUpperCase();
      String last = parts.last[0].toUpperCase();
      return "$first$last";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBlocCubit, ProfileBlocState>(
      listener: (context, state) {
        state.status.matchAny(
          success: () async {
            showSuccess(state.successMessage ?? "Dados apagados com sucesso !");
          },
          error: () {
            showError(state.errorMessage ?? "Erro não informado");
          },
          any: () {},
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue,
                      child: Text(
                        getInitials(fullName),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(email, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit, color: Colors.blue),
                      title: Text("Editar Perfil"),
                      onTap: () {
                        Get.toNamed(
                          "/profile_edit",
                          arguments: {"name": fullName, "email": email},
                        );
                      },
                    ),
                    Divider(),

                    ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.red),
                      title: Text("Logout"),
                      onTap: () async {
                        Get.offAllNamed('/login');
                      },
                    ),
                    Divider(),
                    SizedBox(height: 16),
                    Center(
                      child: InkWell(
                        child: Text(
                          "Apagar Conta",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        onTap: () {
                          BlocProvider.of<ProfileBlocCubit>(
                            context,
                          ).delete(id: prefs.getInt('id') ?? 0);
                          Get.offAllNamed('/login');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

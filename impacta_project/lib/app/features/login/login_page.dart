import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:impacta_project/app/features/login/cubit/login_bloc_cubit.dart';
import 'package:impacta_project/app/features/login/cubit/login_bloc_state.dart';
import 'package:impacta_project/app/features/login/widget/input_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/messages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Messages<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool lembrar = false; // <--- Checkbox

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  /// ---- Carrega login e senha gravados ----
  void _loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLogin = prefs.getString("saved_login");
    final savedPassword = prefs.getString("saved_password");
    final savedRemember = prefs.getBool("remember_login") ?? false;

    if (savedRemember && savedLogin != null && savedPassword != null) {
      setState(() {
        lembrar = true;
        loginController.text = savedLogin;
        senhaController.text = savedPassword;
      });
    }
  }

  /// ---- Tenta logar e salva se necessário ----
  void _checkApplication() async {
    if (lembrar) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("saved_login", loginController.text);
      prefs.setString("saved_password", senhaController.text);
      prefs.setBool("remember_login", true);
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("saved_login");
      prefs.remove("saved_password");
      prefs.setBool("remember_login", false);
    }

    await context.read<LoginBlocCubit>().login(
      email: loginController.text,
      password: senhaController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBlocCubit, LoginBlocState>(
      listener: (context, state) {
        state.status.matchAny(
          success: () async {
            showSuccess("Login efetuado com sucesso");
            Get.offAllNamed("/home_board");
          },
          error: () {
            showError(state.errorMessage ?? "Erro não informado");
          },
          any: () {},
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          buildInput('Login*', controller: loginController),
                          const SizedBox(height: 10),
                          buildInput(
                            'Senha*',
                            obscureText: true,
                            controller: senhaController,
                          ),

                          // ---- CHECKBOX "LEMBRAR" ----
                          Row(
                            children: [
                              Checkbox(
                                value: lembrar,
                                onChanged: (value) {
                                  setState(() {
                                    lembrar = value ?? false;
                                  });
                                },
                              ),
                              const Text("Lembrar login e senha"),
                            ],
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () async {
                                _checkApplication();
                              },
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          InkWell(
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Get.toNamed('/register');
                            },
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            "Versão • 1.0.0",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

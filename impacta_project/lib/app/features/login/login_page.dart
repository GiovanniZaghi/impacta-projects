import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:impacta_project/app/features/login/cubit/login_bloc_cubit.dart';
import 'package:impacta_project/app/features/login/cubit/login_bloc_state.dart';
import 'package:impacta_project/app/features/login/widget/input_widget.dart';

import '../../core/messages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Messages<LoginPage> {
  final TextEditingController servidorController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _checkApplication() async {
    await context.read<LoginBlocCubit>().login(
      email: loginController.text,
      password: senhaController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBlocCubit, LoginBlocState>(
      listener: (context, state) {
        // TODO: implement listener
        state.status.matchAny(
          success: () async {
            showSuccess("Login efetuado com sucesso");
            Get.offAllNamed("/home");
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          buildInput('Login*', controller: loginController),
                          SizedBox(height: 10),
                          buildInput(
                            'Senha*',
                            obscureText: true,
                            controller: senhaController,
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () async {
                                _checkApplication();
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Get.toNamed('/register');
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
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

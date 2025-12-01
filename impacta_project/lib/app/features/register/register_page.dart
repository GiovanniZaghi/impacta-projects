import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:impacta_project/app/core/messages.dart';
import 'package:impacta_project/app/features/register/cubit/register_bloc_state.dart';
import 'package:intl/intl.dart';

import '../login/widget/input_widget.dart';
import 'cubit/register_bloc_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with Messages<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  bool _isValidDate(String value) {
    try {
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);
      return date.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      await context.read<RegisterBlocCubit>().register(
        name: nameController.text,
        email: loginController.text,
        password: senhaController.text,
        birthday: dataController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBlocCubit, RegisterBlocState>(
      listener: (context, state) {
        // TODO: implement listener
        state.status.matchAny(
          success: () async {
            showSuccess("Login efetuado com sucesso");
            Get.toNamed("/home_board");
          },
          error: () {
            showError(state.errorMessage ?? "Erro não informado");
          },
          any: () {},
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Registrar")),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          buildInput(
                            "Nome Completo",
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Informe seu nome completo";
                              }
                              if (value.trim().split(" ").length < 2) {
                                return "Digite nome e sobrenome";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          buildInput(
                            'Data de nascimento',
                            controller: dataController,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Informe sua data de nascimento";
                              }
                              if (!_isValidDate(value)) {
                                return "Data inválida";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          buildInput(
                            "Email",
                            controller: loginController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Informe um e-mail";
                              }

                              if (value.length < 4) {
                                return "E-mail deve ter pelo menos 4 caracteres";
                              }

                              const pattern =
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                              final regex = RegExp(pattern);

                              if (!regex.hasMatch(value.trim())) {
                                return "E-mail inválido";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          buildInput(
                            "Senha",
                            obscureText: true,
                            controller: senhaController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Informe uma senha";
                              }
                              if (value.length < 6) {
                                return "A senha deve ter pelo menos 6 caracteres";
                              }
                              return null;
                            },
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
                              onPressed: _register,
                              child: const Text(
                                'Registrar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

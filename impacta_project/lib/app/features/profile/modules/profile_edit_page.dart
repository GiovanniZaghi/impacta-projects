import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:impacta_project/app/features/profile/cubit/profile_bloc_state.dart';

import '../../../core/messages.dart';
import '../cubit/profile_bloc_cubit.dart';

class ProfileEditPage extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final int userId;

  const ProfileEditPage({
    required this.userId,
    required this.initialEmail,
    required this.initialName,
    super.key,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage>
    with Messages<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    print("Oq tem aqui > ${widget.userId}");
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<ProfileBlocCubit>(context).updateProfile(
        id: widget.userId,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBlocCubit, ProfileBlocState>(
      listener: (context, state) {
        state.status.matchAny(
          success: () async {
            showSuccess(
              state.successMessage ?? "Dados alterados com sucesso !",
            );
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
          appBar: AppBar(
            title: Text("Editar Perfil", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Nome",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isEmpty) {
                        return "O nome não pode ser vazio";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final emailRegex = RegExp(
                          r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return "E-mail inválido";
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 6) {
                        return "A senha deve ter no mínimo 6 caracteres";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Salvar Alterações",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impacta_project/app/repositories/login/login_repository.dart';
import 'package:impacta_project/app/repositories/register/register_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_widget.dart';
import 'features/login/cubit/login_bloc_cubit.dart';
import 'features/register/cubit/register_bloc_cubit.dart';

class BlocInjection extends StatelessWidget {
  late SharedPreferences prefs;

  BlocInjection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBlocCubit>(
          create:
              (_) =>
                  RegisterBlocCubit(registerRepository: RegisterRepository()),
        ),
        BlocProvider<LoginBlocCubit>(
          create: (_) => LoginBlocCubit(loginRepository: LoginRepository()),
        ),
      ],
      child: const AppWidget(),
    );
  }
}

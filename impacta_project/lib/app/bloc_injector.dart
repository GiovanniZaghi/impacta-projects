import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impacta_project/app/features/profile/cubit/profile_bloc_cubit.dart';
import 'package:impacta_project/app/repositories/login/login_repository.dart';
import 'package:impacta_project/app/repositories/profile/profile_repository.dart';
import 'package:impacta_project/app/repositories/register/register_repository.dart';
import 'package:impacta_project/app/repositories/task/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_widget.dart';
import 'features/home/modules/tasks/cubit/task_bloc_cubit.dart';
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
        BlocProvider<ProfileBlocCubit>(
          create:
              (_) => ProfileBlocCubit(profileRepository: ProfileRepository()),
        ),
        BlocProvider<TaskBlocCubit>(
          create: (_) => TaskBlocCubit(taskRepository: TaskRepository()),
        ),
      ],
      child: const AppWidget(),
    );
  }
}

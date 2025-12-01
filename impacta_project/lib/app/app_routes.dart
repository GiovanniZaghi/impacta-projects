import 'package:get/get.dart';
import 'package:impacta_project/app/features/home/home_board_page.dart';
import 'package:impacta_project/app/features/register/register_page.dart';

import 'features/home/home_page.dart';
import 'features/login/login_page.dart';
import 'features/profile/modules/profile_edit_page.dart';

class Routes {
  static const INITIAL = "/login";
  static const REGISTER = '/register';
  static const HOME = "/home";
  static const HOME_BOARD = "/home_board";
  static const PROFILE_EDIT = "/profile_edit";
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => const LoginPage()),
    GetPage(name: Routes.REGISTER, page: () => const RegisterPage()),
    GetPage(
      name: Routes.HOME,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return HomePage(board: args?['name'] ?? [], boardId: args?['id']);
      },
    ),
    GetPage(
      name: Routes.PROFILE_EDIT,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return ProfileEditPage(
          userId: args?["id"] ?? 0,
          initialEmail: args?["email"] ?? "",
          initialName: args?["name"] ?? "",
        );
      },
    ),
    GetPage(name: Routes.HOME_BOARD, page: () => HomeBoardPage()),
  ];
}

import 'package:get/get.dart';
import 'package:impacta_project/app/features/register/register_page.dart';

import 'features/home/home_page.dart';
import 'features/login/login_page.dart';

class Routes {
  static const INITIAL = "/login";
  static const REGISTER = '/register';
  static const HOME = "/home";
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => const LoginPage()),
    GetPage(name: Routes.REGISTER, page: () => const RegisterPage()),
    GetPage(name: Routes.HOME, page: () => const HomePage()),
  ];
}

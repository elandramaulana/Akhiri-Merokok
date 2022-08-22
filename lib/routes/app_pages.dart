import 'package:akhiri_merokok/app/modules/question/form.dart';
import 'package:get/get.dart';

import 'package:akhiri_merokok/app/modules/home/home_view.dart';
import 'package:akhiri_merokok/app/modules/signin/signin_view.dart';
import 'package:akhiri_merokok/app/modules/signup/signup_view.dart';
import 'package:akhiri_merokok/app/modules/splash/splash_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SigninView(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
    ),
    GetPage(
      name: _Paths.FORM,
      page: () => FormRokok(),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:akhiri_merokok/app/modules/signin/signin_view.dart';

import '../../data/providers/auth_controller.dart';
import '../widgets/auth_btn.dart';
import '../widgets/text_input_field.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({Key? key}) : super(key: key);

  final AuthController authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(right: 32.h, left: 32.h),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 32.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Atur Ulang Kata Sandi',
                    style: Get.theme.textTheme.headline1,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email/No. Handphone',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextInputField(
                  iD: 3,
                  textEditingController: authController.emailController,
                  hintText: 'Contoh123@gmail.com/0810112344',
                  obscureText: false,
                ),
                SizedBox(
                  height: 24.h,
                ),

                AuthButton(
                  'Reset Password',
                  () async {
                    authController.sendPasswordResetEmail(context);
                  },
                ),
                SizedBox(
                  height: 24.h,
                ),
                signInLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signInLink(BuildContext context) {
    if (authController.emailController.text == '') {
      return AuthButton(
        "Masuk",
        () => Get.offAll(SigninView()),
      );
    }
    return const SizedBox(width: 0, height: 0);
  }
}

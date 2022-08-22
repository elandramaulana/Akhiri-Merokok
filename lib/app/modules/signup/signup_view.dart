import 'package:akhiri_merokok/app/modules/home/navbar.dart';
import 'package:akhiri_merokok/app/modules/question/question1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:akhiri_merokok/app/modules/widgets/text_input_field.dart';

import '../../data/providers/auth_controller.dart';
import '../signin/signin_view.dart';
import '../widgets/auth_btn.dart';

class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);

  final AuthController authController = AuthController.to;
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(right: 32.h, left: 32.h),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 32.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daftar',
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Kata Sandi',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextInputField(
                  textEditingController: authController.passwordController,
                  hintText: 'Masukkan Password',
                  iD: 4,
                  obscureText: true,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Konfirmasi Kata Sandi',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextInputField(
                  textEditingController: confirmPasswordController,
                  hintText: 'Konfirmasi Password',
                  iD: 4,
                  obscureText: true,
                  // icon: Icons.visibility,
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  height: 48.h,
                ),
                AuthButton(
                  'Daftar',
                  () async {
                    authController.registerWithEmailAndPassword(context);
                    // if (confirmPasswordController ==
                    //     authController.passwordController) {
                    //   SystemChannels.textInput.invokeMethod(
                    //       'TextInput.hide'); //to hide the keyboard - if any
                    // }
                    // Get.offAll(Navbar());
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'Atau daftar dengan',
                  style: Get.theme.textTheme.headline5,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 64.h,
                      width: 140.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffE1E1E1), width: 1.h),
                          borderRadius: BorderRadius.circular(10.h)),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(64.h),
                            primary: Colors.transparent),
                        onPressed: () {},
                        child: Image.asset(
                          'assets/images/google.png',
                          height: 24.h,
                          width: 24.h,
                        ),
                      ),
                    ),
                    Container(
                      height: 64.h,
                      width: 140.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffE1E1E1), width: 1.h),
                          borderRadius: BorderRadius.circular(10.h)),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(64.h),
                            primary: Colors.transparent),
                        onPressed: () {},
                        child: Image.asset(
                          'assets/images/profile.png',
                          height: 24.h,
                          width: 24.h,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 48.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sudah punya akun?  ',
                          textAlign: TextAlign.left,
                          style: Get.theme.textTheme.headline5),
                      GestureDetector(
                        onTap: () => Get.to(SigninView()),
                        // => Get.to(const SigninView(),
                        child: Text(
                          'Masuk',
                          style: Get.theme.textTheme.headline3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

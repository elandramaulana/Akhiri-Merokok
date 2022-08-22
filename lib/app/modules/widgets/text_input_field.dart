import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:akhiri_merokok/core/values/strings_enum.dart' as globals;

class TextInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final int iD;
  final String hintText;
  final bool obscureText;

  const TextInputField({
    Key? key,
    required this.textEditingController,
    required this.iD,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late String inputEmail;
  late String inputPassword;
  bool _passMode = true;
  bool _obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _passMode = widget.obscureText;
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (!_passMode) {
          switch (widget.iD) {
            case 1:
              globals.inputFullName = value;
              break;
            case 2:
              globals.inputPhoneNo = value;
              break;
            case 3:
              globals.inputEmail = value;
              break;
          }
        } else {
          switch (widget.iD) {
            case 4:
              globals.inputPassword = value;
              break;
            case 5:
              globals.inputConfirmPassword = value;
              break;
          }
        }
      },
      obscureText: _obscureText,
      // obscuringCharacter: '●',
      style: Get.theme.inputDecorationTheme.labelStyle,
      textAlign: TextAlign.left,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        suffixIconColor: Get.theme.inputDecorationTheme.suffixIconColor,
        suffixIcon: Padding(
            padding: EdgeInsetsDirectional.only(end: 16.h),
            child: _passMode
                ? (_obscureText
                    ? IconButton(
                        icon: const Icon(
                          Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = false;
                          });
                        })
                    : IconButton(
                        icon: const Icon(
                          Icons.visibility,
                        ),
                        onPressed: () {
                          if (true) {
                            setState(() {
                              _obscureText = true;
                            });
                          }
                        }))
                : null),
        hintText: widget.hintText,
        hintStyle: Get.theme.inputDecorationTheme.hintStyle,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

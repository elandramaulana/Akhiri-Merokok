import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthButton extends StatelessWidget {
  final String _btnText;
  final void Function() onPressed;

  const   AuthButton(this._btnText, this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Get.theme.elevatedButtonTheme.style,
      onPressed: onPressed,
      child: Text(
        _btnText,
      )
    );
  }
}

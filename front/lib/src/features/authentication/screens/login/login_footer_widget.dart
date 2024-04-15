import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../signup/signup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: formHeight - 20),
        TextButton(
          onPressed: () => Get.to(() => SignUpScreen()),
          child: Text.rich(
            TextSpan(
                text: dontHaveAnAccount,
                style: Theme.of(context).textTheme.bodyText1,
                children: const [
                  TextSpan(
                      text: signUp,
                      style: TextStyle(color: Colors.blue)
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
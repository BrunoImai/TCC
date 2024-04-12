import 'package:flutter/material.dart';
import 'package:tcc_front/src/constants/text_strings.dart';
import 'package:tcc_front/src/features/authentication/screens/signup/signup_footer_widget.dart';
import 'package:tcc_front/src/features/authentication/screens/signup/signup_form_widget.dart';

import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../commom_widgets/authentication_appbar.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const WelcomeAppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: welcomeImage,
                  title: signUpTitle,
                  subTitle: signUpSubTitle,
                  imageHeight: 0.15,
                ),
                SignUpFormWidget(),
                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
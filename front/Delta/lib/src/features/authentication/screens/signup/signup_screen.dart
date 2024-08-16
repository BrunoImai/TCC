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
          child: LayoutBuilder(
            builder: (context, constraints) {
              double elementWidth;
              if (constraints.maxWidth < 800) {
                elementWidth = double.infinity;
              } else {
                elementWidth = constraints.maxWidth * 0.3;
              }

              return Container(
                padding: const EdgeInsets.all(defaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: elementWidth,
                        child: const FormHeaderWidget(
                          image: welcomeImage,
                          title: signUpTitle,
                          subTitle: signUpSubTitle,
                          imageHeight: 0.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: elementWidth,
                        child: const SignUpFormWidget(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: elementWidth,
                        child: const SignUpFooterWidget(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
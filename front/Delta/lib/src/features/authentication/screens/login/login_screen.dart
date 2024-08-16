import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';
import '../../../../commom_widgets/authentication_appbar.dart';
import 'login_footer_widget.dart';
import 'login_form_widget.dart';
import 'login_header_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.whoAreYouTag});

  final num whoAreYouTag;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: const WelcomeAppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double elementWidth;
                if (constraints.maxWidth < 800) {
                  elementWidth = double.infinity;
                } else {
                  elementWidth = constraints.maxWidth * 0.3;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: elementWidth,
                        child: LoginHeaderWidget(size: Size(constraints.maxWidth, constraints.maxHeight)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: elementWidth,
                        child: LoginForm(whoAreYouTag: widget.whoAreYouTag),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: elementWidth,
                        child: const LoginFooterWidget(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
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

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: const WelcomeAppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeaderWidget(size: size),
                LoginForm(whoAreYouTag: widget.whoAreYouTag,),
                const LoginFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
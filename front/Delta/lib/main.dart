import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_front/src/features/authentication/screens/slapsh_screen/slapsh_screen.dart';
import 'package:tcc_front/src/features/authentication/screens/welcome/who_are_you_screen.dart';
import 'package:tcc_front/src/utils/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeApp.lightTheme,
      darkTheme: ThemeApp.darkTheme,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home: const WhoAreYouScreen(),
    );
  }
}


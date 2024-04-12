import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/features/authentication/screens/forget_password/update_password_screen.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../../commom_widgets/authentication_appbar.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WelcomeAppBar(),
      body: Container(
        padding: const EdgeInsets.all(defaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              otpTitle,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0),
            ),
            Text(otpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 40.0),
            const Text("$otpMessage support.age@gmail.com", textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            OtpTextField(
                mainAxisAlignment: MainAxisAlignment.center,
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                onSubmit: (code) => print("OTP is => $code")),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                      Get.to(() => const UpdatePasswordScreen());
                  },
                  child: Text(next.toUpperCase())),
            ),
          ],
        ),
      ),
    );
  }
}
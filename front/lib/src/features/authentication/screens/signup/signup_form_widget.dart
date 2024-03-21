import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(companyName),
                  prefixIcon: Icon(Icons.person_outline_rounded)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(email), prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(phoneNo), prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  label: Text(password), prefixIcon: Icon(Icons.fingerprint)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  label: Text(confirmPassword), prefixIcon: Icon(Icons.fingerprint)),
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(signUp.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
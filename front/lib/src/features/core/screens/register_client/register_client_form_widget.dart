import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class RegisterClientFormWidget extends StatelessWidget {
  const RegisterClientFormWidget({
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
                  label: Text(fullName),
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
                  label: Text(cpf), prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(phoneNo), prefixIcon: Icon(Icons.phone_android)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(cep), prefixIcon: Icon(Icons.local_post_office)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(address), prefixIcon: Icon(Icons.location_on)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(number), prefixIcon: Icon(Icons.numbers)),
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
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/src/constants/text_strings.dart';
import 'package:tcc_front/src/features/core/screens/category/category.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/central_home_screen.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/sizes.dart';
import '../../../authentication/screens/signup/central_manager.dart';


class RegisterCategoryFormWidget extends StatefulWidget {
  const RegisterCategoryFormWidget({
    super.key, required this.whoAreYouTag
  });

  final num whoAreYouTag;

  @override
  _RegisterCategoryFormWidget createState() => _RegisterCategoryFormWidget();

}

class _RegisterCategoryFormWidget extends State<RegisterCategoryFormWidget> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> registerCategory(VoidCallback onSuccess) async {
      String name = nameController.text;


      if (name.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O campo nome é obrigatório.');
          },
        );
        return;
      }

      if (name.length == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O nome deve conter mais que um carácter');
          },
        );
        return;
      }

      CategoryRequest categoryRequest = CategoryRequest(name: name);

      String requestBody = jsonEncode(categoryRequest.toJson());
      print(requestBody);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/category'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
          body: utf8.encode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Registration successful!');
        }  else {
          // Registration failed
          print('Failed. Status code: ${response.statusCode}');

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertPopUp(
                    errorDescription: response.body);
              });
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  label: Text(tName),
                  prefixIcon: Icon(Icons.category_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  registerCategory(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CentralHomeScreen(whoAreYouTag: widget.whoAreYouTag,)));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cadastro Realizado')),
                    );
                  });
                },
                child: Text(tSignUp.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
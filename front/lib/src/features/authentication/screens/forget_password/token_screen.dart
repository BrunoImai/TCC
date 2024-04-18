import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/src/features/authentication/screens/forget_password/update_password_screen.dart';
import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../../commom_widgets/authentication_appbar.dart';

class TokenScreen extends StatefulWidget {
  const TokenScreen({super.key, required this.emailSend,});
  final String emailSend;

  @override
  _TokenScreenState createState() => _TokenScreenState();

}

class _TokenScreenState extends State<TokenScreen>{
  final TextEditingController codeController = TextEditingController();
  final _codeFormKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    Future<void> validateToken(VoidCallback onSuccess) async {
      String code = codeController.text;

      if (code.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'É necessário fornecer o código enviado para o email cadastrado');
          },
        );
        return;
      }

      if (code.length != 6) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O código deve possuir 6 caracteres.');
          },
        );
        return;
      }

      print(code);
      print(widget.emailSend);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/login/validateToken?email=${widget.emailSend}&code=$code'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print("Token validated");
        } else {
          print('Token failed. Status code: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any error that occurred during the HTTP request
        print('Error occurred: $e');
      }
    }

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
            const Text("$otpMessage equipe.a.g.e.oficial@gmail.com", textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            Form(
              key: _codeFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                        label: Text(code),
                        hintText: code,
                        prefixIcon: Icon(Icons.numbers)),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            String code = codeController.text;
                            if (_codeFormKey.currentState!.validate()) {
                              validateToken(() {
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UpdatePasswordScreen(code: code)),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Token validado com sucesso!')),
                                );
                              });
                            }
                          },
                          child: Text(next.toUpperCase()))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
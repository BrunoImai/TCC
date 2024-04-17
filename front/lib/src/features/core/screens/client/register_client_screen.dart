import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/client/register_client_form_widget.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/widgets/company_app_bar.dart';

import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/text_strings.dart';

class RegisterClientScreen extends StatelessWidget{
  const RegisterClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: const Column(
            children: [
              FormHeaderWidget(
                crossAxisAlignment: CrossAxisAlignment.center,
                image: welcomeImage,
                title: registerClientTilte,
                subTitle: registerClientSubTitle,
                imageHeight: 0.15,
              ),
              RegisterClientFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}






import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/home_screen_company/widgets/company_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/assistance/register_assistance_form_widget.dart';

import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/text_strings.dart';

class RegisterAssistanceScreen extends StatelessWidget{
  const RegisterAssistanceScreen({Key? key}) : super(key: key);

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
                title: registerAssistanceTitle,
                subTitle: registerAssistanceSubTitle,
                imageHeight: 0.15,
              ),
              RegisterAssistanceFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}






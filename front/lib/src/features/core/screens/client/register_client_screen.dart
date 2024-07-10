import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/client/register_client_form_widget.dart';

import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/text_strings.dart';
import '../central_home_screen/widgets/central_app_bar.dart';

class RegisterClientScreen extends StatelessWidget{
  const RegisterClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CentralAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: const Column(
            children: [
              FormHeaderWidget(
                crossAxisAlignment: CrossAxisAlignment.center,
                image: welcomeImage,
                title: registerClientTitle,
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






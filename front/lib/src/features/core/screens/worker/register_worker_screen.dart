import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/company_home_screen/widgets/company_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/worker/register_worker_form_widget.dart';

import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/text_strings.dart';

class RegisterWorkerScreen extends StatelessWidget{
  const RegisterWorkerScreen({Key? key}) : super(key: key);

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
                title: registerWorkerTilte,
                subTitle: registerWorkerSubTitle,
                imageHeight: 0.15,
              ),
              RegisterWorkerFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}






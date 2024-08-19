import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/features/core/screens/category/register_category_form_widget.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_app_bar.dart';
import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class RegisterCategoryScreen extends StatelessWidget{
  const RegisterCategoryScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CentralAppBar(),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double elementWidth;
            if (constraints.maxWidth < 800) {
              elementWidth = double.infinity;
            } else {
              elementWidth = constraints.maxWidth * 0.3;
            }

            return Container(
              padding: const EdgeInsets.all(defaultSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: elementWidth,
                      child: const FormHeaderWidget(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        image: welcomeImage,
                        title: tRegisterCategoryTitle,
                        subTitle: tRegisterCategorySubTitle,
                        imageHeight: 0.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: elementWidth,
                      child: const RegisterCategoryFormWidget(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}






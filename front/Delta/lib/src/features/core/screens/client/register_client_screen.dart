import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/client/register_client_form_widget.dart';

import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/text_strings.dart';
import '../central_home_screen/widgets/central_app_bar.dart';
import '../central_home_screen/widgets/central_drawer_menu.dart';

class RegisterClientScreen extends StatelessWidget{
  const RegisterClientScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CentralAppBar(whoAreYouTag: whoAreYouTag,),
      drawer: CentralDrawerMenu(whoAreYouTag: whoAreYouTag),
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
                    child: Container(
                      width: elementWidth,
                      child: const FormHeaderWidget(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        image: welcomeImage,
                        title: tRegisterClientTitle,
                        subTitle: tRegisterClientSubTitle,
                        imageHeight: 0.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: elementWidth,
                      child: RegisterClientFormWidget(whoAreYouTag: whoAreYouTag,),
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






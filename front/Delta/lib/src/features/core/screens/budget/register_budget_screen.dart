import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/features/core/screens/budget/register_budget_form_widget.dart';
import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../central_home_screen/widgets/central_app_bar.dart';
import '../central_home_screen/widgets/central_drawer_menu.dart';
import '../report/register_report_form_widget.dart';
import '../worker_home_screen/widgets/worker_app_bar.dart';

class RegisterBudgetScreen extends StatelessWidget{
  const RegisterBudgetScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;


  @override
  Widget build(BuildContext context) {

    PreferredSizeWidget appBar;
    if (whoAreYouTag == 2) {
      appBar = CentralAppBar(whoAreYouTag: whoAreYouTag);
    } else {
      appBar = WorkerAppBar(whoAreYouTag: whoAreYouTag);
    }

    final drawer = whoAreYouTag == 2
        ? CentralDrawerMenu(whoAreYouTag: whoAreYouTag)
        : CentralDrawerMenu(whoAreYouTag: whoAreYouTag); //WorkerDrawerMenu(whoAreYouTag: whoAreYouTag);

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
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
                        title: tRegisterBudgetTitle,
                        subTitle: tRegisterBudgetSubTitle,
                        imageHeight: 0.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: elementWidth,
                      child: RegisterBudgetFormWidget(whoAreYouTag: whoAreYouTag),
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






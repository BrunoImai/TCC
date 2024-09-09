import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/features/core/screens/budget/register_budget_form_widget.dart';
import 'package:tcc_front/src/features/core/screens/report/register_report_form_widget.dart';
import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../central_home_screen/widgets/central_app_bar.dart';
import '../worker_home_screen/widgets/worker_app_bar.dart';

class RegisterReportScreen extends StatelessWidget{
  const RegisterReportScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar;
    if (whoAreYouTag == 2) {
      appBar = CentralAppBar(whoAreYouTag: whoAreYouTag);
    } else {
      appBar = WorkerAppBar(whoAreYouTag: whoAreYouTag);
    }

    return Scaffold(
      appBar: appBar,
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
                        title: tRegisterReportTitle,
                        subTitle: tRegisterReportSubTitle,
                        imageHeight: 0.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: elementWidth,
                      child: RegisterReportFormWidget(whoAreYouTag: whoAreYouTag),
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






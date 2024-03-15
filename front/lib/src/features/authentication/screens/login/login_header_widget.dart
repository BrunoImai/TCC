import 'package:flutter/material.dart';

import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    Key? key,
    required Size size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormHeaderWidget(
          image: tWelcomeImage,
          title: tLoginTitle,
          subTitle: tLoginSubTitle,
          imageHeight: 0.2,
        ),
      ],
    );
  }
}

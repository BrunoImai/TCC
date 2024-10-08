import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcc_front/src/constants/colors.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({Key? key, required this.title, required this.icon, required this.tap}) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tap,
      horizontalTitleGap: 0.03,
      leading: Icon(
        icon,
        color: primaryColor,
        size: 20,
      ),
      title: Text(title,style: Theme.of(context).textTheme.bodyText2),
    );
  }
}

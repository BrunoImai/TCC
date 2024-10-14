import 'package:flutter/material.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/view_line_chart.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';

class Viewers extends StatelessWidget {
  const Viewers({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(homePadding),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Viewers',
            style: TextStyle(
              color: darkColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: ViewLineChart(),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/revenue_line_chart.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';

class Revenue extends StatelessWidget {
  const Revenue({super.key});

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
            'Receita',
            style: TextStyle(
              color: darkColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: RevenueLineChart(),
          )
        ],
      ),
    );
  }
}

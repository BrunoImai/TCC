import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/constants/colors.dart';

import '../../../../../../constants/sizes.dart';
import 'bar_chart_assistances.dart';


class AssistancesChart extends StatelessWidget {
  const AssistancesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.all(homePadding),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Assistências",
            style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: darkColor
            ),
          ),
          const Expanded(
            child: BarChartAssistances(),
          )
        ],
      ),
    );
  }
}

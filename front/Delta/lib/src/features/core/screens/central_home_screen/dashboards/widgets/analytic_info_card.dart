import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../models/analytic_info_model.dart';


class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({super.key, required this.info});

  final AnalyticInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: homePadding,
        vertical: homePadding / 2,
      ),
      decoration: BoxDecoration(
          color: cardBgColor, borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${info.count}",
                style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w200,
                    color: darkColor
                ),
              ),
              Container(
                padding: const EdgeInsets.all(homePadding / 2),
                height: 50,
                width: 40,
                decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    shape: BoxShape.circle
                ),
                child: Icon(
                  info.icon!,
                  color: info.color,
                ),
              )
            ],
          ),
          Text(
            info.title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                fontSize: 14.0,
                fontWeight: FontWeight.w200,
                color: darkColor
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/constants/colors.dart';

import '../../../../../../constants/sizes.dart';
import '../models/discussions_info_model.dart';


class DiscussionInfoDetail extends StatelessWidget {
  const DiscussionInfoDetail({Key? key, required this.info}) : super(key: key);

  final DiscussionInfoModel info;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: homePadding),
      padding: const EdgeInsets.all(homePadding / 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Icon(
              info.icon!,
              size: 38,
              color: primaryColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: homePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.name!,
                    style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: darkColor
                    ),
                  ),

                  Text(
                    info.date!,
                    style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        color: darkColor.withOpacity(0.5)
                    ),
                  ),
                ],
              ),
            ),
          ),
          Icon(Icons.more_vert_rounded,color: primaryColor.withOpacity(0.5),size: 18,)
        ],
      ),
    );
  }
}

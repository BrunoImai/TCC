import 'package:flutter/material.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/radial_painter.dart';
import '../../../../../../constants/sizes.dart';

class UsersByDevice extends StatelessWidget {
  const UsersByDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: homePadding),
      child: Container(
        height: 351,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(homePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Users by device',
              style: TextStyle(
                color: darkColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(homePadding),
              padding: const EdgeInsets.all(homePadding),
              height: 230,
              child: CustomPaint(
                foregroundPainter: RadialPainter(
                  bgColor: darkColor.withOpacity(0.1),
                  lineColor: primaryColor,
                  percent: 0.7,
                  width: 18.0,
                ),
                child: const Center(
                  child: Text(
                    '70%',
                    style: TextStyle(
                      color: darkColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: homePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: primaryColor,
                        size: 10,
                      ),
                      const SizedBox(width: homePadding /2,),
                      Text('Desktop',style: TextStyle(
                        color: darkColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: darkColor.withOpacity(0.2),
                        size: 10,
                      ),
                      const SizedBox(width: homePadding /2,),
                      Text('Mobile',style: TextStyle(
                        color: darkColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

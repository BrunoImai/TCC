import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../constants/colors.dart';

class BarChartUsers extends StatelessWidget {
  const BarChartUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(
          border: Border.all(width: 0),
        ),
        groupsSpace: 15,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final style = GoogleFonts.poppins(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    color: darkColor
                );
                String text;
                switch (value.toInt()) {
                  case 2:
                    text = 'jan 6';
                    break;
                  case 4:
                    text = 'jan 8';
                    break;
                  case 6:
                    text = 'jan 10';
                    break;
                  case 8:
                    text = 'jan 12';
                    break;
                  case 10:
                    text = 'jan 14';
                    break;
                  case 12:
                    text = 'jan 16';
                    break;
                  case 14:
                    text = 'jan 18';
                    break;
                  default:
                    return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8.0,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: darkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                String text;
                switch (value.toInt()) {
                  case 2:
                    text = '1K';
                    break;
                  case 6:
                    text = '2K';
                    break;
                  case 10:
                    text = '3K';
                    break;
                  case 14:
                    text = '4K';
                    break;
                  default:
                    return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
        ),
          barGroups: [
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(
                  toY: 10,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(
                  toY: 3,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(
                toY: 12,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              )
            ]),
            BarChartGroupData(x: 4, barRods: [
              BarChartRodData(
                  toY: 8,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 5, barRods: [
              BarChartRodData(
                  toY: 6,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 6, barRods: [
              BarChartRodData(
                  toY: 10,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 7, barRods: [
              BarChartRodData(
                  toY: 16,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 8, barRods: [
              BarChartRodData(
                  toY: 6,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 9, barRods: [
              BarChartRodData(
                  toY: 4,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 10, barRods: [
              BarChartRodData(
                  toY: 9,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 11, barRods: [
              BarChartRodData(
                  toY: 12,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 12, barRods: [
              BarChartRodData(
                  toY: 2,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 13, barRods: [
              BarChartRodData(
                  toY: 13,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
            BarChartGroupData(x: 14, barRods: [
              BarChartRodData(
                  toY: 15,
                  width: 20,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5)
              )
            ]),
          ]
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiscal_noir/core/theme/app_colors.dart';
import 'package:fiscal_noir/models/transaction_model.dart';

class TacticalRadarChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TacticalRadarChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // 1. Prepare Data for Radar
    final categories = [
      'Alimentação',
      'Transporte',
      'Lazer',
      'Despesas',
      'Outros'
    ];
    final Map<String, double> totals = {};
    double maxVal = 0;

    for (var c in categories) {
      totals[c] = 0;
    }

    for (var t in transactions) {
      // Simple normalization or mapping
      String key = 'Outros';
      for (var c in categories) {
        if (t.category.toLowerCase().contains(c.toLowerCase())) {
          key = c;
          break;
        }
      }
      totals[key] = (totals[key] ?? 0) + t.value;
    }

    // Find max for normalization (optional, depending on chart logic)
    for (var val in totals.values) {
      if (val > maxVal) maxVal = val;
    }
    if (maxVal == 0) maxVal = 1; // Avoid div by zero

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "RADAR TÁTICO",
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color: AppColors.primary.withOpacity(0.8),
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.radar,
                  color: AppColors.primary.withOpacity(0.5), size: 16),
            ],
          ),
        ),
        const Gap(24),
        SizedBox(
          height: 250,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              dataSets: [
                RadarDataSet(
                  fillColor: AppColors.primary.withOpacity(0.2),
                  borderColor: AppColors.primary,
                  entryRadius: 3,
                  dataEntries: categories.map((c) {
                    final val = totals[c] ?? 0;
                    return RadarEntry(value: val);
                  }).toList(),
                  borderWidth: 2,
                ),
              ],
              radarBackgroundColor: Colors.transparent,
              borderData: FlBorderData(show: false),
              radarBorderData:
                  const BorderSide(color: Colors.white12, width: 1),
              titlePositionPercentageOffset: 0.2,
              titleTextStyle: GoogleFonts.spaceMono(
                color: Colors.white54,
                fontSize: 10,
              ),
              getTitle: (index, angle) {
                if (index >= categories.length)
                  return const RadarChartTitle(text: '');
                return RadarChartTitle(text: categories[index]);
              },
              tickCount: 3,
              ticksTextStyle: const TextStyle(color: Colors.transparent),
              tickBorderData: const BorderSide(color: Colors.white10, width: 1),
              gridBorderData: const BorderSide(color: Colors.white10, width: 1),
            ),
            swapAnimationDuration: const Duration(milliseconds: 1000),
            swapAnimationCurve: Curves.linearToEaseOut,
          ),
        ),
      ],
    );
  }
}

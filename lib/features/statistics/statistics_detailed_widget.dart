import 'package:connect_four/features/core/ui/theme.dart';
import 'package:connect_four/features/statistics/statistics_model.dart';
import 'package:flutter/material.dart';
import '../core/logger.dart';

class StatsDetailedWidget extends StatelessWidget {
  final StatisticsLocal stats;

  const StatsDetailedWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    logger.info(
      "stats widget - ${stats.totalGames}, ${stats.winsPlayer1}, ${stats.winsPlayer2}, ${stats.draws}",
    );
    final double winRatePlayer1 = stats.totalGames > 0
        ? (stats.winsPlayer1 / stats.totalGames * 100)
        : 0;
    final double winRatePlayer2 = stats.totalGames > 0
        ? (stats.winsPlayer2 / stats.totalGames * 100)
        : 0;
    final double drawRate = stats.totalGames > 0
        ? (stats.draws / stats.totalGames * 100)
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildStatRow('Всего игр', stats.totalGames.toString()),

        _buildStatRowWithPercentage(
          'Всего игр',
          stats.totalGames.toString(),
          100.toDouble(),
          lightTheme.dividerColor,
        ),
        // const Divider(),
        _buildStatRowWithPercentage(
          'Победы Игрока 1',
          stats.winsPlayer1.toString(),
          winRatePlayer1,
          lightTheme.dividerColor,
        ),
        // const Divider(),
        _buildStatRowWithPercentage(
          'Победы Игрока 2',
          stats.winsPlayer2.toString(),
          winRatePlayer2,
          lightTheme.dividerColor,
        ),
        // const Divider(),
        _buildStatRowWithPercentage(
          'Ничьи',
          stats.draws.toString(),
          drawRate,
          lightTheme.dividerColor,
        ),
      ],
    );
  }

  // Widget _buildStatRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 12),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(label),
  //         Text(
  //           value,
  //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStatRowWithPercentage(
    String label,
    String value,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                '$value (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Color.fromARGB(70, 77, 84, 81),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}

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

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статистика игр',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Всего игр', stats.totalGames.toString()),
            const Divider(),
            _buildStatRowWithPercentage(
              'Победы Игрока 1',
              stats.winsPlayer1.toString(),
              winRatePlayer1,
              Colors.green,
            ),
            const Divider(),
            _buildStatRowWithPercentage(
              'Победы Игрока 2',
              stats.winsPlayer2.toString(),
              winRatePlayer2,
              Colors.blue,
            ),
            const Divider(),
            _buildStatRowWithPercentage(
              'Ничьи',
              stats.draws.toString(),
              drawRate,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRowWithPercentage(
    String label,
    String value,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}

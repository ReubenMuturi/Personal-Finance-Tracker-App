import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';

class SummaryChart extends StatelessWidget {
  final List<Transaction> transactions;

  const SummaryChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expenses = transactions.where((t) => !t.isIncome).toList();
    final Map<String, double> categoryTotal = {};
    for (var t in expenses) {
      categoryTotal[t.category] = (categoryTotal[t.category] ?? 0) + t.amount;
    }

    final pieSections = categoryTotal.entries.map((e) {
      return PieChartSectionData(
        value: e.value,
        title: '${e.key}\n\$${e.value.toStringAsFixed(0)}',
        color: Colors.primaries[categoryTotal.keys.toList().indexOf(e.key) % Colors.primaries.length],
        radius: 60,
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: pieSections.isEmpty
          ? const Center(child: Text('No expenses yet'))
          : PieChart(PieChartData(sections: pieSections)),
    );
  }
}
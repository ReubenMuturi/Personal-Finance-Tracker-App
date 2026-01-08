import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../widgets/summary_chart.dart';
import '../widgets/transaction_list_item.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Finance Tracker')),
      body: transactionsAsync.when(
        data: (transactions) => Column(
          children: [
            SummaryChart(transactions: transactions),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (_, i) => TransactionListItem(transaction: transactions[i]),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
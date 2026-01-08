import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_provider.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  String _category = 'Food';
  bool _isIncome = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Title'), onChanged: (v) => _title = v),
              TextFormField(decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number, onChanged: (v) => _amount = double.tryParse(v) ?? 0),
              DropdownButtonFormField<String>(
                value: _category,
                items: ['Food', 'Transport', 'Salary', 'Entertainment'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => _category = v!,
              ),
              SwitchListTile(title: const Text('Income?'), value: _isIncome, onChanged: (v) => setState(() => _isIncome = v)),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final transaction = Transaction(
                      id: const Uuid().v4(),
                      title: _title,
                      amount: _amount,
                      date: DateTime.now(),
                      category: _category,
                      isIncome: _isIncome,
                    );
                    ref.read(transactionNotifierProvider.notifier).add(transaction);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
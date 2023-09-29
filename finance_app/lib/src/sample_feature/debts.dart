import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays detailed information about a SampleItem.
class DebtsView extends StatefulWidget {
  const DebtsView({Key? key}) : super(key: key);

  static const routeName = '/debts';

  @override
  _DebtsViewState createState() => _DebtsViewState();
}

class _DebtsViewState extends State<DebtsView> {
  final List<Debt> _debts = [];
  double totalDebt = 0.0;

  final _nameController = TextEditingController();
  final _monthlyLoanAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Debt Name',
            ),
          ),
          TextFormField(
            controller: _monthlyLoanAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monthly Loan Amount',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final name = _nameController.text;
                final monthlyLoanAmount =
                    double.tryParse(_monthlyLoanAmountController.text) ?? 0.0;
                _debts.add(
                    Debt(name: name, monthlyLoanAmount: monthlyLoanAmount));
                totalDebt += monthlyLoanAmount;
                debugPrint("Total Debt: $totalDebt");
                _nameController.clear();
                _monthlyLoanAmountController.clear();
              });
            },
            child: const Text('Add Debt'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _debts.length,
              itemBuilder: (context, index) {
                final debt = _debts[index];
                return ListTile(
                  title: Text(debt.name),
                  subtitle: Text(
                    NumberFormat.simpleCurrency().format(
                      debt.monthlyLoanAmount,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Debt {
  final String name;
  final double monthlyLoanAmount;

  Debt({
    required this.name,
    required this.monthlyLoanAmount,
  });
}

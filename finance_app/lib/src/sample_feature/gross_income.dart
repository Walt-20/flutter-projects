import 'package:flutter/material.dart';

class GrossIncomeView extends StatefulWidget {
  const GrossIncomeView({super.key});

  static const routeName = '/gross_income';

  @override
  _GrossIncomeViewState createState() => _GrossIncomeViewState();
}

class _GrossIncomeViewState extends State<GrossIncomeView> {
  final List<Income> _incomes = [];
  double totalIncome = 0.0;

  final _nameController = TextEditingController();
  final _monthlyIncomeAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gross Income'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Income Name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _monthlyIncomeAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monthly Income Amount',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final name = _nameController.text;
                final monthlyIncomeAmount =
                    double.tryParse(_monthlyIncomeAmountController.text) ?? 0.0;
                _incomes.add(Income(
                    name: name, monthlyIncomeAmount: monthlyIncomeAmount));
                totalIncome += monthlyIncomeAmount;
                debugPrint("Total Income: $totalIncome");
                _nameController.clear();
                _monthlyIncomeAmountController.clear();
              });
            },
            child: const Text("Add Income"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _incomes.length,
              itemBuilder: (context, index) {
                final income = _incomes[index];
                return ListTile(
                  title: Text(income.name),
                  subtitle: Text(income.monthlyIncomeAmount.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Income {
  final String name;
  final double monthlyIncomeAmount;

  Income({required this.name, required this.monthlyIncomeAmount});
}

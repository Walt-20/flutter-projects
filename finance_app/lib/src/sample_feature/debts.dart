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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _debts.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _debts.length) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _debts.add(Debt());
                      });
                    },
                    child: const Text('Add Debt'),
                  );
                } else {
                  return _debts[index];
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Debt extends StatefulWidget {
  const Debt({Key? key}) : super(key: key);

  @override
  _DebtState createState() => _DebtState();
}

class _DebtState extends State<Debt> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _debtController = TextEditingController();
  static const _locale = 'en';
  String _formatNumber(String value) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(value));

  @override
  void dispose() {
    _nameController.dispose();
    _debtController.dispose();
    super.dispose();
  }

  double get totalDebt {
    return double.tryParse(_debtController.text.replaceAll(',', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Debt Name:'),
          TextFormField(
            controller: _nameController,
          ),
          const SizedBox(height: 8),
          const Text('Monthly Debt Amount:'),
          TextFormField(
            controller: _debtController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(),
            onChanged: (value) {
              value = _formatNumber(value.replaceAll(",", ''));
              _debtController.value = TextEditingValue(
                text: value,
                selection: TextSelection.collapsed(offset: value.length),
              );
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

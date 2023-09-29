import 'package:flutter/material.dart';

class GrossIncomeView extends StatelessWidget {
  const GrossIncomeView({super.key});

  static const routeName = '/gross_income';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}

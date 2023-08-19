import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Mortgage Calculator'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/mortgage_calculator');
              },
            ),
            ListTile(
              title: const Text('Gross Monthly Income'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/gross_yearly_income');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Consumer<SharedData>(
          builder: (context, sharedData, child) {
            double monthlyMortgage = sharedData.monthlyMortgage;
            double grossIncome = sharedData.grossIncome;
            double monthlyGrossIncome = grossIncome / 12;
            double debtToIncome = 0.0;

            if (monthlyMortgage != 0.0 && monthlyGrossIncome != 0.0) {
              debtToIncome = monthlyMortgage /
                  monthlyGrossIncome *
                  100; // Calculate debt-to-income ratio
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Monthly Mortgage: \$${monthlyMortgage.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  'Gross Monthly Income: \$${monthlyGrossIncome.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  'Debt to Income: ${debtToIncome.toStringAsFixed(2)}%',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

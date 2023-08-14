import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/mortgage_calculator.dart';
import 'screens/gross_yearly_income.dart';
import 'shared_data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/mortgage_calculator': (context) => const MortgageCalculator(),
        '/gross_yearly_income': (context) => const GrossYearlyIncome(),
      },
    );
  }
}

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
              title: const Text('Gross Yearly Income'),
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
            debugPrint("getting monthly mortgage $monthlyMortgage");
            debugPrint("getting gross income $grossIncome");
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Monthly Mortgage: \$${monthlyMortgage.toStringAsFixed(2)}'),
                Text('Gross Income: \$${grossIncome.toStringAsFixed(2)}'),
              ],
            );
          },
        ),
      ),
    );
  }
}

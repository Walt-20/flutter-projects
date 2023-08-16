import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
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

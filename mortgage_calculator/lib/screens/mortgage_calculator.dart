import 'dart:math';

import 'package:flutter/material.dart';
import '/auth/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MortgageCalculator extends StatefulWidget {
  const MortgageCalculator({super.key});
  @override
  MortgageCalculatorState createState() => MortgageCalculatorState();
}

class MortgageCalculatorState extends State<MortgageCalculator> {
  double rate30 = 0.0;
  double rate15 = 0.0;
  String? selectedMortgageType; // defualt value
  String? selectedMortgageTerm;
  double monthlyMortgage = 0.0;
  double interestRate = 6.665;
  TextEditingController loanAmountController = TextEditingController();
  final _dropdownFormKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> get mortgageTypeItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Conventional", child: Text("Conventional")),
      const DropdownMenuItem(value: "FHA", child: Text("FHA")),
      const DropdownMenuItem(
        value: "VA",
        child: Text("VA"),
      )
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get mortgageTermItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "15 Year", child: Text("15 Year")),
      const DropdownMenuItem(value: "30 Year", child: Text("30 Year"))
    ];
    return menuItems;
  }

  double calculateMortgage(
      double loanAmout, double interestRate, int loanTermInMonths) {
    double monthlyInterestRate = interestRate / 12 / 100;
    double numerator = loanAmout *
        monthlyInterestRate *
        pow(1 + monthlyInterestRate, loanTermInMonths);
    double denominator = pow(1 + monthlyInterestRate, loanTermInMonths) - 1;
    return numerator / denominator;
  }

  Future<double> fetchInterestRate(String? loanType, String? loanTerm) async {
    String seriesId = 'MORTGAGE30US';
    if (loanTerm == '15 Year') {
      seriesId = 'MORTGAGE15US';
    }

    final url =
        'https://api.stlouisfed.org/fred/series/observations?series_id=$seriesId&api_key=$API_KEY&file_type=json';
    debugPrint('the url is $url');
    try {
      final reponse = await http.get(Uri.parse(url));
      if (reponse.statusCode == 200) {
        final data = json.decode(reponse.body);
        final latestObservation = data['observations'][0];
        return double.parse(latestObservation['value']);
      } else {
        throw Exception('Failed to get data');
      }
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mortgage Calculator')),
      body: Center(
        child: Column(
          key: _dropdownFormKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: loanAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Loan Amount'),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.blueAccent,
                      ),
                      validator: (value) =>
                          value == null ? "Select Mortgage Type" : null,
                      dropdownColor: Colors.blueAccent,
                      value: selectedMortgageType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMortgageType = newValue!;
                        });
                      },
                      items: mortgageTypeItems),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.blueAccent,
                    ),
                    validator: (value) =>
                        value == null ? 'Select Loan Term' : null,
                    dropdownColor: Colors.blueAccent,
                    value: selectedMortgageTerm,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMortgageTerm = newValue!;
                      });
                    },
                    items: mortgageTermItems,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      double loanAmount =
                          double.parse(loanAmountController.text);
                      int loanTermInMonths =
                          selectedMortgageTerm == '15 Year' ? 15 * 12 : 30 * 12;

                      // fetch interest rate
                      interestRate = await fetchInterestRate(
                          selectedMortgageType, selectedMortgageTerm);
                      debugPrint(
                          'loan amount is $loanAmount\nloan term in months is $loanTermInMonths\ninterest rate is $interestRate');
                      monthlyMortgage = calculateMortgage(
                          loanAmount, interestRate, loanTermInMonths);
                      debugPrint('Monthly Payment: $monthlyMortgage');
                      setState(() {});
                    },
                    child: const Text('Calculate')),
                const SizedBox(height: 20),
                Text(
                  'Monthly Payment \$${monthlyMortgage.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

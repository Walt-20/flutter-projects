import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/auth/secrets.dart';
import 'package:mortgage_calculator/shared_data.dart';
import 'package:provider/provider.dart';

class MortgageCalculator extends StatefulWidget {
  const MortgageCalculator({super.key});
  @override
  MortgageCalculatorState createState() => MortgageCalculatorState();
}

class MortgageCalculatorState extends State<MortgageCalculator> {
  // defualt values
  String? selectedMortgageType;
  String? selectedMortgageTerm;
  int loanAmount = 0;
  double monthlyMortgage = 0.0;
  double interestRate = 0.0;
  int downpaymentAmount = 0;
  double percentage = 0.0;
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController downpaymentAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loanAmountController.text = '';
    downpaymentAmountController.text = '';
  }

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

  double calculateMortgage(double percentage, int downPayment, int loanAmout,
      double interestRate, int loanTermInMonths) {
    double monthlyInterestRate = interestRate / 12 / 100;
    if (percentage == 0.0) {
      int newLoanAmountWithoutPercentage = loanAmout - downPayment;
      double numerator = newLoanAmountWithoutPercentage *
          monthlyInterestRate *
          pow(1 + monthlyInterestRate, loanTermInMonths);
      double denominator = pow(1 + monthlyInterestRate, loanTermInMonths) - 1;
      return numerator / denominator;
    } else {
      double newLoanAmount = (loanAmount * (percentage / 100));
      double numerator = newLoanAmount *
          monthlyInterestRate *
          pow(1 + monthlyInterestRate, loanTermInMonths);
      double denominator = pow(1 + monthlyInterestRate, loanTermInMonths) - 1;
      return numerator / denominator;
    }
  }

  Future<double> fetchInterestRate(String? loanType, String? loanTerm) async {
    String seriesId = 'MORTGAGE30US';
    // loan term
    if (loanTerm == '15 Year') {
      seriesId = 'MORTGAGE15US';
    }

    if (loanType == 'VA' && loanTerm == '30 Year') {
      seriesId = 'OBMMIVA30YF';
    } else if (loanType == 'FHA' && loanTerm == '30 Year') {
      seriesId = 'OBMMIFHA30YF';
    }

    final url =
        'https://api.stlouisfed.org/fred/series/observations?series_id=$seriesId&api_key=$API_KEY&file_type=json';
    debugPrint('the url is $url');
    try {
      final reponse = await http.get(Uri.parse(url));
      debugPrint("awaiting response ${reponse.statusCode}");
      if (reponse.statusCode == 200) {
        debugPrint("Got ${reponse.statusCode}");
        final data = json.decode(reponse.body);
        final observations = data['observations'] as List<dynamic>;
        final latestObservation = observations.last;
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
    final sharedData = Provider.of<SharedData>(context, listen: false);
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
                    onTap: () {
                      if (loanAmountController.text == '0') {
                        loanAmountController.clear();
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        loanAmount = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: downpaymentAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Downpayment Amount'),
                          onTap: () {
                            if (downpaymentAmountController.text == '0') {
                              downpaymentAmountController.clear();
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              downpaymentAmount = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: '%'),
                          onChanged: (value) {
                            setState(() {
                              // Assuming you have a variable for the percentage, update it here
                              percentage = double.tryParse(value) ?? 0.0;
                            });
                          },
                        ),
                      ),
                    ],
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
                          value == null ? "Mortgage Type" : null,
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
                    validator: (value) => value == null ? 'Loan Term' : null,
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
                      int loanTermInMonths =
                          selectedMortgageTerm == '15 Year' ? 15 * 12 : 30 * 12;

                      // fetch interest rate
                      interestRate = await fetchInterestRate(
                          selectedMortgageType, selectedMortgageTerm);
                      debugPrint(
                          'loan amount is $loanAmount\nloan term in months is $loanTermInMonths\ninterest rate is $interestRate\ndownpayment is $downpaymentAmount\npercentage is $percentage');
                      monthlyMortgage = calculateMortgage(
                          percentage,
                          downpaymentAmount,
                          loanAmount,
                          interestRate,
                          loanTermInMonths);
                      sharedData.setMonthlyMortgage(monthlyMortgage);
                      debugPrint('Monthly Payment: $monthlyMortgage');
                      setState(() {});
                    },
                    child: const Text('Calculate')),
                const SizedBox(height: 20),
                Text(
                  'Monthly Mortgage Payment \$${monthlyMortgage.toStringAsFixed(2)}',
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

import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/secrets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared_data.dart'; // Import the gross yearly income widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? jobType;
  double yearlyIncome = 0.0;
  double monthlyGrossIncome = 0.0;
  double? hoursWorkedPerWeek;
  double? hourlyPay;
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
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          key: _dropdownFormKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Financial Information
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                      const SizedBox(height: 10),
                      Text(
                        'Gross Monthly Income: \$${monthlyGrossIncome.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Debt to Income: ${debtToIncome.toStringAsFixed(2)}%',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            // ---------------- Mortgage Section ---------------- //
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mortgage Calculator',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                  validator: (value) => value == null ? "Mortgage Type" : null,
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
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
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
              child: const Text('Calculate'),
            ),
            // ---------------- End Mortgage Section ---------------- //

            // ---------------- Income Section ---------------- //
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: jobType,
                    onChanged: (newValue) {
                      setState(() {
                        jobType = newValue;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'Salaried',
                        child: Text('Salaried'),
                      ),
                      DropdownMenuItem(
                        value: 'Hourly',
                        child: Text('Hourly'),
                      ),
                    ],
                    hint: const Text('Select Job Type'),
                  ),
                  const SizedBox(height: 16.0),
                  if (jobType == 'Salaried')
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Yearly Income'),
                      onChanged: (value) {
                        setState(() {
                          yearlyIncome = double.parse(value);
                        });
                      },
                    ),
                  if (jobType == 'Hourly')
                    Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Hours Worked Per Week'),
                          onChanged: (value) {
                            setState(() {
                              hoursWorkedPerWeek = double.tryParse(value);
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Hourly Pay'),
                          onChanged: (value) {
                            setState(() {
                              hourlyPay = double.parse(value);
                              if (hourlyPay != null &&
                                  hoursWorkedPerWeek != null) {
                                yearlyIncome =
                                    hourlyPay! * hoursWorkedPerWeek! * 52;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      sharedData.setGrossIncome(yearlyIncome);
                      debugPrint('yearly gross income is $yearlyIncome');
                      monthlyGrossIncome = yearlyIncome / 12;
                      debugPrint(monthlyGrossIncome.toString());
                      setState(() {});
                    },
                    child: const Text('Calculate'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

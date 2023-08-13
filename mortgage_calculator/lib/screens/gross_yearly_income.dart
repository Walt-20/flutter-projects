import 'package:flutter/material.dart';

import '../shared_data.dart';

class GrossYearlyIncome extends StatefulWidget {
  const GrossYearlyIncome({super.key});

  @override
  GrossYearlyIncomeState createState() => GrossYearlyIncomeState();
}

class GrossYearlyIncomeState extends State<GrossYearlyIncome> {
  String? jobType;
  double yearlyIncome = 0.0;
  double? hoursWorkedPerWeek;
  double? hourlyPay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gross Yearly Income'),
      ),
      body: Padding(
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
                decoration: const InputDecoration(labelText: 'Yearly Income'),
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
                    decoration: const InputDecoration(labelText: 'Hourly Pay'),
                    onChanged: (value) {
                      setState(() {
                        hourlyPay = double.parse(value);
                        if (hourlyPay != null && hoursWorkedPerWeek != null) {
                          yearlyIncome = hourlyPay! * hoursWorkedPerWeek! * 52;
                        }
                      });
                    },
                  ),
                ],
              ),
            ElevatedButton(
                onPressed: () {
                  SharedData().setGrossIncome(yearlyIncome);
                },
                child: const Text('Calculate'))
          ],
        ),
      ),
    );
  }
}

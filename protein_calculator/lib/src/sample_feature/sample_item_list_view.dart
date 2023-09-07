import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

class SampleItemListView extends StatefulWidget {
  SampleItemListView(
      {super.key,
      this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)]});

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  _SampleItemListViewState createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  final TextEditingController _weightController = TextEditingController();
  double proteinToConsume = 0.0; // Initialize with a default value

  double calculateProteinToConsume(double weight) {
    double kilos = weight * 0.4535924;
    double proteinToConsume = kilos * 0.8;
    return proteinToConsume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protein Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter weight in lbs",
              ),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              onSubmitted: (String input) {
                if (input == "") {
                  input = "0.0";
                }
                double weight = double.parse(input);
                double calculatedProtein = calculateProteinToConsume(weight);
                setState(() {
                  proteinToConsume =
                      calculatedProtein; // Update the protein value
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Daily Protein: ${proteinToConsume.toStringAsFixed(2)} grams',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.items[index];

                return ListTile(
                  title: Text('SampleItem ${item.id}'),
                  leading: const CircleAvatar(
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
                  ),
                  onTap: () {
                    Navigator.restorablePushNamed(
                      context,
                      SampleItemDetailsView.routeName,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:finance_app/src/sample_feature/debts.dart';
import 'package:finance_app/src/sample_feature/gross_income.dart';
import 'package:flutter/material.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  static const routeName = '/';
  final List<Map<String, dynamic>> classNames = [
    {
      'className': 'Debt',
      'routeName': DebtsView.routeName,
    },
    {
      'className': 'Income',
      'routeName': GrossIncomeView.routeName,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      drawer: Drawer(
        child: ListView.builder(
          // Providing a restorationId allows the ListView to restore the
          // scroll position when a user leaves and returns to the app after it
          // has been killed while running in the background.
          restorationId: 'sampleItemListView',
          itemCount: classNames.length,
          itemBuilder: (BuildContext context, int index) {
            final item = classNames[index];

            return ListTile(
                title: Text(item['className']),
                leading: const CircleAvatar(
                  // Display the Flutter Logo image asset.
                  foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                ),
                onTap: () {
                  // Navigate to the details page. If the user leaves and returns to
                  // the app after it has been killed while running in the
                  // background, the navigation stack is restored.
                  Navigator.pushNamed(
                    context,
                    item['routeName'],
                  );
                });
          },
        ),
      ),
    );
  }
}

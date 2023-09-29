import 'package:finance_app/src/sample_feature/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  static const routeName = '/onboarding';

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool hasConsented = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onboarding Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!hasConsented)
              ElevatedButton(
                onPressed: () {
                  // Show consent dialog
                  showConsentDialog(context);
                },
                child: Text('Provide Consent'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  // Launch the 3rd party application
                  _launchURL(context);
                },
                child: Text('Launch 3rd Party Application'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> showConsentDialog(BuildContext context) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Consent'),
          content: Text('Do you consent to continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Dismiss the dialog with false
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Dismiss the dialog with true
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (accepted == true) {
      setState(() {
        hasConsented = true;
      });
    }
  }

  void _launchURL(BuildContext context) async {
    try {
      await launch(
        'https://example.com/',
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }
}

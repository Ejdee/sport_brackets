import 'package:flutter/material.dart';
import 'load_button.dart';
import 'package:flutter/services.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;

  void onReset() {
    // This will simulate a close of the app
    SystemNavigator.pop(); // Close the app
  }

  MainScaffold({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            title: const Row(
              children: [
                Icon(Icons.sports_martial_arts_rounded),
                SizedBox(width: 8.0),
                Text('Karate'),
              ],
            ),
            actions: <Widget>[
              createLoadButton(context), // Existing load button
              //IconButton(
              //  icon: const Icon(Icons.refresh), // Reset button icon
              //  onPressed: onReset, // Reset logic
              //  tooltip: 'Reset State',
              //),
            ],
            elevation: 0.0, // Removes elevation from AppBar
          ),
        ),
      ),
      body: body,
    );
  }
}
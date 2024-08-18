import 'package:flutter/material.dart';

TextButton createLoadButton(BuildContext context) {
  return TextButton(
    child: const Text('Load'),
    onPressed:() {
      final loadController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Google Sheets URL'),
            content: TextField(
              controller: loadController,
              onChanged: (value) {
                // Store your value here
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  String url = loadController.text;
                  Navigator.of(context).pop();
                  // Load data from Google Sheets here
                  print('Loading data from $url...');
                },
              ),
            ],
          );
        },
      );
    },
  );
}
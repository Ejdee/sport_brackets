import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data_manage/category_manager.dart';

TextButton createLoadButton(BuildContext context) {
  return TextButton(
    child: const Text('Load'),
    onPressed: () {
      final loadController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Google Sheets URL'),
            content: TextField(
              controller: loadController,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () async {
                  String url = loadController.text;
                  Navigator.of(context).pop();

                  // Load data from Google Sheets here
                  var gsheetData = await loadGoogleSheetData(url);
                  // get the category data
                  var cmdata = CategoryDataManager.instance.categoryData;

                  // variable to store the categories and the names
                  Map<String, List<String>> filtered_categories = {};

                  // gsheetData is like
                  // [name, age, weight, rank, kata?, kumite?]

                  for(var category in cmdata) {
                    for(var person in gsheetData) {
                      // make variable for each data
                      String name = person[0];
                      int age = int.parse(person[1]);
                      double weight = double.parse(person[2]);
                      int rank = int.parse(person[3]);

                      bool fits = true;

                      // check if the person competes in the category
                      if(category['categoryType'] == 'Kata' && person[4] != 'ano') {
                        fits = false;
                      } else if (category['categoryType'] == 'Kumite' && person[5] != 'ano') {
                        fits = false;
                      }

                      // check the age
                      var ageRange = category['age']?.split('-').map(int.parse).toList();
                      if(age < ageRange![0] || age > ageRange[1]) {
                        fits = false;
                      }

                      if(category['categoryType'] == 'Kata') {
                        // check the rank - ALERT: rank is descending
                        var rankRange = category['rank']?.split('-').map(int.parse).toList();
                        if(rank > rankRange![0] || rank < rankRange[1]) {
                          fits = false;
                        }
                      } else {
                        // check the weight
                        var weightRange = category['weight']?.split('-').map(double.parse).toList();
                        if(weight < weightRange![0] || weight > weightRange[1]) {
                          fits = false;
                        }
                      }

                      if(fits) {
                        // add the person to the category
                        String categoryName = category['categoryType'] == 'Kata' ?
                          '${category['categoryType']}_${category['age']}_${category['rank']}' :
                          '${category['categoryType']}_${category['age']}_${category['weight']}';

                        if(!filtered_categories.containsKey(categoryName)) {
                          filtered_categories[categoryName] = [];
                        }

                        filtered_categories[categoryName]!.add(name);
                      }
                    }
                  }

                  // show the result
                  print(filtered_categories);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

Future<List<List<dynamic>>> loadGoogleSheetData(String url) async {
  try {
    // Load credentials from assets
    final jsonString = await rootBundle.loadString('assets/credentials.json');
    final credentials = jsonDecode(jsonString);

    if (credentials['type'] != 'service_account') {
      throw Exception('Invalid credentials type');
    }

    // Initialize gsheets
    final gsheets = GSheets(credentials);

    // Extract spreadsheet ID from the URL
    final spreadsheetId = extractSpreadsheetId(url);

    // Fetch the spreadsheet
    final spreadsheet = await gsheets.spreadsheet(spreadsheetId);

    // Fetch the first worksheet (you can specify other worksheets if needed)
    final sheet = spreadsheet.sheets.first;

    // Fetch the data from the sheet
    final data = await sheet.values.allRows(fromRow: 3, fromColumn: 2);

    print('Loaded data: $data');
    return data;
  } catch (e) {
    print('Error loading Google Sheet: $e');
    throw Exception('Data loading failed');
  }
}

String extractSpreadsheetId(String url) {
  final regex = RegExp(r'/spreadsheets/d/([a-zA-Z0-9-_]+)');
  final match = regex.firstMatch(url);
  return match?.group(1) ?? '';
}
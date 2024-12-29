import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data_manage/category_manager.dart';


TextButton createLoadButton(BuildContext context) {
  return TextButton(
    child: const Text('Nahrát soutěžící'),
    onPressed: () {
      final loadController = TextEditingController();
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Zadejte Google Sheets URL'),
                SizedBox(height: 5),
                Text(
                  'POZOR: udělat až po vytvoření všech kategorií.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                )
              ],
            ),
            content: TextField(
              controller: loadController,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () async {
                  String url = loadController.text;

                  // Close the dialog using the dialog context
                  Navigator.of(dialogContext).pop();

                  // Show the loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  try {
                    // Simulate loading data
                    var gsheetData = await loadGoogleSheetData(url);
                    var cmdata = CategoryDataManager.instance.categoryData;
                    var categoryNames = await loadCategoryNames(url);

                    for (var category in cmdata) {
                      for (var person in gsheetData) {
                        String name = person[0];
                        String gender = person[1];
                        int age = int.parse(person[2]);
                        double weight = double.parse(person[3]);
                        int rank = int.parse(person[4]);

                        bool fits = true;

                        int i = 5;
                        for (var name in categoryNames) {
                          if (category['categoryType']!.toLowerCase() == name.toLowerCase() &&
                              person[i] != 'ano') {
                            fits = false;
                          }
                          i++;
                        }

                        if (category['gender'] == 'female' && gender != "žena") {
                          fits = false;
                        } else if (category['gender'] == 'male' && gender != "muž") {
                          fits = false;
                        }

                        if (category['age'] != "") {
                          var ageRange = category['age']?.split('-').map(int.parse).toList();
                          if (ageRange != null && ageRange.isNotEmpty) {
                            if (ageRange.length == 1 && age != ageRange[0]) {
                              fits = false;
                            } else if (ageRange.length == 2 &&
                                (age < ageRange[0] || age > ageRange[1])) {
                              fits = false;
                            }
                          }
                        }

                        if (category['rank'] != "") {
                          var rankRange = category['rank']?.split('-').map(int.parse).toList();
                          if (rankRange != null && rankRange.isNotEmpty) {
                            if (rankRange.length == 1 && rank != rankRange[0]) {
                              fits = false;
                            } else if (rankRange.length == 2 &&
                                (rank > rankRange[0] || rank < rankRange[1])) {
                              fits = false;
                            }
                          }
                        }

                        if (category['weight'] != "") {
                          var weightRange =
                              category['weight']?.split('-').map(double.parse).toList();
                          if (weightRange != null && weightRange.isNotEmpty) {
                            if (weightRange.length == 1 && weight != weightRange[0]) {
                              fits = false;
                            } else if (weightRange.length == 2 &&
                                (weight < weightRange[0] || weight > weightRange[1])) {
                              fits = false;
                            }
                          }
                        }

                        if (fits) {
                          String genderName = "";
                          if (category['gender'] == 'male') {
                            genderName = "Muži";
                          } else if (category['gender'] == 'female') {
                            genderName = "Ženy";
                          } else if (category['gender'] == 'both') {
                            genderName = 'Smíšené';
                          }

                          String ageString = category['age'] != "" ? ", ${category['age']} let" : "";
                          String weightString =
                              category['weight'] != "" ? ", ${category['weight']} kg" : "";
                          String rankString =
                              category['rank'] != "" ? ", ${category['rank']} kyu" : "";

                          String categoryName =
                              '${category['categoryType']}$ageString$weightString$rankString, $genderName';

                          FilteredCategoryDataManager.instance.addCategory(categoryName, name);
                        }
                      }
                    }

                    print(FilteredCategoryDataManager.instance.filteredCategories);
                  } catch (e) {
                    print('Error loading data: $e');
                  } finally {
                    // Close the loading dialog using the correct context
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  }
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
    final data = await sheet.values.allRows(fromRow: 2, fromColumn: 1);

    print('Loaded data: $data');
    return data;
  } catch (e) {
    print('Error loading Google Sheet: $e');
    throw Exception('Data loading failed');
  }
}

Future<List<dynamic>> loadCategoryNames(String url) async {
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
    final names = await sheet.values.row(1, fromColumn: 6);

    print('Loaded data: $names');
    return names;
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
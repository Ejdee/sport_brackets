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
        builder: (context) {
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
              ]
            ),
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

                  var categoryNames = await loadCategoryNames(url);


                  // variable to store the categories and the names
                  var filteredCategoriesVar = FilteredCategoryDataManager.instance.filteredCategories;

                  // gsheetData is like
                  // [name, age, weight, rank, kata?, kumite?, agility?, rychlost?]

                  for(var category in cmdata) {
                    for(var person in gsheetData) {
                      // make variable for each data
                      String name = person[0];
                      String gender = person[1];
                      int age = int.parse(person[2]);
                      double weight = double.parse(person[3]);
                      int rank = int.parse(person[4]);

                      bool fits = true;

                      //// check if the person competes in the category
                      //if(category['categoryType'] == 'Kata' && person[5] != 'ano') {
                      //  fits = false;
                      //} else if (category['categoryType'] == 'Kumite' && person[6] != 'ano') {
                      //  fits = false;
                      //} else if (category['categoryType'] == 'Agility' && person[7] != 'ano') {
                      //  fits = false;
                      //} else if (category['categoryType'] == 'Rychlost' && person[8] != 'ano') {
                      //  fits = false;
                      //}

                      // starting column of category names in google sheets
                      int i = 5;
                      for(var name in categoryNames) {
                        if(category['categoryType']!.toLowerCase() == name.toLowerCase() && person[i] != 'ano') {
                          fits = false; 
                        }
                        i++;
                      }

                      if(category['gender'] == 'female' && gender != "žena") {
                        fits = false;
                      } else if (category['gender'] == 'male' && gender != "muž")  {
                        fits = false;
                      }

                      // Check the age
                      if (category['age'] != "") {
                        var ageRange = category['age']?.split('-').map(int.parse).toList();

                        if (ageRange != null && ageRange.isNotEmpty) {
                          if (ageRange.length == 1) {
                            // Single number
                            if (age != ageRange[0]) {
                              fits = false;
                            }
                          } else if (ageRange.length == 2) {
                            // Range
                            if (age < ageRange[0] || age > ageRange[1]) {
                              fits = false;
                            }
                          } else {
                            // Invalid format
                            throw FormatException('Invalid age format: ${category['age']}');
                          }
                        }
                      }

                      // Check the rank
                      if (category['rank'] != "") {
                        var rankRange = category['rank']?.split('-').map(int.parse).toList();

                        if (rankRange != null && rankRange.isNotEmpty) {
                          if (rankRange.length == 1) {
                            // Single number
                            if (rank != rankRange[0]) {
                              fits = false;
                            }
                          } else if (rankRange.length == 2) {
                            // Range
                            if (rank > rankRange[0] || rank < rankRange[1]) {
                              fits = false;
                            }
                          } else {
                            // Invalid format
                            throw FormatException('Invalid rank format: ${category['rank']}');
                          }
                        }
                      }

                      // Check the weight
                      if (category['weight'] != "") {
                        var weightRange = category['weight']?.split('-').map(double.parse).toList();

                        if (weightRange != null && weightRange.isNotEmpty) {
                          if (weightRange.length == 1) {
                            // Single number
                            if (weight != weightRange[0]) {
                              fits = false;
                            }
                          } else if (weightRange.length == 2) {
                            // Range
                            if (weight < weightRange[0] || weight > weightRange[1]) {
                              fits = false;
                            }
                          } else {
                            // Invalid format
                            throw FormatException('Invalid weight format: ${category['weight']}');
                          }
                        }
                      }


                      if(fits) {
                        String genderName = "";
                        if(category['gender'] == 'male') {
                          genderName = "Muži";
                        } else if (category['gender'] == 'female') {
                          genderName = "Ženy";
                        } else if (category['gender'] == 'both') {
                          genderName = 'Smíšené';
                        }
                        // add the person to the category
                        String categoryName = '${category['categoryType']}, ${category['age']} let,${category['weight']} kg, ${category['rank']} kyu, $genderName';

                        FilteredCategoryDataManager.instance.addCategory(categoryName, name); 
                      }
                    }
                  }

                  // show the result
                  print(FilteredCategoryDataManager.instance.filteredCategories);
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
import 'package:flutter/material.dart';
import 'category_input.dart';
import 'category_grid.dart';
import '../components/category_card.dart';
import '../components/switch_category_button.dart';
import '../components/main_scaffold.dart';
import '../data_manage/category_manager.dart';
import 'bracket.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _categories = [];
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  final ValueNotifier<String> _categoryNotifier = ValueNotifier<String>('Kata');
  final ValueNotifier<String> _genderNotifier = ValueNotifier<String>('female');

  List<Map<String, String>> categoryData = [];

  void _addCategory() {
    setState(() {
      String categoryType = _categoryNotifier.value;
      String age = _ageController.text;
      String weight = _weightController.text;
      String rank = _rankController.text;
      String gender = _genderNotifier.value;

      // Add the category to the list of data
      CategoryDataManager.instance.addCategory({
        'categoryType': categoryType,
        'age': age,
        'rank': _rankController.text,
        'weight': _weightController.text,
        'gender': gender
      });

      _categories = List.from(_categories)..add(
        CategoryCard(
          key: UniqueKey(),
          age: age,
          weight: weight,
          rank: rank,
          onDelete: (key) {
            setState(() {
              // Find the index of the category card to be deleted
              var index = _categories.indexWhere((card) => card.key == key);
              // Remove from the list of widgets
              _categories.removeAt(index);
              // Remove from the singleton instance
              CategoryDataManager.instance.removeCategory(index);
              print(CategoryDataManager.instance.categoryData);
            });
          },
          categoryNotifier: _categoryNotifier.value,
          gender: gender,
        ),
      );
    });
    print(CategoryDataManager.instance.categoryData);
  }

  void _resetState() {
    setState(() {
      // Reset TextEditingController values
      _ageController.clear();
      _weightController.clear();
      _rankController.clear();

      // Reset ValueNotifiers to their initial states
      _categoryNotifier.value = 'Kata';
      _genderNotifier.value = 'female';

      // Clear categories
      _categories.clear();
      CategoryDataManager.instance.clearAll();
      print(CategoryDataManager.instance.categoryData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Přidat novou kategorii',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          CategoryInputScreen(
            ageController: _ageController,
            rankController: _rankController,
            weightController: _weightController,
            categoryNotifier: _categoryNotifier,
            genderNotifier: _genderNotifier,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addCategory,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.black), // Background color
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                  ),
                  child: const Text(
                    'Přidat kategorii',
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CategoryGrid(
              key: const Key('categoryGrid'),
              categories: _categories,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomButton(
                  text: 'Vytvořit pavouky',
                  onPressed: () async {
                    try {
                      final pdfData = generateBracketPdf(FilteredCategoryDataManager.instance.filteredCategories);
                      final path = await savePdf(pdfData);
                      print('PDF saved to $path');

                      // Show a dialog with the path
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Pavouci vytvořeny.'),
                          content: Text('PDF bylo uloženo do složky -pavouk- ve složce programu.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: const Text('Zavřít'),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      print('Error saving PDF: $e');
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Pavouky se nepodařilo vytvořit. Zkuste to prosím znovu.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Uzavřít'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
      //onReset: _resetState,
    );
  }
}


class BracketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bracket Display'),
      ),
      body: BracketScreen(), // Display the Bracket widget
    );
  }
}
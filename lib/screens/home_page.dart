import 'package:flutter/material.dart';
import 'category_input.dart';
import 'category_grid.dart';
import '../components/category_card.dart';
import '../components/switch_category_button.dart';
import '../components/main_scaffold.dart';
import '../data_manage/category_manager.dart';

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

  List<Map<String, String>> categoryData = [];

  void _addCategory() {
    setState(() {
      String categoryType = _categoryNotifier.value;
      String age = _ageController.text;
      String weight = _weightController.text;
      String rank = _rankController.text;

      // add the category to the list of data
      CategoryDataManager.instance.addCategory({
        'categoryType': categoryType,
        'age': age,
        'rank': (_rankController.text == '-') ? "" : _rankController.text,
        'weight': (_weightController.text == '-') ? "" : _weightController.text,
      });

      _categories = List.from(_categories)..add(
        CategoryCard(
          key: UniqueKey(),
          age: age,
          weight: weight,
          rank: rank,
          onDelete: (key) {
            setState(() {
              // find the index of the category card to be deleted
              var index = _categories.indexWhere((card) => card.key == key);
              // remove from the list of widgets
              _categories.removeAt(index);
              // remove from the singleton instance
              CategoryDataManager.instance.removeCategory(index);
            });
          },
          categoryNotifier: _categoryNotifier.value,
        )
      );
    });
    print(CategoryDataManager.instance.categoryData);
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
              child: Text('Add New Category',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          CategoryInputScreen(ageController: _ageController, rankController: _rankController, weightController: _weightController, categoryNotifier: _categoryNotifier),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
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
                  'Add Category',
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ),
          ),
          Expanded(
            child: CategoryGrid(key: const Key('categoryGrid'), categories: _categories),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomButton(
                  text: 'Create Brackets',
                  onPressed: () {
                    setState(() {
                      // I DONT KNOW YET
                    });
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'kata.dart';
import 'kumite.dart';
import 'category_grid.dart';
import '../components/category_card.dart';
import '../components/switch_category_button.dart';
import '../components/main_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showKata = true;
  List<Widget> _categories = [];
  final TextEditingController _ageKumiteController = TextEditingController();
  final TextEditingController _ageKataController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();

  List<Map<String, String>> categoryData = [];

  void _addCategory() {
    setState(() {
      String categoryType = showKata ? 'Kata' : 'Kumite';
      String age = showKata ? _ageKataController.text : _ageKumiteController.text;
      String weight = _weightController.text;
      String rank = _rankController.text;

      // add the category to the list of data
      categoryData.add({
        'categoryType': categoryType,
        'age': age,
        showKata ? 'rank' : 'weight' : showKata ? rank : weight,
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
              // remove from the list of data
              categoryData.removeAt(index);
            });
          },
          showKata: showKata,
        )
      );
    });
    print(categoryData);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('Manage Categories',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // display either kata or kumite screen based on showKata value
          showKata ? KataScreen(ageKataController: _ageKataController, rankController: _rankController,)
           : KumiteScreen(ageKumiteController: _ageKumiteController, weightController: _weightController),
          ElevatedButton(
            onPressed: _addCategory,
            child: const Text('Add'),
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
                  text: 'Show Kata',
                  onPressed: () {
                    setState(() {
                      showKata = true;
                    });
                  }
                ),
                CustomButton(
                  text: 'Show Kumite',
                  onPressed: () {
                    setState(() {
                      showKata = false;
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'kata.dart';
import 'kumite.dart';
import 'category_grid.dart';
import '../components/category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showKata = true;
  List<Widget> _categories = [];
  final TextEditingController _ageKumiteController = TextEditingController();
  final TextEditingController _ageKataController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();

  void _addCategory() {
    setState(() {
      _categories = List.from(_categories)..add(
        CategoryCard(
          key: const Key('categoryCard'),
          age: _showKata ? _ageKataController.text : _ageKumiteController.text,
          weight: _weightController.text,
          rank: _rankController.text,
        )
      );
    });
    print(_categories);
  }

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
                offset: const Offset(0, 3), // changes position of shadow
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
            elevation: 0.0, // remove elevation from AppBar
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('Manage Categories',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // display either kata or kumite screen based on _showKata value
          _showKata ? KataScreen(ageKataController: _ageKataController, rankController: _rankController,)
           : KumiteScreen(ageKumiteController: _ageKumiteController, weightController: _weightController),
          ElevatedButton(
            onPressed: _addCategory,
            child: const Text('Add'),
          ),
          Expanded(
            child: CategoryGrid(key: const Key('categoryGrid'), categories: _categories),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Show Kata'),
                onPressed: () {
                  setState(() {
                    _showKata = true;
                  });
                },
              ),
              ElevatedButton(
                child: const Text('Show Kumite'),
                onPressed: () {
                  setState(() {
                    _showKata = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
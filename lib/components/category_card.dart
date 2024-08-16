import 'package:flutter/material.dart';
import '../screens/home_page.dart';

class CategoryCard extends StatelessWidget {
  final String age;
  final String? weight;
  final String? rank;
  final Function onDelete;

  const CategoryCard({required Key key, required this.age, this.weight, this.rank, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Text('Age: $age'),
          showKata ? Text('Rank: $rank') : Text('Weight: $weight'),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(key),
          )
        ]
      )
    );
  }
}
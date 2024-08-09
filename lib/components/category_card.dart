import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String age;
  final String? weight;
  final String? rank;

  const CategoryCard({required Key key, required this.age, this.weight, this.rank}) : super(key: key);

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
          if (weight != null) Text('Weight: $weight'),
          if (rank != null) Text('Rank: $rank'),
        ]
      )
    );
  }
}
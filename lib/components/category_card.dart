import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;

  const StyledText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15.0,
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String age;
  final String? weight;
  final String? rank;
  final Function onDelete;
  final bool showKata;

  const CategoryCard({required Key key, required this.age, this.weight, this.rank, required this.onDelete, required this.showKata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center( // Add this line
                  child: Text(showKata ? 'Kata' : 'Kumite', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)), // Wrap this line
                ), // Add this line
                StyledText(text: 'Age: $age'),
                showKata ? StyledText(text: 'Rank: $rank') : StyledText(text: 'Weight: $weight'),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDelete(key),
            ),
          ),
        ],
      ),
    );
  }
}
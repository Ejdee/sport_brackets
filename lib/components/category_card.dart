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
  final String categoryNotifier;
  final String gender;

  const CategoryCard({required Key key, required this.age, this.weight, this.rank, required this.onDelete, required this.categoryNotifier, required this.gender}) : super(key: key);

  String get finalGender {
    if (gender == "female") {
      return "ženy";
    } else if (gender == "male") {
      return "muži";
    } else if (gender == "both") {
      return "smíšené";
    }
    return "";
  }

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
                  child: Text(categoryNotifier, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)), // Wrap this line
                ), // Add this line
                StyledText(text: 'Věk: $age'),
                // show these two only if it is not empty string
                rank != "" ? StyledText(text: 'Kyu: $rank') : Container(),
                weight != "" ? StyledText(text: 'Váha: $weight') : Container(),
                gender != "" ? StyledText(text: 'Pohlaví: $finalGender') : Container(),
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
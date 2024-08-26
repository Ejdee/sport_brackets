import 'package:flutter/material.dart';
import '../components/single_bracket.dart';
import '../data_manage/category_manager.dart';

class Bracket extends StatelessWidget {
  Bracket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Map<String, List<String>> filteredCategories = FilteredCategoryDataManager.instance.filteredCategories;

    return Column(
      children: filteredCategories.keys.map((category) {
        // For each category, create a CategoryBracket widget
        return CategoryBracket(category: category, participants: filteredCategories[category]!);
      }).toList(),
    );
  }
}

class CategoryBracket extends StatelessWidget {
  final String category; // The name of the category
  final List<String> participants; // The list of participants in this category

  // Constructor to initialize with category name and participants
  CategoryBracket({required this.category, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align the content to the start (left)
      children: [
        Text(
          category, // Display the category name
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ..._buildRounds(participants), // Add the rounds of matches for this category
      ],
    );
  }

  // Helper function to build rounds of matches
  List<Widget> _buildRounds(List<String> participants) {
    // This is a simple example, and you need to implement the logic to create rounds.
    // Assuming 4 participants, 2 rounds.

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space matches evenly across the row
        children: participants.map((participant) => SingleBracket(participant: participant)).toList(),
      ),
      // Add more rows for subsequent rounds (this is just a basic starting point)
    ];
  }
}


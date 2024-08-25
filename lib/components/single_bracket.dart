import 'package:flutter/material.dart';

class SingleBracket extends StatelessWidget {
  final String participant; // The name of the participant in the match

  // Constructor to initialize the match widget with a participant
  SingleBracket({required this.participant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), // Add some padding around the participant name
      decoration: BoxDecoration(
        border: Border.all(), // Add a border around the container
        borderRadius: BorderRadius.circular(8), // Round the corners of the border
      ),
      child: Text(participant), // Display the participant's name
    );
  }
}

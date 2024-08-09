import 'package:flutter/material.dart';

class KumiteScreen extends StatelessWidget {
  final TextEditingController ageKumiteController;
  final TextEditingController weightController;

  const KumiteScreen({
    super.key,
    required this.ageKumiteController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: screenWidth / 2.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: TextField(
              controller: ageKumiteController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Enter age',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          Container(
            width: screenWidth / 2.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: TextField(
              controller: weightController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Enter weight',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      )
    );
  }
}
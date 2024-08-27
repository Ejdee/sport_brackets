import 'package:flutter/material.dart';

class CategoryInputScreen extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController rankController;
  final TextEditingController weightController;
  final ValueNotifier<String> categoryNotifier;

  final List<String> categories = ["Kata", "Kumite", "Agility", "Rychlost"];

  CategoryInputScreen({
    super.key,
    required this.ageController,
    required this.rankController,
    required this.weightController,
    required this.categoryNotifier,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Dropdown menu
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1/3,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                child: ValueListenableBuilder<String>(
                  valueListenable: categoryNotifier,
                  builder: (context, value, child) {
                    return Container(
                      height: 25.0,
                      child:DropdownButton<String>(
                        value: value,
                        isExpanded: true,
                        underline: SizedBox(),
                        onChanged: (String? newValue) {
                          if (newValue != null && categories.contains(newValue)) {
                            categoryNotifier.value = newValue;
                          }
                        },
                        items: categories.map<DropdownMenuItem<String>>((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(category),
                            ),
                          );
                        }).toList(),
                      )
                    );
                  },
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          // Age input
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1/3,
              child: _buildTextField(screenWidth, ageController, 'Enter age'),
            ),
          ),
          const SizedBox(height: 20),
          // Rank input
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1/3,
              child: _buildTextField(screenWidth, rankController, 'Enter rank'),
            ),
          ),
          const SizedBox(height: 20),
          // Weight input
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1/3,
              child: _buildTextField(screenWidth, weightController, 'Enter weight'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    double screenWidth, TextEditingController controller, String labelText) {
    return Container(
      width: screenWidth,
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
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CategoryInputScreen extends StatefulWidget {
  final TextEditingController ageController;
  final TextEditingController rankController;
  final TextEditingController weightController;
  final ValueNotifier<String> categoryNotifier;

  CategoryInputScreen({
    super.key,
    required this.ageController,
    required this.rankController,
    required this.weightController,
    required this.categoryNotifier,
  });

  @override
  State<CategoryInputScreen> createState() => _CategoryInputScreenState();
}

class _CategoryInputScreenState extends State<CategoryInputScreen> {
  // List of categories
  final List<String> categories = ["Kata", "Kumite"];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Custom dropdown menu
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                child: PopupMenuButton<String>(
                  onSelected: (String value) {
                    if (value == 'add') {
                      _showAddCategoryDialog(context);
                    } else {
                      setState(() {
                        widget.categoryNotifier.value = value; // Update selected category
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      ...categories.map((String category) {
                        return PopupMenuItem<String>(
                          value: category,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey),
                                onPressed: () {
                                  Navigator.pop(context); // Close dropdown
                                  _deleteCategory(context, category); // Delete and refresh
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const PopupMenuItem<String>(
                        value: 'add',
                        child: Row(
                          children: [
                            Icon(Icons.add, color: Colors.blue),
                            SizedBox(width: 10),
                            Text("Add New Category", style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    ];
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: widget.categoryNotifier,
                          builder: (context, value, child) {
                            return Text(
                              value.isNotEmpty ? value : "Select a category",
                              style: const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Age input
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: _buildTextField(screenWidth, widget.ageController, 'Enter age'),
            ),
          ),
          const SizedBox(height: 20),

          // Rank input
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: _buildTextField(screenWidth, widget.rankController, 'Enter rank'),
            ),
          ),
          const SizedBox(height: 20),

          // Weight input
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: _buildTextField(screenWidth, widget.weightController, 'Enter weight'),
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

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController newCategoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Category"),
          content: TextField(
            controller: newCategoryController,
            decoration: const InputDecoration(
              hintText: "Enter category name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newCategory = newCategoryController.text.trim();
                if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
                  setState(() {
                    categories.add(newCategory);
                    widget.categoryNotifier.value = newCategory; // Automatically select the new category
                  });
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Category '$newCategory' added!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid or duplicate category!")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(BuildContext context, String category) {
    setState(() {
      categories.remove(category);
      // If the deleted category is the selected one, clear the selection
      if (widget.categoryNotifier.value == category) {
        widget.categoryNotifier.value = categories.isNotEmpty ? categories.first : ""; // Default to first category
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Category '$category' removed!")),
    );
  }
}

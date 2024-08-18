import 'package:flutter/material.dart';

class CategoryGrid extends StatefulWidget {
  final List<Widget> categories;

  CategoryGrid({required Key key, required this.categories}) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: widget.categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3.0, // Increase this value to reduce height
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          return widget.categories[index];
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 137, 80, 218),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}
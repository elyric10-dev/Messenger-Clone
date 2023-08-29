import 'package:flutter/material.dart';

class CustomButton {
  Widget buttonFullRadius(
    String label,
    Function function, {
    double? width = 100,
    double? height = 50,
    Color? color = Colors.blue,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ElevatedButton(
          onPressed: () => function(),
          child: Text(label),
          style: ElevatedButton.styleFrom(
            primary: color,
          ),
        ),
      ),
    );
  }
}

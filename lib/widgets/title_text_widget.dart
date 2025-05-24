import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final String text;
  final Color color;

  const TitleTextWidget({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 50,
        fontStyle: FontStyle.italic,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

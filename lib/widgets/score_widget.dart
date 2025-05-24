import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final String emoji;
  final int score;

  const ScoreWidget({
    super.key,
    required this.emoji,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$emoji : $score',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
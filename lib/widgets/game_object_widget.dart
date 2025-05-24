import 'package:flutter/material.dart';
import '../models/object_model.dart';

class GameObjectWidget extends StatelessWidget {
  final GameObject gameObject;

  const GameObjectWidget({
    super.key,
    required this.gameObject,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: gameObject.x + 0.5,
      top: gameObject.y + 0.5,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: gameObject.color,
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            gameObject.type.toString().split('.').last,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/object_model.dart';

abstract class ObjectFactory {
  List<GameObject> createInitialObjects({
    required int rocksCount,
    required int papersCount,
    required int scissorsCount,
    required Size screenSize,
    required int speed,
  });
}

class ObjectFactoryImpl implements ObjectFactory {
  final Random _random;

  ObjectFactoryImpl({Random? random}) : _random = random ?? Random();

  @override
  List<GameObject> createInitialObjects({
    required int rocksCount,
    required int papersCount,
    required int scissorsCount,
    required Size screenSize,
    required int speed,
  }) {
    final objects = <GameObject>[];
    int idCounter = 0;

    final totalObjects = rocksCount + papersCount + scissorsCount;
    final gridSize = sqrt(totalObjects).ceil();
    final cellWidth = (screenSize.width - 60) / gridSize;
    final cellHeight = (screenSize.height - 60) / gridSize;

    final positions = List.generate(totalObjects, (index) => index);
    positions.shuffle(_random);

    for (int i = 0; i < rocksCount; i++) {
      objects.add(
        _createObject(
          id: idCounter++,
          type: GameObjectType.rock,
          color: Colors.red,
          screenSize: screenSize,
          speed: speed,
          cellWidth: cellWidth,
          cellHeight: cellHeight,
          gridIndex: positions[i],
          gridSize: gridSize,
        ),
      );
    }

    for (int i = 0; i < papersCount; i++) {
      objects.add(
        _createObject(
          id: idCounter++,
          type: GameObjectType.paper,
          color: Colors.green,
          screenSize: screenSize,
          speed: speed,
          cellWidth: cellWidth,
          cellHeight: cellHeight,
          gridIndex: positions[rocksCount + i],
          gridSize: gridSize,
        ),
      );
    }

    for (int i = 0; i < scissorsCount; i++) {
      objects.add(
        _createObject(
          id: idCounter++,
          type: GameObjectType.scissor,
          color: Colors.blue,
          screenSize: screenSize,
          speed: speed,
          cellWidth: cellWidth,
          cellHeight: cellHeight,
          gridIndex: positions[rocksCount + papersCount + i],
          gridSize: gridSize,
        ),
      );
    }

    return objects;
  }

  GameObject _createObject({
    required int id,
    required GameObjectType type,
    required Color color,
    required Size screenSize,
    required int speed,
    required double cellWidth,
    required double cellHeight,
    required int gridIndex,
    required int gridSize,
  }) {
    final row = gridIndex ~/ gridSize;
    final col = gridIndex % gridSize;

    final rand1 = _random.nextDouble() * 0.6 + 0.2; 
    final rand2 = _random.nextDouble() * 0.6 + 0.2; 

    return GameObject(
      id: id,
      type: type,
      color: color,
      x: col * cellWidth + rand1 * cellWidth,
      y: row * cellHeight + rand2 * cellHeight,
      dx: (_random.nextDouble() - 0.5) * speed,
      dy: (_random.nextDouble() - 0.5) * speed,
    );
  }
}

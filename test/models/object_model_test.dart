import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rockpaperscissor/models/object_model.dart';

void main() {
  group('GameObject Tests', () {
    late GameObject defaultObject;

    setUp(() {
      defaultObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100.0,
        y: 200.0,
        dx: 5.0,
        dy: -3.0,
      );
    });

    test('should create GameObject with correct initial properties', () {
      expect(defaultObject.id, equals(1));
      expect(defaultObject.type, equals(GameObjectType.rock));
      expect(defaultObject.color, equals(Colors.red));
      expect(defaultObject.x, equals(100.0));
      expect(defaultObject.y, equals(200.0));
      expect(defaultObject.dx, equals(5.0));
      expect(defaultObject.dy, equals(-3.0));
    });

    test('copyWith should create new instance with updated properties', () {
      final updatedObject = defaultObject.copyWith(
        x: 150.0,
        dy: 10.0,
        color: Colors.blue,
        type: GameObjectType.paper,
      );

      // Check updated properties
      expect(updatedObject.x, equals(150.0));
      expect(updatedObject.dy, equals(10.0));
      expect(updatedObject.color, equals(Colors.blue));
      expect(updatedObject.type, equals(GameObjectType.paper));

      // Check unchanged properties
      expect(updatedObject.id, equals(defaultObject.id));
      expect(updatedObject.y, equals(defaultObject.y));
      expect(updatedObject.dx, equals(defaultObject.dx));
    });

    test('copyWith should handle null values correctly', () {
      final updatedObject = defaultObject.copyWith(x: null, dy: null);

      // Check that null values keep original properties
      expect(updatedObject.x, equals(defaultObject.x));
      expect(updatedObject.dy, equals(defaultObject.dy));
    });

    test('should handle position updates correctly', () {
      defaultObject.x = 150.0;
      defaultObject.y = 250.0;

      expect(defaultObject.x, equals(150.0));
      expect(defaultObject.y, equals(250.0));
    });

    test('should handle velocity updates correctly', () {
      defaultObject.dx = 10.0;
      defaultObject.dy = -5.0;

      expect(defaultObject.dx, equals(10.0));
      expect(defaultObject.dy, equals(-5.0));
    });
  });

  group('GameObjectType Tests', () {
    test('should have correct enum values and order', () {
      expect(GameObjectType.values.length, equals(3));
      expect(GameObjectType.values[0], equals(GameObjectType.rock));
      expect(GameObjectType.values[1], equals(GameObjectType.paper));
      expect(GameObjectType.values[2], equals(GameObjectType.scissor));
    });

    test('should have correct string representation', () {
      expect(GameObjectType.rock.toString(), equals('GameObjectType.rock'));
      expect(GameObjectType.paper.toString(), equals('GameObjectType.paper'));
      expect(
        GameObjectType.scissor.toString(),
        equals('GameObjectType.scissor'),
      );
    });
  });
}

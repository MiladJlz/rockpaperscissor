import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/object_model.dart';
import '../../lib/services/collision_detector.dart';

void main() {
  group('CollisionDetectorImpl Tests', () {
    late CollisionDetector collisionDetector;

    setUp(() {
      collisionDetector = CollisionDetectorImpl(collisionDistance: 60.0);
    });

    test('should detect collision when objects are close enough', () {
      // Arrange
      final obj1 = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100.0,
        y: 100.0,
        dx: 1.0,
        dy: 1.0,
      );
      final obj2 = GameObject(
        id: 2,
        type: GameObjectType.paper,
        color: Colors.green,
        x: 130.0, // 30 units away (less than 60)
        y: 100.0,
        dx: -1.0,
        dy: 1.0,
      );

      // Act
      final collisions = collisionDetector.detectCollisions([obj1, obj2]);

      // Assert
      expect(collisions.length, equals(1));
      expect(collisions.first.obj1, equals(obj1));
      expect(collisions.first.obj2, equals(obj2));
    });

    test('should not detect collision when objects are far apart', () {
      // Arrange
      final obj1 = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100.0,
        y: 100.0,
        dx: 1.0,
        dy: 1.0,
      );
      final obj2 = GameObject(
        id: 2,
        type: GameObjectType.paper,
        color: Colors.green,
        x: 200.0, // 100 units away (more than 60)
        y: 100.0,
        dx: -1.0,
        dy: 1.0,
      );

      // Act
      final collisions = collisionDetector.detectCollisions([obj1, obj2]);

      // Assert
      expect(collisions, isEmpty);
    });

    test('should detect multiple collisions', () {
      // Arrange
      final obj1 = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100.0,
        y: 100.0,
        dx: 1.0,
        dy: 1.0,
      );
      final obj2 = GameObject(
        id: 2,
        type: GameObjectType.paper,
        color: Colors.green,
        x: 130.0,
        y: 100.0,
        dx: -1.0,
        dy: 1.0,
      );
      final obj3 = GameObject(
        id: 3,
        type: GameObjectType.scissor,
        color: Colors.blue,
        x: 100.0,
        y: 130.0,
        dx: 1.0,
        dy: -1.0,
      );

      // Act
      final collisions = collisionDetector.detectCollisions([obj1, obj2, obj3]);
      // Assert

      expect(collisions.length, equals(3)); // obj1-obj2 and obj1-obj3
    });

    test('should handle empty list', () {
      // Act
      final collisions = collisionDetector.detectCollisions([]);

      // Assert
      expect(collisions, isEmpty);
    });

    test('should handle single object', () {
      // Arrange
      final obj1 = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100.0,
        y: 100.0,
        dx: 1.0,
        dy: 1.0,
      );

      // Act
      final collisions = collisionDetector.detectCollisions([obj1]);

      // Assert
      expect(collisions, isEmpty);
    });
  });
}

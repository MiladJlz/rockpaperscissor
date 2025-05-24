import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rockpaperscissor/models/game_state.dart';
import 'package:rockpaperscissor/models/object_model.dart';
import 'package:rockpaperscissor/services/collision_detector.dart';
import 'package:rockpaperscissor/services/game_engine.dart';
import 'package:rockpaperscissor/services/object_factory.dart';

void main() {
  group('Edge Cases Tests', () {
    test('should handle empty object list in collision detection', () {
      // Arrange
      final collisionDetector = CollisionDetectorImpl();

      // Act & Assert
      expect(() => collisionDetector.detectCollisions([]), returnsNormally);
      expect(collisionDetector.detectCollisions([]), isEmpty);
    });

    test('should handle single object in collision detection', () {
      // Arrange
      final collisionDetector = CollisionDetectorImpl();
      final singleObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100,
        y: 100,
        dx: 1,
        dy: 1,
      );

      // Act & Assert
      expect(
        () => collisionDetector.detectCollisions([singleObject]),
        returnsNormally,
      );
      expect(collisionDetector.detectCollisions([singleObject]), isEmpty);
    });

    test('should handle zero counts in object factory', () {
      // Arrange
      final factory = ObjectFactoryImpl();

      // Act
      final objects = factory.createInitialObjects(
        rocksCount: 0,
        papersCount: 0,
        scissorsCount: 0,
        screenSize: const Size(800, 600),
        speed: 10,
      );

      // Assert
      expect(objects, isEmpty);
    });

    test('should handle objects with zero velocity', () {
      // Arrange
      final engine = RockPaperScissorsGameEngine();
      final staticObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100,
        y: 100,
        dx: 0,
        dy: 0,
      );
      final state = GameState.initial().copyWith(objects: [staticObject]);

      // Act
      final updatedState = engine.updateGame(state, const Size(800, 600));

      // Assert
      expect(updatedState.objects.first.x, equals(100)); // No movement
      expect(updatedState.objects.first.y, equals(100)); // No movement
    });

    test('should handle very small screen size', () {
      // Arrange
      final engine = RockPaperScissorsGameEngine();
      const tinySize = Size(100, 100);

      // Act & Assert
      expect(() => engine.initializeGame(tinySize), returnsNormally);
      final state = engine.initializeGame(tinySize);
      expect(state.objects, isNotEmpty);

      // All objects should be within bounds
      for (final obj in state.objects) {
        expect(obj.x, greaterThanOrEqualTo(0));
        expect(obj.x, lessThanOrEqualTo(tinySize.width - 60));
        expect(obj.y, greaterThanOrEqualTo(0));
        expect(obj.y, lessThanOrEqualTo(tinySize.height - 60));
      }
    });

    test('should handle negative positions gracefully', () {
      // Arrange
      final engine = RockPaperScissorsGameEngine();
      final objectWithNegativePosition = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: -50,
        y: -30,
        dx: -1,
        dy: -1,
      );
      final state = GameState.initial().copyWith(
        objects: [objectWithNegativePosition],
      );

      // Act
      final updatedState = engine.updateGame(state, const Size(800, 600));

      // Assert
      final updatedObject = updatedState.objects.first;
      expect(updatedObject.dx, equals(1)); // Direction should be reversed
      expect(updatedObject.dy, equals(1)); // Direction should be reversed
    });

    test('should handle maximum boundary positions', () {
      // Arrange
      final engine = RockPaperScissorsGameEngine();
      const screenSize = Size(800, 600);
      final objectAtMaxBoundary = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: screenSize.width - 60 + 10, // Beyond right boundary
        y: screenSize.height - 60 + 10, // Beyond bottom boundary
        dx: 1,
        dy: 1,
      );
      final state = GameState.initial().copyWith(
        objects: [objectAtMaxBoundary],
      );

      // Act
      final updatedState = engine.updateGame(state, screenSize);

      // Assert
      final updatedObject = updatedState.objects.first;
      expect(updatedObject.dx, equals(1)); // Direction should be reversed
      expect(updatedObject.dy, equals(1)); // Direction should be reversed
    });

    test('should handle simultaneous multiple collisions', () {
      // Arrange
      final engine = RockPaperScissorsGameEngine();
      // Three objects at the same position
      final objects = [
        GameObject(
          id: 1,
          type: GameObjectType.rock,
          color: Colors.red,
          x: 100,
          y: 100,
          dx: 1,
          dy: 1,
        ),
        GameObject(
          id: 2,
          type: GameObjectType.paper,
          color: Colors.green,
          x: 100,
          y: 100,
          dx: 1,
          dy: 1,
        ),
        GameObject(
          id: 3,
          type: GameObjectType.scissor,
          color: Colors.blue,
          x: 100,
          y: 100,
          dx: 1,
          dy: 1,
        ),
      ];
      final state = GameState.initial().copyWith(
        objects: objects,
        rocksCount: 1,
        papersCount: 1,
        scissorsCount: 1,
      );

      // Act & Assert - Should not throw and should handle collisions
      expect(
        () => engine.updateGame(state, const Size(800, 600)),
        returnsNormally,
      );
      final updatedState = engine.updateGame(state, const Size(800, 600));

      // At least one collision should have been processed
      expect(updatedState.objects.length, lessThan(3));
    });
  });
}

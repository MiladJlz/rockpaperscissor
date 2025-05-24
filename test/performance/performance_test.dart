import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/object_model.dart';
import '../../lib/services/collision_detector.dart';
import '../../lib/services/game_engine.dart';
import '../../lib/models/game_state.dart';

void main() {
  group('Performance Tests', () {
    test('collision detection should handle large number of objects efficiently', () {
      // Arrange
      final collisionDetector = CollisionDetectorImpl();
      final objects = List.generate(100, (index) => GameObject(
        id: index,
        type: GameObjectType.values[index % 3],
        color: const Color(0xFF000000),
        x: (index % 10) * 50.0,
        y: (index ~/ 10) * 50.0,
        dx: 1.0,
        dy: 1.0,
      ));

      // Act & Assert - Should complete within reasonable time
      final stopwatch = Stopwatch()..start();
      final collisions = collisionDetector.detectCollisions(objects);
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be fast
      expect(collisions, isA<List<Collision>>());
    });

    test('game engine update should handle complex state efficiently', () {
      // Arrange
      final engine = RockPaperScissorsGameEngine();
      final objects = List.generate(50, (index) => GameObject(
        id: index,
        type: GameObjectType.values[index % 3],
        color: const Color(0xFF000000),
        x: (index % 10) * 80.0,
        y: (index ~/ 10) * 80.0,
        dx: (index % 2 == 0) ? 2.0 : -2.0,
        dy: (index % 3 == 0) ? 2.0 : -2.0,
      ));
      final state = GameState.initial().copyWith(objects: objects);

      // Act & Assert - Should complete within reasonable time
      final stopwatch = Stopwatch()..start();
      final updatedState = engine.updateGame(state, const Size(800, 600));
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(50)); // Should be very fast
      expect(updatedState, isA<GameState>());
    });
  });
}
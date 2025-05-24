import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rockpaperscissor/models/game_state.dart';
import 'package:rockpaperscissor/models/object_model.dart';
import 'package:rockpaperscissor/services/collision_detector.dart';
import 'package:rockpaperscissor/services/game_engine.dart';
import 'package:rockpaperscissor/services/game_rules.dart';
import 'package:rockpaperscissor/services/object_factory.dart';

// Mock implementations for testing
class MockCollisionDetector implements CollisionDetector {
  final List<Collision> collisionsToReturn;
  MockCollisionDetector(this.collisionsToReturn);

  @override
  List<Collision> detectCollisions(List<GameObject> objects) {
    return collisionsToReturn;
  }
}

class MockObjectFactory implements ObjectFactory {
  final List<GameObject> objectsToReturn;
  MockObjectFactory(this.objectsToReturn);

  @override
  List<GameObject> createInitialObjects({
    required int rocksCount,
    required int papersCount,
    required int scissorsCount,
    required Size screenSize,
    required int speed,
  }) {
    return objectsToReturn;
  }
}

class MockGameRules implements GameRules {
  final GameObject Function(GameObject, GameObject) winnerFunction;
  MockGameRules(this.winnerFunction);

  @override
  GameObject determineWinner(GameObject obj1, GameObject obj2) {
    return winnerFunction(obj1, obj2);
  }
}

void main() {
  group('RockPaperScissorsGameEngine Tests', () {
    test('should initialize game with correct initial state', () {
      // Arrange
      final testObjects = [
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
          x: 200,
          y: 200,
          dx: -1,
          dy: -1,
        ),
      ];
      final mockFactory = MockObjectFactory(testObjects);
      final engine = RockPaperScissorsGameEngine(
        objectFactory: mockFactory,
        collisionDetector: MockCollisionDetector([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final state = engine.initializeGame(const Size(800, 600));

      // Assert
      expect(state.objects, equals(testObjects));
      expect(state.rocksCount, equals(3));
      expect(state.papersCount, equals(3));
      expect(state.scissorsCount, equals(3));
      expect(state.status, equals(GameStatus.playing));
    });

    test('should update object positions correctly', () {
      // Arrange
      final initialObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100,
        y: 100,
        dx: 5,
        dy: 3,
      );
      final initialState = GameState.initial().copyWith(
        objects: [initialObject],
      );
      final engine = RockPaperScissorsGameEngine(
        collisionDetector: MockCollisionDetector([]),
        objectFactory: MockObjectFactory([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final updatedState = engine.updateGame(
        initialState,
        const Size(800, 600),
      );

      // Assert
      final updatedObject = updatedState.objects.first;
      expect(updatedObject.x, equals(105)); // 100 + 5
      expect(updatedObject.y, equals(103)); // 100 + 3
    });

    test('should reverse direction when hitting left boundary', () {
      // Arrange
      final initialObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: -1, // Beyond left boundary
        y: 100,
        dx: -5,
        dy: 3,
      );
      final initialState = GameState.initial().copyWith(
        objects: [initialObject],
      );
      final engine = RockPaperScissorsGameEngine(
        collisionDetector: MockCollisionDetector([]),
        objectFactory: MockObjectFactory([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final updatedState = engine.updateGame(
        initialState,
        const Size(800, 600),
      );

      // Assert
      final updatedObject = updatedState.objects.first;
      expect(updatedObject.dx, equals(5)); // Direction reversed
      expect(updatedObject.x, equals(4)); // -1 + 5 (new direction)
    });

    test('should reverse direction when hitting right boundary', () {
      // Arrange
      final initialObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 750, // Near right boundary (800 - 60 = 740)
        y: 100,
        dx: 5,
        dy: 3,
      );
      final initialState = GameState.initial().copyWith(
        objects: [initialObject],
      );
      final engine = RockPaperScissorsGameEngine(
        collisionDetector: MockCollisionDetector([]),
        objectFactory: MockObjectFactory([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final updatedState = engine.updateGame(
        initialState,
        const Size(800, 600),
      );

      // Assert
      final updatedObject = updatedState.objects.first;
      expect(updatedObject.dx, equals(5)); // Direction reversed
    });

    test('should handle same-type collision by swapping velocities', () {
      // Arrange
      final obj1 = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100,
        y: 100,
        dx: 5,
        dy: 3,
      );
      final obj2 = GameObject(
        id: 2,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 130,
        y: 100,
        dx: -2,
        dy: -1,
      );
      final collision = Collision(obj1, obj2);
      final initialState = GameState.initial().copyWith(objects: [obj1, obj2]);

      final engine = RockPaperScissorsGameEngine(
        collisionDetector: MockCollisionDetector([collision]),
        objectFactory: MockObjectFactory([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final updatedState = engine.updateGame(
        initialState,
        const Size(800, 600),
      );

      // Assert
      final updatedObj1 = updatedState.objects.firstWhere((obj) => obj.id == 1);
      final updatedObj2 = updatedState.objects.firstWhere((obj) => obj.id == 2);

      expect(updatedObj1.dx, equals(-2)); // Swapped from obj2
      expect(updatedObj1.dy, equals(-1)); // Swapped from obj2
      expect(updatedObj2.dx, equals(5)); // Swapped from obj1
      expect(updatedObj2.dy, equals(3)); // Swapped from obj1
    });

    test('should handle different-type collision by removing loser', () {
      // Arrange
      final rock = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100,
        y: 100,
        dx: 5,
        dy: 3,
      );
      final scissor = GameObject(
        id: 2,
        type: GameObjectType.scissor,
        color: Colors.blue,
        x: 130,
        y: 100,
        dx: -2,
        dy: -1,
      );
      final collision = Collision(rock, scissor);
      final initialState = GameState.initial().copyWith(
        objects: [rock, scissor],
        rocksCount: 1,
        scissorsCount: 1,
      );

      final engine = RockPaperScissorsGameEngine(
        collisionDetector: MockCollisionDetector([collision]),
        objectFactory: MockObjectFactory([]),
        gameRules: MockGameRules(
          (obj1, obj2) => obj1,
        ), // Always return first object as winner
      );

      // Act
      final updatedState = engine.updateGame(
        initialState,
        const Size(800, 600),
      );

      // Assert
      expect(updatedState.objects.length, equals(1)); // Loser removed
      expect(updatedState.objects.first.id, equals(1)); // Rock should remain
      expect(updatedState.rocksWins, equals(1)); // Rock win count increased
      expect(updatedState.scissorsCount, equals(0)); // Scissor count decreased

      // Winner direction should be reversed
      expect(updatedState.objects.first.dx, equals(-5));
      expect(updatedState.objects.first.dy, equals(-3));
    });

    test('should detect rock wins when only rocks remain', () {
      // Arrange
      final rock = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100,
        y: 100,
        dx: 5,
        dy: 3,
      );
      final initialState = GameState.initial().copyWith(
        objects: [rock],
        rocksCount: 1,
        papersCount: 0,
        scissorsCount: 0,
      );

      final engine = RockPaperScissorsGameEngine(
        collisionDetector: MockCollisionDetector([]),
        objectFactory: MockObjectFactory([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final updatedState = engine.updateGame(
        initialState,
        const Size(800, 600),
      );

      // Assert
      expect(updatedState.status, equals(GameStatus.rockWins));
      expect(updatedState.rockTextColor, equals(Colors.red));
    });

    test('should detect paper wins when only papers remain', () {
      // Arrange
      final paper = GameObject(
        id: 1,
        type: GameObjectType.paper,
        color: Colors.green,
        x: 100,
        y: 100,
        dx: 5,
        dy: 3,
      );
      final initialState = GameState.initial().copyWith(
        objects: [paper],
        rocksCount: 0,
        papersCount: 1,
        scissorsCount: 0,
      );

      final engine = RockPaperScissorsGameEngine(
        collisionDetector: MockCollisionDetector([]),
        objectFactory: MockObjectFactory([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final updatedState = engine.updateGame(
        initialState,
        const Size(800, 600),
      );

      // Assert
      expect(updatedState.status, equals(GameStatus.paperWins));
      expect(updatedState.paperTextColor, equals(Colors.green));
    });

    test('should detect scissor wins when only scissors remain', () {
      // Arrange
      final scissor = GameObject(
        id: 1,
        type: GameObjectType.scissor,
        color: Colors.blue,
        x: 100,
        y: 100,
        dx: 5,
        dy: 3,
      );
      final initialState = GameState.initial().copyWith(
        objects: [scissor],
        rocksCount: 0,
        papersCount: 0,
        scissorsCount: 1,
      );

      final engine = RockPaperScissorsGameEngine(
        collisionDetector: MockCollisionDetector([]),
        objectFactory: MockObjectFactory([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final updatedState = engine.updateGame(
        initialState,
        const Size(800, 600),
      );

      // Assert
      expect(updatedState.status, equals(GameStatus.scissorWins));
      expect(updatedState.scissorTextColor, equals(Colors.blue));
    });

    test('restartGame should return fresh initial state', () {
      // Arrange
      final testObjects = [
        GameObject(
          id: 1,
          type: GameObjectType.rock,
          color: Colors.red,
          x: 100,
          y: 100,
          dx: 1,
          dy: 1,
        ),
      ];
      final mockFactory = MockObjectFactory(testObjects);
      final engine = RockPaperScissorsGameEngine(
        objectFactory: mockFactory,
        collisionDetector: MockCollisionDetector([]),
        gameRules: MockGameRules((obj1, obj2) => obj1),
      );

      // Act
      final state = engine.restartGame(const Size(800, 600));

      // Assert
      expect(state.objects, equals(testObjects));
      expect(state.rocksCount, equals(3));
      expect(state.papersCount, equals(3));
      expect(state.scissorsCount, equals(3));
      expect(state.rocksWins, equals(0));
      expect(state.papersWins, equals(0));
      expect(state.scissorsWins, equals(0));
      expect(state.status, equals(GameStatus.playing));
    });
  });
}

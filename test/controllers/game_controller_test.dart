import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../lib/controllers/game_controller.dart';
import '../../lib/models/game_state.dart';
import '../../lib/models/object_model.dart';
import '../../lib/services/game_engine.dart';

class MockGameEngine implements GameEngine {
  GameState _currentState = GameState.initial();
  bool initializeCalled = false;
  bool updateCalled = false;
  bool restartCalled = false;

  @override
  GameState initializeGame(Size screenSize) {
    initializeCalled = true;
    _currentState = GameState.initial();
    return _currentState;
  }

  @override
  GameState updateGame(GameState currentState, Size screenSize) {
    updateCalled = true;
    return _currentState;
  }

  @override
  GameState restartGame(Size screenSize) {
    restartCalled = true;
    return _currentState;
  }

  void setMockState(GameState state) {
    _currentState = state;
  }
}

void main() {
  group('GameControllerImpl Tests', () {
    late MockGameEngine mockEngine;
    late GameController controller;
    const testScreenSize = Size(800, 600);

    setUp(() {
      Get.testMode = true;
      mockEngine = MockGameEngine();
      controller = GameControllerImpl(
        gameEngine: mockEngine,
        screenSize: testScreenSize,
      );
      controller.onInit();
    });

    tearDown(() {
      Get.reset();
    });

    test('should initialize game on creation', () {
      // Assert
      expect(
        mockEngine.initializeCalled,
        isTrue,
        reason: 'Initialize should be called',
      );
      expect(
        controller.currentState,
        isA<GameState>(),
        reason: 'Current state should be a GameState',
      );
      expect(
        controller.currentState,
        equals(GameState.initial()),
        reason: 'Current state should be initial',
      );
    });

    test('should restart game when restartGame is called', () {
      // Arrange
      final testState = GameState.initial().copyWith(rocksWins: 5);
      mockEngine.setMockState(testState);

      // Act
      controller.restartGame();

      // Assert
      expect(mockEngine.restartCalled, isTrue);
      expect(controller.currentState, equals(testState));
    });

    test('currentState should return current game state', () {
      // Arrange
      final testObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100,
        y: 100,
        dx: 1,
        dy: 1,
      );
      final testState = GameState.initial().copyWith(objects: [testObject]);
      mockEngine.setMockState(testState);

      // Act
      controller.restartGame(); // Trigger state update

      // Assert
      expect(controller.currentState.objects, contains(testObject));
    });
  });
}

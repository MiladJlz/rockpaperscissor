import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rockpaperscissor/models/game_state.dart';
import 'package:rockpaperscissor/models/object_model.dart';

void main() {
  group('GameState Tests', () {
    test('initial should create correct initial state', () {
      // Act
      final state = GameState.initial();

      // Assert
      expect(state.objects, isEmpty);
      expect(state.rocksCount, equals(3));
      expect(state.papersCount, equals(3));
      expect(state.scissorsCount, equals(3));
      expect(state.rocksWins, equals(0));
      expect(state.papersWins, equals(0));
      expect(state.scissorsWins, equals(0));
      expect(state.rockTextColor, equals(Colors.black));
      expect(state.paperTextColor, equals(Colors.black));
      expect(state.scissorTextColor, equals(Colors.black));
      expect(state.status, equals(GameStatus.playing));
    });

    test('copyWith should create new state with updated values', () {
      // Arrange
      final initialState = GameState.initial();
      final testObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100.0,
        y: 200.0,
        dx: 5.0,
        dy: -3.0,
      );

      // Act
      final updatedState = initialState.copyWith(
        objects: [testObject],
        rocksWins: 5,
        rockTextColor: Colors.red,
        status: GameStatus.rockWins,
      );

      // Assert
      expect(updatedState.objects, equals([testObject]));
      expect(updatedState.rocksWins, equals(5));
      expect(updatedState.rockTextColor, equals(Colors.red));
      expect(updatedState.status, equals(GameStatus.rockWins));
      // Unchanged values
      expect(updatedState.rocksCount, equals(3));
      expect(updatedState.papersCount, equals(3));
      expect(updatedState.scissorsCount, equals(3));
    });

    test('equality should work correctly', () {
      // Arrange
      final state1 = GameState.initial();
      final state2 = GameState.initial();
      final state3 = state1.copyWith(rocksWins: 1);

      // Assert
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('GameStatus Tests', () {
    test('should have correct enum values', () {
      expect(GameStatus.values.length, equals(4));
      expect(GameStatus.values, contains(GameStatus.playing));
      expect(GameStatus.values, contains(GameStatus.rockWins));
      expect(GameStatus.values, contains(GameStatus.paperWins));
      expect(GameStatus.values, contains(GameStatus.scissorWins));
    });
  });
}

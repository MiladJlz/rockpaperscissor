import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rockpaperscissor/models/object_model.dart';
import 'package:rockpaperscissor/services/game_rules.dart';

void main() {
  group('GameRulesImpl Tests', () {
    late GameRules gameRules;

    setUp(() {
      gameRules = GameRulesImpl();
    });

    test('rock should beat scissor', () {
      // Arrange
      final rock = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 0,
        y: 0,
        dx: 1,
        dy: 1,
      );
      final scissor = GameObject(
        id: 2,
        type: GameObjectType.scissor,
        color: Colors.blue,
        x: 0,
        y: 0,
        dx: 1,
        dy: 1,
      );

      // Act
      final winner1 = gameRules.determineWinner(rock, scissor);
      final winner2 = gameRules.determineWinner(scissor, rock);

      // Assert
      expect(winner1, equals(rock));
      expect(winner2, equals(rock));
    });

    test('paper should beat rock', () {
      // Arrange
      final paper = GameObject(
        id: 1,
        type: GameObjectType.paper,
        color: Colors.green,
        x: 0,
        y: 0,
        dx: 1,
        dy: 1,
      );
      final rock = GameObject(
        id: 2,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 0,
        y: 0,
        dx: 1,
        dy: 1,
      );

      // Act
      final winner1 = gameRules.determineWinner(paper, rock);
      final winner2 = gameRules.determineWinner(rock, paper);

      // Assert
      expect(winner1, equals(paper));
      expect(winner2, equals(paper));
    });

    test('scissor should beat paper', () {
      // Arrange
      final scissor = GameObject(
        id: 1,
        type: GameObjectType.scissor,
        color: Colors.blue,
        x: 0,
        y: 0,
        dx: 1,
        dy: 1,
      );
      final paper = GameObject(
        id: 2,
        type: GameObjectType.paper,
        color: Colors.green,
        x: 0,
        y: 0,
        dx: 1,
        dy: 1,
      );

      // Act
      final winner1 = gameRules.determineWinner(scissor, paper);
      final winner2 = gameRules.determineWinner(paper, scissor);

      // Assert
      expect(winner1, equals(scissor));
      expect(winner2, equals(scissor));
    });
  });
}

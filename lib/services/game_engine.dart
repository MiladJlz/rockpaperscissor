import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/object_model.dart';
import '../models/game_state.dart';
import 'collision_detector.dart';
import 'object_factory.dart';
import 'game_rules.dart';

abstract class GameEngine {
  GameState updateGame(GameState currentState, Size screenSize);
  GameState initializeGame(Size screenSize);
  GameState restartGame(Size screenSize);
}

class RockPaperScissorsGameEngine implements GameEngine {
  final CollisionDetector _collisionDetector;
  final ObjectFactory _objectFactory;
  final GameRules _gameRules;
  final int speed;

  RockPaperScissorsGameEngine({
    CollisionDetector? collisionDetector,
    ObjectFactory? objectFactory,
    GameRules? gameRules,
    this.speed = 10,
  }) : _collisionDetector = collisionDetector ?? CollisionDetectorImpl(),
       _objectFactory = objectFactory ?? ObjectFactoryImpl(),
       _gameRules = gameRules ?? GameRulesImpl();

  @override
  GameState initializeGame(Size screenSize) {
    final objects = _objectFactory.createInitialObjects(
      rocksCount: 3,
      papersCount: 3,
      scissorsCount: 3,
      screenSize: screenSize,
      speed: speed,
    );

    return GameState.initial().copyWith(objects: objects);
  }

  @override
  GameState updateGame(GameState currentState, Size screenSize) {
    var updatedState = _updateObjectPositions(currentState, screenSize);
    updatedState = _processCollisions(updatedState);
    updatedState = _checkWinner(updatedState);
    return updatedState;
  }

  @override
  GameState restartGame(Size screenSize) {
    return initializeGame(screenSize);
  }

  GameState _updateObjectPositions(GameState state, Size screenSize) {
    final updatedObjects =
        state.objects.map((obj) {
          var newX = obj.x + obj.dx;
          var newY = obj.y + obj.dy;
          var newDx = obj.dx;
          var newDy = obj.dy;

          // Boundary collision
          if (newX < 0 || newX > screenSize.width) {
            newDx *= -1;
            newX = obj.x + newDx;
          }
          if (newY < 0 || newY > screenSize.height) {
            newDy *= -1;
            newY = obj.y + newDy;
          }

          return obj.copyWith(x: newX, y: newY, dx: newDx, dy: newDy);
        }).toList();

    return state.copyWith(objects: updatedObjects);
  }

  GameState _processCollisions(GameState state) {
    final collisionResults = _collisionDetector.detectCollisions(state.objects);

    var updatedObjects = List<GameObject>.from(state.objects);
    var rocksCount = state.rocksCount;
    var papersCount = state.papersCount;
    var scissorsCount = state.scissorsCount;
    var rocksWins = state.rocksWins;
    var papersWins = state.papersWins;
    var scissorsWins = state.scissorsWins;

    for (final collision in collisionResults) {
      if (collision.obj1.type == collision.obj2.type) {
        // Same type collision - bounce off each other
        final obj1Index = updatedObjects.indexWhere(
          (obj) => obj.id == collision.obj1.id,
        );
        final obj2Index = updatedObjects.indexWhere(
          (obj) => obj.id == collision.obj2.id,
        );

        if (obj1Index != -1 && obj2Index != -1) {
          final tempDx = updatedObjects[obj1Index].dx;
          final tempDy = updatedObjects[obj1Index].dy;
          updatedObjects[obj1Index] = updatedObjects[obj1Index].copyWith(
            dx: updatedObjects[obj2Index].dx,
            dy: updatedObjects[obj2Index].dy,
          );
          updatedObjects[obj2Index] = updatedObjects[obj2Index].copyWith(
            dx: tempDx,
            dy: tempDy,
          );
        }
      } else {
        final winner = _gameRules.determineWinner(
          collision.obj1,
          collision.obj2,
        );
        final loser =
            winner == collision.obj1 ? collision.obj2 : collision.obj1;

        switch (winner.type) {
          case GameObjectType.rock:
            rocksWins++;
            break;
          case GameObjectType.paper:
            papersWins++;
            break;
          case GameObjectType.scissor:
            scissorsWins++;
            break;
        }

        switch (loser.type) {
          case GameObjectType.rock:
            rocksCount--;
            break;
          case GameObjectType.paper:
            papersCount--;
            break;
          case GameObjectType.scissor:
            scissorsCount--;
            break;
        }

        updatedObjects.removeWhere((obj) => obj.id == loser.id);
        final winnerIndex = updatedObjects.indexWhere(
          (obj) => obj.id == winner.id,
        );
        if (winnerIndex != -1) {
          updatedObjects[winnerIndex] = updatedObjects[winnerIndex].copyWith(
            dx: -updatedObjects[winnerIndex].dx,
            dy: -updatedObjects[winnerIndex].dy,
          );
        }
      }
    }

    return state.copyWith(
      objects: updatedObjects,
      rocksCount: rocksCount,
      papersCount: papersCount,
      scissorsCount: scissorsCount,
      rocksWins: rocksWins,
      papersWins: papersWins,
      scissorsWins: scissorsWins,
    );
  }

  GameState _checkWinner(GameState state) {
    if (state.papersCount == 0 && state.scissorsCount == 0) {
      return state.copyWith(
        rockTextColor: Colors.red,
        status: GameStatus.rockWins,
      );
    } else if (state.rocksCount == 0 && state.scissorsCount == 0) {
      return state.copyWith(
        paperTextColor: Colors.green,
        status: GameStatus.paperWins,
      );
    } else if (state.papersCount == 0 && state.rocksCount == 0) {
      return state.copyWith(
        scissorTextColor: Colors.blue,
        status: GameStatus.scissorWins,
      );
    }
    return state;
  }
}

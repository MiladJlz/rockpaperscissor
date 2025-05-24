import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../models/game_state.dart';
import '../services/game_engine.dart';

abstract class GameController extends GetxController
    with GetTickerProviderStateMixin {
  GameState get currentState;
  void restartGame();

  void updateScreenSize(Size newSize);
}

class GameControllerImpl extends GameController {
  final GameEngine _gameEngine;
  Size _screenSize;

  late Ticker _ticker;
  final Rx<GameState> _gameState = GameState.initial().obs;

  GameControllerImpl({required GameEngine gameEngine, required Size screenSize})
    : _gameEngine = gameEngine,
      _screenSize = screenSize;

  @override
  GameState get currentState => _gameState.value;

  @override
  void onInit() {
    super.onInit();
    _ticker = createTicker(_onTick);
    _initializeGame();
    _ticker.start();
  }

  @override
  void onClose() {
    _ticker.dispose();
    super.onClose();
  }

  void _initializeGame() {
    _gameState.value = _gameEngine.initializeGame(_screenSize);
  }

  void _onTick(Duration duration) {
    _gameState.value = _gameEngine.updateGame(_gameState.value, _screenSize);
  }

  @override
  void restartGame() {
    _gameState.value = _gameEngine.restartGame(_screenSize);
  }

  @override
  void updateScreenSize(Size newSize) {
    _screenSize = newSize;
    _gameState.value = _gameEngine.updateGame(_gameState.value, _screenSize);
  }
}

import 'package:flutter/material.dart';
import 'object_model.dart';

class GameState {
  final List<GameObject> objects;
  final int rocksCount;
  final int papersCount;
  final int scissorsCount;
  final int rocksWins;
  final int papersWins;
  final int scissorsWins;
  final Color rockTextColor;
  final Color paperTextColor;
  final Color scissorTextColor;
  final GameStatus status;

  const GameState({
    required this.objects,
    required this.rocksCount,
    required this.papersCount,
    required this.scissorsCount,
    required this.rocksWins,
    required this.papersWins,
    required this.scissorsWins,
    required this.rockTextColor,
    required this.paperTextColor,
    required this.scissorTextColor,
    required this.status,
  });

  factory GameState.initial() {
    return const GameState(
      objects: [],
      rocksCount: 3,
      papersCount: 3,
      scissorsCount: 3,
      rocksWins: 0,
      papersWins: 0,
      scissorsWins: 0,
      rockTextColor: Colors.black,
      paperTextColor: Colors.black,
      scissorTextColor: Colors.black,
      status: GameStatus.playing,
    );
  }

  GameState copyWith({
    List<GameObject>? objects,
    int? rocksCount,
    int? papersCount,
    int? scissorsCount,
    int? rocksWins,
    int? papersWins,
    int? scissorsWins,
    Color? rockTextColor,
    Color? paperTextColor,
    Color? scissorTextColor,
    GameStatus? status,
  }) {
    return GameState(
      objects: objects ?? this.objects,
      rocksCount: rocksCount ?? this.rocksCount,
      papersCount: papersCount ?? this.papersCount,
      scissorsCount: scissorsCount ?? this.scissorsCount,
      rocksWins: rocksWins ?? this.rocksWins,
      papersWins: papersWins ?? this.papersWins,
      scissorsWins: scissorsWins ?? this.scissorsWins,
      rockTextColor: rockTextColor ?? this.rockTextColor,
      paperTextColor: paperTextColor ?? this.paperTextColor,
      scissorTextColor: scissorTextColor ?? this.scissorTextColor,
      status: status ?? this.status,
    );
  }


  
}

enum GameStatus { playing, rockWins, paperWins, scissorWins }
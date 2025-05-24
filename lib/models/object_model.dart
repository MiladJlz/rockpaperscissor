import 'dart:ui';

class GameObject {
  final int id;
  final Color color;
  final GameObjectType type;
  double x;
  double y;
  double dx;
  double dy;

  GameObject({
    required this.id,
    required this.type,
    required this.color,
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
  });

  GameObject copyWith({
    int? id,
    GameObjectType? type,
    Color? color,
    double? x,
    double? y,
    double? dx,
    double? dy,
  }) {
    return GameObject(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
      x: x ?? this.x,
      y: y ?? this.y,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
    );
  }

 
}

enum GameObjectType { rock, paper, scissor }

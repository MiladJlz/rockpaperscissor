import 'dart:math';
import '../models/object_model.dart';

class Collision {
  final GameObject obj1;
  final GameObject obj2;

  const Collision(this.obj1, this.obj2);

}

abstract class CollisionDetector {
  List<Collision> detectCollisions(List<GameObject> objects);
}

class CollisionDetectorImpl implements CollisionDetector {
  final double collisionDistance;

  CollisionDetectorImpl({this.collisionDistance = 60.0});

  @override
  List<Collision> detectCollisions(List<GameObject> objects) {
    final collisions = <Collision>[];

    for (var i = 0; i < objects.length; i++) {
      for (var j = i + 1; j < objects.length; j++) {
        final obj1 = objects[i];
        final obj2 = objects[j];

        final distance = sqrt(
          pow(obj1.x - obj2.x, 2) + pow(obj1.y - obj2.y, 2),
        );

        if (distance <= collisionDistance) {
          collisions.add(Collision(obj1, obj2));
        }
      }
    }

    return collisions;
  }
}

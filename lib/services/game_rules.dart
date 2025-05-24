import '../models/object_model.dart';

abstract class GameRules {
  GameObject determineWinner(GameObject obj1, GameObject obj2);
}

class GameRulesImpl implements GameRules {
  @override
  GameObject determineWinner(GameObject obj1, GameObject obj2) {
    if ((obj1.type == GameObjectType.rock && obj2.type == GameObjectType.scissor) ||
        (obj1.type == GameObjectType.paper && obj2.type == GameObjectType.rock) ||
        (obj1.type == GameObjectType.scissor && obj2.type == GameObjectType.paper)) {
      return obj1;
    } else {
      return obj2;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rockpaperscissor/models/object_model.dart';
import 'package:rockpaperscissor/widgets/game_object_widget.dart';

void main() {
  group('GameObjectWidget Tests', () {
    testWidgets('should display game object with correct properties', (
      WidgetTester tester,
    ) async {
      // Arrange
      final gameObject = GameObject(
        id: 1,
        type: GameObjectType.rock,
        color: Colors.red,
        x: 100,
        y: 200,
        dx: 5,
        dy: 5,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(children: [GameObjectWidget(gameObject: gameObject)]),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(of: find.text('rock'), matching: find.byType(Container)),
      );

      // Check position
      final positioned = tester.widget<Positioned>(
        find.ancestor(
          of: find.byType(Container),
          matching: find.byType(Positioned),
        ),
      );
      expect(positioned.left, equals(100.5)); // x + 0.5
      expect(positioned.top, equals(200.5)); // y + 0.5

      // Check container properties
      expect(container.constraints?.maxWidth, equals(60));
      expect(container.constraints?.maxHeight, equals(60));

      // Check decoration
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.red));
      expect(decoration.border, isA<Border>());

      // Check text
      final text = tester.widget<Text>(find.text('rock'));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
      expect(text.style?.fontSize, equals(12));
    });

    testWidgets('should display different game object types correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final gameObjects = [
        GameObject(
          id: 1,
          type: GameObjectType.rock,
          color: Colors.red,
          x: 100,
          y: 100,
          dx: 5,
          dy: 5,
        ),
        GameObject(
          id: 2,
          type: GameObjectType.paper,
          color: Colors.green,
          x: 200,
          y: 200,
          dx: 5,
          dy: 5,
        ),
        GameObject(
          id: 3,
          type: GameObjectType.scissor,
          color: Colors.blue,
          x: 300,
          y: 300,
          dx: 5,
          dy: 5,
        ),
      ];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children:
                  gameObjects
                      .map((obj) => GameObjectWidget(gameObject: obj))
                      .toList(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('rock'), findsOneWidget);
      expect(find.text('paper'), findsOneWidget);
      expect(find.text('scissor'), findsOneWidget);

      // Check colors
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorations =
          containers.map((c) => (c.decoration as BoxDecoration).color).toList();
      expect(decorations, contains(Colors.red));
      expect(decorations, contains(Colors.green));
      expect(decorations, contains(Colors.blue));
    });
  });
}

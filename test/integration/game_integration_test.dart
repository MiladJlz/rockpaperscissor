import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rockpaperscissor/controllers/game_controller.dart';
import 'package:rockpaperscissor/models/game_state.dart';
import 'package:rockpaperscissor/screens/game_screen.dart';

void main() {
  group('Game Integration Tests', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('complete game flow integration', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const GameScreen());
      await tester.pump(); // Wait for initial build

      // Assert - Initial state
      expect(find.text('Rock!'), findsOneWidget);
      expect(find.text('Paper!'), findsOneWidget);
      expect(find.text('Scissor!'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Act - Tap restart button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump(); // Wait for restart

      // Assert - Game should restart
      expect(find.text('🪨 : 0'), findsOneWidget);
      expect(find.text('📄 : 0'), findsOneWidget);
      expect(find.text('✂️ : 0'), findsOneWidget);

      // Cleanup
      await tester.pumpWidget(Container()); // Remove the widget
      await tester.pump(); // Wait for cleanup
    });

    testWidgets('should display game objects on screen', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const GameScreen());
      await tester.pump(); // Wait for initial build

      // Assert - Should find game object texts
      expect(find.text('rock'), findsWidgets);
      expect(find.text('paper'), findsWidgets);
      expect(find.text('scissor'), findsWidgets);

      // Cleanup
      await tester.pumpWidget(Container()); // Remove the widget
      await tester.pump(); // Wait for cleanup
    });

    testWidgets('should handle game state updates', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const GameScreen());
      await tester.pump(); // Wait for initial build

      final controller = Get.find<GameController>();

      // Act - Multiple frame updates to simulate game progression
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Assert - Game should still be running
      expect(controller.currentState, isA<GameState>());
      expect(controller.currentState.objects, isNotEmpty);

      // Cleanup
      await tester.pumpWidget(Container()); // Remove the widget
      await tester.pump(); // Wait for cleanup
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/widgets/score_widget.dart';

void main() {
  group('ScoreWidget Tests', () {
    testWidgets('should display emoji and score correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreWidget(
              emoji: '🪨',
              score: 5,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('🪨 : 5'), findsOneWidget);
    });

    testWidgets('should display zero score correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreWidget(
              emoji: '📄',
              score: 0,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('📄 : 0'), findsOneWidget);
    });

    testWidgets('should have correct text styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScoreWidget(
              emoji: '✂️',
              score: 10,
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('✂️ : 10'));
      expect(textWidget.style?.fontSize, equals(16));
      expect(textWidget.style?.fontWeight, equals(FontWeight.w500));
    });
  });
}

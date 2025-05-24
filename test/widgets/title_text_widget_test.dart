import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rockpaperscissor/widgets/title_text_widget.dart';

void main() {
  group('TitleTextWidget Tests', () {
    testWidgets('should display text with correct style', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TitleTextWidget(text: 'Rock!', color: Colors.red),
          ),
        ),
      );

      // Assert
      expect(find.text('Rock!'), findsOneWidget);

      final textWidget = tester.widget<Text>(find.text('Rock!'));
      expect(textWidget.style?.fontSize, equals(50));
      expect(textWidget.style?.fontStyle, equals(FontStyle.italic));
      expect(textWidget.style?.color, equals(Colors.red));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should display different colors correctly', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TitleTextWidget(text: 'Paper!', color: Colors.green),
                TitleTextWidget(text: 'Scissor!', color: Colors.blue),
              ],
            ),
          ),
        ),
      );

      // Assert
      final paperText = tester.widget<Text>(find.text('Paper!'));
      final scissorText = tester.widget<Text>(find.text('Scissor!'));

      expect(paperText.style?.color, equals(Colors.green));
      expect(scissorText.style?.color, equals(Colors.blue));
    });
  });
}

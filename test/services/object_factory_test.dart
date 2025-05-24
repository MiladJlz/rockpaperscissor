import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/object_model.dart';
import '../../lib/services/object_factory.dart';

class MockRandom implements Random {
  final double _fixedValue;
  MockRandom(this._fixedValue);

  @override
  double nextDouble() => _fixedValue;

  @override
  bool nextBool() => throw UnimplementedError();

  @override
  int nextInt(int max) => (_fixedValue * max).floor();
}

void main() {
  group('ObjectFactoryImpl Tests', () {
    test('should create correct number of objects', () {
      // Arrange
      final factory = ObjectFactoryImpl(random: MockRandom(0.5));
      const screenSize = Size(800, 600);

      // Act
      final objects = factory.createInitialObjects(
        rocksCount: 2,
        papersCount: 3,
        scissorsCount: 1,
        screenSize: screenSize,
        speed: 10,
      );

      // Assert
      expect(objects.length, equals(6)); // 2 + 3 + 1

      final rocks =
          objects.where((obj) => obj.type == GameObjectType.rock).toList();
      final papers =
          objects.where((obj) => obj.type == GameObjectType.paper).toList();
      final scissors =
          objects.where((obj) => obj.type == GameObjectType.scissor).toList();

      expect(rocks.length, equals(2));
      expect(papers.length, equals(3));
      expect(scissors.length, equals(1));
    });

    test('should create objects with correct colors', () {
      // Arrange
      final factory = ObjectFactoryImpl(random: MockRandom(0.5));
      const screenSize = Size(800, 600);

      // Act
      final objects = factory.createInitialObjects(
        rocksCount: 1,
        papersCount: 1,
        scissorsCount: 1,
        screenSize: screenSize,
        speed: 10,
      );

      // Assert
      final rock = objects.firstWhere((obj) => obj.type == GameObjectType.rock);
      final paper = objects.firstWhere(
        (obj) => obj.type == GameObjectType.paper,
      );
      final scissor = objects.firstWhere(
        (obj) => obj.type == GameObjectType.scissor,
      );

      expect(rock.color, equals(Colors.red));
      expect(paper.color, equals(Colors.green));
      expect(scissor.color, equals(Colors.blue));
    });

    test('should create objects with unique IDs', () {
      // Arrange
      final factory = ObjectFactoryImpl(random: MockRandom(0.5));
      const screenSize = Size(800, 600);

      // Act
      final objects = factory.createInitialObjects(
        rocksCount: 2,
        papersCount: 2,
        scissorsCount: 2,
        screenSize: screenSize,
        speed: 10,
      );

      // Assert
      final ids = objects.map((obj) => obj.id).toSet();
      expect(ids.length, equals(objects.length)); // All IDs should be unique
    });

    test('should create objects within screen bounds', () {
      // Arrange
      final factory = ObjectFactoryImpl(random: MockRandom(0.5));
      const screenSize = Size(800, 600);

      // Act
      final objects = factory.createInitialObjects(
        rocksCount: 3,
        papersCount: 3,
        scissorsCount: 3,
        screenSize: screenSize,
        speed: 10,
      );

      // Assert
      for (final obj in objects) {
        expect(obj.x, greaterThanOrEqualTo(0));
        expect(obj.x, lessThanOrEqualTo(screenSize.width - 60));
        expect(obj.y, greaterThanOrEqualTo(0));
        expect(obj.y, lessThanOrEqualTo(screenSize.height - 60));
      }
    });

    test(
      'should create objects with predictable positions when using mock random',
      () {
        // Arrange
        final factory = ObjectFactoryImpl(
          random: MockRandom(0.6),
        ); // Fixed value
        const screenSize = Size(800, 600);

        // Act
        final objects = factory.createInitialObjects(
          rocksCount: 1,
          papersCount: 0,
          scissorsCount: 0,
          screenSize: screenSize,
          speed: 10,
        );

        // Assert
        final rock = objects.first;
        // With rand1 = rand2 = 0.6 * 0.6 + 0.2 = 0.56
        // cellWidth = 800 - 60 = 740
        // cellHeight = 600 - 60 = 540
        expect(rock.x, closeTo(414.4, 0.0001)); // 0.56 * 740
        expect(rock.y, closeTo(302.4, 0.0001)); // 0.56 * 540
        // With speed = 10, dx = (0.6 - 0.5) * 10 = 1.0
        expect(rock.dx, closeTo(1.0, 0.0001));
        expect(rock.dy, closeTo(1.0, 0.0001));
      },
    );
  });
}

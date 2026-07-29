import 'dart:math';
import 'dart:ui';

import 'package:wordzoo/data/models/category.dart';
import 'package:wordzoo/data/models/subcategory.dart';

class CategoryMapLayout {
  final Random random;

  /// Kích thước toàn bộ map
  final Size mapSize;

  /// Kích thước của mỗi Category widget
  final Size nodeSize;

  /// Khoảng cách tới mép map
  final double margin;

  /// Khoảng cách tối thiểu giữa các node
  final double safeSpacing;

  /// Số lần thử tối đa để tìm vị trí hợp lệ
  final int maxAttempts;

  CategoryMapLayout({
    required this.mapSize,
    required this.nodeSize,
    this.margin = 24,
    this.safeSpacing = 20,
    this.maxAttempts = 100,
    int seed = 100,
  }) : random = Random(seed);

  List<CategoryLayout> generate(List<Subcategory> categories) {
    final layouts = <CategoryLayout>[];

    for (final category in categories) {
      Offset? position;

      int attempts = 0;

      while (attempts < maxAttempts) {
        attempts++;

        final candidate = _generateRandomPosition();

        if (!_isOverlap(candidate, layouts)) {
          position = candidate;
          break;
        }
      }

      // Nếu không tìm được thì vẫn đặt node cuối cùng
      position ??= _generateRandomPosition();

      layouts.add(
        CategoryLayout(
          category: category,
          position: position,
        ),
      );
    }

    return layouts;
  }

  Offset _generateRandomPosition() {
    final maxX =
        mapSize.width - nodeSize.width - margin;

    final maxY =
        mapSize.height - nodeSize.height - margin;

    final x =
        margin + random.nextDouble() * (maxX - margin);

    final y =
        margin + random.nextDouble() * (maxY - margin);

    return Offset(x, y);
  }

  bool _isOverlap(
      Offset position,
      List<CategoryLayout> layouts,
      ) {
    final current = Rect.fromLTWH(
      position.dx - safeSpacing,
      position.dy - safeSpacing,
      nodeSize.width + safeSpacing * 2,
      nodeSize.height + safeSpacing * 2,
    );

    for (final layout in layouts) {
      final other = Rect.fromLTWH(
        layout.position.dx,
        layout.position.dy,
        nodeSize.width,
        nodeSize.height,
      );

      if (current.overlaps(other)) {
        return true;
      }
    }

    return false;
  }
}
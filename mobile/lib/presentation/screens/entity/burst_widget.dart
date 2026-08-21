import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordzoo/base/resizer/size_manager.dart';

import 'gift_drop_controller.dart';

class BurstWidget extends StatelessWidget {
  const BurstWidget({
    super.key,
    required this.controller,
  });

  final GiftDropController controller;

  @override
  Widget build(BuildContext context) {

    if (!controller.showEntity) {
      return const SizedBox();
    }

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (_, constraints) {

          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          final center = Offset(
            controller.giftX * w,
            controller.giftY * h,
          );

          return CustomPaint(
            painter: BurstPainter(
              center: center,
              progress: controller.entityOpacity,
            ),
          );
        },
      ),
    );
  }
}

class BurstPainter extends CustomPainter {

  BurstPainter({
    required this.center,
    required this.progress,
  });

  final Offset center;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final count = Dimens().spacing16;

    final radius = Dimens().spacing48 * progress;

    for (int i = 0; i < count; i++) {

      final angle =
          pi * 2 * i / count;

      final start = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      final end = Offset(
        center.dx + cos(angle) * (radius + Dimens().spacing16),
        center.dy + sin(angle) * (radius + Dimens().spacing16),
      );

      paint
        ..strokeWidth = 3
        ..color = Colors.yellow.withOpacity(
          1 - progress,
        );

      canvas.drawLine(
        start,
        end,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BurstPainter oldDelegate) {
    return true;
  }
}
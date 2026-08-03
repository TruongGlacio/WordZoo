import 'package:flutter/material.dart';

import 'gift_drop_controller.dart';

class GiftBoxWidget extends StatelessWidget {
  const GiftBoxWidget({
    super.key,
    required this.controller,
    required this.frames,
  });

  final GiftDropController controller;
  final List<ImageProvider> frames;

  @override
  Widget build(BuildContext context) {

    if (!controller.giftVisible) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (_, constraints) {

        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final giftSize = w * 0.22;

        final left =
            controller.giftX * w - giftSize / 2;

        final top =
            controller.giftY * h - giftSize / 2;

        final image = controller.currentFrame < frames.length
            ? frames[controller.currentFrame]
            : frames.last;

        return Stack(
          children: [

            Positioned(
              left: left,
              top: top,
              child: SizedBox(
                width: giftSize,
                height: giftSize,
                child: Transform.rotate(
                  angle: controller.giftRotation,
                  child: Image(
                    image: image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

          ],
        );
      },
    );
  }
}
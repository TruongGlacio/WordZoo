import 'package:flutter/material.dart';

import 'gift_drop_controller.dart';

class EntityRevealWidget extends StatelessWidget {
  const EntityRevealWidget({
    super.key,
    required this.controller,
    required this.image,
  });

  final GiftDropController controller;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {

    if (!controller.showEntity) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (_, constraints) {

        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final size = w * 0.42;

        final left =
            controller.giftX * w - size / 2;

        final top =
            controller.giftY * h - size / 2;

        return Stack(
          children: [

            Positioned(
              left: left,
              top: top,
              child: Opacity(
                opacity: controller.entityOpacity,
                child: Transform.scale(
                  scale: controller.entityScale,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.25),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Image(
                      image: image,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
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
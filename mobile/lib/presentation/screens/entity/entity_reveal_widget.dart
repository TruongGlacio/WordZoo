import 'package:flutter/material.dart';
import 'package:wordzoo/utils/size_manager.dart';

import 'gift_drop_controller.dart';

class EntityRevealWidget extends StatelessWidget {
  const EntityRevealWidget({
    super.key,
    required this.controller,
    required this.image,
  });

  final GiftDropController controller;
  final Widget image;

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

        final left = controller.giftX * w - size / 2;

        final top = controller.giftY * h - size / 2;

        return Visibility(
          visible: controller.giftVisible,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: SafeArea(
                  //padding: const EdgeInsets.only(top: 32),
                  child: Opacity(
                    opacity: controller.entityOpacity,
                    child: Transform.scale(
                      scale: controller.entityScale,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        height: MediaQuery.of(context).size.width * 0.16,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withValues(alpha: 0.25),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: image,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}
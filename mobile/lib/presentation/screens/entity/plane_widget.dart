import 'package:flutter/material.dart';
import 'package:wordzoo/generated/assets.dart';
import 'package:wordzoo/base/resizer/size_manager.dart';

import 'gift_drop_controller.dart';

class PlaneWidget extends StatelessWidget {
  const PlaneWidget({
    super.key,
    required this.controller,
  });

  final GiftDropController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.state == GiftAnimationState.finished) {
      return const SizedBox();
    }

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (_, constraints) {

          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          final planeWidth = w * 0.35;
          final planeHeight = planeWidth * 0.55;

          final x = controller.planeX * w;
          final y = controller.planeY * h;

          return Stack(
            children: [
              //----------------------------------------------------
              // Plane
              //----------------------------------------------------
              Positioned(
                left: x,
                top: y,
                child: SizedBox(
                  child: Image.asset(
                    Assets.assets.icons.flight.path,
                    width: Dimens().imageXLarge,
                    height:  Dimens().imageXLarge,
                    fit: BoxFit.contain,
                  ),
                )
              ),
            ],
          );
        },
      ),
    );
  }
}
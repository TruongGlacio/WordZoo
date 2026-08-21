import 'package:flutter/material.dart';
import 'package:wordzoo/base/resizer/size_manager.dart';

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

        double left = controller.giftX * w - giftSize / 2;
        if(left<w/2 -giftSize/4) {
          left = w/2 - giftSize/4;
        }

        double top = controller.giftY * h - giftSize / 2;
         if(top<=Dimens().spacing32)
           {top=Dimens().spacing32;}

        final image = controller.currentFrame < frames.length
            ? frames[controller.currentFrame]
            : frames.last;

        //print('left:$left, top:$top');
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: left,
              top: top,
              child: Image(
                image: image,
                width: Dimens().spacing128,
                height: Dimens().spacing128,
                fit: BoxFit.contain,
              ),
            ),

          ],
        );
      },
    );
  }
}
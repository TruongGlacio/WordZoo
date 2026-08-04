import 'package:flutter/material.dart';

import 'entity_reveal_widget.dart';
import 'gift_box_widget.dart';
import 'gift_drop_controller.dart';
import 'plane_widget.dart';
import 'burst_widget.dart';

class GiftDropAnimation extends StatefulWidget {
  const GiftDropAnimation({super.key, required this.frames, required this.entityImage, this.width = 220, this.height = 220, this.onFinished});

  /// 16 frame hộp quà
  final List<ImageProvider> frames;

  /// ảnh entity cuối cùng
  final Widget entityImage;

  final double width;
  final double height;

  final VoidCallback? onFinished;

  @override
  State<GiftDropAnimation> createState() => GiftDropAnimationState();
}

class GiftDropAnimationState extends State<GiftDropAnimation> with TickerProviderStateMixin {
  late GiftDropController controller;

  @override
  void initState() {
    super.initState();

    controller = GiftDropController(vsync: this, frameCount: widget.frames.length);

    controller.start();

    controller.completed.addListener(() {
      if (controller.completed.value) {
        widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void play() {
    controller.play(widget.entityImage);
  }
  void playCustom(Widget image) {

    controller.play(image);

  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              //--------------------------------------------------
              // Plane
              //--------------------------------------------------
              PlaneWidget(controller: controller),

              //--------------------------------------------------
              // Gift Box
              //--------------------------------------------------
              GiftBoxWidget(controller: controller, frames: widget.frames),
              BurstWidget(controller: controller),

              //--------------------------------------------------
              // Entity
              //--------------------------------------------------
             // EntityRevealWidget(controller: controller, image: widget.entityImage),
            ],
          );
        },
      ),
    );
  }
}
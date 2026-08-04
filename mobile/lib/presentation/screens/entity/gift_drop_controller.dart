import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum GiftAnimationState {
  flying,
  dropping,
  opening,
  reveal,
  finished,
}

class GiftDropController extends ChangeNotifier {

  GiftDropController({
    required TickerProvider vsync,
    required this.frameCount,
  }) {

    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 4800),
    );

    _controller.addListener(_update);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        completed.value = true;
      }
    });
  }

  //------------------------------------------------------------
  // Timeline
  //------------------------------------------------------------

  static const double planeEnd = 0.32;

  static const double giftEnd = 0.62;

  static const double openEnd = 0.80;
  double planeRotation = 0;
  double giftRotation = 0;
  //------------------------------------------------------------

  final int frameCount;

  late final AnimationController _controller;

  AnimationController get animation => _controller;

  final ValueNotifier<bool> completed =
  ValueNotifier(false);

  GiftAnimationState state = GiftAnimationState.flying;
  Widget? entityImage;
  //------------------------------------------------------------
  // Plane
  //------------------------------------------------------------

  double planeX = 1.0;

  double planeY = 0.10;

  //------------------------------------------------------------
  // Gift
  //------------------------------------------------------------

  bool giftVisible = true;

  double giftX = 0;

  double giftY = 0;

  //------------------------------------------------------------
  // Sprite
  //------------------------------------------------------------
  /// vị trí bắt đầu rơi
  double dropStartX = 0;
  double dropStartY = 0;

  /// đã tách khỏi máy bay chưa
  bool dropped = false;
  int currentFrame = 0;

  //------------------------------------------------------------
  // Entity
  //------------------------------------------------------------

  bool showEntity = false;

  double entityScale = 0;

  double entityOpacity = 0;

  //------------------------------------------------------------

  void start() {

    completed.value = false;

    giftVisible = true;

    showEntity = false;

    currentFrame = 0;

    entityScale = 0;

    entityOpacity = 0;

    dropped = false;

    state = GiftAnimationState.flying;

    _controller.forward(from: 0);
  }
  void play(Widget image) {

    entityImage = image;

    start();

  }
  //------------------------------------------------------------

  void _update() {

    final t = _controller.value;

    //--------------------------------------------------------
    // Plane
    //--------------------------------------------------------
//--------------------------------------------------------
// Plane bay
//--------------------------------------------------------
    planeRotation = sin(t * 30) * 0.04;
    if (t <= planeEnd) {

      state = GiftAnimationState.flying;

      final p = t / planeEnd;

      planeX = lerpDouble(
        1.15,
        -0.15,
        p,
      )!;

      planeY = 0.15;
      // Máy bay rung nhẹ
      planeRotation = sin(t * 30) * 0.04;
      if (!dropped) {

        giftX = planeX + 0.18;

        giftY = planeY + 0.12;

      }

    }

//--------------------------------------------------------
// Gift rơi
//--------------------------------------------------------

    else if (t <= giftEnd) {

      if (!dropped) {

        dropped = true;

        dropStartX = giftX;

        dropStartY = giftY;

      }

      state = GiftAnimationState.dropping;

      //----------------------------------------------------
      // máy bay vẫn bay tiếp
      //----------------------------------------------------

      final planeProgress =
          (t - planeEnd) /
              (1 - planeEnd);

      planeX = lerpDouble(
        planeX,
        -0.35,
        planeProgress,
      )!;

      //----------------------------------------------------
      // hộp quà rơi
      //----------------------------------------------------

      final p =
          (t - planeEnd) /
              (giftEnd - planeEnd);
      giftRotation = lerpDouble(
        0.15,
        1.2,
        p,
      )!;
      giftX = dropStartX;

      giftY = lerpDouble(
        dropStartY,
        0.72,
        Curves.easeIn.transform(p),
      )!;

    }

    //--------------------------------------------------------
    // Open Box
    //--------------------------------------------------------

    else if (t <= openEnd) {

      state = GiftAnimationState.opening;

      final p =
          (t - giftEnd) /
              (openEnd - giftEnd);

      currentFrame =
          (p * (frameCount - 1))
              .floor()
              .clamp(
            0,
            frameCount - 1,
          );

    }

    //--------------------------------------------------------
    // Reveal
    //--------------------------------------------------------

    else {

      state = GiftAnimationState.reveal;

      giftVisible = false;

      showEntity = true;

      final p =
          (t - openEnd) /
              (1 - openEnd);

      entityOpacity = Curves.easeOut.transform(
        p,
      );

      entityScale = Tween<double>(
        begin: 0.25,
        end: 1,
      ).transform(
        Curves.easeOutBack.transform(p),
      );

    }

    notifyListeners();

  }

  //------------------------------------------------------------

  @override
  void dispose() {

    completed.dispose();

    _controller.dispose();

    super.dispose();

  }

}
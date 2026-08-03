import 'package:flutter/cupertino.dart';

enum GiftState {

  flying,

  dropping,

  opening,

  reveal,

  finish,

}
class GiftAnimationData {

  final List<ImageProvider> frames;

  final ImageProvider entityImage;
  GiftAnimationData({required this.frames, required this.entityImage});

}
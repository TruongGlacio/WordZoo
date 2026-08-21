import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import '../../base/resizer/size_manager.dart';

class ProgressBarWidget extends StatelessWidget {
  final int learned;
  final int total;

  const ProgressBarWidget({
    super.key,
    required this.learned,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? learned / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$learned/$total',
          style: TextStyleConstant.small,
        ),
        Gap(Dimens().spacingSmall),
        LinearProgressIndicator(
          value: progress,
          minHeight: Dimens().spacingSmall,
          borderRadius: BorderRadius.circular(Dimens().borderRadiusSmall),
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation<Color>(ColorConst.leafGreen),
        ),
      ],
    );
  }
}

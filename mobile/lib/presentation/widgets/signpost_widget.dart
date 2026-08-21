import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import '../../base/resizer/size_manager.dart';

class SignpostWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SignpostWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 80,
        decoration: BoxDecoration(
          color: ColorConst.earthBrown,
          borderRadius: BorderRadius.circular(Dimens().borderRadiusSmall),
          border: Border.all(color: ColorConst.earthBrown, width: 4),
          boxShadow: const [
            BoxShadow(
              color: ColorConst.softShadow,
              blurRadius: 8,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyleConstant.signpost,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ).animate().scale(duration: 200.ms);
  }
}

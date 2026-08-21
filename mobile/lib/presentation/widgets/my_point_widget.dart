import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import '../../base/resizer/size_manager.dart';

class MyPointWidget extends StatelessWidget {
  const MyPointWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.sunnyYellow.withValues(alpha: 1),
        borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge),
        border: Border.all(color: ColorConst.grassGreen, width: Dimens().spacing4),
      ),
      padding: EdgeInsetsGeometry.symmetric(
          horizontal: Dimens().spacing8,
          vertical: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListenableBuilder(
            listenable: DataManager().myPointModel,
            builder: (context, child) {
              return  Text(
                DataManager().myPointModel.point.toString(),
                style: TextStyleConstant.body.copyWith(color: ColorConst.coralRed),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Gap(Dimens().spacing4),
          Card(
            elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens().borderRadiusMedium)
              ),
              color: ColorConst.white,
              child: Center(
                  child: Icon(Icons.add_circle_outlined,
                size: Dimens().iconSmall,color: ColorConst.leafGreen,)))
        ],
      ),
    ).animate().scale(duration: 200.ms);
  }
}

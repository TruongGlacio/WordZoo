import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';

class MyPointWidget extends StatelessWidget {
  const MyPointWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sunnyYellow.withValues(alpha: 1),
        borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
        border: Border.all(color: AppColors.grassGreen, width: SizeManager().spacing4),
      ),
      padding: EdgeInsetsGeometry.symmetric(
          horizontal: SizeManager().spacing8,
          vertical: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListenableBuilder(
            listenable: DataManager().myPointModel,
            builder: (context, child) {
              return  Text(
                DataManager().myPointModel.point.toString(),
                style: AppTextStyles.body.copyWith(color: AppColors.coralRed),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Gap(SizeManager().spacing4),
          Card(
            elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium)
              ),
              color: AppColors.white,
              child: Center(
                  child: Icon(Icons.add_circle_outlined,
                size: SizeManager().iconSmall,color: AppColors.leafGreen,)))
        ],
      ),
    ).animate().scale(duration: 200.ms);
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/iap/blocs/iap_bloc.dart';
import '../../data/models/entity.dart';
import '../../presentation/theme/app_colors.dart';
import '../../utils/size_manager.dart';

class HorizontalEntityList extends StatelessWidget {
  final List<Entity> entities;
  final String? selectedId;
  final ValueChanged<Entity> onSelect;

  const HorizontalEntityList({super.key, required this.entities, required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<IAPBloc>().state is PremiumActive;
    double height = MediaQuery.of(context).size.height/8;
    if(height <=( SizeManager().buttonHeightMedium + SizeManager().spacing16))
    {
      height = SizeManager().buttonHeightMedium +  SizeManager().spacing16;
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
        border: Border.all(color: AppColors.white, width: 2),
      ),
      height: height,
      margin: SizeManager().paddingHorizontalXXXXLarge,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding:  EdgeInsets.symmetric(horizontal: SizeManager().spacing16, vertical: SizeManager().spacing8),
        itemCount: entities.length,
        itemBuilder: (context, index) {
          final entity = entities[index];
          final isLocked = (entity.isPremium ?? false) && !isPremium;
          final isSelected = selectedId == entity.id;

          return InkWell(
            onTap: isLocked ? null : () => onSelect(entity),
            child: Container(
              width: height,
              //height: height,
              margin:  EdgeInsets.symmetric(horizontal: SizeManager().spacing8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.skyBlue  : Colors.white,
                borderRadius: BorderRadius.circular(SizeManager().spacing12),
                border: Border.all(color: isSelected ? AppColors.leafGreen : AppColors.earthBrown, width: 2),
              ),
              child: Stack(
                children: [
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(SizeManager().spacing12),
                        child: Image.file(
                          File(entity.getLocalIcon()),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey[300], child: Icon(Icons.image, size: SizeManager().spacing40));
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(SizeManager().borderRadiusXSmall)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: SizeManager().spacing4),
                          child: Text(
                            entity.names.getBy(DataManager().getCurrentLocale().languageCode),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: SizeManager().spacing12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.darkText),                          ),
                        ),
                      ),
                      if (isLocked)
                        Container(
                          color: AppColors.darkText.withOpacity(0.5),
                          child:  Icon(Icons.lock, color: Colors.white, size: SizeManager().spacing24),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

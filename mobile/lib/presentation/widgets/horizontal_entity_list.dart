import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../blocs/iap/iap_bloc.dart';
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
    final isPremium = context.watch<IapBloc>().state is PremiumActive;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
        border: Border.all(color: AppColors.white, width: 2),
      ),
      margin: SizeManager().paddingHorizontalXXXXLarge,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: entities.length,
        itemBuilder: (context, index) {
          final entity = entities[index];
          final isLocked = (entity.isPremium ?? false) && !isPremium;
          final isSelected = selectedId == entity.id;

          return InkWell(
            onTap: isLocked ? null : () => onSelect(entity),
            child: Container(
              width: SizeManager().imageMedium,
              height: SizeManager().imageMedium,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.leafGreen : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? AppColors.leafGreen : AppColors.earthBrown, width: 2),
              ),
              child: Stack(
                children: [
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(entity.getLocalIcon()),
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 40));
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
                            entity.names.vi,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.darkText),
                          ),
                        ),
                      ),
                      if (isLocked)
                        Container(
                          color: AppColors.darkText.withOpacity(0.5),
                          child: const Icon(Icons.lock, color: Colors.white, size: 24),
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

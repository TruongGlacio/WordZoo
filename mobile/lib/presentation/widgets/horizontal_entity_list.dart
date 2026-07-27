import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../data/models/entity.dart';
import '../../presentation/theme/app_colors.dart';

class HorizontalEntityList extends StatelessWidget {
  final List<Entity> entities;
  final String? selectedId;
  final ValueChanged<Entity> onSelect;

  const HorizontalEntityList({
    super.key,
    required this.entities,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<IapBloc>().state is PremiumActive;

    return Container(
      color: Colors.white.withOpacity(0.8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: entities.length,
        itemBuilder: (context, index) {
          final entity = entities[index];
          final isLocked = entity.isPremium && !isPremium;
          final isSelected = selectedId == entity.id;

          return GestureDetector(
            onTap: isLocked ? null : () => onSelect(entity),
            child: Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.leafGreen : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.leafGreen : AppColors.earthBrown,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            entity.realImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, size: 40),
                              );
                            },
                          ),
                        ),
                        if (isLocked)
                          Container(
                            color: AppColors.darkText.withOpacity(0.5),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      entity.names.vi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : AppColors.darkText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

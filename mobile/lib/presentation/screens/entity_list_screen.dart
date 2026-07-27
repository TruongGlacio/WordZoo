import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/entity/entity_bloc.dart';
import '../../data/models/category.dart';
import '../../data/models/subcategory.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../widgets/airplane_animation.dart';
import '../widgets/detail_panel.dart';
import '../widgets/horizontal_entity_list.dart';

class EntityListScreen extends StatelessWidget {
  final Category category;
  final Subcategory subcategory;

  const EntityListScreen({
    super.key,
    required this.category,
    required this.subcategory,
  });

  @override
  Widget build(BuildContext context) {
    context.read<EntityBloc>().add(
          LoadEntities(category.id, subcategory.id),
        );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.skyBlue, AppColors.grassGreen],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
                    ),
                    Expanded(
                      child: Text(
                        subcategory.names.vi,
                        style: AppTextStyles.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<EntityBloc, EntityState>(
                  builder: (context, state) {
                    if (state is EntityLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EntityLoaded) {
                      final selectedEntity = state.selectedEntity;
                      return Column(
                        children: [
                          // Top detail panel (70%)
                          Expanded(
                            flex: 7,
                            child: selectedEntity != null
                                ? AirplaneAnimation(
                                    child: DetailPanel(entity: selectedEntity),
                                  )
                                : Center(
                                    child: Text(
                                      'Chọn một thực thể để xem chi tiết',
                                      style: AppTextStyles.body,
                                    ),
                                  ),
                          ),
                          // Bottom horizontal list (30%)
                          Expanded(
                            flex: 3,
                            child: HorizontalEntityList(
                              entities: state.entities,
                              selectedId: selectedEntity?.id,
                              onSelect: (entity) {
                                context.read<EntityBloc>().add(
                                      SelectEntity(entity.id),
                                    );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (state is EntityError) {
                      return Center(child: Text('Lỗi: ${state.message}'));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

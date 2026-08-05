import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wordzoo/generated/assets.dart';
import 'package:wordzoo/utils/audio_service.dart';
import '../../blocs/entity/entity_bloc.dart';
import '../../data/models/category.dart';
import '../../data/models/subcategory.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import '../widgets/airplane_animation.dart';
import '../widgets/detail_panel.dart';
import '../widgets/horizontal_entity_list.dart';
import 'package:wordzoo/l10n/app_localizations.dart';

import 'entity/gift_drop_animation.dart';
class EntityListScreen extends StatefulWidget {

  final Category category;
  final Subcategory subcategory;

  const EntityListScreen({
    super.key,
    required this.category,
    required this.subcategory,
  });

  @override
  State<EntityListScreen> createState() =>
      _EntityListScreenState();
}
class _EntityListScreenState extends State<EntityListScreen> {
   late Category category;
   late Subcategory subcategory;
   final GlobalKey<GiftDropAnimationState>giftKey = GlobalKey<GiftDropAnimationState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = widget.category;
    subcategory = widget.subcategory;
    context.read<EntityBloc>().add(
      LoadEntities(category.id, subcategory.id),
    );
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: null,
      body: Stack(
        children: [
          Container(
          decoration:  BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(image: AssetImage(Assets.assets.background.entityList.path), fit: BoxFit.fill),
          ),
          child: BlocBuilder<EntityBloc, EntityState>(
            builder: (context, state) {
              if (state is EntityLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EntityLoaded) {
                final selectedEntity = state.selectedEntity;
                return Stack(
                  children: [
                    SafeArea(
                      left: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Top detail panel (70%)
                          Expanded(
                            child: selectedEntity != null
                                ? Visibility(
                                visible: state.isVisibleDetailPanel ?? false,
                                child: DetailPanel(entity: selectedEntity),
                            )
                                : Center(
                              child: Text(
                                AppLocalizations.of(context)!.selectEntityToViewDetails,
                                style: AppTextStyles.body,
                              ),
                            ),
                          ),
                          // Bottom horizontal list (30%)
                          SizedBox(
                            height: SizeManager().imageMedium,
                            child: HorizontalEntityList(
                              entities: state.entities,
                              selectedId: selectedEntity?.id,
                              onSelect: (entity) {
                                //giftKey.currentState?.
                                giftKey.currentState?.playCustom(Image.file(
                                  File(entity.getLocalIcon()),
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 40));
                                  },
                                ));
                                context.read<EntityBloc>().add(SelectEntity(entity.id, false ),);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !(state.isVisibleDetailPanel ?? false),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GiftDropAnimation(
                            key: giftKey,
                            entityImage: Image.file(
                              File(selectedEntity!.getLocalIcon()),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 40));
                              },
                            ),
                            frames: [
                              AssetImage(Assets.assets.entityAnimationsFrame.frame6.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame7.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame8.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame9.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame10.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame11.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame12.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame13.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame14.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame15.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame16.path,),
                              AssetImage(Assets.assets.entityAnimationsFrame.frame17.path,),
                            ],
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height *0.7,
                            onFinished: () {
                              context.read<EntityBloc>().add(SelectEntity(selectedEntity.id, true ),);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is EntityError) {
                return Center(child: Text(AppLocalizations.of(context)!.errorWithMessage(state.message)));
              }
              return const SizedBox.shrink();
            },
          ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 36),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Image.asset(Assets.assets.icons.backPage.path, width: SizeManager().iconXLarge, height: SizeManager().iconXLarge),
                  ),
                ),
                Container(
                  width: 50,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(SizeManager().borderRadiusSmall)
                  ),
                  child: StatefulBuilder(builder: (context, setState) {
                    return SfSlider.vertical(
                      min: AudioService().playbackRateMin,
                      max: AudioService().playbackRateMax,
                      interval: 0.1,
                      showTicks: true,
                      showLabels: false,
                      enableTooltip: true,
                      minorTicksPerInterval: 0,
                      onChanged: (value) {
                        setState(() {
                          AudioService().setPlaybackRateValue(double.parse(value.toString()));
                        },);
                      },
                      value: AudioService().getPlaybackRateValue(),
                    );
                  },),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

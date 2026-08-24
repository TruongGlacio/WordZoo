import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/features/ads/google_mobile_ads/google_mobile_ads_manager.dart';
import 'package:wordzoo/features/iap/blocs/iap_bloc.dart';
import 'package:wordzoo/utils/premium_entity_manager.dart';
import '../../../data/models/entity.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import '../../../base/resizer/size_manager.dart';

class HorizontalEntityList extends StatelessWidget {
  final List<Entity> entities;
  final String? selectedId;
  final ValueChanged<Entity> onSelect;

  const HorizontalEntityList({super.key, required this.entities, required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<IAPBloc>().state is PremiumActive;
    double height = MediaQuery.of(context).size.height/5;
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.primaryColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge),
        border: Border.all(color: ColorConst.white, width: 2),
      ),
      height: height,
      constraints: BoxConstraints(
        minHeight: Dimens().buttonHeightMedium + Dimens().spacing16,
       // maxHeight: Dimens().buttonHeightXXXLarge +  Dimens().spacing16
      ),
      margin: Dimens().paddingHorizontalXXXXLarge,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding:  EdgeInsets.symmetric(horizontal: Dimens().spacing16, vertical: Dimens().spacing8),
        itemCount: entities.length,
        itemBuilder: (context, index) {
          final entity = entities.elementAt(index);
          bool isOpen = false;
          if(isPremium)
            {
              isOpen =true;
            }
          else
            {
              isOpen = entity.isOpenedEntity();
            }

          final isSelected = selectedId == entity.id;

          return InkWell(
            onTap: () async {
              if(isOpen)
                {
                  onSelect(entity);
                }
              else
                {
                  /// xi ly ads hoặc iap
                  if(!PremiumEntityManager().isValidPoint()) {
                    GoogleMobileAdsManager().showRewardAds(
                    onRewardEarned: (ad, reward) {
                    },
                    onAdFailedToShow: (error) {

                    },
                    onAdDismissed: () async {
                      await PremiumEntityManager().increasePointForFreeEntityForOneAdsWatching();
                      await PremiumEntityManager().updateListOfPassEntity({entity.id: true});
                      onSelect(entity);
                    },
                  );
                  }
                  else
                    {
                      await PremiumEntityManager().updateListOfPassEntity({entity.id: true});
                      onSelect(entity);

                    }

                }
            },
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxHeight*3/2,
                //height: height,
                margin:  EdgeInsets.symmetric(horizontal: Dimens().spacing8),
                decoration: BoxDecoration(
                  color: isSelected ? ColorConst.skyBlue  : Colors.yellowAccent.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(Dimens().spacing12),
                  border: Border.all(color: isSelected ? ColorConst.leafGreen : ColorConst.white.withValues(alpha: 0.7), width: 2),
                ),
                child: Stack(
                  children: [
                    Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimens().spacing12),
                          child: Image.file(
                            File(entity.getLocalIcon()),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: Colors.grey[300], child: Icon(Icons.image, size: Dimens().spacing40));
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorConst.blackColor.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(Dimens().spacing12)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: Dimens().spacing4),
                            margin: EdgeInsets.symmetric(horizontal: Dimens().spacing4),
                            //alignment: Alignment.bottomCenter,
                           //width: constraints.maxHeight*3/2,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                entity.names.getBy(DataManager().getCurrentLocale().languageCode)??'',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: Dimens().extraSmallFontSize, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : ColorConst.white),                          ),
                            ),
                          ),
                        ),
                        if (!isOpen)
                          Container(
                            color: ColorConst.darkText.withValues(alpha: 0.5),
                            child:  Icon(Icons.lock, color: Colors.white, size: Dimens().spacing24),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },),
          );
        },
      ),
    );
  }
}

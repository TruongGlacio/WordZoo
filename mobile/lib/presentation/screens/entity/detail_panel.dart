import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/features/iap/blocs/iap_bloc.dart';
import 'package:wordzoo/utils/audio_service.dart';
import '../../../blocs/entity/entity_bloc.dart';
import '../../../data/models/entity.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import '../../../base/resizer/size_manager.dart';
import 'package:wordzoo/generated/l10n.dart';

class DetailPanel extends StatefulWidget {
  final Entity entity;

  const DetailPanel({super.key, required this.entity});

  @override
  State<DetailPanel> createState() => _DetailPanelState();
}

class _DetailPanelState extends State<DetailPanel> {
  String _currentLang = DataManager().getCurrentLocaleForEntity().languageCode;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremiumLocked = (widget.entity.isPremium ?? false) && context.watch<IAPBloc>().state is! PremiumActive;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: Dimens().spacing128),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Real image
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    if (widget.entity.soundEffect != null) {
                      AudioService().playDeviceFileSource(widget.entity.soundEffect!);
                    }
                  },
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: constraints.maxHeight- Dimens().spacing12*2,
                      height: constraints.maxHeight,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width/4,
                        maxHeight: MediaQuery.of(context).size.width/2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge),
                        //boxShadow: const [BoxShadow(color: AppColors.softShadow, blurRadius: 20, spreadRadius: 5)],
                      ),
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: Dimens().spacing12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens().borderRadiusLarge),
                        child: Image.file(
                          File(widget.entity.getLocalIcon()),
                          fit: BoxFit.fitWidth,
                          //width: SizeManager().imageXXXLarge,
                          //height: SizeManager().imageXXLarge,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 80));
                          },
                        ),
                      ),
                    );
                  },)
                ),
              ],
            ),
          ),
          Gap(Dimens().spacing8),
          LayoutBuilder(builder: (context, constraints) {
            return Center(
              child: Container(
                height: constraints.maxHeight/2,
                width: Dimens().spacing4/4,
                color: ColorConst.darkText,
              ),
            );
          },),
          Gap(Dimens().spacing8),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return InkWell(
                      onTap: () {
                        final audioPath = widget.entity.getLocalAudio(_currentLang);
                        print('check exit audio file ${File(audioPath!).existsSync()}');
                        setState(() {
                          AudioService().playDeviceFileSource(audioPath, onEnd: () {
                            setState(() {
                              print('check exit audio file ${File(audioPath!).existsSync()}');
                            },);
                          },);
                        });
                      },
                      child: Row(
                        children: [
                          Icon(AudioService().isPlaying == true ? Icons.volume_up : Icons.volume_down, color: ColorConst.earthBrown, size: Dimens().imageSmall),
                          Gap(Dimens().spacing8),
                          Expanded(child: Text(widget.entity.names.getBy(_currentLang), style: TextStyleConstant.heading)),
                        ],
                      ),
                    );
                  },
                ),
                Gap(Dimens().spacing8),
                Visibility(
                  visible: widget.entity.pronunciationInfo?.getBy(_currentLang) != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text((widget.entity.pronunciationInfo?.getBy(_currentLang)?.ipa ?? '').isNotEmpty ?
                      "/${widget.entity.pronunciationInfo?.getBy(_currentLang)?.ipa ?? ''}/ -" : '',
                          style: TextStyleConstant.body.copyWith(color: ColorConst.oceanBlue)),
                      Gap(Dimens().spacing8),
                      Text((widget.entity.pronunciationInfo?.getBy(_currentLang)?.syllable ?? '').isNotEmpty ?
                      "/${widget.entity.pronunciationInfo?.getBy(_currentLang)?.syllable ?? ''}/" : '',
                          style: TextStyleConstant.body.copyWith(color: ColorConst.oceanBlue)),
                    ],
                  ),
                ),
                Gap(Dimens().spacing8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _LangButton(label: 'VI', isSelected: _currentLang == 'vi', onTap:() {
                      setCurrentLocaleForEntity(currentLang: 'vi');
                    },),
                    Gap(Dimens().spacing12),
                    _LangButton(label: 'EN', isSelected: _currentLang == 'en', onTap: () {

                      setCurrentLocaleForEntity(currentLang: 'en');

                    },),
                    Gap(Dimens().spacing12),
                    _LangButton(label: 'ZH', isSelected: _currentLang == 'zh', onTap: () {
                      setCurrentLocaleForEntity(currentLang: 'zh');
                    },),
                  ],
                ),
                Gap(Dimens().spacing8),
                Visibility(
                  visible: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<EntityBloc>().add(MarkAsLearned(widget.entity.id));
                        },
                        icon: Icon(Icons.check_circle_outline, color: ColorConst.grassGreen, size: Dimens().imageSmall),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<EntityBloc>().add(ToggleFavorite(widget.entity.id));
                        },
                        icon: Icon(Icons.star_border, size: Dimens().imageSmall),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void setCurrentLocaleForEntity({required String currentLang}){
    setState(() {
      _currentLang = currentLang;
      DataManager().setCurrentLocaleForEntity(Locale(_currentLang));
    },);
    final audioPath = widget.entity.getLocalAudio(_currentLang);
    AudioService().playDeviceFileSource(audioPath!);
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: isSelected ? ColorConst.leafGreen : Colors.grey[300], foregroundColor: isSelected ? Colors.white : ColorConst.darkText),
      child: Text(label),
    );
  }
}

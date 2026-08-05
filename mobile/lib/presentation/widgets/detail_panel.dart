import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/utils/audio_service.dart';
import '../../blocs/entity/entity_bloc.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../data/models/entity.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import 'package:wordzoo/l10n/app_localizations.dart';

class DetailPanel extends StatefulWidget {
  final Entity entity;

  const DetailPanel({super.key, required this.entity});

  @override
  State<DetailPanel> createState() => _DetailPanelState();
}

class _DetailPanelState extends State<DetailPanel> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _currentLang = 'vi';

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremiumLocked = (widget.entity.isPremium ?? false) && context.watch<IapBloc>().state is! PremiumActive;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: SizeManager().spacing128),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Real image
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    if (widget.entity.soundEffect != null) {
                      await _audioPlayer.play(DeviceFileSource(widget.entity.soundEffect!));
                    }
                  },
                  child: Container(
                    width: SizeManager().imageXXLarge,
                    height: SizeManager().imageXXLarge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
                      //boxShadow: const [BoxShadow(color: AppColors.softShadow, blurRadius: 20, spreadRadius: 5)],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
                      child: Image.file(
                        File(widget.entity.getLocalIcon()),
                        fit: BoxFit.fitHeight,
                        width: SizeManager().imageXXLarge,
                        height: SizeManager().imageXXLarge,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 80));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(SizeManager().spacing32),
          // Names
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            final audioPath = widget.entity.getLocalAudio(_currentLang);
                            print('check exit audio file ${File(audioPath!).existsSync()}');
                            if (audioPath != null) {
                              setState(() {
                                AudioService().playDeviceFileSource(
                                  audioPath,
                                  onEnd: () {
                                    setState(() {
                                      _audioPlayer.stop();
                                    });
                                  },
                                );
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(widget.entity.names.getBy(_currentLang), style: AppTextStyles.heading),
                              Gap(SizeManager().spacing8),
                              Icon(_audioPlayer.state == PlayerState.playing ? Icons.volume_up : Icons.volume_down, color: AppColors.earthBrown, size: SizeManager().imageSmall),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Gap(SizeManager().spacing8),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text((widget.entity.pronunciationInfo?.getBy(_currentLang)?.ipa ?? '').isNotEmpty ?
                        "/${widget.entity.pronunciationInfo?.getBy(_currentLang)?.ipa ?? ''}/ -" : '',
                            style: AppTextStyles.body.copyWith(color: AppColors.oceanBlue)),
                        Gap(SizeManager().spacing8),
                        Text((widget.entity.pronunciationInfo?.getBy(_currentLang)?.syllable ?? '').isNotEmpty ?
                        "/${widget.entity.pronunciationInfo?.getBy(_currentLang)?.syllable ?? ''}/" : '',
                            style: AppTextStyles.body.copyWith(color: AppColors.oceanBlue)),
                      ],
                    ),
                  ],
                ),
                Gap(SizeManager().spacing8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _LangButton(label: 'VI', isSelected: _currentLang == 'vi', onTap: () => setState(() => _currentLang = 'vi')),
                    Gap(SizeManager().spacing12),
                    _LangButton(label: 'EN', isSelected: _currentLang == 'en', onTap: () => setState(() => _currentLang = 'en')),
                    Gap(SizeManager().spacing12),
                    _LangButton(label: 'ZH', isSelected: _currentLang == 'zh', onTap: () => setState(() => _currentLang = 'zh')),
                  ],
                ),
                Gap(SizeManager().spacing8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<EntityBloc>().add(MarkAsLearned(widget.entity.id));
                      },
                      icon: Icon(Icons.check_circle_outline, color: AppColors.grassGreen, size: SizeManager().imageSmall),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<EntityBloc>().add(ToggleFavorite(widget.entity.id));
                      },
                      icon: Icon(Icons.star_border, size: SizeManager().imageSmall),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
      style: ElevatedButton.styleFrom(backgroundColor: isSelected ? AppColors.leafGreen : Colors.grey[300], foregroundColor: isSelected ? Colors.white : AppColors.darkText),
      child: Text(label),
    );
  }
}

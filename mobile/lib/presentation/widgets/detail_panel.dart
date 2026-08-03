import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gap/gap.dart';
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
    final isPremiumLocked = widget.entity.isPremium &&
        context.watch<IapBloc>().state is! PremiumActive;

    return Padding(
      padding: SizeManager().paddingLarge,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Real image
          Expanded(
            child: InkWell(
              onTap: () async {
                if (widget.entity.soundEffect != null)
                  {
                    await _audioPlayer.play(DeviceFileSource(widget.entity.soundEffect!));
                  }

              },
              child: Container(
                width: SizeManager().imageXLarge,
                //height: SizeManager().imageXLarge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeManager().borderRadiusLarge),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.softShadow,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.entity.realImage,
                    fit: BoxFit.cover,
                    width: SizeManager().imageXLarge,
                    //height: SizeManager().imageXLarge,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 80),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Gap(SizeManager().spacing24),
          // Names
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final audioPath = _currentLang == 'vi'
                      ? widget.entity.audioNames.vi
                      : _currentLang == 'en'
                      ? widget.entity.audioNames.en
                      : widget.entity.audioNames.zh;
                  await _audioPlayer.play(DeviceFileSource(audioPath));
                },
                child: Text(
                  widget.entity.names.getBy(_currentLang),
                  style: AppTextStyles.heading,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LangButton(
                    label: 'VI',
                    isSelected: _currentLang == 'vi',
                    onTap: () => setState(() => _currentLang = 'vi'),
                  ),
                  Gap(SizeManager().spacing12),
                  _LangButton(
                    label: 'EN',
                    isSelected: _currentLang == 'en',
                    onTap: () => setState(() => _currentLang = 'en'),
                  ),
                  Gap(SizeManager().spacing12),
                  _LangButton(
                    label: 'ZH',
                    isSelected: _currentLang == 'zh',
                    onTap: () => setState(() => _currentLang = 'zh'),
                  ),
                ],
              ),
            ],
          ),
          // Language toggles
          Gap(SizeManager().spacing16),
          // Audio buttons
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context.read<EntityBloc>().add(MarkAsLearned(widget.entity.id));
                },
                icon: const Icon(Icons.check_circle),
                label: Text(AppLocalizations.of(context)!.learned),
              ),
              Gap(SizeManager().spacing16),
              IconButton(
                onPressed: () {
                  context.read<EntityBloc>().add(ToggleFavorite(widget.entity.id));
                },
                icon: const Icon(Icons.star_border),
              ),
            ],
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

  const _LangButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.leafGreen : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : AppColors.darkText,
      ),
      child: Text(label),
    );
  }
}

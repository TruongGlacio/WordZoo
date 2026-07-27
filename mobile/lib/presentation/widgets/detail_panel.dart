import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../blocs/entity/entity_bloc.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../data/models/entity.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';

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
        !(context.watch<IapBloc>().state is PremiumActive);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Real image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
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
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 80),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Names
          Text(
            widget.entity.names.getBy(_currentLang),
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 8),
          Text('EN: ${widget.entity.names.en}', style: AppTextStyles.body),
          Text('ZH: ${widget.entity.names.zh}', style: AppTextStyles.body),
          const SizedBox(height: 16),
          // Language toggles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LangButton(
                label: 'VI',
                isSelected: _currentLang == 'vi',
                onTap: () => setState(() => _currentLang = 'vi'),
              ),
              const SizedBox(width: 12),
              _LangButton(
                label: 'EN',
                isSelected: _currentLang == 'en',
                onTap: () => setState(() => _currentLang = 'en'),
              ),
              const SizedBox(width: 12),
              _LangButton(
                label: 'ZH',
                isSelected: _currentLang == 'zh',
                onTap: () => setState(() => _currentLang = 'zh'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Audio buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  final audioPath = _currentLang == 'vi'
                      ? widget.entity.audioNames.vi
                      : _currentLang == 'en'
                          ? widget.entity.audioNames.en
                          : widget.entity.audioNames.zh;
                  await _audioPlayer.play(DeviceFileSource(audioPath));
                },
                icon: const Icon(Icons.volume_up, size: 32),
              ),
              if (widget.entity.soundEffect != null)
                IconButton(
                  onPressed: () async {
                    await _audioPlayer.play(DeviceFileSource(widget.entity.soundEffect!));
                  },
                  icon: const Icon(Icons.music_note, size: 32),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context.read<EntityBloc>().add(MarkAsLearned(widget.entity.id));
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Đã học'),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  context.read<EntityBloc>().add(ToggleFavorite(widget.entity.id));
                },
                icon: const Icon(Icons.star_border),
              ),
            ],
          ),
          if (isPremiumLocked) ...[
            const SizedBox(height: 16),
            const Text(
              '🔒 Nâng cấp Premium để mở khóa',
              style: TextStyle(color: AppColors.coralRed),
            ),
          ],
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

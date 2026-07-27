import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final VoidCallback? onCompleted;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    this.onCompleted,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      await _player.play(DeviceFileSource(widget.audioPath));
      setState(() => _isPlaying = true);
      _player.onPlayerComplete.listen((_) {
        setState(() => _isPlaying = false);
        widget.onCompleted?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _togglePlay,
      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
    );
  }
}

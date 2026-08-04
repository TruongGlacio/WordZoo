import 'package:audioplayers/audioplayers.dart';

class AudioService {

  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String path, {Function()? onEnd}) async {

    await _player.stop();
    await _player.play(DeviceFileSource(path), volume: 2.0);
    onEnd?.call();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
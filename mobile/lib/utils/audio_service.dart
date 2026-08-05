import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();

  static final AudioService instanceAudioService = AudioService._();
  factory AudioService() => instanceAudioService;

  final AudioPlayer _player = AudioPlayer();

  double playbackRate = 0.8;
  final playbackRateMin =0.5;
  final playbackRateMax = 2;
  void setPlaybackRateValue(double rate) {
    if(rate>=playbackRateMin && rate<=playbackRateMax)
      {
        playbackRate = rate;
        print(playbackRate);
      }
  }
  double getPlaybackRateValue(){
    return playbackRate;
  }
  Future<void> playDeviceFileSource(String path, {Function()? onEnd}) async {

    await _player.stop();
    _player.setPlaybackRate(getPlaybackRateValue());
    await _player.play(DeviceFileSource(path), volume: 2.0);
    onEnd?.call();
  }
  Future<void> playAssetSource(String path, {Function()? onEnd, Duration? position,}) async {

    await _player.stop();
    _player.setPlaybackRate(1.2);
    path = path.replaceAll('assets/', '');
    await _player.play(AssetSource(path), volume: 2.0, position: position);
    onEnd?.call();
  }
  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
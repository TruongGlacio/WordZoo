import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();

  static final AudioService instanceAudioService = AudioService._();
  factory AudioService() => instanceAudioService;

  final AudioPlayer _player = AudioPlayer();

  double playbackRate = 0.8;
  final playbackRateMin =0.5;
  final playbackRateMax = 1.5;
  bool isPlaying = false;

  void setPlaybackRateValue(double rate) {
    if(rate>=playbackRateMin && rate<=playbackRateMax)
      {
        playbackRate = rate;
        print(playbackRate);
      }
  }

  AudioPlayer getAudioPlayer(){
    return _player;
  }
  double getPlaybackRateValue(){
    return playbackRate;
  }
  Future<void> playDeviceFileSource(String path, {Function()? onEnd}) async {

    isPlaying = true;
    await _player.stop();
    _player.setPlaybackRate(getPlaybackRateValue());
    _player.onPlayerComplete.listen((event) {
      onEnd?.call();
      isPlaying = false;
    },);
    await _player.play(DeviceFileSource(path), volume: 2.0,);

  }
  Future<void> playAssetSource(String path, {Function()? onEnd, Duration? position,}) async {
    isPlaying = true;
    await _player.stop();
    _player.setPlaybackRate(1.2);
    path = path.replaceAll('assets/', '');
    _player.onPlayerComplete.listen((event) {
      onEnd?.call();
      isPlaying = false;
    },);
     _player.play(AssetSource(path), volume: 2.0, position: position);
  }
  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
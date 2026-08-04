import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordzoo/utils/logger.dart';

enum MediaType { image, audio, folder }

class MediaCacheService {
  MediaCacheService._();

  static final MediaCacheService instance = MediaCacheService._();

  Future<Directory> get _localDir async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/media');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }

  Future<Directory> get _imageDir async {
    final dir = await _localDir;
    final imageDir = Directory('${dir.path}/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir;
  }


  Future<Directory> get _audioDir async {
    final dir = await _localDir;
    final audioDir = Directory('${dir.path}/audio');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return audioDir;
  }

  Future<String> _getLocalPath(String remotePath, MediaType type) async {
    final fileName = remotePath.split('/').last;
    final safeName = remotePath.replaceAll('/', '_').replaceAll('\\', '_');
    return type == MediaType.image ? (await _imageDir).path : (type == MediaType.folder ? (await _localDir).path : '${(await _audioDir).path}/$safeName');
  }

  Future<bool> exists(String remotePath, MediaType type) async {
    final localPath = await _getLocalPath(remotePath, type);
    return File(localPath).exists();
  }

  Future<String?> getLocalPathIfExists(String remotePath, MediaType type) async {
    try {
      final localPath = await _getLocalPath(remotePath, type);
      final file = File(localPath);
      if (await file.exists()) {
        return localPath;
      }
      return null;
    } catch (e, st) {
      AppLogger.e('getLocalPathIfExists failed for $remotePath', e, st);
      return null;
    }
  }

  Future<File> getLocalFile(String remotePath, MediaType type) async {
    final localPath = await _getLocalPath(remotePath, type);
    return File(localPath);
  }

  Future<void> downloadAndCache(
      String remotePath,
      MediaType type
      ) async {


    final root =
    await getApplicationDocumentsDirectory();



    final file =
    File(
        '${root.path}/wordzoo/$remotePath'
    );


    if(await file.exists()){

      return;

    }


    AppLogger.w(
        'File not found $remotePath'
    );


  }
  Future<void> downloadAndCacheBatch(List<String> remotePaths, MediaType type, {Function (int)?callbackIndexSuccess}) async {
    int index =0;
    for (final path in remotePaths) {
      await downloadAndCache(path, type);
      index++;
      callbackIndexSuccess?.call(index);
    }
  }

  Future<Map<String, String>> cacheEntities(List<dynamic> entities) async {
    final imagePaths = <String>{};
    final audioPaths = <String>{};

    for (final entity in entities) {
      if (entity is Map<String, dynamic>) {
        final realImage = entity['real_image'] as String?;
        final animationImage = entity['animation_image'] as String?;
        final audioNames = entity['audio_names'] as Map<String, dynamic>?;
        final soundEffect = entity['sound_effect'] as String?;

        if (realImage != null) imagePaths.add(realImage);
        if (animationImage != null) imagePaths.add(animationImage);
        if (audioNames != null) {
          audioPaths.add(audioNames['vi'] as String);
          audioPaths.add(audioNames['en'] as String);
          audioPaths.add(audioNames['zh'] as String);
        }
        if (soundEffect != null) audioPaths.add(soundEffect);
      }
    }

    AppLogger.i('MediaCache: caching ${imagePaths.length} images and ${audioPaths.length} audio files');
    int index = 0;
    int total = imagePaths.length + audioPaths.length;
    int percent = 0;
    await downloadAndCacheBatch(imagePaths.toList(), MediaType.image, callbackIndexSuccess: (p0) {
      index = p0;
      if(index!=0)
        {
          percent = ((index/total)*100).toInt();

        }
    },);
    await downloadAndCacheBatch(audioPaths.toList(), MediaType.audio, callbackIndexSuccess: (p0) {
      index = index + p0;
      if(index!=0)
        {
          percent = ((index/total)*100).toInt();
        }
    });

    final result = <String, String>{};
    for (final path in imagePaths) {
      result[path] = await _getLocalPath(path, MediaType.image);
    }
    for (final path in audioPaths) {
      result[path] = await _getLocalPath(path, MediaType.audio);
    }
    return result;
  }

  Future<void> clearCache() async {
    try {
      final dir = await _localDir;
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        AppLogger.i('MediaCache: cache cleared');
      }
    } catch (e, st) {
      AppLogger.e('MediaCache: failed to clear cache', e, st);
    }
  }

  Future<Map<String, int>> getCacheStats() async {
    try {
      final imageDir = await _imageDir;
      final audioDir = await _audioDir;

      final imageFiles = await imageDir.list().toList();
      final audioFiles = await audioDir.list().toList();

      return {
        'images': imageFiles.length,
        'audio': audioFiles.length,
      };
    } catch (e, st) {
      AppLogger.e('MediaCache: failed to get stats', e, st);
      return {'images': 0, 'audio': 0};
    }
  }
}

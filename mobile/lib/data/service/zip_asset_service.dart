import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/utils/logger.dart';

class ZipAssetService {
  ZipAssetService._();

  static final instance = ZipAssetService._();

  Future<Directory> getRootDir()async{
     return await _rootDir1;
  }
  Future<Directory> get _rootDir1 async {
    final dir = await getApplicationDocumentsDirectory();

    final wordZooDir = Directory('${dir.path}/');

    if (!await wordZooDir.exists()) {
      await wordZooDir.create(recursive: true);
    }
    DataManager().setRootPath(wordZooDir.path);
    return wordZooDir;
  }
  Future<Directory> get _rootDir async {
    final dir = await getApplicationDocumentsDirectory();

    final wordZooDir = Directory('${dir.path}/wordzoo');

    if (!await wordZooDir.exists()) {
      await wordZooDir.create(recursive: true);
    }
    return wordZooDir;
  }

  Future<String> downloadAndExtractCategoryZip(String categoryId, String zipName) async {
    final root = await _rootDir;

    final categoryDir = Directory('${root.path}/$categoryId');

    //
    // đã extract rồi
    //
    if (await categoryDir.exists()) {
      AppLogger.i('$categoryId already extracted');

      return categoryDir.path;
    }

    AppLogger.i('Downloading $zipName');

    final bytes = await Supabase.instance.client.storage.from('assets').download(zipName);

    AppLogger.i('Download completed ${bytes.length}');

    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = '${categoryDir.path}/${file.name}';

      if (file.isFile) {
        final outFile = File(filename);

        await outFile.parent.create(recursive: true);

        await outFile.writeAsBytes(file.content as List<int>);
      }
    }

    AppLogger.i('$categoryId extracted');

    return categoryDir.path;
  }
}

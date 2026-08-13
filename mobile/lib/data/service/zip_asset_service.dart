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
  Future<String> downloadAndExtractCategoryZip(
      String categoryId,
      String zipName,
      ) async {
    final root = await _rootDir;

    final categoryDir = Directory(
      '${root.path}/$categoryId',
    );

    // Temporary directory dùng để download + extract bản mới.
    final tempDir = Directory(
      '${root.path}/.${categoryId}_update_tmp',
    );

    try {
      // ============================================================
      // 1. Nếu còn thư mục temporary từ lần update trước thì xóa
      // ============================================================

      if (await tempDir.exists()) {
        AppLogger.i(
          '$categoryId: removing old temporary update directory',
        );

        await tempDir.delete(
          recursive: true,
        );
      }

      await tempDir.create(
        recursive: true,
      );

      // ============================================================
      // 2. Download ZIP mới
      // ============================================================

      AppLogger.i(
        '$categoryId: downloading $zipName',
      );

      final bytes = await Supabase
          .instance
          .client
          .storage
          .from('assets')
          .download(zipName);

      AppLogger.i(
        '$categoryId: download completed '
            '(${bytes.length} bytes)',
      );

      if (bytes.isEmpty) {
        throw Exception(
          'Downloaded ZIP is empty: $zipName',
        );
      }

      // ============================================================
      // 3. Decode ZIP
      // ============================================================

      AppLogger.i(
        '$categoryId: extracting ZIP...',
      );

      final archive = ZipDecoder().decodeBytes(
        bytes,
      );

      if (archive.isEmpty) {
        throw Exception(
          'ZIP archive is empty: $zipName',
        );
      }

      // ============================================================
      // 4. Extract vào temporary directory
      // ============================================================

      var extractedFiles = 0;

      for (final file in archive) {
        if (!file.isFile) {
          continue;
        }

        final filename = file.name;

        // ----------------------------------------------------------
        // Bảo vệ khỏi ZIP path traversal:
        //
        // Không cho phép ZIP chứa:
        // ../../something
        // ----------------------------------------------------------

        final normalizedPath = filename.replaceAll(
          '\\',
          '/',
        );

        if (normalizedPath.startsWith('/') ||
            normalizedPath.contains('../') ||
            normalizedPath.contains('..\\')) {
          throw Exception(
            'Unsafe path inside ZIP: $filename',
          );
        }

        final outFile = File(
          '${tempDir.path}/$normalizedPath',
        );

        await outFile.parent.create(
          recursive: true,
        );

        await outFile.writeAsBytes(
          file.content as List<int>,
          flush: true,
        );

        extractedFiles++;
      }

      // ============================================================
      // 5. Kiểm tra extraction
      // ============================================================

      if (extractedFiles == 0) {
        throw Exception(
          'No files extracted from $zipName',
        );
      }

      AppLogger.i(
        '$categoryId: extracted '
            '$extractedFiles files successfully',
      );

      // ============================================================
      // 6. Extraction thành công
      //
      //    Bây giờ mới xóa dữ liệu cũ.
      // ============================================================

      if (await categoryDir.exists()) {
        AppLogger.i(
          '$categoryId: removing old category data',
        );

        await categoryDir.delete(
          recursive: true,
        );

        AppLogger.i(
          '$categoryId: old data deleted',
        );
      }

      // ============================================================
      // 7. Rename temporary → category
      // ============================================================

      await tempDir.rename(
        categoryDir.path,
      );

      AppLogger.i(
        '$categoryId: update completed successfully',
      );

      return categoryDir.path;
    } catch (e, stackTrace) {
      // ============================================================
      // Update thất bại
      //
      // QUAN TRỌNG:
      // categoryDir cũ KHÔNG bị động vào nếu lỗi xảy ra trước
      // bước delete old category.
      // ============================================================

      AppLogger.e(
        '$categoryId: update failed $e',
      );

      // Xóa temporary directory nếu còn.
      try {
        if (await tempDir.exists()) {
          await tempDir.delete(
            recursive: true,
          );
        }
      } catch (cleanupError) {
        AppLogger.e(
          '$categoryId: failed to cleanup temporary directory $cleanupError',
        );
      }
      // Giữ nguyên dữ liệu cũ.
      throw Exception(
        'Failed to update category $categoryId: $e',
      );
    }
  }
/*  Future<String> downloadAndExtractCategoryZip(String categoryId, String zipName) async {
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
  }*/
}

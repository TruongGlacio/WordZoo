import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/repositories/r2_repository.dart';
import 'package:wordzoo/utils/logger.dart';

class ZipAssetService {
  ZipAssetService._();

  static final instance = ZipAssetService._();

  // ============================================================
  // ROOT DIRECTORY
  // ============================================================

  Future<Directory> getRootDir() async {
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

  // ============================================================
  // DOWNLOAD + EXTRACT CATEGORY ZIP
  // ============================================================

  Future<String> downloadAndExtractCategoryZip(String categoryId, String zipName) async {
    final root = await _rootDir;

    final categoryDir = Directory('${root.path}/$categoryId');

    final tempDir = Directory('${root.path}/.${categoryId}_update_tmp');

    File? downloadedZip;

    try {
      // ==========================================================
      // 1. CLEAN OLD TEMP DIRECTORY
      // ==========================================================

      if (await tempDir.exists()) {
        AppLogger.i(
          '$categoryId: removing old '
          'temporary update directory',
        );

        await tempDir.delete(recursive: true);
      }

      await tempDir.create(recursive: true);

      // ==========================================================
      // 2. DOWNLOAD ZIP FROM R2
      // ==========================================================

      AppLogger.i('$categoryId: downloading $zipName from R2');

      downloadedZip = await R2RepositoryImplement.instance.downloadCategoryZip(zipName);

      AppLogger.i(
        '$categoryId: download completed '
        '(${await downloadedZip.length()} bytes)',
      );

      // ==========================================================
      // 3. READ ZIP
      // ==========================================================

      final bytes = await downloadedZip.readAsBytes();

      if (bytes.isEmpty) {
        throw Exception(
          'Downloaded ZIP is empty: '
          '$zipName',
        );
      }

      // ==========================================================
      // 4. DECODE ZIP
      // ==========================================================

      AppLogger.i('$categoryId: extracting ZIP...');

      final archive = ZipDecoder().decodeBytes(bytes);

      if (archive.isEmpty) {
        throw Exception(
          'ZIP archive is empty: '
          '$zipName',
        );
      }

      // ==========================================================
      // 5. EXTRACT TO TEMP DIRECTORY
      // ==========================================================

      var extractedFiles = 0;

      for (final file in archive) {
        if (!file.isFile) {
          continue;
        }

        final filename = file.name;

        // --------------------------------------------------------
        // ZIP PATH TRAVERSAL PROTECTION
        // --------------------------------------------------------

        final normalizedPath = filename.replaceAll('\\', '/');

        if (normalizedPath.startsWith('/') || normalizedPath.contains('../') || normalizedPath.contains('..\\')) {
          throw Exception(
            'Unsafe path inside ZIP: '
            '$filename',
          );
        }

        final outFile = File(
          '${tempDir.path}/'
          '$normalizedPath',
        );

        await outFile.parent.create(recursive: true);

        await outFile.writeAsBytes(file.content as List<int>, flush: true);

        extractedFiles++;
      }

      // ==========================================================
      // 6. VALIDATE EXTRACTION
      // ==========================================================

      if (extractedFiles == 0) {
        throw Exception(
          'No files extracted from '
          '$zipName',
        );
      }

      AppLogger.i(
        '$categoryId: extracted '
        '$extractedFiles files successfully',
      );

      // ==========================================================
      // 7. DELETE OLD CATEGORY
      // ==========================================================

      if (await categoryDir.exists()) {
        AppLogger.i(
          '$categoryId: removing old '
          'category data',
        );

        await categoryDir.delete(recursive: true);

        AppLogger.i('$categoryId: old data deleted');
      }

      // ==========================================================
      // 8. RENAME TEMP -> CATEGORY
      // ==========================================================

      await tempDir.rename(categoryDir.path);

      AppLogger.i(
        '$categoryId: update completed '
        'successfully',
      );

      return categoryDir.path;
    } catch (e, stackTrace) {
      // ==========================================================
      // UPDATE FAILED
      // ==========================================================

      AppLogger.e('$categoryId: update failed $e', e, stackTrace);

      // ----------------------------------------------------------
      // Cleanup temporary directory
      // ----------------------------------------------------------

      try {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      } catch (cleanupError) {
        AppLogger.e(
          '$categoryId: failed to cleanup '
          'temporary directory '
          '$cleanupError',
        );
      }

      throw Exception(
        'Failed to update category '
        '$categoryId: $e',
      );
    } finally {
      // ==========================================================
      // DELETE DOWNLOADED ZIP
      // ==========================================================

      if (downloadedZip != null) {
        try {
          if (await downloadedZip.exists()) {
            await downloadedZip.delete();

            AppLogger.i(
              '$categoryId: deleted temporary '
              'ZIP $zipName',
            );
          }
        } catch (cleanupError) {
          AppLogger.w(
            '$categoryId: failed to delete '
            'temporary ZIP $zipName: '
            '$cleanupError',
          );
        }
      }
    }
  }
}

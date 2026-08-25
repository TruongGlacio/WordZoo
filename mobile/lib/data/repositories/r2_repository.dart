import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:wordzoo/utils/logger.dart';

abstract class R2Repository {
  String getFileUrl(String fileName);
  Future<List<int>> downloadBytes(String fileName);
  Future<File> downloadFile(String fileName, {String? localFileName});
  Future<String> downloadDataJson(String version);
  Future<File> downloadCategoryZip(String zipName);
  Future<void> deleteDownloadedFile(String fileName);
  Future<void> clearDownloads();
}

class R2RepositoryImplement implements R2Repository {
  R2RepositoryImplement._internal();

  static final R2RepositoryImplement _instance = R2RepositoryImplement._internal();

  static R2RepositoryImplement get instance => _instance;

  factory R2RepositoryImplement() => _instance;

  // ============================================================
  // CONFIG
  // ============================================================

  /// Public URL của Cloudflare R2.
  ///
  /// Ví dụ:
  /// https://pub-xxxxxxxxxxxxxxxx.r2.dev
  ///
  /// Hoặc custom domain:
  /// https://media.wordzoo.app

  String get baseUrl {
    final value = dotenv.env['R2_PUBLIC_URL'];

    if (value == null || value.isEmpty) {
      throw Exception('R2_PUBLIC_URL is not configured');
    }

    return value;
  }
  // ============================================================
  // BUILD URL
  // ============================================================

  @override
  String getFileUrl(String fileName) {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

    final path = fileName.startsWith('/') ? fileName.substring(1) : fileName;

    return '$base/$path';
  }

  // ============================================================
  // DOWNLOAD BYTES
  // ============================================================

  @override
  Future<List<int>> downloadBytes(String fileName) async {
    final url = getFileUrl(fileName);

    AppLogger.i('R2: downloading $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw HttpException(
        'R2 download failed: '
        '${response.statusCode} '
        '$url',
      );
    }

    if (response.bodyBytes.isEmpty) {
      throw HttpException('R2 returned empty file: $fileName');
    }

    AppLogger.i(
      'R2: downloaded $fileName '
      '(${response.bodyBytes.length} bytes)',
    );

    return response.bodyBytes;
  }

  // ============================================================
  // DOWNLOAD TO LOCAL FILE
  // ============================================================

  @override
  Future<File> downloadFile(String fileName, {String? localFileName}) async {
    final bytes = await downloadBytes(fileName);

    final dir = await getApplicationDocumentsDirectory();

    final downloadDir = Directory('${dir.path}/wordzoo/.downloads');

    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final file = File(
      '${downloadDir.path}/'
      '${localFileName ?? fileName}',
    );

    await file.writeAsBytes(bytes, flush: true);

    AppLogger.i('R2: saved file ${file.path}');

    return file;
  }

  // ============================================================
  // DOWNLOAD DATA JSON
  // ============================================================

  @override
  Future<String> downloadDataJson(String version) async {
    final fileName = 'data-v$version.json';

    final bytes = await downloadBytes(fileName);

    return String.fromCharCodes(bytes);
  }

  // ============================================================
  // DOWNLOAD CATEGORY ZIP
  // ============================================================

  @override
  Future<File> downloadCategoryZip(String zipName) async {
    return downloadFile(zipName, localFileName: zipName);
  }

  // ============================================================
  // DELETE LOCAL DOWNLOADED ZIP
  // ============================================================

  @override
  Future<void> deleteDownloadedFile(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();

      final file = File(
        '${dir.path}/wordzoo/.downloads/'
        '$fileName',
      );

      if (await file.exists()) {
        await file.delete();

        AppLogger.i(
          'R2: deleted local file '
          '$fileName',
        );
      }
    } catch (e, st) {
      AppLogger.e(
        'R2: failed to delete local file '
        '$fileName',
        e,
        st,
      );
    }
  }

  // ============================================================
  // CLEAR ALL LOCAL DOWNLOADS
  // ============================================================

  @override
  Future<void> clearDownloads() async {
    try {
      final dir = await getApplicationDocumentsDirectory();

      final downloadDir = Directory('${dir.path}/wordzoo/.downloads');

      if (await downloadDir.exists()) {
        await downloadDir.delete(recursive: true);
      }

      AppLogger.i('R2: local download cache cleared');
    } catch (e, st) {
      AppLogger.e('R2: clearDownloads failed', e, st);
    }
  }
}

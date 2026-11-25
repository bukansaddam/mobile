import 'dart:convert';
import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class OfflineMasterCacheLocalDatasource {
  static const String _folderName = 'master_cache';

  static const String keyCategoriesJagaTanah = 'categories_jaga_tanah';
  static const String keyCategoriesReport = 'categories_report';
  static const String keyBankSampahLocations = 'bank_sampah_locations';
  static const String keyBaselineProvinces = 'baseline_regions_provinces';

  final Future<Directory> Function() _rootDirectory;
  final Dio _dio;

  OfflineMasterCacheLocalDatasource({
    Future<Directory> Function()? rootDirectory,
    Dio? dio,
  }) : _rootDirectory = rootDirectory ?? getApplicationSupportDirectory,
       _dio = dio ?? DioClient.instance;

  Future<Directory> _dir() async {
    final base = await _rootDirectory();
    final dir = Directory('${base.path}/$_folderName');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  File _fileFor(Directory dir, String key) {
    final sanitized = key.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    return File('${dir.path}/$sanitized.json');
  }

  Future<void> saveCache(String key, dynamic data) async {
    try {
      final baseDir = await _dir();
      final target = _fileFor(baseDir, key);
      final tmp = File('${target.path}.tmp');

      final encoded = jsonEncode(data);
      await tmp.writeAsString(encoded, flush: true);
      if (target.existsSync()) {
        await target.delete();
      }
      await tmp.rename(target.path);
    } catch (e, s) {
      AppLogger.w('[MASTER_CACHE] Failed to save cache for $key: $e', e, s);
    }
  }

  Future<dynamic> getCache(String key) async {
    try {
      final baseDir = await _dir();
      final target = _fileFor(baseDir, key);
      if (!target.existsSync()) return null;

      final content = await target.readAsString();
      if (content.trim().isEmpty) return null;
      return jsonDecode(content);
    } catch (e) {
      AppLogger.w('[MASTER_CACHE] Failed to read cache for $key: $e');
      return null;
    }
  }

  /// Memanaskan (warm-up) master data penting di latar belakang secara non-blocking.
  Future<void> warmUpEssentialMasterData() async {
    try {
      await Future.wait([
        _warmUpCategoriesJagaTanah(),
        _warmUpCategoriesReport(),
        _warmUpBankSampahMap(),
      ]);
      AppLogger.i(
        '[MASTER_CACHE] Essential master data warmed up successfully',
      );
    } catch (e) {
      AppLogger.w('[MASTER_CACHE] Warmup encountered error (ignored): $e');
    }
  }

  Future<void> _warmUpCategoriesJagaTanah() async {
    try {
      final res = await _dio.get(
        ApiConstants.categories,
        queryParameters: const {'domain': 'jaga_tanah'},
        options: Options(receiveTimeout: const Duration(seconds: 8)),
      );
      if (res.statusCode == 200 && res.data != null) {
        await saveCache(keyCategoriesJagaTanah, res.data);
      }
    } catch (_) {}
  }

  Future<void> _warmUpCategoriesReport() async {
    try {
      final res = await _dio.get(
        ApiConstants.categories,
        queryParameters: const {'domain': 'report'},
        options: Options(receiveTimeout: const Duration(seconds: 8)),
      );
      if (res.statusCode == 200 && res.data != null) {
        await saveCache(keyCategoriesReport, res.data);
      }
    } catch (_) {}
  }

  Future<void> _warmUpBankSampahMap() async {
    try {
      final res = await _dio.get(
        ApiConstants.bankSampahMap,
        options: Options(receiveTimeout: const Duration(seconds: 8)),
      );
      if (res.statusCode == 200 && res.data != null) {
        await saveCache(keyBankSampahLocations, res.data);
      }
    } catch (_) {}
  }

  Future<void> clearAll() async {
    try {
      final baseDir = await _dir();
      if (baseDir.existsSync()) {
        await baseDir.delete(recursive: true);
      }
    } catch (e) {
      AppLogger.w('[MASTER_CACHE] Failed to clear master cache: $e');
    }
  }
}

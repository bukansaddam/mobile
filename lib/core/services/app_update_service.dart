import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUpdateInfo {
  final String platform;
  final String currentVersion;
  final String latestVersion;
  final String? minVersion;
  final bool isMustUpdate;
  final String downloadUrl;

  const AppUpdateInfo({
    required this.platform,
    required this.currentVersion,
    required this.latestVersion,
    this.minVersion,
    required this.isMustUpdate,
    required this.downloadUrl,
  });

  bool get isForceUpdate {
    if (isMustUpdate) return true;
    final min = minVersion;
    if (min == null || min.trim().isEmpty) return false;
    final cmp = compareSemanticVersions(currentVersion, min);
    return cmp != null && cmp < 0;
  }
}

/// Compares two semantic version strings (e.g. "1.10.0" vs "1.2.0").
/// Strips optional leading "v", "+build", and "-prerelease" suffixes.
/// Returns negative if [a] < [b], 0 if equal, positive if [a] > [b], or null if invalid.
int? compareSemanticVersions(String a, String b) {
  final pa = _parseVersionParts(a);
  final pb = _parseVersionParts(b);
  if (pa == null || pb == null) return null;

  final maxLen = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < maxLen; i++) {
    final va = i < pa.length ? pa[i] : 0;
    final vb = i < pb.length ? pb[i] : 0;
    if (va != vb) return va.compareTo(vb);
  }
  return 0;
}

List<int>? _parseVersionParts(String raw) {
  var cleaned = raw.trim();
  if (cleaned.isEmpty) return null;
  if (cleaned.startsWith('v') || cleaned.startsWith('V')) {
    cleaned = cleaned.substring(1);
  }
  final core = cleaned.split(RegExp(r'[+\-]')).first.trim();
  if (core.isEmpty) return null;

  final segments = core.split('.');
  final parts = <int>[];
  for (final segment in segments) {
    final parsed = int.tryParse(segment);
    if (parsed == null || parsed < 0) return null;
    parts.add(parsed);
  }
  return parts;
}

class AppUpdateService {
  static const String _dismissedVersionKey = 'app_update_dismissed_version';
  static const String _dismissedAtMsKey = 'app_update_dismissed_at_ms';
  static const Duration _optionalCooldown = Duration(hours: 24);
  static const Duration _requestTimeout = Duration(seconds: 8);

  final Dio? _dio;
  final SharedPreferences? _prefs;
  final Future<String> Function() _currentVersionProvider;
  final String? Function() _platformProvider;
  final DateTime Function() _nowProvider;
  final bool _allowInsecureHttp;

  AppUpdateService({
    required Dio this._dio,
    required SharedPreferences this._prefs,
    Future<String> Function()? currentVersionProvider,
    String? Function()? platformProvider,
    DateTime Function()? nowProvider,
    this._allowInsecureHttp = kDebugMode,
  }) : _currentVersionProvider =
           currentVersionProvider ?? _defaultCurrentVersion,
       _platformProvider = platformProvider ?? _defaultPlatform,
       _nowProvider = nowProvider ?? DateTime.now;

  @visibleForTesting
  AppUpdateService.forTesting()
    : _dio = null,
      _prefs = null,
      _currentVersionProvider = _defaultCurrentVersion,
      _platformProvider = _defaultPlatform,
      _nowProvider = DateTime.now,
      _allowInsecureHttp = true;

  static Future<String> _defaultCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  static String? _defaultPlatform() {
    if (kIsWeb) return null;
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return null;
  }

  Future<AppUpdateInfo?> checkForUpdate() async {
    final dio = _dio;
    if (dio == null) return null;

    final platform = _platformProvider();
    if (platform == null || platform.isEmpty) return null;

    try {
      final currentVersion = (await _currentVersionProvider()).trim();
      if (_parseVersionParts(currentVersion) == null) return null;

      final response = await dio.get(
        ApiConstants.appVersion,
        queryParameters: {'platform': platform},
        options: Options(
          sendTimeout: _requestTimeout,
          receiveTimeout: _requestTimeout,
        ),
      );

      final payload = _extractPayload(response.data);
      if (payload == null) return null;

      final latestVersion = (payload['version'] ?? '').toString().trim();
      final minRaw = payload['min_version']?.toString().trim();
      final minVersion = (minRaw != null && minRaw.isNotEmpty) ? minRaw : null;
      final isMustUpdate = _parseBool(payload['is_must_update']);
      final downloadUrl = (payload['download_url'] ?? '').toString().trim();

      if (!_isAllowedUrl(downloadUrl)) return null;

      final cmpLatest = compareSemanticVersions(currentVersion, latestVersion);
      if (cmpLatest == null || cmpLatest >= 0) return null;

      final info = AppUpdateInfo(
        platform: (payload['platform'] ?? platform).toString().trim(),
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        minVersion: minVersion,
        isMustUpdate: isMustUpdate,
        downloadUrl: downloadUrl,
      );

      if (!info.isForceUpdate && _isInOptionalCooldown(info.latestVersion)) {
        return null;
      }

      return info;
    } catch (e, stack) {
      AppLogger.w('App update check skipped', e, stack);
      return null;
    }
  }

  Future<void> dismissOptionalUpdate(String version) async {
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.setString(_dismissedVersionKey, version.trim());
    await prefs.setInt(
      _dismissedAtMsKey,
      _nowProvider().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic>? _extractPayload(dynamic raw) {
    if (raw is! Map) return null;
    if (raw['success'] == false) return null;

    final nested = raw['data'];
    if (nested is Map) {
      return Map<String, dynamic>.from(nested);
    }
    if (raw.containsKey('version')) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.trim().toLowerCase();
      return lower == 'true' || lower == '1';
    }
    return false;
  }

  bool _isAllowedUrl(String rawUrl) {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || uri.host.isEmpty) return false;
    if (uri.scheme == 'https') return true;
    return _allowInsecureHttp && uri.scheme == 'http';
  }

  bool _isInOptionalCooldown(String latestVersion) {
    final prefs = _prefs;
    if (prefs == null) return false;

    final dismissedVersion = prefs.getString(_dismissedVersionKey);
    final dismissedAtMs = prefs.getInt(_dismissedAtMsKey);
    if (dismissedVersion == null || dismissedAtMs == null) return false;

    // Re-show immediately if the server published a newer version than what was dismissed.
    final cmp = compareSemanticVersions(latestVersion, dismissedVersion);
    if (cmp == null || cmp > 0) return false;

    final elapsed = _nowProvider().difference(
      DateTime.fromMillisecondsSinceEpoch(dismissedAtMs),
    );
    return elapsed < _optionalCooldown;
  }
}

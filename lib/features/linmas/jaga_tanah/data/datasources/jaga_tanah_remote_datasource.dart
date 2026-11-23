import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/utils/image_compress_helper.dart';
import 'package:akar/features/linmas/jaga_tanah/data/models/jaga_tanah_detail_model.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/masyarakat/complaint/data/models/complaint_report_model.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

abstract class JagaTanahRemoteDatasource {
  Future<ComplaintPaginatedModel> getMyReports({
    int page = 1,
    int perPage = 20,
    String? status,
    String? category,
  });

  Future<JagaTanahDetailModel> getReportDetail(String id);

  Future<List<JagaTanahCategoryEntity>> getCategories();

  Future<ComplaintReportModel> createReport({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    required int categoryId,
    int? subCategoryId,
    String type = 'point',
    String? locationAccess,
    String? fieldCondition,
    String? dominantLandCover,
    String? visibleUsage,
    String? usageLevel,
    String? maintenanceStatus,
    String? conditionInfoSource,
    String? tenureInfoSource,
    String? possessionMarkers,
    String? conflictInfo,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  });
}

class JagaTanahRemoteDatasourceImpl extends BaseRemoteDataSource
    implements JagaTanahRemoteDatasource {
  static const String _attachmentsField = 'attachments[]';

  static final Options _uploadOptions = Options(
    sendTimeout: const Duration(minutes: 10),
    receiveTimeout: const Duration(minutes: 3),
  );

  final Dio? _dioOverride;
  final OfflineMasterCacheLocalDatasource? _masterCache;

  JagaTanahRemoteDatasourceImpl({
    Dio? dio,
    OfflineMasterCacheLocalDatasource? masterCache,
  }) : _dioOverride = dio,
       _masterCache = masterCache;

  @override
  Dio get dio => _dioOverride ?? super.dio;

  @override
  Future<ComplaintPaginatedModel> getMyReports({
    int page = 1,
    int perPage = 20,
    String? status,
    String? category,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.jagaTanahReportsMe,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'status': ?status,
          'category': ?category,
        },
      );
      final body = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : const <String, dynamic>{};
      return ComplaintPaginatedModel.fromJson(body);
    } on DioException catch (e) {
      AppLogger.e(
        '[JAGA_TANAH_DS] DioException in getMyReports: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<JagaTanahDetailModel> getReportDetail(String id) async {
    try {
      final response = await handleRequest<JagaTanahDetailModel>(
        () => dio.get(ApiConstants.jagaTanahReportDetail(id)),
        fromJson: (json) => JagaTanahDetailModel.fromJson(
          json is Map ? Map<String, dynamic>.from(json) : const {},
        ),
      );

      if (!response.success) {
        throwResponseError(
          response,
          fallbackMessage: 'Gagal memuat detail laporan Jaga Tanah',
        );
      }
      return response.data ??
          const JagaTanahDetailModel(JagaTanahDetailEntity());
    } catch (e, s) {
      AppLogger.e('[JAGA_TANAH_DS] Error in getReportDetail: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<List<JagaTanahCategoryEntity>> getCategories() async {
    try {
      final response = await dio.get(
        ApiConstants.categories,
        queryParameters: const {'domain': 'jaga_tanah'},
      );
      await _masterCache?.saveCache(
        OfflineMasterCacheLocalDatasource.keyCategoriesJagaTanah,
        response.data,
      );
      return parseCategoryTree(response.data);
    } on DioException catch (e) {
      final cached = await _masterCache?.getCache(
        OfflineMasterCacheLocalDatasource.keyCategoriesJagaTanah,
      );
      if (cached != null) {
        return parseCategoryTree(cached);
      }
      AppLogger.e(
        '[JAGA_TANAH_DS] DioException in getCategories: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<ComplaintReportModel> createReport({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    required int categoryId,
    int? subCategoryId,
    String type = 'point',
    String? locationAccess,
    String? fieldCondition,
    String? dominantLandCover,
    String? visibleUsage,
    String? usageLevel,
    String? maintenanceStatus,
    String? conditionInfoSource,
    String? tenureInfoSource,
    String? possessionMarkers,
    String? conflictInfo,
    String? idempotencyKey,
    bool skipMediaPreparation = false,
  }) async {
    try {
      final prepared = skipMediaPreparation
          ? attachments
          : await ImageCompressHelper.prepareMediaFiles(
              attachments,
              latitude: latitude,
              longitude: longitude,
              address: address,
              resolveDeviceLocationIfMissing: address.trim().isEmpty,
            );
      final trimmedKey = idempotencyKey?.trim();
      final requestOptions = (trimmedKey != null && trimmedKey.isNotEmpty)
          ? _uploadOptions.copyWith(
              headers: {
                ...?_uploadOptions.headers,
                'X-Idempotency-Key': trimmedKey,
              },
            )
          : _uploadOptions;

      final response = await handleRequest<ComplaintReportModel>(
        () async => dio.post(
          ApiConstants.jagaTanahReports,
          data: await _createFormData(
            title: title,
            description: description,
            address: address,
            latitude: latitude,
            longitude: longitude,
            attachments: prepared,
            categoryId: categoryId,
            subCategoryId: subCategoryId,
            type: type,
            locationAccess: locationAccess,
            fieldCondition: fieldCondition,
            dominantLandCover: dominantLandCover,
            visibleUsage: visibleUsage,
            usageLevel: usageLevel,
            maintenanceStatus: maintenanceStatus,
            conditionInfoSource: conditionInfoSource,
            tenureInfoSource: tenureInfoSource,
            possessionMarkers: possessionMarkers,
            conflictInfo: conflictInfo,
          ),
          options: requestOptions,
        ),
        fromJson: (json) => ComplaintReportModel.fromJson(
          json is Map ? Map<String, dynamic>.from(json) : const {},
        ),
      );

      if (!response.success) {
        throwResponseError(response, fallbackMessage: 'Gagal mengirim laporan');
      }
      return response.data ?? const ComplaintReportModel();
    } catch (e, s) {
      AppLogger.e('[JAGA_TANAH_DS] Error in createReport: $e', e, s);
      rethrow;
    }
  }

  /// Parses flat + nested category payload into a deduplicated parent tree.
  static List<JagaTanahCategoryEntity> parseCategoryTree(dynamic body) {
    final rawList = body is Map && body['data'] is List
        ? body['data'] as List
        : (body is List ? body : const []);

    final parsedAll = rawList
        .whereType<Map>()
        .map((raw) => _parseCategoryNode(Map<String, dynamic>.from(raw)))
        .whereType<JagaTanahCategoryEntity>()
        .toList();

    final groupedChildren = <int, List<JagaTanahCategoryEntity>>{};
    for (final item in parsedAll) {
      final parentId = item.parentId;
      if (parentId != null) {
        groupedChildren.putIfAbsent(parentId, () => []).add(item);
      }
    }

    final roots = parsedAll.where((item) => item.parentId == null).toList();
    if (roots.isEmpty) {
      return parsedAll..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }

    final normalizedRoots = roots.map((root) {
      final children = root.children.isNotEmpty
          ? root.children
          : (groupedChildren[root.id] ?? const <JagaTanahCategoryEntity>[]);
      final sortedChildren = List<JagaTanahCategoryEntity>.from(children)
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return JagaTanahCategoryEntity(
        id: root.id,
        code: root.code,
        label: root.label,
        parentId: null,
        colorHex: root.colorHex,
        sortOrder: root.sortOrder,
        children: List<JagaTanahCategoryEntity>.unmodifiable(sortedChildren),
      );
    }).toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return List<JagaTanahCategoryEntity>.unmodifiable(normalizedRoots);
  }

  static JagaTanahCategoryEntity? _parseCategoryNode(Map<String, dynamic> map) {
    if (map['is_active'] == false) return null;
    final label = (map['label'] ?? map['name'] ?? '').toString().trim();
    if (label.isEmpty) return null;

    final id = (map['id'] as num?)?.toInt() ?? 0;
    final codeRaw = (map['code'] ?? '').toString().trim();
    final rawChildren = map['children'] is List
        ? map['children'] as List
        : const [];
    final parsedChildren = rawChildren
        .whereType<Map>()
        .map((raw) => _parseCategoryNode(Map<String, dynamic>.from(raw)))
        .whereType<JagaTanahCategoryEntity>()
        .toList();

    return JagaTanahCategoryEntity(
      id: id,
      code: codeRaw.isNotEmpty ? codeRaw : label,
      label: label,
      parentId: (map['parent_id'] as num?)?.toInt(),
      colorHex: (map['color'] ?? '').toString().trim(),
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      children: List<JagaTanahCategoryEntity>.unmodifiable(parsedChildren),
    );
  }

  Future<FormData> _createFormData({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> attachments,
    required int categoryId,
    int? subCategoryId,
    required String type,
    String? locationAccess,
    String? fieldCondition,
    String? dominantLandCover,
    String? visibleUsage,
    String? usageLevel,
    String? maintenanceStatus,
    String? conditionInfoSource,
    String? tenureInfoSource,
    String? possessionMarkers,
    String? conflictInfo,
  }) async {
    final files = <MultipartFile>[];
    for (final file in attachments) {
      files.add(await _multipartFile(file));
    }

    final data = <String, dynamic>{
      'title': title.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'category_id': categoryId,
      _attachmentsField: files,
    };
    if (subCategoryId != null) {
      data['sub_category_id'] = subCategoryId;
    }

    final optionalTextFields = <String, String?>{
      'description': description,
      'address': address,
      'type': type,
      'location_access': locationAccess,
      'field_condition': fieldCondition,
      'dominant_land_cover': dominantLandCover,
      'visible_usage': visibleUsage,
      'usage_level': usageLevel,
      'maintenance_status': maintenanceStatus,
      'condition_info_source': conditionInfoSource,
      'tenure_info_source': tenureInfoSource,
      'possession_markers': possessionMarkers,
      'conflict_info': conflictInfo,
    };
    for (final entry in optionalTextFields.entries) {
      final trimmed = entry.value?.trim() ?? '';
      if (trimmed.isNotEmpty) {
        data[entry.key] = trimmed;
      }
    }

    return FormData.fromMap(data);
  }

  Future<MultipartFile> _multipartFile(File file) {
    return MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
      contentType: _mediaTypeOf(file.path),
    );
  }

  DioMediaType _mediaTypeOf(String path) {
    final extension = path.split('.').last.toLowerCase();
    if (FileSecurityUtils.isVideoPath(path)) {
      return DioMediaType(
        'video',
        extension == 'mov' ? 'quicktime' : extension,
      );
    }
    return DioMediaType('image', extension == 'jpg' ? 'jpeg' : extension);
  }
}

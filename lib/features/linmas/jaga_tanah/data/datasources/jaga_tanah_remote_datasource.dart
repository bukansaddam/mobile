import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/utils/image_compress_helper.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
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
  });
}

class JagaTanahRemoteDatasourceImpl extends BaseRemoteDataSource
    implements JagaTanahRemoteDatasource {
  static const String _attachmentsField = 'attachments[]';

  static final Options _uploadOptions = Options(
    sendTimeout: const Duration(minutes: 10),
    receiveTimeout: const Duration(minutes: 3),
  );

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
  Future<List<JagaTanahCategoryEntity>> getCategories() async {
    try {
      final response = await dio.get(
        ApiConstants.categories,
        queryParameters: const {'domain': 'jaga_tanah'},
      );
      return parseCategoryTree(response.data);
    } on DioException catch (e) {
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
  }) async {
    try {
      final prepared = await ImageCompressHelper.prepareMediaFiles(
        attachments,
        latitude: latitude,
        longitude: longitude,
        address: address,
        resolveDeviceLocationIfMissing: address.trim().isEmpty,
      );
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
          ),
          options: _uploadOptions,
        ),
        fromJson: (json) => ComplaintReportModel.fromJson(
          json is Map ? Map<String, dynamic>.from(json) : const {},
        ),
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Gagal mengirim laporan');
      }
      return response.data ?? const ComplaintReportModel();
    } on DioException catch (e) {
      AppLogger.e(
        '[JAGA_TANAH_DS] DioException in createReport: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
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
  }) async {
    final files = <MultipartFile>[];
    for (final file in attachments) {
      files.add(await _multipartFile(file));
    }

    final data = <String, dynamic>{
      'title': title,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'report_category_id': categoryId,
      _attachmentsField: files,
    };
    if (subCategoryId != null) {
      data['sub_category_id'] = subCategoryId;
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

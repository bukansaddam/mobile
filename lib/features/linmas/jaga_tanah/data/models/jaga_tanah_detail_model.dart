import 'dart:convert';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/utils/report_point_policy.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_polygon_utils.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Model parser defensif untuk payload `GET /api/jaga-tanah-reports/{id}`
/// yang mendukung struktur flat maupun nested (`report`, `location`, `condition`, `tenure`).
class JagaTanahDetailModel {
  final JagaTanahDetailEntity entity;

  const JagaTanahDetailModel(this.entity);

  factory JagaTanahDetailModel.fromJson(Map<String, dynamic> json) {
    final report = _asMap(
      json['report'] ??
          json['complaint'] ??
          json['jaga_tanah'] ??
          json['jagaTanah'],
    );
    final location = _asMap(
      json['location'] ??
          json['spatial'] ??
          report?['location'] ??
          report?['spatial'],
    );
    final region = _asMap(
      json['region'] ?? location?['region'] ?? report?['region'],
    );
    final geometry = _firstMap(
      json['geometry'] ??
          report?['geometry'] ??
          json['geometries'] ??
          report?['geometries'],
    );
    final condition = _asMap(
      json['condition'] ??
          json['land_condition'] ??
          report?['condition'] ??
          report?['land_condition'],
    );
    final tenure = _asMap(
      json['tenure'] ??
          json['rights'] ??
          report?['tenure'] ??
          report?['rights'],
    );
    final spatialAndCondition = _asMap(
      json['spatialAndCondition'] ??
          json['spatial_and_condition'] ??
          report?['spatialAndCondition'] ??
          report?['spatial_and_condition'],
    );
    final verification = _asMap(
      json['verification'] ?? report?['verification'],
    );
    final followUp = _asMap(
      json['follow_up'] ??
          json['followUp'] ??
          report?['follow_up'] ??
          report?['followUp'],
    );
    final bpn = _latestMap(
      json['bpn_feedback'] ??
          json['bpnFeedback'] ??
          json['bpn_feedbacks'] ??
          json['bpnFeedbacks'] ??
          report?['bpn_feedback'] ??
          report?['bpnFeedback'] ??
          report?['bpn_feedbacks'] ??
          report?['bpnFeedbacks'],
    );

    final coreMaps = [?report, json];
    final spatialMaps = [
      ?location,
      ?region,
      ?geometry,
      ?spatialAndCondition,
      ...coreMaps,
    ];
    final conditionMaps = [?condition, ?spatialAndCondition, ...coreMaps];
    final tenureMaps = [?tenure, ?spatialAndCondition, ...coreMaps];
    final verificationMaps = [?verification, ...coreMaps];
    final followUpMaps = [?followUp, ...coreMaps];
    final bpnMaps = [?bpn, ...followUpMaps];

    final categoryPair = _parseCategories(coreMaps);
    final polygonPoints = _parseBoundaryPolygon(spatialMaps);
    final rawEstimatedArea = _pickString(spatialMaps, const [
      'estimated_area',
      'estimatedArea',
    ]);
    final postgisAreaSqm = _pickDouble(spatialMaps, const [
      'postgisAreaSqm',
      'postgis_area_sqm',
    ]);
    final resolvedEstimatedArea = rawEstimatedArea ??
        (postgisAreaSqm != null && postgisAreaSqm > 0
            ? JagaTanahPolygonUtils.formatArea(postgisAreaSqm)
            : null);

    return JagaTanahDetailModel(
      JagaTanahDetailEntity(
        id: _pickScalarString(coreMaps, const ['id']) ?? '',
        ticketNumber:
            _pickString(coreMaps, const ['ticketNumber', 'ticket_number']) ??
            '',
        title: _pickString(coreMaps, const ['title']) ?? '',
        description: _pickString(coreMaps, const ['description']) ?? '',
        status: _pickString(coreMaps, const ['status']) ?? '',
        statusLabel:
            _pickString(coreMaps, const ['statusLabel', 'status_label']) ?? '',
        category: categoryPair.category,
        subCategory: categoryPair.subCategory,
        reportedAt: _pickDateTime(coreMaps, const [
          'reportedAt',
          'reported_at',
          'createdAt',
          'created_at',
        ]),
        updatedAt: _pickDateTime(coreMaps, const ['updatedAt', 'updated_at']),
        escalationLevel:
            _pickInt(coreMaps, const ['escalation_level', 'escalationLevel']) ??
            0,
        pointsAwarded: ReportPointPolicy.parsePointsFromMaps(coreMaps),
        address: _pickString(spatialMaps, const ['address', 'landmark']) ?? '',
        province: _pickString(spatialMaps, const ['province', 'province_name']),
        regency: _pickString(spatialMaps, const ['regency', 'regency_name']),
        district: _pickString(spatialMaps, const ['district', 'district_name']),
        village: _pickString(spatialMaps, const ['village', 'village_name']),
        latitude: _pickCoordinate(spatialMaps, const [
          'latitude',
          'lat',
        ], coordinateIndex: 1),
        longitude: _pickCoordinate(spatialMaps, const [
          'longitude',
          'lng',
          'lon',
        ], coordinateIndex: 0),
        polygonPoints: polygonPoints,
        geometryType: _pickString(
          [?geometry, ?location, ...coreMaps],
          const ['type', 'geometry_type', 'geometryType'],
        ),
        objectShape: _pickString(spatialMaps, const [
          'object_shape',
          'objectShape',
        ]),
        estimatedArea: resolvedEstimatedArea,
        locationAccess: _pickString(spatialMaps, const [
          'location_access',
          'locationAccess',
        ]),
        fieldCondition: _pickString(conditionMaps, const [
          'field_condition',
          'fieldCondition',
        ]),
        dominantLandCover: _pickString(conditionMaps, const [
          'dominant_land_cover',
          'dominantLandCover',
        ]),
        visibleUsage: _pickString(conditionMaps, const [
          'visible_usage',
          'visibleUsage',
        ]),
        usageLevel: _pickString(conditionMaps, const [
          'usage_level',
          'usageLevel',
        ]),
        maintenanceStatus: _pickString(conditionMaps, const [
          'maintenance_status',
          'maintenanceStatus',
        ]),
        conditionInfoSource: _pickString(conditionMaps, const [
          'condition_info_source',
          'conditionInfoSource',
        ]),
        tenureInfoSource: _pickString(tenureMaps, const [
          'tenure_info_source',
          'tenureInfoSource',
        ]),
        possessionMarkers: _pickString(tenureMaps, const [
          'possession_markers',
          'possessionMarkers',
        ]),
        conflictInfo: _pickString(tenureMaps, const [
          'conflict_info',
          'conflictInfo',
        ]),
        verifierUnit: _pickString(verificationMaps, const [
          'verifier_unit',
          'verifierUnit',
        ]),
        verifierName:
            _pickString(verificationMaps, const [
              'verifier_name',
              'verifierName',
              'pic_name',
              'picName',
            ]) ??
            _extractActorName(verification?['verifier'] ?? report?['verifier']),
        verificationMethod: _pickString(verificationMaps, const [
          'verification_method',
          'verificationMethod',
        ]),
        verificationSummary: _pickString(verificationMaps, const [
          'verification_summary',
          'verificationSummary',
        ]),
        followUpDecision: _pickString(followUpMaps, const [
          'follow_up_decision',
          'followUpDecision',
          'decision',
        ]),
        followUpNotes: _pickString(followUpMaps, const [
          'follow_up_notes',
          'followUpNotes',
          'notes',
        ]),
        bpnActionType: _pickString(followUpMaps, const [
          'bpn_action_type',
          'bpnActionType',
        ]),
        bpnReferenceNumber: _pickString(bpnMaps, const [
          'bpn_reference_number',
          'bpnReferenceNumber',
        ]),
        sourceInstitution: _pickString(bpnMaps, const [
          'source_institution',
          'sourceInstitution',
        ]),
        landRightType: _pickString(bpnMaps, const [
          'land_right_type',
          'landRightType',
        ]),
        landRightNumberNib: _pickString(bpnMaps, const [
          'land_right_number_nib',
          'landRightNumberNib',
        ]),
        bpnFeedbackStatus: _pickString(
          [?bpn],
          const ['status', 'bpn_status', 'bpnStatus'],
        ),
        bpnFeedbackSummary: _pickString(
          [?bpn],
          const ['summary', 'bpn_summary', 'bpnSummary'],
        ),
        rejectionReason: _pickString(verificationMaps, const [
          'rejection_reason',
          'rejectionReason',
          'reason',
        ]),
        completionSummary: _pickString(followUpMaps, const [
          'completion_summary',
          'completionSummary',
        ]),
        attachments: _parseAttachments(
          json['attachments'] ?? report?['attachments'] ?? json['media'],
        ),
        sla: _parseSla(json['sla'] ?? report?['sla']),
        timeline: _parseTimeline(
          json['timeline'] ??
              json['histories'] ??
              json['status_history'] ??
              report?['timeline'],
        ),
      ),
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static Map<String, dynamic>? _firstMap(dynamic value) {
    final direct = _asMap(value);
    if (direct != null) return direct;
    if (value is List) {
      for (final item in value) {
        final mapped = _asMap(item);
        if (mapped != null) return mapped;
      }
    }
    return null;
  }

  static Map<String, dynamic>? _latestMap(dynamic value) {
    final direct = _asMap(value);
    if (direct != null) return direct;
    if (value is List && value.isNotEmpty) {
      for (final item in value.reversed) {
        final mapped = _asMap(item);
        if (mapped != null) return mapped;
      }
    }
    return null;
  }

  static String? _pickScalarString(
    List<Map<String, dynamic>> maps,
    List<String> keys,
  ) {
    for (final map in maps) {
      for (final key in keys) {
        final value = map[key];
        if (value == null) continue;
        final text = value.toString().trim();
        if (text.isNotEmpty) return text;
      }
    }
    return null;
  }

  static String? _pickString(
    List<Map<String, dynamic>> maps,
    List<String> keys,
  ) {
    for (final map in maps) {
      for (final key in keys) {
        final raw = map[key];
        if (raw == null) continue;
        if (raw is Map) {
          final nested = (raw['label'] ?? raw['name'] ?? raw['title'])
              ?.toString()
              .trim();
          if (nested != null && nested.isNotEmpty) return nested;
          continue;
        }
        final text = raw.toString().trim();
        if (text.isNotEmpty) return text;
      }
    }
    return null;
  }

  static int? _pickInt(List<Map<String, dynamic>> maps, List<String> keys) {
    for (final map in maps) {
      for (final key in keys) {
        final raw = map[key];
        if (raw is int) return raw;
        if (raw is num) return raw.toInt();
        if (raw is String) {
          final parsed = int.tryParse(raw.trim());
          if (parsed != null) return parsed;
        }
      }
    }
    return null;
  }

  static double? _pickDouble(
    List<Map<String, dynamic>> maps,
    List<String> keys,
  ) {
    for (final map in maps) {
      for (final key in keys) {
        final raw = map[key];
        if (raw is num) return raw.toDouble();
        if (raw is String) {
          final parsed = double.tryParse(raw.trim());
          if (parsed != null) return parsed;
        }
      }
    }
    return null;
  }

  static double? _pickCoordinate(
    List<Map<String, dynamic>> maps,
    List<String> keys, {
    required int coordinateIndex,
  }) {
    final direct = _pickDouble(maps, keys);
    if (direct != null) return direct;

    for (final map in maps) {
      final centroid = map['centroid'];
      if (centroid is Map) {
        final raw = coordinateIndex == 1
            ? (centroid['latitude'] ?? centroid['lat'])
            : (centroid['longitude'] ?? centroid['lng'] ?? centroid['lon']);
        if (raw is num) return raw.toDouble();
      } else if (centroid is List && centroid.length >= 2) {
        final raw = centroid[coordinateIndex];
        if (raw is num) return raw.toDouble();
      }
    }
    return null;
  }

  static DateTime? _pickDateTime(
    List<Map<String, dynamic>> maps,
    List<String> keys,
  ) {
    for (final map in maps) {
      for (final key in keys) {
        final raw = map[key];
        if (raw is String && raw.trim().isNotEmpty) {
          final parsed = DateTime.tryParse(raw.trim());
          if (parsed != null) return parsed.toLocal();
        }
      }
    }
    return null;
  }

  static String? _extractActorName(dynamic raw) {
    final map = _asMap(raw);
    if (map == null) return null;
    final name = map['name']?.toString().trim();
    return (name != null && name.isNotEmpty) ? name : null;
  }

  static ({String category, String? subCategory}) _parseCategories(
    List<Map<String, dynamic>> maps,
  ) {
    String? category;
    String? subCategory = _pickString(maps, const [
      'sub_category',
      'subCategory',
      'subcategory',
      'sub_category_label',
      'subCategoryLabel',
    ]);

    for (final map in maps) {
      final rawCategory = map['category'];
      if (rawCategory is Map) {
        final parent = _asMap(rawCategory['parent']);
        final label = (rawCategory['label'] ?? rawCategory['name'])
            ?.toString()
            .trim();
        final parentLabel = (parent?['label'] ?? parent?['name'])
            ?.toString()
            .trim();
        if (parentLabel != null && parentLabel.isNotEmpty) {
          category ??= parentLabel;
          if (label != null && label.isNotEmpty) {
            subCategory ??= label;
          }
        } else if (label != null && label.isNotEmpty) {
          category ??= label;
        }
      } else if (rawCategory != null) {
        final text = rawCategory.toString().trim();
        if (text.isNotEmpty) category ??= text;
      }
    }

    category ??= _pickString(maps, const ['category_label', 'categoryLabel']);
    return (category: category ?? '', subCategory: subCategory);
  }

  static List<ComplaintAttachmentEntity> _parseAttachments(dynamic rawList) {
    if (rawList is! List) return const [];
    final items = <ComplaintAttachmentEntity>[];
    for (final entry in rawList) {
      final map = _asMap(entry);
      if (map == null) continue;
      final id = map['id']?.toString().trim();
      var url =
          (map['fileUrl'] ??
                  map['file_url'] ??
                  map['url'] ??
                  map['download_url'] ??
                  '')
              .toString()
              .trim();
      if (url.isEmpty && id != null && id.isNotEmpty) {
        url = '${ApiConstants.jagaTanahReports}/attachments/$id/file';
      }
      if (url.isEmpty) continue;
      url = _absoluteUrl(url);

      var mimeType = (map['mimeType'] ?? map['mime_type'] ?? '')
          .toString()
          .trim()
          .toLowerCase();
      final fileName = (map['fileName'] ?? map['file_name'] ?? url)
          .toString()
          .trim();
      if (mimeType.isEmpty && FileSecurityUtils.isVideoPath(fileName)) {
        mimeType = 'video/mp4';
      }
      items.add(ComplaintAttachmentEntity(mimeType: mimeType, url: url));
    }
    return items;
  }

  static ComplaintSlaEntity? _parseSla(dynamic raw) {
    final map = _asMap(raw);
    if (map == null) return null;
    final remaining = map['remainingMinutes'] ?? map['remaining_minutes'];
    final progress = map['progressPct'] ?? map['progress_pct'];
    return ComplaintSlaEntity(
      stageLabel: (map['stageLabel'] ?? map['stage_label'] ?? '')
          .toString()
          .trim(),
      remainingMinutes: remaining is num ? remaining.toInt() : 0,
      progressPct: progress is num ? progress.toInt() : 0,
      state: (map['state'] ?? '').toString().trim(),
    );
  }

  static List<ComplaintTimelineEntity> _parseTimeline(dynamic rawList) {
    if (rawList is! List) return const [];
    final entries = <ComplaintTimelineEntity>[];
    for (final entry in rawList) {
      final map = _asMap(entry);
      if (map == null) continue;
      final createdAtRaw =
          (map['createdAt'] ?? map['created_at'] ?? map['timestamp'])
              ?.toString()
              .trim();
      final createdAt = (createdAtRaw != null && createdAtRaw.isNotEmpty)
          ? DateTime.tryParse(createdAtRaw)?.toLocal()
          : null;
      final description =
          (map['description'] ??
                  map['message'] ??
                  map['note'] ??
                  map['statusLabel'] ??
                  map['status_label'] ??
                  '')
              .toString()
              .trim();
      final actorName =
          _extractActorName(map['actor'] ?? map['user']) ??
          (map['actor_name'] ?? map['actorName'] ?? '').toString().trim();

      entries.add(
        ComplaintTimelineEntity(
          type: (map['type'] ?? map['status'] ?? '').toString().trim(),
          description: description,
          actorName: actorName,
          createdAt: createdAt,
        ),
      );
    }
    return entries;
  }

  static List<LatLng> _parseBoundaryPolygon(List<Map<String, dynamic>> maps) {
    const keys = [
      'boundaryGeoJson',
      'boundary_geojson',
      'boundaryGeojson',
      'geojson',
      'boundary',
    ];
    for (final map in maps) {
      for (final key in keys) {
        final raw = map[key];
        if (raw == null) continue;
        final points = _decodeGeoJsonPolygon(raw);
        if (points.length >= 3) return points;
      }
      if (map['coordinates'] is List) {
        final points = _decodeGeoJsonPolygon(map);
        if (points.length >= 3) return points;
      }
    }
    return const [];
  }

  static List<LatLng> _decodeGeoJsonPolygon(dynamic raw) {
    dynamic decoded = raw;
    if (decoded is String) {
      final trimmed = decoded.trim();
      if (trimmed.isEmpty) return const [];
      try {
        decoded = jsonDecode(trimmed);
      } catch (_) {
        return const [];
      }
    }
    final geo = _asMap(decoded);
    if (geo == null) return const [];

    final type = (geo['type'] ?? '').toString().trim().toLowerCase();
    final coordinates = geo['coordinates'];
    if (coordinates is! List || coordinates.isEmpty) return const [];

    List<dynamic>? ring;
    if (type == 'multipolygon') {
      final firstPolygon = coordinates.first;
      if (firstPolygon is List &&
          firstPolygon.isNotEmpty &&
          firstPolygon.first is List) {
        ring = firstPolygon.first as List<dynamic>;
      }
    } else if (type.isEmpty || type == 'polygon') {
      if (coordinates.first is List) {
        ring = coordinates.first as List<dynamic>;
      }
    }
    if (ring == null || ring.length < 3) return const [];

    final points = <LatLng>[];
    for (final item in ring) {
      if (item is! List || item.length < 2) continue;
      final lng = _toDouble(item[0]);
      final lat = _toDouble(item[1]);
      if (lat == null || lng == null) continue;
      points.add(LatLng(lat, lng));
    }
    if (points.length >= 4 && points.first == points.last) {
      points.removeLast();
    }
    return points.length >= 3 ? List<LatLng>.unmodifiable(points) : const [];
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  static String _absoluteUrl(String url) {
    if (url.isEmpty ||
        url.startsWith('http://') ||
        url.startsWith('https://')) {
      return url;
    }
    final base = Uri.tryParse(ApiConstants.baseUrl);
    return base == null ? url : base.resolve(url).toString();
  }
}

import 'package:akar/features/masyarakat/complaint/presentation/models/complaint_item.dart';
import 'package:equatable/equatable.dart';

/// Jenis laporan Linmas yang memperoleh insentif poin setelah diverifikasi.
enum ReportPointCategory {
  jagaTanah(10),
  laporanInsidentil(1);

  final int defaultPoints;

  const ReportPointCategory(this.defaultPoints);
}

/// Status perolehan poin untuk satu laporan.
enum ReportPointState { earned, pending, notEligible }

/// Nilai terhitung dan label siap-tampil untuk keterangan poin laporan.
class ReportPointInfo extends Equatable {
  final ReportPointCategory category;
  final ReportPointState state;
  final int points;

  const ReportPointInfo({
    required this.category,
    required this.state,
    required this.points,
  });

  bool get isEarned => state == ReportPointState.earned;

  String get badgeLabel => '+$points Poin';

  String get detailChipLabel => switch (state) {
    ReportPointState.earned => '+$points Poin',
    ReportPointState.pending => 'Potensi +$points Poin',
    ReportPointState.notEligible => '0 Poin',
  };

  String get detailTitle => switch (state) {
    ReportPointState.earned => 'Poin diperoleh',
    ReportPointState.pending => 'Menunggu verifikasi',
    ReportPointState.notEligible => 'Tidak memperoleh poin',
  };

  String get detailDescription => switch (state) {
    ReportPointState.earned =>
      'Poin otomatis masuk setelah laporan diverifikasi.',
    ReportPointState.pending => 'Poin didapat setelah laporan diverifikasi.',
    ReportPointState.notEligible =>
      'Laporan yang ditolak atau dibatalkan tidak memperoleh poin.',
  };

  @override
  List<Object?> get props => [category, state, points];
}

/// Policy terpusat untuk parsing hybrid field poin API dan fallback status verifikasi.
class ReportPointPolicy {
  ReportPointPolicy._();

  static const List<String> _apiPointKeys = [
    'points_awarded',
    'pointsAwarded',
    'earned_points',
    'earnedPoints',
    'reward_points',
    'rewardPoints',
    'points',
    'point',
  ];

  static const Set<String> _rejectedCodes = {
    'rejected',
    'cancelled',
    'canceled',
  };

  static const Set<String> _verifiedAndBeyondCodes = {
    'verified',
    'in_progress',
    'processing',
    'mediation',
    'fifty_fifty',
    'bpn_forwarded',
    'resolved',
    'completed',
    'done',
  };

  static const Set<String> _pendingCodes = {
    'new',
    'created',
    'submitted',
    'pending',
    'verification',
    'verification_assigned',
    'in_review',
  };

  /// Mengambil nilai poin non-negatif dari satu map JSON, atau `null` jika tidak ada/tidak valid.
  static int? parsePointsFromMap(Map<dynamic, dynamic> map) {
    for (final key in _apiPointKeys) {
      if (!map.containsKey(key)) continue;
      final parsed = _parseNonNegativeInt(map[key]);
      if (parsed != null) return parsed;
    }
    return null;
  }

  /// Mengambil nilai poin pertama yang valid dari urutan beberapa map kandidat.
  static int? parsePointsFromMaps(Iterable<Map<dynamic, dynamic>> maps) {
    for (final map in maps) {
      final parsed = parsePointsFromMap(map);
      if (parsed != null) return parsed;
    }
    return null;
  }

  /// Menentukan status & nominal poin laporan secara Hybrid (API-first, fallback status lokal).
  static ReportPointInfo resolve({
    required ReportPointCategory category,
    String? statusCode,
    ComplaintStatus? fallbackStatus,
    int? apiPoints,
    Iterable<String> timelineTypes = const [],
  }) {
    final normalizedCode = (statusCode ?? '').trim().toLowerCase();

    final isRejectedByCode = _rejectedCodes.contains(normalizedCode);
    final isRejectedByFallback =
        normalizedCode.isEmpty &&
        (fallbackStatus == ComplaintStatus.rejected ||
            fallbackStatus == ComplaintStatus.cancelled);

    if (isRejectedByCode || isRejectedByFallback) {
      return ReportPointInfo(
        category: category,
        state: ReportPointState.notEligible,
        points: 0,
      );
    }

    if (apiPoints != null && apiPoints > 0) {
      return ReportPointInfo(
        category: category,
        state: ReportPointState.earned,
        points: apiPoints,
      );
    }

    final hasVerifiedTimeline = timelineTypes.any(
      (type) => type.trim().toLowerCase() == 'verified',
    );

    if (normalizedCode.isNotEmpty) {
      if (_verifiedAndBeyondCodes.contains(normalizedCode) ||
          hasVerifiedTimeline) {
        return ReportPointInfo(
          category: category,
          state: ReportPointState.earned,
          points: category.defaultPoints,
        );
      }
      if (_pendingCodes.contains(normalizedCode)) {
        return ReportPointInfo(
          category: category,
          state: ReportPointState.pending,
          points: category.defaultPoints,
        );
      }
    } else if (hasVerifiedTimeline) {
      return ReportPointInfo(
        category: category,
        state: ReportPointState.earned,
        points: category.defaultPoints,
      );
    }

    if (normalizedCode.isEmpty && fallbackStatus != null) {
      final isEarnedByFallback =
          fallbackStatus == ComplaintStatus.verified ||
          fallbackStatus == ComplaintStatus.inProgress ||
          fallbackStatus == ComplaintStatus.completed;
      if (isEarnedByFallback) {
        return ReportPointInfo(
          category: category,
          state: ReportPointState.earned,
          points: category.defaultPoints,
        );
      }
    }

    return ReportPointInfo(
      category: category,
      state: ReportPointState.pending,
      points: category.defaultPoints,
    );
  }

  static int? _parseNonNegativeInt(dynamic raw) {
    if (raw is int) return raw >= 0 ? raw : null;
    if (raw is num) {
      if (!raw.isFinite || raw < 0) return null;
      return raw.toInt();
    }
    if (raw is String) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) return null;
      final parsedInt = int.tryParse(trimmed);
      if (parsedInt != null) return parsedInt >= 0 ? parsedInt : null;
      final parsedDouble = double.tryParse(trimmed);
      if (parsedDouble == null || !parsedDouble.isFinite || parsedDouble < 0) {
        return null;
      }
      return parsedDouble.toInt();
    }
    return null;
  }
}

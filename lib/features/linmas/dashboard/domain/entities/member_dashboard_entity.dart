import 'package:equatable/equatable.dart';
import 'package:akar/core/constants/api_constants.dart';

class MemberDashboardEntity extends Equatable {
  final MemberDashboardUserEntity user;
  final MemberDashboardWasteEntity waste;
  final MemberDashboardSurveyEntity survey;

  const MemberDashboardEntity({
    required this.user,
    required this.waste,
    required this.survey,
  });

  @override
  List<Object?> get props => [user, waste, survey];
}

class MemberDashboardUserEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? membershipNo;
  final String? nik;
  final String? photoUrl;
  final String role;
  final String status;

  const MemberDashboardUserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.membershipNo,
    this.nik,
    this.photoUrl,
    required this.role,
    required this.status,
  });

  String? get displayPhotoUrl {
    if (photoUrl == null || photoUrl!.trim().isEmpty) return null;
    final raw = photoUrl!.trim();
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    final clean = raw.startsWith('/') ? raw.substring(1) : raw;
    return '${ApiConstants.baseUrl}/storage/$clean';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    email,
    phone,
    membershipNo,
    nik,
    photoUrl,
    role,
    status,
  ];
}

class MemberDashboardWasteEntity extends Equatable {
  final double totalEarnings;
  final double totalWeightKg;
  final int totalDeposits;

  const MemberDashboardWasteEntity({
    required this.totalEarnings,
    required this.totalWeightKg,
    required this.totalDeposits,
  });

  @override
  List<Object?> get props => [totalEarnings, totalWeightKg, totalDeposits];
}

class MemberDashboardSurveyEntity extends Equatable {
  final bool isAvailable;
  final bool isFilled;
  final String? period;
  final String? month;
  final int? year;
  final int? surveyId;
  final String? surveyTitle;
  final String? description;
  final String? deadlineAt;
  final int? estimatedMinutes;
  final int totalQuestions;
  final String? submittedAt;
  final int? submissionId;

  const MemberDashboardSurveyEntity({
    required this.isAvailable,
    required this.isFilled,
    this.period,
    this.month,
    this.year,
    this.surveyId,
    this.surveyTitle,
    this.description,
    this.deadlineAt,
    this.estimatedMinutes,
    required this.totalQuestions,
    this.submittedAt,
    this.submissionId,
  });

  String get periodLabel {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    int? m = int.tryParse(month ?? '');
    int? y = year;

    if (m == null && period != null && period!.contains('-')) {
      final parts = period!.split('-');
      if (parts.length >= 2) {
        y = int.tryParse(parts[0]);
        m = int.tryParse(parts[1]);
      }
    }

    if (m != null && m >= 1 && m <= 12) {
      final name = monthNames[m - 1];
      return y != null ? '$name $y' : name;
    }

    return period ?? '';
  }

  @override
  List<Object?> get props => [
    isAvailable,
    isFilled,
    period,
    month,
    year,
    surveyId,
    surveyTitle,
    description,
    deadlineAt,
    estimatedMinutes,
    totalQuestions,
    submittedAt,
    submissionId,
  ];
}

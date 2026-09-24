import '../../domain/entities/member_dashboard_entity.dart';

class MemberDashboardResponseModel {
  final bool success;
  final String? message;
  final MemberDashboardModel? data;

  const MemberDashboardResponseModel({
    required this.success,
    this.message,
    this.data,
  });

  factory MemberDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return MemberDashboardResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? MemberDashboardModel.fromJson(json['data'] as Map<String, dynamic>)
          : (json['data'] != null && json['data'] is Map
                ? MemberDashboardModel.fromJson(
                    Map<String, dynamic>.from(json['data'] as Map),
                  )
                : null),
    );
  }
}

class MemberDashboardModel extends MemberDashboardEntity {
  const MemberDashboardModel({
    required super.user,
    required super.waste,
    required super.survey,
  });

  factory MemberDashboardModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : <String, dynamic>{};
    final wasteMap = json['waste'] is Map
        ? Map<String, dynamic>.from(json['waste'] as Map)
        : <String, dynamic>{};
    final surveyMap = json['survey'] is Map
        ? Map<String, dynamic>.from(json['survey'] as Map)
        : <String, dynamic>{};

    return MemberDashboardModel(
      user: MemberDashboardUserModel.fromJson(userMap),
      waste: MemberDashboardWasteModel.fromJson(wasteMap),
      survey: MemberDashboardSurveyModel.fromJson(surveyMap),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as MemberDashboardUserModel).toJson(),
      'waste': (waste as MemberDashboardWasteModel).toJson(),
      'survey': (survey as MemberDashboardSurveyModel).toJson(),
    };
  }
}

class MemberDashboardUserModel extends MemberDashboardUserEntity {
  const MemberDashboardUserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    super.phone,
    super.membershipNo,
    super.nik,
    super.photoUrl,
    required super.role,
    required super.status,
  });

  factory MemberDashboardUserModel.fromJson(Map<String, dynamic> json) {
    return MemberDashboardUserModel(
      id: _parseInt(json['id']),
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      membershipNo: json['membership_no'] as String?,
      nik: json['nik'] as String?,
      photoUrl: json['photo_url'] as String?,
      role: json['role'] as String? ?? '',
      status: json['status'] as String? ?? 'offline',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'membership_no': membershipNo,
      'nik': nik,
      'photo_url': photoUrl,
      'role': role,
      'status': status,
    };
  }
}

class MemberDashboardWasteModel extends MemberDashboardWasteEntity {
  const MemberDashboardWasteModel({
    required super.totalEarnings,
    required super.totalWeightKg,
    required super.totalDeposits,
  });

  factory MemberDashboardWasteModel.fromJson(Map<String, dynamic> json) {
    return MemberDashboardWasteModel(
      totalEarnings: _parseDouble(json['total_earnings']),
      totalWeightKg: _parseDouble(json['total_weight_kg']),
      totalDeposits: _parseInt(json['total_deposits']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_earnings': totalEarnings,
      'total_weight_kg': totalWeightKg,
      'total_deposits': totalDeposits,
    };
  }
}

class MemberDashboardSurveyModel extends MemberDashboardSurveyEntity {
  const MemberDashboardSurveyModel({
    required super.isAvailable,
    required super.isFilled,
    super.period,
    super.month,
    super.year,
    super.surveyId,
    super.surveyTitle,
    super.description,
    super.deadlineAt,
    super.estimatedMinutes,
    required super.totalQuestions,
    super.submittedAt,
    super.submissionId,
  });

  factory MemberDashboardSurveyModel.fromJson(Map<String, dynamic> json) {
    return MemberDashboardSurveyModel(
      isAvailable: json['is_available'] == true,
      isFilled: json['is_filled'] == true,
      period: json['period'] as String?,
      month: json['month']?.toString(),
      year: json['year'] != null ? _parseInt(json['year']) : null,
      surveyId: json['survey_id'] != null ? _parseInt(json['survey_id']) : null,
      surveyTitle: json['survey_title'] as String?,
      description: json['description'] as String?,
      deadlineAt: json['deadline_at'] as String?,
      estimatedMinutes: json['estimated_minutes'] != null
          ? _parseInt(json['estimated_minutes'])
          : null,
      totalQuestions: _parseInt(json['total_questions']),
      submittedAt: json['submitted_at'] as String?,
      submissionId: json['submission_id'] != null
          ? _parseInt(json['submission_id'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_available': isAvailable,
      'is_filled': isFilled,
      'period': period,
      'month': month,
      'year': year,
      'survey_id': surveyId,
      'survey_title': surveyTitle,
      'description': description,
      'deadline_at': deadlineAt,
      'estimated_minutes': estimatedMinutes,
      'total_questions': totalQuestions,
      'submitted_at': submittedAt,
      'submission_id': submissionId,
    };
  }
}

double _parseDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString()) ?? 0.0;
}

int _parseInt(dynamic val) {
  if (val == null) return 0;
  if (val is num) return val.toInt();
  return int.tryParse(val.toString()) ?? 0;
}

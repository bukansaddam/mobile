import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:equatable/equatable.dart';

/// Entitas domain lengkap untuk detail laporan Jaga Tanah.
class JagaTanahDetailEntity extends Equatable {
  final String id;
  final String ticketNumber;
  final String title;
  final String description;
  final String status;
  final String statusLabel;
  final String category;
  final String? subCategory;
  final DateTime? reportedAt;
  final DateTime? updatedAt;
  final int escalationLevel;
  final int? pointsAwarded;

  // A. Lokasi & Data Spasial
  final String address;
  final String? province;
  final String? regency;
  final String? district;
  final String? village;
  final double? latitude;
  final double? longitude;
  final String? geometryType;
  final String? objectShape;
  final String? estimatedArea;
  final String? locationAccess;

  // B. Kondisi Penggunaan & Pemanfaatan
  final String? fieldCondition;
  final String? dominantLandCover;
  final String? visibleUsage;
  final String? usageLevel;
  final String? maintenanceStatus;
  final String? conditionInfoSource;

  // C. Informasi Hak & Penguasaan
  final String? tenureInfoSource;
  final String? possessionMarkers;
  final String? conflictInfo;

  // Verifikasi, Tindak Lanjut & Feedback BPN
  final String? verifierUnit;
  final String? verifierName;
  final String? verificationMethod;
  final String? verificationSummary;
  final String? followUpDecision;
  final String? followUpNotes;
  final String? bpnActionType;
  final String? bpnReferenceNumber;
  final String? sourceInstitution;
  final String? landRightType;
  final String? landRightNumberNib;
  final String? bpnFeedbackStatus;
  final String? bpnFeedbackSummary;
  final String? rejectionReason;
  final String? completionSummary;

  // Media, SLA & Timeline
  final List<ComplaintAttachmentEntity> attachments;
  final ComplaintSlaEntity? sla;
  final List<ComplaintTimelineEntity> timeline;

  const JagaTanahDetailEntity({
    this.id = '',
    this.ticketNumber = '',
    this.title = '',
    this.description = '',
    this.status = '',
    this.statusLabel = '',
    this.category = '',
    this.subCategory,
    this.reportedAt,
    this.updatedAt,
    this.escalationLevel = 0,
    this.pointsAwarded,
    this.address = '',
    this.province,
    this.regency,
    this.district,
    this.village,
    this.latitude,
    this.longitude,
    this.geometryType,
    this.objectShape,
    this.estimatedArea,
    this.locationAccess,
    this.fieldCondition,
    this.dominantLandCover,
    this.visibleUsage,
    this.usageLevel,
    this.maintenanceStatus,
    this.conditionInfoSource,
    this.tenureInfoSource,
    this.possessionMarkers,
    this.conflictInfo,
    this.verifierUnit,
    this.verifierName,
    this.verificationMethod,
    this.verificationSummary,
    this.followUpDecision,
    this.followUpNotes,
    this.bpnActionType,
    this.bpnReferenceNumber,
    this.sourceInstitution,
    this.landRightType,
    this.landRightNumberNib,
    this.bpnFeedbackStatus,
    this.bpnFeedbackSummary,
    this.rejectionReason,
    this.completionSummary,
    this.attachments = const [],
    this.sla,
    this.timeline = const [],
  });

  factory JagaTanahDetailEntity.fromReportEntity(ComplaintReportEntity report) {
    return JagaTanahDetailEntity(
      id: report.id,
      ticketNumber: report.ticketNumber,
      title: report.title,
      description: report.description,
      status: report.status,
      statusLabel: report.statusLabel,
      category: report.category,
      address: report.address,
      latitude: report.latitude,
      longitude: report.longitude,
      reportedAt: report.reportedAt,
      pointsAwarded: report.pointsAwarded,
      attachments: report.attachments,
      sla: report.sla,
      timeline: report.timeline,
    );
  }

  String get displayTicket => ticketNumber.isNotEmpty ? ticketNumber : id;

  bool get hasSpatialCoordinates => latitude != null && longitude != null;

  bool get hasRegionFields => [
    province,
    regency,
    district,
    village,
  ].any((value) => value != null && value.trim().isNotEmpty);

  bool get hasWorkflowDetails => [
    verifierUnit,
    verifierName,
    verificationMethod,
    verificationSummary,
    followUpDecision,
    followUpNotes,
    bpnActionType,
    bpnReferenceNumber,
    sourceInstitution,
    landRightType,
    landRightNumberNib,
    bpnFeedbackStatus,
    bpnFeedbackSummary,
    rejectionReason,
    completionSummary,
  ].any((value) => value != null && value.trim().isNotEmpty);

  @override
  List<Object?> get props => [
    id,
    ticketNumber,
    title,
    description,
    status,
    statusLabel,
    category,
    subCategory,
    reportedAt,
    updatedAt,
    escalationLevel,
    pointsAwarded,
    address,
    province,
    regency,
    district,
    village,
    latitude,
    longitude,
    geometryType,
    objectShape,
    estimatedArea,
    locationAccess,
    fieldCondition,
    dominantLandCover,
    visibleUsage,
    usageLevel,
    maintenanceStatus,
    conditionInfoSource,
    tenureInfoSource,
    possessionMarkers,
    conflictInfo,
    verifierUnit,
    verifierName,
    verificationMethod,
    verificationSummary,
    followUpDecision,
    followUpNotes,
    bpnActionType,
    bpnReferenceNumber,
    sourceInstitution,
    landRightType,
    landRightNumberNib,
    bpnFeedbackStatus,
    bpnFeedbackSummary,
    rejectionReason,
    completionSummary,
    attachments,
    sla,
    timeline,
  ];
}

part of 'create_jaga_tanah_bloc.dart';

abstract class CreateJagaTanahEvent extends Equatable {
  const CreateJagaTanahEvent();

  @override
  List<Object?> get props => [];
}

class LoadJagaTanahCategoriesEvent extends CreateJagaTanahEvent {
  final bool force;

  const LoadJagaTanahCategoriesEvent({this.force = false});

  @override
  List<Object?> get props => [force];
}

class SubmitJagaTanahReportEvent extends CreateJagaTanahEvent {
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final List<File> attachments;
  final int categoryId;
  final int? subCategoryId;
  final String type;
  final String? locationAccess;
  final String? fieldCondition;
  final String? dominantLandCover;
  final String? visibleUsage;
  final String? usageLevel;
  final String? maintenanceStatus;
  final String? conditionInfoSource;
  final String? tenureInfoSource;
  final String? possessionMarkers;
  final String? conflictInfo;
  final String? idempotencyKey;

  const SubmitJagaTanahReportEvent({
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.attachments,
    required this.categoryId,
    this.subCategoryId,
    this.type = 'point',
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
    this.idempotencyKey,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    address,
    latitude,
    longitude,
    attachments,
    categoryId,
    subCategoryId,
    type,
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
    idempotencyKey,
  ];
}

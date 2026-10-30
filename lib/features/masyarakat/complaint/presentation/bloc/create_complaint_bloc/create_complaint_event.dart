part of 'create_complaint_bloc.dart';

abstract class CreateComplaintEvent extends Equatable {
  const CreateComplaintEvent();

  @override
  List<Object?> get props => [];
}

class SubmitComplaintEvent extends CreateComplaintEvent {
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final List<File> attachments;

  const SubmitComplaintEvent({
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.attachments,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    address,
    latitude,
    longitude,
    attachments,
  ];
}

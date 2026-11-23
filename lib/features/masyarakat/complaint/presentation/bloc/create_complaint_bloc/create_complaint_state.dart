part of 'create_complaint_bloc.dart';

abstract class CreateComplaintState extends Equatable {
  const CreateComplaintState();

  @override
  List<Object?> get props => [];
}

class CreateComplaintInitial extends CreateComplaintState {
  const CreateComplaintInitial();
}

class CreateComplaintSubmitting extends CreateComplaintState {
  const CreateComplaintSubmitting();
}

class CreateComplaintSuccess extends CreateComplaintState {
  final ComplaintReportEntity report;

  const CreateComplaintSuccess(this.report);

  @override
  List<Object?> get props => [report];
}

class CreateComplaintQueuedOffline extends CreateComplaintState {
  final String message;
  final String title;

  const CreateComplaintQueuedOffline({
    this.message =
        'Laporan disimpan di antrean offline dan akan dikirim saat online',
    required this.title,
  });

  @override
  List<Object?> get props => [message, title];
}

class CreateComplaintFailure extends CreateComplaintState {
  final String message;

  const CreateComplaintFailure(this.message);

  @override
  List<Object?> get props => [message];
}

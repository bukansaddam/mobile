part of 'complaint_detail_bloc.dart';

abstract class ComplaintDetailState extends Equatable {
  const ComplaintDetailState();

  @override
  List<Object?> get props => [];
}

class ComplaintDetailInitial extends ComplaintDetailState {
  const ComplaintDetailInitial();
}

class ComplaintDetailLoading extends ComplaintDetailState {
  const ComplaintDetailLoading();
}

class ComplaintDetailLoaded extends ComplaintDetailState {
  final ComplaintReportEntity report;

  const ComplaintDetailLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class ComplaintDetailFailure extends ComplaintDetailState {
  final String message;

  const ComplaintDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}

part of 'complaint_detail_bloc.dart';

abstract class ComplaintDetailEvent extends Equatable {
  const ComplaintDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchComplaintDetailEvent extends ComplaintDetailEvent {
  final String id;

  const FetchComplaintDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

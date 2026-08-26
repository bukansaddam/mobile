part of 'activation_bloc.dart';

abstract class ActivationEvent extends Equatable {
  const ActivationEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivationActivitiesEvent extends ActivationEvent {
  final bool isRefresh;

  const LoadActivationActivitiesEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class LoadMoreActivationActivitiesEvent extends ActivationEvent {}

class SetActivationSearchQueryEvent extends ActivationEvent {
  final String query;

  const SetActivationSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SetActivationCategoryFilterEvent extends ActivationEvent {
  final ActivationCategory? category;

  const SetActivationCategoryFilterEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SetActivationStatusFilterEvent extends ActivationEvent {
  final ActivationStatus? status;

  const SetActivationStatusFilterEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class SetActivationSortOptionEvent extends ActivationEvent {
  final ActivationSortOption sortOption;

  const SetActivationSortOptionEvent(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}

class ClearActivationSearchEvent extends ActivationEvent {}

class ResetActivationFiltersEvent extends ActivationEvent {}

class AddActivationReportEvent extends ActivationEvent {
  final String activityId;
  final ActivationReport report;

  const AddActivationReportEvent({
    required this.activityId,
    required this.report,
  });

  @override
  List<Object?> get props => [activityId, report];
}

class SubmitActivationReportApiEvent extends ActivationEvent {
  final String participantId;
  final File file;
  final String? notes;
  final String? receiverNik;
  final String? receiverName;
  final VoidCallback? onSuccess;
  final Function(String message)? onError;

  const SubmitActivationReportApiEvent({
    required this.participantId,
    required this.file,
    this.notes,
    this.receiverNik,
    this.receiverName,
    this.onSuccess,
    this.onError,
  });

  @override
  List<Object?> get props => [
        participantId,
        file.path,
        notes,
        receiverNik,
        receiverName,
      ];
}

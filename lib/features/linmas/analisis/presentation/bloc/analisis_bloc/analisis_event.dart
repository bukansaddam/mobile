part of 'analisis_bloc.dart';

abstract class AnalisisEvent extends Equatable {
  const AnalisisEvent();

  @override
  List<Object?> get props => [];
}

class UpdateAnalisisActivitiesEvent extends AnalisisEvent {
  final List<ActivationActivity> activities;

  const UpdateAnalisisActivitiesEvent(this.activities);

  @override
  List<Object?> get props => [activities];
}

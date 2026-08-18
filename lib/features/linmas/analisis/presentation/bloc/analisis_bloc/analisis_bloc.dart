import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';

part 'analisis_event.dart';
part 'analisis_state.dart';

class AnalisisBloc extends Bloc<AnalisisEvent, AnalisisState> {
  AnalisisBloc({List<ActivationActivity>? initialActivities})
    : super(AnalisisState(activities: initialActivities ?? const [])) {
    on<UpdateAnalisisActivitiesEvent>((event, emit) {
      emit(state.copyWith(activities: event.activities));
    });
  }
}

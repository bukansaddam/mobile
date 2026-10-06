part of 'panic_bloc.dart';

abstract class PanicEvent extends Equatable {
  const PanicEvent();

  @override
  List<Object?> get props => [];
}

class InitPanicLocationEvent extends PanicEvent {}

class SendPanicAlertEvent extends PanicEvent {
  final bool isEmergency;
  final String? note;
  final String? selectedMemberId;

  const SendPanicAlertEvent({
    this.isEmergency = true,
    this.note,
    this.selectedMemberId,
  });

  @override
  List<Object?> get props => [isEmergency, note, selectedMemberId];
}

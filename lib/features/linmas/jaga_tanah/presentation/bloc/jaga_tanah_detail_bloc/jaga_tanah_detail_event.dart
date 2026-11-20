part of 'jaga_tanah_detail_bloc.dart';

abstract class JagaTanahDetailEvent extends Equatable {
  const JagaTanahDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchJagaTanahDetailEvent extends JagaTanahDetailEvent {
  final String id;
  final bool isRefresh;

  const FetchJagaTanahDetailEvent(this.id, {this.isRefresh = false});

  @override
  List<Object?> get props => [id, isRefresh];
}

part of 'jaga_tanah_detail_bloc.dart';

enum JagaTanahDetailStatus { initial, loading, loaded, failure }

class JagaTanahDetailState extends Equatable {
  final JagaTanahDetailStatus status;
  final JagaTanahDetailEntity? detail;
  final String? errorMessage;
  final bool isRefreshing;

  const JagaTanahDetailState({
    this.status = JagaTanahDetailStatus.initial,
    this.detail,
    this.errorMessage,
    this.isRefreshing = false,
  });

  bool get isLoading => status == JagaTanahDetailStatus.loading || isRefreshing;

  JagaTanahDetailState copyWith({
    JagaTanahDetailStatus? status,
    JagaTanahDetailEntity? detail,
    String? errorMessage,
    bool clearError = false,
    bool? isRefreshing,
  }) {
    return JagaTanahDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [status, detail, errorMessage, isRefreshing];
}

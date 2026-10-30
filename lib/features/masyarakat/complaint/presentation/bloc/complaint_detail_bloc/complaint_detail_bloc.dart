import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_complaint_detail_usecase.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'complaint_detail_event.dart';
part 'complaint_detail_state.dart';

class ComplaintDetailBloc
    extends Bloc<ComplaintDetailEvent, ComplaintDetailState> {
  final GetComplaintDetailUsecase _getComplaintDetail;

  ComplaintDetailBloc({required GetComplaintDetailUsecase getComplaintDetail})
    : _getComplaintDetail = getComplaintDetail,
      super(const ComplaintDetailInitial()) {
    on<FetchComplaintDetailEvent>(_onFetch);
  }

  Future<void> _onFetch(
    FetchComplaintDetailEvent event,
    Emitter<ComplaintDetailState> emit,
  ) async {
    emit(const ComplaintDetailLoading());

    final result = await _getComplaintDetail(event.id);

    result.fold((failure) {
      AppLogger.e(
        '[COMPLAINT_DETAIL_BLOC] Gagal memuat detail: ${failure.message}',
      );
      emit(ComplaintDetailFailure(failure.message));
    }, (report) => emit(ComplaintDetailLoaded(report)));
  }
}

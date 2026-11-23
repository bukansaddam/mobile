part of 'create_jaga_tanah_bloc.dart';

enum CreateJagaTanahSubmitStatus { initial, submitting, success, failure }

class CreateJagaTanahState extends Equatable {
  final List<JagaTanahCategoryEntity> categories;
  final bool isLoadingCategories;
  final String? categoryError;
  final CreateJagaTanahSubmitStatus submitStatus;
  final ComplaintReportEntity? submittedReport;
  final String? errorMessage;
  final bool isQueuedOffline;

  const CreateJagaTanahState({
    this.categories = const [],
    this.isLoadingCategories = false,
    this.categoryError,
    this.submitStatus = CreateJagaTanahSubmitStatus.initial,
    this.submittedReport,
    this.errorMessage,
    this.isQueuedOffline = false,
  });

  bool get isSubmitting =>
      submitStatus == CreateJagaTanahSubmitStatus.submitting;

  CreateJagaTanahState copyWith({
    List<JagaTanahCategoryEntity>? categories,
    bool? isLoadingCategories,
    String? categoryError,
    bool clearCategoryError = false,
    CreateJagaTanahSubmitStatus? submitStatus,
    ComplaintReportEntity? submittedReport,
    String? errorMessage,
    bool clearSubmitError = false,
    bool? isQueuedOffline,
  }) {
    return CreateJagaTanahState(
      categories: categories ?? this.categories,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      categoryError: clearCategoryError
          ? null
          : (categoryError ?? this.categoryError),
      submitStatus: submitStatus ?? this.submitStatus,
      submittedReport: submittedReport ?? this.submittedReport,
      errorMessage: clearSubmitError
          ? null
          : (errorMessage ?? this.errorMessage),
      isQueuedOffline: isQueuedOffline ?? this.isQueuedOffline,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    isLoadingCategories,
    categoryError,
    submitStatus,
    submittedReport,
    errorMessage,
    isQueuedOffline,
  ];
}

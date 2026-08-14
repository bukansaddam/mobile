class TrackingResponseModel {
  final bool success;
  final String message;

  TrackingResponseModel({required this.success, required this.message});

  factory TrackingResponseModel.fromJson(Map<String, dynamic> json) {
    final successVal = json['success'] ?? json['status'] ?? true;
    final messageVal =
        json['message'] ??
        json['meta']?['message'] ??
        'Berhasil mengirim lokasi';

    return TrackingResponseModel(
      success: successVal is bool
          ? successVal
          : successVal == 200 || successVal == 'success',
      message: messageVal.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'message': message};
}

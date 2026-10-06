import 'package:freezed_annotation/freezed_annotation.dart';

part 'panic_entity.freezed.dart';

@freezed
abstract class NearbyMemberEntity with _$NearbyMemberEntity {
  const NearbyMemberEntity._();

  const factory NearbyMemberEntity({
    required String id,
    required String name,
    required String role,
    @Default('') String distanceText,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @Default('') String phone,
    @Default(true) bool isOnline,
  }) = _NearbyMemberEntity;
}

@freezed
abstract class PanicAlertResultEntity with _$PanicAlertResultEntity {
  const PanicAlertResultEntity._();

  const factory PanicAlertResultEntity({
    @Default(true) bool isSuccess,
    required String alertId,
    required DateTime timestamp,
    required String message,
  }) = _PanicAlertResultEntity;
}

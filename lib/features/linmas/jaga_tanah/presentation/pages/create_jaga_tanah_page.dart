import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/linmas/activation/presentation/pages/camera_capture_screen.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/usecases/get_jaga_tanah_regions_usecase.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/location_picker_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_form_draft.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_form_options.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_polygon_utils.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_region_matcher.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_reverse_geocoder.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/pages/jaga_tanah_polygon_picker_page.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_attachment_section.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_category_field.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_category_sheet.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_dropdown_field.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_field_label.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_option_sheet.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_region_sheet.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_review_step.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_section_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_spatial_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_step_indicator.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef _DropdownSpec = ({
  _DropdownKey key,
  String label,
  String hint,
  List<String> options,
});

enum _DropdownKey {
  aksesLokasi,
  kondisiUtama,
  penutupLahan,
  penggunaanTerlihat,
  tingkatPenggunaan,
  pemeliharaanFasilitas,
  sumberInformasiKondisi,
  sumberInformasiPenguasaan,
  tandaPenguasaan,
  informasiKonflik,
}

typedef JagaTanahPolygonPickerOpener = Future<List<LatLng>?> Function(
  BuildContext context, {
  LatLng? initialCenter,
  List<LatLng> initialPoints,
});

typedef JagaTanahAdminAddressResolver = Future<JagaTanahAdminAddress> Function(
  LatLng position,
);

typedef JagaTanahMapLocationPickerOpener =
    Future<LocationPickerResult?> Function(
      BuildContext context, {
      String? initialAddress,
      LatLng? initialPosition,
    });

/// Form pelaporan kondisi dan penyalahgunaan tanah 5 langkah (seperti Laporan Harian).
class CreateJagaTanahPage extends HookWidget {
  final bool autoFetchLocation;
  final JagaTanahMapPreviewBuilder? mapPreviewBuilder;
  final JagaTanahPolygonPickerOpener? onOpenPolygonOverride;
  final Future<String?> Function(BuildContext context)? onPickPhotoOverride;
  final Future<String?> Function(BuildContext context)? onPickVideoOverride;
  final JagaTanahAdminAddressResolver? addressResolverOverride;
  final Future<LatLng?> Function(BuildContext context)? onFetchLocationOverride;
  final JagaTanahMapLocationPickerOpener? onPickMapLocationOverride;
  final GetJagaTanahRegionsUsecase? regionsUsecase;

  const CreateJagaTanahPage({
    super.key,
    this.autoFetchLocation = true,
    this.mapPreviewBuilder,
    this.onOpenPolygonOverride,
    this.onPickPhotoOverride,
    this.onPickVideoOverride,
    this.addressResolverOverride,
    this.onFetchLocationOverride,
    this.onPickMapLocationOverride,
    this.regionsUsecase,
  });

  static const int _maxPhotos = 5;

  static const List<_DropdownSpec> _sectionADropdowns = [
    (
      key: _DropdownKey.aksesLokasi,
      label: 'Akses Lokasi',
      hint: 'Pilih akses menuju lokasi',
      options: JagaTanahFormOptions.aksesLokasi,
    ),
  ];

  static const List<_DropdownSpec> _sectionBDropdowns = [
    (
      key: _DropdownKey.kondisiUtama,
      label: 'Kondisi Utama di Lapangan',
      hint: 'Pilih kondisi utama di lapangan',
      options: JagaTanahFormOptions.kondisiUtama,
    ),
    (
      key: _DropdownKey.penutupLahan,
      label: 'Penutup Lahan Dominan',
      hint: 'Pilih penutup lahan dominan',
      options: JagaTanahFormOptions.penutupLahan,
    ),
    (
      key: _DropdownKey.penggunaanTerlihat,
      label: 'Penggunaan Terlihat',
      hint: 'Pilih penggunaan yang terlihat',
      options: JagaTanahFormOptions.penggunaanTerlihat,
    ),
    (
      key: _DropdownKey.tingkatPenggunaan,
      label: 'Tingkat Penggunaan',
      hint: 'Pilih tingkat penggunaan lahan',
      options: JagaTanahFormOptions.tingkatPenggunaan,
    ),
    (
      key: _DropdownKey.pemeliharaanFasilitas,
      label: 'Pemeliharaan / Fasilitas',
      hint: 'Pilih kondisi pemeliharaan',
      options: JagaTanahFormOptions.pemeliharaanFasilitas,
    ),
    (
      key: _DropdownKey.sumberInformasiKondisi,
      label: 'Sumber Informasi Kondisi',
      hint: 'Pilih sumber informasi kondisi',
      options: JagaTanahFormOptions.sumberInformasiKondisi,
    ),
  ];

  static const List<_DropdownSpec> _sectionCDropdowns = [
    (
      key: _DropdownKey.sumberInformasiPenguasaan,
      label: 'Sumber Informasi Penguasaan',
      hint: 'Pilih sumber informasi penguasaan',
      options: JagaTanahFormOptions.sumberInformasiPenguasaan,
    ),
    (
      key: _DropdownKey.tandaPenguasaan,
      label: 'Tanda Penguasaan (Pagar / Papan)',
      hint: 'Pilih tanda penguasaan di lokasi',
      options: JagaTanahFormOptions.tandaPenguasaan,
    ),
    (
      key: _DropdownKey.informasiKonflik,
      label: 'Informasi Konflik / Sengketa',
      hint: 'Pilih status informasi konflik',
      options: JagaTanahFormOptions.informasiKonflik,
    ),
  ];

  Future<void> _fillAdminFromCoordinates(
    BuildContext context, {
    required int seq,
    required ObjectRef<int> locationRequestSeq,
    required LatLng position,
    required GetJagaTanahRegionsUsecase? regionsUsecase,
    required ValueNotifier<JagaTanahRegionEntity?> selectedProvince,
    required ValueNotifier<JagaTanahRegionEntity?> selectedRegency,
    required ValueNotifier<JagaTanahRegionEntity?> selectedDistrict,
    required ValueNotifier<JagaTanahRegionEntity?> selectedVillage,
    required ValueNotifier<Map<JagaTanahRegionLevel, String>> regionErrors,
    required ValueNotifier<bool> isSyncingRegions,
    required ValueNotifier<String?> regionSyncNote,
    required ValueNotifier<bool> regionApiUnavailable,
    required TextEditingController landmarkController,
    String? fallbackLandmark,
    bool overwriteExisting = true,
  }) async {
    final resolved = addressResolverOverride != null
        ? await addressResolverOverride!(position)
        : await JagaTanahReverseGeocoder.resolve(position);
    if (!context.mounted || locationRequestSeq.value != seq) return;

    final landmark =
        (resolved.landmarkAddress != null &&
            resolved.landmarkAddress!.isNotEmpty)
        ? resolved.landmarkAddress!
        : (fallbackLandmark?.trim().isNotEmpty == true
              ? fallbackLandmark!.trim()
              : 'Lat: ${position.latitude.toStringAsFixed(6)}, Long: ${position.longitude.toStringAsFixed(6)}');
    final hasAnyResolved =
        resolved.province != null ||
        resolved.regency != null ||
        resolved.district != null ||
        resolved.village != null ||
        landmark.isNotEmpty;

    if (overwriteExisting && hasAnyResolved) {
      landmarkController.text = landmark;
    } else if (landmark.isNotEmpty && landmarkController.text.trim().isEmpty) {
      landmarkController.text = landmark;
    }

    if (regionsUsecase == null) return;
    if (!overwriteExisting && selectedProvince.value != null) return;

    final hasResolvedRegion =
        resolved.province != null ||
        resolved.regency != null ||
        resolved.district != null ||
        resolved.village != null;
    if (!hasResolvedRegion) {
      if (overwriteExisting) {
        selectedProvince.value = null;
        selectedRegency.value = null;
        selectedDistrict.value = null;
        selectedVillage.value = null;
        regionSyncNote.value = null;
      }
      return;
    }

    isSyncingRegions.value = true;
    try {
      JagaTanahRegionEntity? matchedProvince;
      JagaTanahRegionEntity? matchedRegency;
      JagaTanahRegionEntity? matchedDistrict;
      JagaTanahRegionEntity? matchedVillage;
      var hadPartialMismatch = false;
      var provincesFailed = false;
      var childApiFailed = false;

      final provResult = await regionsUsecase.getProvinces();
      if (!context.mounted || locationRequestSeq.value != seq) return;

      List<JagaTanahRegionEntity>? provinces;
      provResult.fold(
        (_) {
          provincesFailed = true;
          regionApiUnavailable.value = true;
        },
        (items) {
          regionApiUnavailable.value = false;
          provinces = items;
        },
      );

      if (provinces != null) {
        matchedProvince = JagaTanahRegionMatcher.findBestMatch(
          provinces!,
          resolved.province,
          level: JagaTanahRegionLevel.province,
        );

        if (matchedProvince != null) {
          final regResult = await regionsUsecase.getRegencies(
            matchedProvince.id,
          );
          if (!context.mounted || locationRequestSeq.value != seq) return;

          List<JagaTanahRegionEntity>? regencies;
          regResult.fold(
            (_) => childApiFailed = true,
            (items) => regencies = items,
          );

          if (regencies != null) {
            matchedRegency = JagaTanahRegionMatcher.findBestMatch(
              regencies!,
              resolved.regency,
              level: JagaTanahRegionLevel.regency,
            );

            if (matchedRegency != null) {
              final distResult = await regionsUsecase.getDistricts(
                matchedRegency.id,
              );
              if (!context.mounted || locationRequestSeq.value != seq) return;

              List<JagaTanahRegionEntity>? districts;
              distResult.fold(
                (_) => childApiFailed = true,
                (items) => districts = items,
              );

              if (districts != null) {
                matchedDistrict = JagaTanahRegionMatcher.findBestMatch(
                  districts!,
                  resolved.district,
                  level: JagaTanahRegionLevel.district,
                );

                if (matchedDistrict != null) {
                  final vilResult = await regionsUsecase.getVillages(
                    matchedDistrict.id,
                  );
                  if (!context.mounted || locationRequestSeq.value != seq) {
                    return;
                  }

                  List<JagaTanahRegionEntity>? villages;
                  vilResult.fold(
                    (_) => childApiFailed = true,
                    (items) => villages = items,
                  );

                  if (villages != null) {
                    matchedVillage = JagaTanahRegionMatcher.findBestMatch(
                      villages!,
                      resolved.village,
                      level: JagaTanahRegionLevel.village,
                    );
                    if (matchedVillage == null &&
                        resolved.village != null &&
                        resolved.village!.trim().isNotEmpty) {
                      hadPartialMismatch = true;
                    }
                  }
                } else if (resolved.district != null &&
                    resolved.district!.trim().isNotEmpty) {
                  hadPartialMismatch = true;
                }
              }
            } else if (resolved.regency != null &&
                resolved.regency!.trim().isNotEmpty) {
              hadPartialMismatch = true;
            }
          }
        } else if (resolved.province != null &&
            resolved.province!.trim().isNotEmpty) {
          hadPartialMismatch = true;
        }
      }

      if (!context.mounted || locationRequestSeq.value != seq) return;

      if (overwriteExisting || selectedProvince.value == null) {
        selectedProvince.value = matchedProvince;
        selectedRegency.value = matchedRegency;
        selectedDistrict.value = matchedDistrict;
        selectedVillage.value = matchedVillage;

        if (regionErrors.value.isNotEmpty) {
          final nextErrors = Map<JagaTanahRegionLevel, String>.of(
            regionErrors.value,
          );
          if (matchedProvince != null) {
            nextErrors.remove(JagaTanahRegionLevel.province);
          }
          if (matchedRegency != null) {
            nextErrors.remove(JagaTanahRegionLevel.regency);
          }
          if (matchedDistrict != null) {
            nextErrors.remove(JagaTanahRegionLevel.district);
          }
          if (matchedVillage != null) {
            nextErrors.remove(JagaTanahRegionLevel.village);
          }
          regionErrors.value = nextErrors;
        }
      }

      if (provincesFailed || childApiFailed) {
        regionApiUnavailable.value = true;
        regionSyncNote.value =
            'Daftar wilayah sedang tidak dapat dimuat. Anda dapat memilih ulang saat online atau lanjut dengan koordinat GPS.';
      } else if (hadPartialMismatch) {
        regionSyncNote.value =
            'Sebagian wilayah otomatis belum cocok. Silakan pilih sisanya secara manual.';
      } else {
        regionSyncNote.value = null;
      }
    } finally {
      if (context.mounted && locationRequestSeq.value == seq) {
        isSyncingRegions.value = false;
      }
    }
  }

  Future<void> _fetchCurrentLocation(
    BuildContext context, {
    required ValueNotifier<bool> isFetchingLocation,
    required ObjectRef<int> locationRequestSeq,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<double?> accuracyMeters,
    required ValueNotifier<String?> gpsError,
    required GetJagaTanahRegionsUsecase? regionsUsecase,
    required ValueNotifier<JagaTanahRegionEntity?> selectedProvince,
    required ValueNotifier<JagaTanahRegionEntity?> selectedRegency,
    required ValueNotifier<JagaTanahRegionEntity?> selectedDistrict,
    required ValueNotifier<JagaTanahRegionEntity?> selectedVillage,
    required ValueNotifier<Map<JagaTanahRegionLevel, String>> regionErrors,
    required ValueNotifier<bool> isSyncingRegions,
    required ValueNotifier<String?> regionSyncNote,
    required ValueNotifier<bool> regionApiUnavailable,
    required TextEditingController landmarkController,
    bool showErrorToast = true,
    bool overwriteExisting = true,
  }) async {
    if (isFetchingLocation.value) return;
    final seq = ++locationRequestSeq.value;
    isSyncingRegions.value = false;
    isFetchingLocation.value = true;
    try {
      if (onFetchLocationOverride != null) {
        final picked = await onFetchLocationOverride!(context);
        if (picked == null ||
            !context.mounted ||
            locationRequestSeq.value != seq) {
          return;
        }
        latitude.value = picked.latitude;
        longitude.value = picked.longitude;
        accuracyMeters.value = null;
        gpsError.value = null;
        await _fillAdminFromCoordinates(
          context,
          seq: seq,
          locationRequestSeq: locationRequestSeq,
          position: picked,
          regionsUsecase: regionsUsecase,
          selectedProvince: selectedProvince,
          selectedRegency: selectedRegency,
          selectedDistrict: selectedDistrict,
          selectedVillage: selectedVillage,
          regionErrors: regionErrors,
          isSyncingRegions: isSyncingRegions,
          regionSyncNote: regionSyncNote,
          regionApiUnavailable: regionApiUnavailable,
          landmarkController: landmarkController,
          overwriteExisting: overwriteExisting,
        );
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 3));
      if (!serviceEnabled) {
        if (showErrorToast && context.mounted) {
          AppToast.showWarning(
            context,
            message: 'Aktifkan layanan GPS pada perangkat Anda.',
          );
        }
        return;
      }

      var permission = await Geolocator.checkPermission().timeout(
        const Duration(seconds: 3),
      );
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission().timeout(
          const Duration(seconds: 10),
        );
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (showErrorToast && context.mounted) {
          AppToast.showWarning(
            context,
            message: 'Izin lokasi ditolak. Aktifkan izin lokasi di pengaturan.',
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      if (!context.mounted || locationRequestSeq.value != seq) return;

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      accuracyMeters.value = position.accuracy;
      gpsError.value = null;

      await _fillAdminFromCoordinates(
        context,
        seq: seq,
        locationRequestSeq: locationRequestSeq,
        position: LatLng(position.latitude, position.longitude),
        regionsUsecase: regionsUsecase,
        selectedProvince: selectedProvince,
        selectedRegency: selectedRegency,
        selectedDistrict: selectedDistrict,
        selectedVillage: selectedVillage,
        regionErrors: regionErrors,
        isSyncingRegions: isSyncingRegions,
        regionSyncNote: regionSyncNote,
        regionApiUnavailable: regionApiUnavailable,
        landmarkController: landmarkController,
        overwriteExisting: overwriteExisting,
      );
    } catch (_) {
      if (showErrorToast && context.mounted && locationRequestSeq.value == seq) {
        AppToast.showError(context, message: 'Gagal mendeteksi koordinat GPS.');
      }
    } finally {
      if (context.mounted && locationRequestSeq.value == seq) {
        isFetchingLocation.value = false;
      }
    }
  }

  Future<void> _openPolygonPicker(
    BuildContext context, {
    required ValueNotifier<bool> isFetchingLocation,
    required ObjectRef<int> locationRequestSeq,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<double?> accuracyMeters,
    required ValueNotifier<String?> gpsError,
    required ValueNotifier<List<LatLng>> polygonPoints,
    required GetJagaTanahRegionsUsecase? regionsUsecase,
    required ValueNotifier<JagaTanahRegionEntity?> selectedProvince,
    required ValueNotifier<JagaTanahRegionEntity?> selectedRegency,
    required ValueNotifier<JagaTanahRegionEntity?> selectedDistrict,
    required ValueNotifier<JagaTanahRegionEntity?> selectedVillage,
    required ValueNotifier<Map<JagaTanahRegionLevel, String>> regionErrors,
    required ValueNotifier<bool> isSyncingRegions,
    required ValueNotifier<String?> regionSyncNote,
    required ValueNotifier<bool> regionApiUnavailable,
    required TextEditingController landmarkController,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final initialCenter = latitude.value != null && longitude.value != null
        ? LatLng(latitude.value!, longitude.value!)
        : null;

    final opener = onOpenPolygonOverride ?? JagaTanahPolygonPickerPage.open;
    final picked = await opener(
      context,
      initialCenter: initialCenter,
      initialPoints: polygonPoints.value,
    );
    if (picked == null || !context.mounted) return;

    polygonPoints.value = List<LatLng>.unmodifiable(picked);
    final center = JagaTanahPolygonUtils.centroidOf(picked);
    if (center == null) return;

    final seq = ++locationRequestSeq.value;
    isSyncingRegions.value = false;
    latitude.value = center.latitude;
    longitude.value = center.longitude;
    accuracyMeters.value = null;
    gpsError.value = null;

    isFetchingLocation.value = true;
    try {
      await _fillAdminFromCoordinates(
        context,
        seq: seq,
        locationRequestSeq: locationRequestSeq,
        position: center,
        regionsUsecase: regionsUsecase,
        selectedProvince: selectedProvince,
        selectedRegency: selectedRegency,
        selectedDistrict: selectedDistrict,
        selectedVillage: selectedVillage,
        regionErrors: regionErrors,
        isSyncingRegions: isSyncingRegions,
        regionSyncNote: regionSyncNote,
        regionApiUnavailable: regionApiUnavailable,
        landmarkController: landmarkController,
        overwriteExisting: false,
      );
    } finally {
      if (context.mounted && locationRequestSeq.value == seq) {
        isFetchingLocation.value = false;
      }
    }
  }

  Future<void> _pickLocationFromMap(
    BuildContext context, {
    required ValueNotifier<bool> isFetchingLocation,
    required ObjectRef<int> locationRequestSeq,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<double?> accuracyMeters,
    required ValueNotifier<String?> gpsError,
    required GetJagaTanahRegionsUsecase? regionsUsecase,
    required ValueNotifier<JagaTanahRegionEntity?> selectedProvince,
    required ValueNotifier<JagaTanahRegionEntity?> selectedRegency,
    required ValueNotifier<JagaTanahRegionEntity?> selectedDistrict,
    required ValueNotifier<JagaTanahRegionEntity?> selectedVillage,
    required ValueNotifier<Map<JagaTanahRegionLevel, String>> regionErrors,
    required ValueNotifier<bool> isSyncingRegions,
    required ValueNotifier<String?> regionSyncNote,
    required ValueNotifier<bool> regionApiUnavailable,
    required TextEditingController landmarkController,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final initialPosition = latitude.value != null && longitude.value != null
        ? LatLng(latitude.value!, longitude.value!)
        : null;
    final trimmedAddress = landmarkController.text.trim();
    final opener =
        onPickMapLocationOverride ?? LocationPickerPage.showWithResult;

    final picked = await opener(
      context,
      initialAddress: trimmedAddress.isEmpty ? null : trimmedAddress,
      initialPosition: initialPosition,
    );
    if (picked == null || !context.mounted) return;

    final seq = ++locationRequestSeq.value;
    isSyncingRegions.value = false;
    latitude.value = picked.latitude;
    longitude.value = picked.longitude;
    accuracyMeters.value = null;
    gpsError.value = null;

    isFetchingLocation.value = true;
    try {
      await _fillAdminFromCoordinates(
        context,
        seq: seq,
        locationRequestSeq: locationRequestSeq,
        position: picked.position,
        regionsUsecase: regionsUsecase,
        selectedProvince: selectedProvince,
        selectedRegency: selectedRegency,
        selectedDistrict: selectedDistrict,
        selectedVillage: selectedVillage,
        regionErrors: regionErrors,
        isSyncingRegions: isSyncingRegions,
        regionSyncNote: regionSyncNote,
        regionApiUnavailable: regionApiUnavailable,
        landmarkController: landmarkController,
        fallbackLandmark: picked.address,
        overwriteExisting: true,
      );
    } finally {
      if (context.mounted && locationRequestSeq.value == seq) {
        isFetchingLocation.value = false;
      }
    }
  }

  Future<void> _addPhoto(
    BuildContext context, {
    required ValueNotifier<List<String>> photos,
    required ValueNotifier<String?> photoError,
  }) async {
    if (photos.value.length >= _maxPhotos) {
      AppToast.showWarning(context, message: 'Maksimal $_maxPhotos lampiran.');
      return;
    }

    final path = onPickPhotoOverride != null
        ? await onPickPhotoOverride!(context)
        : await CameraCaptureScreen.open(context);
    if (path != null && context.mounted) {
      photos.value = [...photos.value, path];
      photoError.value = null;
    }
  }

  Future<void> _addVideo(
    BuildContext context, {
    required ValueNotifier<List<String>> photos,
    required ValueNotifier<String?> photoError,
  }) async {
    if (photos.value.length >= _maxPhotos) {
      AppToast.showWarning(context, message: 'Maksimal $_maxPhotos lampiran.');
      return;
    }
    if (photos.value.any(FileSecurityUtils.isVideoPath)) {
      AppToast.showWarning(context, message: 'Maksimal 1 video per laporan.');
      return;
    }

    final path = onPickVideoOverride != null
        ? await onPickVideoOverride!(context)
        : await CameraCaptureScreen.openVideo(context);
    if (path != null && context.mounted) {
      photos.value = [...photos.value, path];
      photoError.value = null;
    }
  }

  void _openCategorySheet(
    BuildContext context, {
    required String title,
    required List<JagaTanahCategoryEntity> categories,
    int? selectedId,
    required ValueChanged<JagaTanahCategoryEntity> onSelected,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    final colors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => JagaTanahCategorySheet(
        title: title,
        categories: categories,
        selectedId: selectedId,
        onSelected: onSelected,
      ),
    );
  }

  String? _validateStep(
    int step, {
    required GlobalKey<FormState> step0FormKey,
    required GlobalKey<FormState> step1FormKey,
    required TextEditingController titleController,
    required ValueNotifier<JagaTanahCategoryEntity?> selectedCategory,
    required ValueNotifier<JagaTanahCategoryEntity?> selectedSubCategory,
    required ValueNotifier<String?> categoryError,
    required ValueNotifier<String?> subCategoryError,
    required ValueNotifier<JagaTanahRegionEntity?> selectedProvince,
    required ValueNotifier<JagaTanahRegionEntity?> selectedRegency,
    required ValueNotifier<JagaTanahRegionEntity?> selectedDistrict,
    required ValueNotifier<JagaTanahRegionEntity?> selectedVillage,
    required ValueNotifier<Map<JagaTanahRegionLevel, String>> regionErrors,
    required ValueNotifier<bool> regionApiUnavailable,
    required TextEditingController landmarkController,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<String?> gpsError,
    required ValueNotifier<List<String>> photos,
    required ValueNotifier<String?> photoError,
    required ValueNotifier<Map<_DropdownKey, String>> dropdownValues,
    required ValueNotifier<Map<_DropdownKey, String>> dropdownErrors,
  }) {
    if (step == 0) {
      final category = selectedCategory.value;
      final hasCategory = category != null;
      categoryError.value = hasCategory
          ? null
          : 'Kategori Laporan wajib dipilih';

      final needsSub = category?.hasSubCategories == true;
      final hasSub = !needsSub || selectedSubCategory.value != null;
      subCategoryError.value = hasSub ? null : 'Sub-Kategori wajib dipilih';

      final validText = step0FormKey.currentState != null
          ? step0FormKey.currentState!.validate()
          : titleController.text.trim().isNotEmpty;

      if (!hasCategory) {
        return 'Pilih kategori laporan terlebih dahulu.';
      }
      if (!hasSub) {
        return 'Pilih sub-kategori laporan terlebih dahulu.';
      }
      if (!validText) {
        return 'Lengkapi judul laporan terlebih dahulu.';
      }
      return null;
    }

    if (step == 1) {
      final hasGps = latitude.value != null && longitude.value != null;
      gpsError.value = hasGps ? null : 'Titik lokasi di peta wajib dipilih';

      final isOfflineFallback =
          hasGps &&
          (regionApiUnavailable.value ||
              (selectedProvince.value == null &&
                  selectedRegency.value == null &&
                  landmarkController.text.trim().startsWith('Lat:')));

      var hasValidRegions = true;
      if (isOfflineFallback) {
        if (regionErrors.value.isNotEmpty) {
          regionErrors.value = const {};
        }
      } else {
        final nextRegionErrors = <JagaTanahRegionLevel, String>{};
        if (selectedProvince.value == null) {
          nextRegionErrors[JagaTanahRegionLevel.province] =
              'Provinsi wajib dipilih';
        }
        if (selectedRegency.value == null) {
          nextRegionErrors[JagaTanahRegionLevel.regency] =
              'Kabupaten/Kota wajib dipilih';
        }
        if (selectedDistrict.value == null) {
          nextRegionErrors[JagaTanahRegionLevel.district] =
              'Kecamatan wajib dipilih';
        }
        if (selectedVillage.value == null) {
          nextRegionErrors[JagaTanahRegionLevel.village] =
              'Desa/Kelurahan wajib dipilih';
        }
        regionErrors.value = nextRegionErrors;
        hasValidRegions = nextRegionErrors.isEmpty;
      }

      final validLandmark = step1FormKey.currentState != null
          ? step1FormKey.currentState!.validate()
          : landmarkController.text.trim().isNotEmpty;

      final hasPhotos = photos.value.isNotEmpty;
      photoError.value = hasPhotos
          ? null
          : 'Minimal 1 lampiran foto atau video wajib dilampirkan';

      final dropdownIssue = _validateDropdownGroup(
        _sectionADropdowns,
        dropdownValues: dropdownValues,
        dropdownErrors: dropdownErrors,
      );

      if (!hasValidRegions || !validLandmark) {
        return 'Lengkapi seluruh data wilayah dan alamat lokasi.';
      }
      if (!hasGps) {
        return 'Pilih titik lokasi di peta terlebih dahulu.';
      }
      if (!hasPhotos) {
        return 'Ambil minimal 1 lampiran foto atau video.';
      }
      return dropdownIssue;
    }

    if (step == 2) {
      return _validateDropdownGroup(
        _sectionBDropdowns,
        dropdownValues: dropdownValues,
        dropdownErrors: dropdownErrors,
      );
    }

    if (step == 3) {
      return _validateDropdownGroup(
        _sectionCDropdowns,
        dropdownValues: dropdownValues,
        dropdownErrors: dropdownErrors,
      );
    }

    return null;
  }

  JagaTanahFormDraft _buildDraft({
    required JagaTanahCategoryEntity? category,
    required JagaTanahCategoryEntity? subCategory,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required JagaTanahRegionEntity? selectedProvince,
    required JagaTanahRegionEntity? selectedRegency,
    required JagaTanahRegionEntity? selectedDistrict,
    required JagaTanahRegionEntity? selectedVillage,
    required TextEditingController landmarkController,
    required double? latitude,
    required double? longitude,
    required double? accuracyMeters,
    required List<LatLng> polygonPoints,
    required List<String> photos,
    required Map<_DropdownKey, String> values,
  }) {
    return JagaTanahFormDraft(
      categoryId: category?.id ?? 0,
      categoryLabel: category?.label ?? '-',
      subCategoryId: subCategory?.id,
      subCategoryLabel: subCategory?.label,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      province: selectedProvince?.name ?? '',
      regency: selectedRegency?.name ?? '',
      district: selectedDistrict?.name ?? '',
      village: selectedVillage?.name ?? '',
      provinceId: selectedProvince?.id,
      regencyId: selectedRegency?.id,
      districtId: selectedDistrict?.id,
      villageId: selectedVillage?.id,
      landmarkAddress: landmarkController.text.trim(),
      latitude: latitude ?? 0,
      longitude: longitude ?? 0,
      accuracyMeters: accuracyMeters,
      polygonPoints: polygonPoints,
      photoPaths: photos,
      aksesLokasi: values[_DropdownKey.aksesLokasi] ?? '-',
      kondisiUtama: values[_DropdownKey.kondisiUtama] ?? '-',
      penutupLahan: values[_DropdownKey.penutupLahan] ?? '-',
      penggunaanTerlihat: values[_DropdownKey.penggunaanTerlihat] ?? '-',
      tingkatPenggunaan: values[_DropdownKey.tingkatPenggunaan] ?? '-',
      pemeliharaanFasilitas: values[_DropdownKey.pemeliharaanFasilitas] ?? '-',
      sumberInformasiKondisi:
          values[_DropdownKey.sumberInformasiKondisi] ?? '-',
      sumberInformasiPenguasaan:
          values[_DropdownKey.sumberInformasiPenguasaan] ?? '-',
      tandaPenguasaan: values[_DropdownKey.tandaPenguasaan] ?? '-',
      informasiKonflik: values[_DropdownKey.informasiKonflik] ?? '-',
    );
  }

  String? _validateDropdownGroup(
    List<_DropdownSpec> specs, {
    required ValueNotifier<Map<_DropdownKey, String>> dropdownValues,
    required ValueNotifier<Map<_DropdownKey, String>> dropdownErrors,
  }) {
    final nextErrors = Map<_DropdownKey, String>.of(dropdownErrors.value);
    String? firstMissing;
    for (final spec in specs) {
      final selected = dropdownValues.value[spec.key];
      if (selected == null || selected.trim().isEmpty) {
        nextErrors[spec.key] = '${spec.label} wajib dipilih';
        firstMissing ??= spec.label;
      } else {
        nextErrors.remove(spec.key);
      }
    }
    dropdownErrors.value = nextErrors;
    return firstMissing != null ? 'Pilih $firstMissing terlebih dahulu.' : null;
  }

  void _scrollToTop(ScrollController scrollController) {
    if (!scrollController.hasClients) return;
    scrollController.jumpTo(0);
  }

  void _onNextStep(
    BuildContext context, {
    required ValueNotifier<int> currentStep,
    required ScrollController scrollController,
    required GlobalKey<FormState> step0FormKey,
    required GlobalKey<FormState> step1FormKey,
    required TextEditingController titleController,
    required ValueNotifier<JagaTanahCategoryEntity?> selectedCategory,
    required ValueNotifier<JagaTanahCategoryEntity?> selectedSubCategory,
    required ValueNotifier<String?> categoryError,
    required ValueNotifier<String?> subCategoryError,
    required ValueNotifier<JagaTanahRegionEntity?> selectedProvince,
    required ValueNotifier<JagaTanahRegionEntity?> selectedRegency,
    required ValueNotifier<JagaTanahRegionEntity?> selectedDistrict,
    required ValueNotifier<JagaTanahRegionEntity?> selectedVillage,
    required ValueNotifier<Map<JagaTanahRegionLevel, String>> regionErrors,
    required ValueNotifier<bool> regionApiUnavailable,
    required TextEditingController landmarkController,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<String?> gpsError,
    required ValueNotifier<List<String>> photos,
    required ValueNotifier<String?> photoError,
    required ValueNotifier<Map<_DropdownKey, String>> dropdownValues,
    required ValueNotifier<Map<_DropdownKey, String>> dropdownErrors,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    final error = _validateStep(
      currentStep.value,
      step0FormKey: step0FormKey,
      step1FormKey: step1FormKey,
      titleController: titleController,
      selectedCategory: selectedCategory,
      selectedSubCategory: selectedSubCategory,
      categoryError: categoryError,
      subCategoryError: subCategoryError,
      selectedProvince: selectedProvince,
      selectedRegency: selectedRegency,
      selectedDistrict: selectedDistrict,
      selectedVillage: selectedVillage,
      regionErrors: regionErrors,
      regionApiUnavailable: regionApiUnavailable,
      landmarkController: landmarkController,
      latitude: latitude,
      longitude: longitude,
      gpsError: gpsError,
      photos: photos,
      photoError: photoError,
      dropdownValues: dropdownValues,
      dropdownErrors: dropdownErrors,
    );
    if (error != null) {
      AppToast.showWarning(context, message: error);
      return;
    }
    if (currentStep.value < JagaTanahStepIndicator.totalSteps - 1) {
      currentStep.value = currentStep.value + 1;
      _scrollToTop(scrollController);
    }
  }

  static final Random _idempotencyRandom = Random.secure();

  String _generateIdempotencyKey() {
    final bytes = List<int>.generate(
      12,
      (_) => _idempotencyRandom.nextInt(256),
    );
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    return 'jgt-$ts-$hex';
  }

  String _resolveIdempotencyKey(
    ObjectRef<({String signature, String key})?> ref, {
    required int categoryId,
    required int? subCategoryId,
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required List<String> attachmentPaths,
    required Map<_DropdownKey, String> dropdownValues,
    Map<String, dynamic>? boundaryGeojson,
  }) {
    final parts = <String>[
      '$categoryId',
      '${subCategoryId ?? ''}',
      title,
      description,
      address,
      latitude.toStringAsFixed(6),
      longitude.toStringAsFixed(6),
      boundaryGeojson != null ? jsonEncode(boundaryGeojson) : '',
      attachmentPaths.join('\x1E'),
      ..._DropdownKey.values.map((k) => dropdownValues[k] ?? ''),
    ];
    final signature = parts.join('\x1F');
    final existing = ref.value;
    if (existing != null && existing.signature == signature) {
      return existing.key;
    }
    final key = _generateIdempotencyKey();
    ref.value = (signature: signature, key: key);
    return key;
  }

  Future<void> _showSubmitSuccessDialog(
    BuildContext context, {
    ComplaintReportEntity? report,
    bool isQueuedOffline = false,
  }) {
    final ticketNumber = report?.ticketNumber.trim();
    final hasTicket =
        !isQueuedOffline && ticketNumber != null && ticketNumber.isNotEmpty;

    return AppDialogs.showSuccess<void>(
      context,
      title: isQueuedOffline
          ? 'Disimpan di Antrean Offline'
          : 'Laporan Terkirim',
      message: isQueuedOffline
          ? 'Laporan Jaga Tanah disimpan di antrean offline dan akan dikirim otomatis saat online.'
          : 'Laporan Jaga Tanah berhasil dikirim dan sedang diproses untuk verifikasi (< 24 jam).',
      buttonText: 'Selesai',
      barrierDismissible: false,
      customContent: hasTicket
          ? Builder(
              builder: (dialogContext) {
                final colors = dialogContext.appColors;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nomor Tiket',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ticketNumber,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: colors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : null,
      onPressed: () {
        if (context.mounted) {
          Navigator.of(context).maybePop(true);
        }
      },
    );
  }

  void _submit(
    BuildContext context, {
    required ValueNotifier<int> currentStep,
    required ScrollController scrollController,
    required GlobalKey<FormState> step0FormKey,
    required GlobalKey<FormState> step1FormKey,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required ValueNotifier<JagaTanahCategoryEntity?> selectedCategory,
    required ValueNotifier<JagaTanahCategoryEntity?> selectedSubCategory,
    required ValueNotifier<String?> categoryError,
    required ValueNotifier<String?> subCategoryError,
    required ValueNotifier<JagaTanahRegionEntity?> selectedProvince,
    required ValueNotifier<JagaTanahRegionEntity?> selectedRegency,
    required ValueNotifier<JagaTanahRegionEntity?> selectedDistrict,
    required ValueNotifier<JagaTanahRegionEntity?> selectedVillage,
    required ValueNotifier<Map<JagaTanahRegionLevel, String>> regionErrors,
    required ValueNotifier<bool> regionApiUnavailable,
    required TextEditingController landmarkController,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<String?> gpsError,
    required ValueNotifier<List<LatLng>> polygonPoints,
    required ValueNotifier<List<String>> photos,
    required ValueNotifier<String?> photoError,
    required ValueNotifier<Map<_DropdownKey, String>> dropdownValues,
    required ValueNotifier<Map<_DropdownKey, String>> dropdownErrors,
    required ObjectRef<({String signature, String key})?> idempotencyRef,
  }) {
    final bloc = context.read<CreateJagaTanahBloc>();
    if (bloc.state.isSubmitting) return;

    FocusManager.instance.primaryFocus?.unfocus();
    for (var step = 0; step < JagaTanahStepIndicator.totalSteps - 1; step++) {
      final error = _validateStep(
        step,
        step0FormKey: step0FormKey,
        step1FormKey: step1FormKey,
        titleController: titleController,
        selectedCategory: selectedCategory,
        selectedSubCategory: selectedSubCategory,
        categoryError: categoryError,
        subCategoryError: subCategoryError,
        selectedProvince: selectedProvince,
        selectedRegency: selectedRegency,
        selectedDistrict: selectedDistrict,
        selectedVillage: selectedVillage,
        regionErrors: regionErrors,
        regionApiUnavailable: regionApiUnavailable,
        landmarkController: landmarkController,
        latitude: latitude,
        longitude: longitude,
        gpsError: gpsError,
        photos: photos,
        photoError: photoError,
        dropdownValues: dropdownValues,
        dropdownErrors: dropdownErrors,
      );
      if (error != null) {
        currentStep.value = step;
        _scrollToTop(scrollController);
        AppToast.showWarning(context, message: error);
        return;
      }
    }

    final categoryId = selectedCategory.value?.id;
    final lat = latitude.value;
    final lng = longitude.value;
    if (categoryId == null || lat == null || lng == null) return;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final address = landmarkController.text.trim();
    final values = dropdownValues.value;
    final boundaryGeojson = JagaTanahPolygonUtils.toBoundaryGeoJson(
      polygonPoints.value,
    );
    final hasPolygon = boundaryGeojson != null;
    final reportType = hasPolygon ? 'geometries' : 'point';
    final estimatedArea = hasPolygon
        ? JagaTanahPolygonUtils.formatArea(
            JagaTanahPolygonUtils.calculateAreaSquareMeters(
              polygonPoints.value,
            ),
          )
        : null;
    final idempotencyKey = _resolveIdempotencyKey(
      idempotencyRef,
      categoryId: categoryId,
      subCategoryId: selectedSubCategory.value?.id,
      title: title,
      description: description,
      address: address,
      latitude: lat,
      longitude: lng,
      attachmentPaths: photos.value,
      dropdownValues: values,
      boundaryGeojson: boundaryGeojson,
    );

    bloc.add(
      SubmitJagaTanahReportEvent(
        title: title,
        description: description,
        address: address,
        latitude: lat,
        longitude: lng,
        attachments: photos.value.map(File.new).toList(),
        categoryId: categoryId,
        subCategoryId: selectedSubCategory.value?.id,
        type: reportType,
        locationAccess: values[_DropdownKey.aksesLokasi],
        fieldCondition: values[_DropdownKey.kondisiUtama],
        dominantLandCover: values[_DropdownKey.penutupLahan],
        visibleUsage: values[_DropdownKey.penggunaanTerlihat],
        usageLevel: values[_DropdownKey.tingkatPenggunaan],
        maintenanceStatus: values[_DropdownKey.pemeliharaanFasilitas],
        conditionInfoSource: values[_DropdownKey.sumberInformasiKondisi],
        tenureInfoSource: values[_DropdownKey.sumberInformasiPenguasaan],
        possessionMarkers: values[_DropdownKey.tandaPenguasaan],
        conflictInfo: values[_DropdownKey.informasiKonflik],
        boundaryGeojson: boundaryGeojson,
        estimatedArea: estimatedArea,
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final step0FormKey = useMemoized(GlobalKey<FormState>.new);
    final step1FormKey = useMemoized(GlobalKey<FormState>.new);
    final scrollController = useScrollController();
    final currentStep = useState<int>(0);

    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final selectedCategory = useState<JagaTanahCategoryEntity?>(null);
    final selectedSubCategory = useState<JagaTanahCategoryEntity?>(null);
    final categoryError = useState<String?>(null);
    final subCategoryError = useState<String?>(null);

    final effectiveRegionsUsecase =
        regionsUsecase ??
        (sl.isRegistered<GetJagaTanahRegionsUsecase>()
            ? sl<GetJagaTanahRegionsUsecase>()
            : null);

    final selectedProvince = useState<JagaTanahRegionEntity?>(null);
    final selectedRegency = useState<JagaTanahRegionEntity?>(null);
    final selectedDistrict = useState<JagaTanahRegionEntity?>(null);
    final selectedVillage = useState<JagaTanahRegionEntity?>(null);
    final regionErrors = useState<Map<JagaTanahRegionLevel, String>>(const {});
    final isSyncingRegions = useState<bool>(false);
    final regionSyncNote = useState<String?>(null);
    final regionApiUnavailable = useState<bool>(false);
    final landmarkController = useTextEditingController();

    final isFetchingLocation = useState(false);
    final locationRequestSeq = useRef<int>(0);
    final latitude = useState<double?>(null);
    final longitude = useState<double?>(null);
    final accuracyMeters = useState<double?>(null);
    final gpsError = useState<String?>(null);
    final polygonPoints = useState<List<LatLng>>(const []);

    final photos = useState<List<String>>(const []);
    final photoError = useState<String?>(null);

    final dropdownValues = useState<Map<_DropdownKey, String>>(const {});
    final dropdownErrors = useState<Map<_DropdownKey, String>>(const {});
    final idempotencyRef = useRef<({String signature, String key})?>(null);
    final isSubmitting = context.select<CreateJagaTanahBloc, bool>(
      (bloc) => bloc.state.isSubmitting,
    );

    void clearRegionErrors(Iterable<JagaTanahRegionLevel> levels) {
      if (regionErrors.value.isEmpty) return;
      final next = Map<JagaTanahRegionLevel, String>.of(regionErrors.value);
      var changed = false;
      for (final level in levels) {
        if (next.remove(level) != null) changed = true;
      }
      if (changed) regionErrors.value = next;
    }

    useEffect(() {
      if (!autoFetchLocation) return null;
      _fetchCurrentLocation(
        context,
        isFetchingLocation: isFetchingLocation,
        locationRequestSeq: locationRequestSeq,
        latitude: latitude,
        longitude: longitude,
        accuracyMeters: accuracyMeters,
        gpsError: gpsError,
        regionsUsecase: effectiveRegionsUsecase,
        selectedProvince: selectedProvince,
        selectedRegency: selectedRegency,
        selectedDistrict: selectedDistrict,
        selectedVillage: selectedVillage,
        regionErrors: regionErrors,
        isSyncingRegions: isSyncingRegions,
        regionSyncNote: regionSyncNote,
        regionApiUnavailable: regionApiUnavailable,
        landmarkController: landmarkController,
        showErrorToast: false,
        overwriteExisting: false,
      );
      return null;
    }, [autoFetchLocation]);

    List<Widget> buildDropdownWidgets(List<_DropdownSpec> specs) {
      final widgets = <Widget>[];
      for (var i = 0; i < specs.length; i++) {
        final spec = specs[i];
        if (i > 0) widgets.add(const SizedBox(height: 14));
        widgets.add(
          JagaTanahDropdownField(
            label: spec.label,
            hintText: spec.hint,
            selectedValue: dropdownValues.value[spec.key],
            errorText: dropdownErrors.value[spec.key],
            onTap: () => JagaTanahOptionSheet.show(
              context,
              title: spec.label,
              options: spec.options,
              selectedValue: dropdownValues.value[spec.key],
              onSelected: (picked) {
                dropdownValues.value = {
                  ...dropdownValues.value,
                  spec.key: picked,
                };
                dropdownErrors.value = Map.of(dropdownErrors.value)
                  ..remove(spec.key);
              },
            ),
          ),
        );
      }
      return widgets;
    }

    final Widget stepContent;
    switch (currentStep.value) {
      case 0:
        stepContent = Form(
          key: step0FormKey,
          child: JagaTanahSectionCard(
            title: 'Informasi Laporan',
            icon: Icons.article_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<CreateJagaTanahBloc, CreateJagaTanahState>(
                  builder: (blocContext, state) {
                    return JagaTanahCategoryField(
                      label: 'Kategori Laporan',
                      hintText: 'Pilih kategori laporan',
                      prefixIcon: selectedCategory.value != null
                          ? JagaTanahCategorySheet.iconFor(
                              selectedCategory.value!,
                            )
                          : Icons.landscape_rounded,
                      selectedLabel: selectedCategory.value?.label,
                      isLoading: state.isLoadingCategories,
                      errorText: categoryError.value,
                      fetchErrorText: state.categoryError,
                      onRetry: () => blocContext
                          .read<CreateJagaTanahBloc>()
                          .add(const LoadJagaTanahCategoriesEvent(force: true)),
                      onTap: () {
                        if (state.categories.isEmpty) {
                          blocContext.read<CreateJagaTanahBloc>().add(
                            const LoadJagaTanahCategoriesEvent(force: true),
                          );
                          return;
                        }
                        _openCategorySheet(
                          context,
                          title: 'Kategori Laporan',
                          categories: state.categories,
                          selectedId: selectedCategory.value?.id,
                          onSelected: (picked) {
                            selectedCategory.value = picked;
                            selectedSubCategory.value = null;
                            categoryError.value = null;
                            subCategoryError.value = null;
                          },
                        );
                      },
                    );
                  },
                ),
                if (selectedCategory.value?.hasSubCategories == true) ...[
                  const SizedBox(height: 14),
                  JagaTanahCategoryField(
                    label: 'Sub-Kategori',
                    hintText: 'Pilih sub-kategori',
                    prefixIcon: selectedSubCategory.value != null
                        ? JagaTanahCategorySheet.iconFor(
                            selectedSubCategory.value!,
                          )
                        : Icons.subdirectory_arrow_right_rounded,
                    selectedLabel: selectedSubCategory.value?.label,
                    errorText: subCategoryError.value,
                    onTap: () => _openCategorySheet(
                      context,
                      title: 'Sub-Kategori (${selectedCategory.value!.label})',
                      categories: selectedCategory.value!.children,
                      selectedId: selectedSubCategory.value?.id,
                      onSelected: (picked) {
                        selectedSubCategory.value = picked;
                        subCategoryError.value = null;
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                JagaTanahTextField(
                  controller: titleController,
                  label: 'Judul Laporan',
                  hintText: 'Contoh: Indikasi okupasi tanah kas desa',
                  maxLength: 255,
                ),
                const SizedBox(height: 14),
                JagaTanahTextField(
                  controller: descriptionController,
                  label: 'Deskripsi',
                  hintText: 'Ringkasan singkat atau catatan penting di lapangan (opsional)',
                  isRequired: false,
                  maxLines: 3,
                  maxLength: 1000,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        );
      case 1:
        stepContent = Form(
          key: step1FormKey,
          child: JagaTanahSectionCard(
            title: 'Lokasi dan Data Spasial',
            icon: Icons.location_on_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textScale = MediaQuery.textScalerOf(context)
                        .scale(1.0);
                    final useTwoColumns =
                        constraints.maxWidth >= 320 && textScale <= 1.35;

                    final hasCoordinates =
                        latitude.value != null && longitude.value != null;
                    final isOfflineLocationFallback =
                        hasCoordinates &&
                        (regionApiUnavailable.value ||
                            (selectedProvince.value == null &&
                                selectedRegency.value == null &&
                                landmarkController.text.trim().startsWith(
                                  'Lat:',
                                )));
                    final isWilayahRequired = !isOfflineLocationFallback;

                    JagaTanahRegionLoader trackRegionLoader(
                      JagaTanahRegionLoader loader,
                    ) {
                      return ({bool forceRefresh = false}) async {
                        final result = await loader(forceRefresh: forceRefresh);
                        if (context.mounted) {
                          result.fold(
                            (_) => regionApiUnavailable.value = true,
                            (_) => regionApiUnavailable.value = false,
                          );
                        }
                        return result;
                      };
                    }

                    final provinceField = JagaTanahDropdownField(
                      label: 'Provinsi',
                      hintText: 'Pilih provinsi',
                      selectedValue: selectedProvince.value?.name,
                      isRequired: isWilayahRequired,
                      isLoading:
                          isSyncingRegions.value &&
                          selectedProvince.value == null,
                      errorText:
                          regionErrors.value[JagaTanahRegionLevel.province],
                      onTap: () {
                        if (effectiveRegionsUsecase == null) {
                          AppToast.showWarning(
                            context,
                            message: 'Layanan data wilayah belum tersedia.',
                          );
                          return;
                        }
                        JagaTanahRegionSheet.show(
                          context,
                          title: 'Pilih Provinsi',
                          searchHint: 'Cari provinsi...',
                          selectedId: selectedProvince.value?.id,
                          loader: trackRegionLoader(
                            ({bool forceRefresh = false}) =>
                                effectiveRegionsUsecase.getProvinces(
                                  forceRefresh: forceRefresh,
                                ),
                          ),
                          onSelected: (picked) {
                            locationRequestSeq.value++;
                            isFetchingLocation.value = false;
                            isSyncingRegions.value = false;
                            regionSyncNote.value = null;
                            regionApiUnavailable.value = false;
                            if (picked.id != selectedProvince.value?.id) {
                              selectedProvince.value = picked;
                              selectedRegency.value = null;
                              selectedDistrict.value = null;
                              selectedVillage.value = null;
                              clearRegionErrors(JagaTanahRegionLevel.values);
                            } else {
                              clearRegionErrors(const [
                                JagaTanahRegionLevel.province,
                              ]);
                            }
                          },
                        );
                      },
                    );
                    final regencyField = JagaTanahDropdownField(
                      label: 'Kabupaten/Kota',
                      hintText: 'Pilih kabupaten/kota',
                      selectedValue: selectedRegency.value?.name,
                      isRequired: isWilayahRequired,
                      isMuted: selectedProvince.value == null,
                      isLoading:
                          isSyncingRegions.value &&
                          selectedProvince.value != null &&
                          selectedRegency.value == null,
                      errorText:
                          regionErrors.value[JagaTanahRegionLevel.regency],
                      onTap: () {
                        if (effectiveRegionsUsecase == null) {
                          AppToast.showWarning(
                            context,
                            message: 'Layanan data wilayah belum tersedia.',
                          );
                          return;
                        }
                        final province = selectedProvince.value;
                        if (province == null) {
                          AppToast.showWarning(
                            context,
                            message: 'Pilih Provinsi terlebih dahulu.',
                          );
                          return;
                        }
                        JagaTanahRegionSheet.show(
                          context,
                          title: 'Pilih Kabupaten/Kota',
                          searchHint: 'Cari kabupaten/kota...',
                          selectedId: selectedRegency.value?.id,
                          loader: trackRegionLoader(
                            ({bool forceRefresh = false}) =>
                                effectiveRegionsUsecase.getRegencies(
                                  province.id,
                                  forceRefresh: forceRefresh,
                                ),
                          ),
                          onSelected: (picked) {
                            locationRequestSeq.value++;
                            isFetchingLocation.value = false;
                            isSyncingRegions.value = false;
                            regionSyncNote.value = null;
                            if (picked.id != selectedRegency.value?.id) {
                              selectedRegency.value = picked;
                              selectedDistrict.value = null;
                              selectedVillage.value = null;
                              clearRegionErrors(const [
                                JagaTanahRegionLevel.regency,
                                JagaTanahRegionLevel.district,
                                JagaTanahRegionLevel.village,
                              ]);
                            } else {
                              clearRegionErrors(const [
                                JagaTanahRegionLevel.regency,
                              ]);
                            }
                          },
                        );
                      },
                    );
                    final districtField = JagaTanahDropdownField(
                      label: 'Kecamatan',
                      hintText: 'Pilih kecamatan',
                      selectedValue: selectedDistrict.value?.name,
                      isRequired: isWilayahRequired,
                      isMuted: selectedRegency.value == null,
                      isLoading:
                          isSyncingRegions.value &&
                          selectedRegency.value != null &&
                          selectedDistrict.value == null,
                      errorText:
                          regionErrors.value[JagaTanahRegionLevel.district],
                      onTap: () {
                        if (effectiveRegionsUsecase == null) {
                          AppToast.showWarning(
                            context,
                            message: 'Layanan data wilayah belum tersedia.',
                          );
                          return;
                        }
                        final regency = selectedRegency.value;
                        if (regency == null) {
                          AppToast.showWarning(
                            context,
                            message: 'Pilih Kabupaten/Kota terlebih dahulu.',
                          );
                          return;
                        }
                        JagaTanahRegionSheet.show(
                          context,
                          title: 'Pilih Kecamatan',
                          searchHint: 'Cari kecamatan...',
                          selectedId: selectedDistrict.value?.id,
                          loader: trackRegionLoader(
                            ({bool forceRefresh = false}) =>
                                effectiveRegionsUsecase.getDistricts(
                                  regency.id,
                                  forceRefresh: forceRefresh,
                                ),
                          ),
                          onSelected: (picked) {
                            locationRequestSeq.value++;
                            isFetchingLocation.value = false;
                            isSyncingRegions.value = false;
                            regionSyncNote.value = null;
                            if (picked.id != selectedDistrict.value?.id) {
                              selectedDistrict.value = picked;
                              selectedVillage.value = null;
                              clearRegionErrors(const [
                                JagaTanahRegionLevel.district,
                                JagaTanahRegionLevel.village,
                              ]);
                            } else {
                              clearRegionErrors(const [
                                JagaTanahRegionLevel.district,
                              ]);
                            }
                          },
                        );
                      },
                    );
                    final villageField = JagaTanahDropdownField(
                      label: 'Desa/Kelurahan',
                      hintText: 'Pilih desa/kelurahan',
                      selectedValue: selectedVillage.value?.name,
                      isRequired: isWilayahRequired,
                      isMuted: selectedDistrict.value == null,
                      isLoading:
                          isSyncingRegions.value &&
                          selectedDistrict.value != null &&
                          selectedVillage.value == null,
                      errorText:
                          regionErrors.value[JagaTanahRegionLevel.village],
                      onTap: () {
                        if (effectiveRegionsUsecase == null) {
                          AppToast.showWarning(
                            context,
                            message: 'Layanan data wilayah belum tersedia.',
                          );
                          return;
                        }
                        final district = selectedDistrict.value;
                        if (district == null) {
                          AppToast.showWarning(
                            context,
                            message: 'Pilih Kecamatan terlebih dahulu.',
                          );
                          return;
                        }
                        JagaTanahRegionSheet.show(
                          context,
                          title: 'Pilih Desa/Kelurahan',
                          searchHint: 'Cari desa/kelurahan...',
                          selectedId: selectedVillage.value?.id,
                          loader: trackRegionLoader(
                            ({bool forceRefresh = false}) =>
                                effectiveRegionsUsecase.getVillages(
                                  district.id,
                                  forceRefresh: forceRefresh,
                                ),
                          ),
                          onSelected: (picked) {
                            locationRequestSeq.value++;
                            isFetchingLocation.value = false;
                            isSyncingRegions.value = false;
                            regionSyncNote.value = null;
                            selectedVillage.value = picked;
                            clearRegionErrors(const [
                              JagaTanahRegionLevel.village,
                            ]);
                          },
                        );
                      },
                    );

                    if (!useTwoColumns) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          provinceField,
                          const SizedBox(height: 14),
                          regencyField,
                          const SizedBox(height: 14),
                          districtField,
                          const SizedBox(height: 14),
                          villageField,
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: provinceField),
                            const SizedBox(width: 10),
                            Expanded(child: regencyField),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: districtField),
                            const SizedBox(width: 10),
                            Expanded(child: villageField),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                if (regionSyncNote.value != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            regionSyncNote.value!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                JagaTanahTextField(
                  controller: landmarkController,
                  label: 'Alamat / Patokan Lokasi',
                  hintText: 'Contoh: ± 500 m arah barat Balai Desa',
                  prefixIcon: Icons.place_outlined,
                  maxLines: 2,
                  maxLength: 255,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textScale = MediaQuery.textScalerOf(context)
                        .scale(1.0);
                    final useRow =
                        constraints.maxWidth >= 300 && textScale <= 1.35;
                    final locationActionStyle = OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      backgroundColor: colors.primaryLight,
                      foregroundColor: colors.primaryDark,
                      side: BorderSide(
                        color: colors.primaryDark.withValues(alpha: 0.25),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      textStyle: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    );

                    final fetchLocationButton = OutlinedButton.icon(
                      onPressed: isFetchingLocation.value
                          ? null
                          : () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _fetchCurrentLocation(
                                context,
                                isFetchingLocation: isFetchingLocation,
                                locationRequestSeq: locationRequestSeq,
                                latitude: latitude,
                                longitude: longitude,
                                accuracyMeters: accuracyMeters,
                                gpsError: gpsError,
                                regionsUsecase: effectiveRegionsUsecase,
                                selectedProvince: selectedProvince,
                                selectedRegency: selectedRegency,
                                selectedDistrict: selectedDistrict,
                                selectedVillage: selectedVillage,
                                regionErrors: regionErrors,
                                isSyncingRegions: isSyncingRegions,
                                regionSyncNote: regionSyncNote,
                                regionApiUnavailable: regionApiUnavailable,
                                landmarkController: landmarkController,
                                showErrorToast: true,
                                overwriteExisting: true,
                              );
                            },
                      style: locationActionStyle,
                      icon: isFetchingLocation.value
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.primaryDark,
                              ),
                            )
                          : const Icon(Icons.my_location_rounded, size: 18),
                      label: Text(
                        isFetchingLocation.value
                            ? 'Mengambil lokasi...'
                            : 'Ambil Lokasi',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );

                    final pickFromMapsButton = OutlinedButton.icon(
                      onPressed: () => _pickLocationFromMap(
                        context,
                        isFetchingLocation: isFetchingLocation,
                        locationRequestSeq: locationRequestSeq,
                        latitude: latitude,
                        longitude: longitude,
                        accuracyMeters: accuracyMeters,
                        gpsError: gpsError,
                        regionsUsecase: effectiveRegionsUsecase,
                        selectedProvince: selectedProvince,
                        selectedRegency: selectedRegency,
                        selectedDistrict: selectedDistrict,
                        selectedVillage: selectedVillage,
                        regionErrors: regionErrors,
                        isSyncingRegions: isSyncingRegions,
                        regionSyncNote: regionSyncNote,
                        regionApiUnavailable: regionApiUnavailable,
                        landmarkController: landmarkController,
                      ),
                      style: locationActionStyle,
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: const Text(
                        'Pilih dari Maps',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );

                    if (!useRow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          fetchLocationButton,
                          const SizedBox(height: 10),
                          pickFromMapsButton,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: fetchLocationButton),
                        const SizedBox(width: 10),
                        Expanded(child: pickFromMapsButton),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                const JagaTanahFieldLabel(label: 'Peta Lokasi'),
                const SizedBox(height: 4),
                Text(
                  'Ketuk peta atau tombol di bawah untuk menandai dan mengubah titik bidang.',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                JagaTanahSpatialCard(
                  latitude: latitude.value,
                  longitude: longitude.value,
                  polygonPoints: polygonPoints.value,
                  showMapTypeToggle: true,
                  initialMapType: MapType.normal,
                  isFetchingLocation: isFetchingLocation.value,
                  errorText: gpsError.value,
                  mapPreviewBuilder: mapPreviewBuilder,
                  onOpenMap: () => _openPolygonPicker(
                    context,
                    isFetchingLocation: isFetchingLocation,
                    locationRequestSeq: locationRequestSeq,
                    latitude: latitude,
                    longitude: longitude,
                    accuracyMeters: accuracyMeters,
                    gpsError: gpsError,
                    polygonPoints: polygonPoints,
                    regionsUsecase: effectiveRegionsUsecase,
                    selectedProvince: selectedProvince,
                    selectedRegency: selectedRegency,
                    selectedDistrict: selectedDistrict,
                    selectedVillage: selectedVillage,
                    regionErrors: regionErrors,
                    isSyncingRegions: isSyncingRegions,
                    regionSyncNote: regionSyncNote,
                    regionApiUnavailable: regionApiUnavailable,
                    landmarkController: landmarkController,
                  ),
                ),
                const SizedBox(height: 16),
                JagaTanahAttachmentSection(
                  attachments: photos.value,
                  maxAttachments: _maxPhotos,
                  hasVideo: photos.value.any(FileSecurityUtils.isVideoPath),
                  isRequired: true,
                  errorText: photoError.value,
                  onAddPhoto: () => _addPhoto(
                    context,
                    photos: photos,
                    photoError: photoError,
                  ),
                  onAddVideo: () => _addVideo(
                    context,
                    photos: photos,
                    photoError: photoError,
                  ),
                  onRemove: (index) {
                    final updated = List<String>.from(photos.value)
                      ..removeAt(index);
                    photos.value = updated;
                  },
                ),
                const SizedBox(height: 16),
                ...buildDropdownWidgets(_sectionADropdowns),
              ],
            ),
          ),
        );
      case 2:
        stepContent = JagaTanahSectionCard(
          title: 'Kondisi Penggunaan & Pemanfaatan',
          icon: Icons.eco_rounded,
          accentColor: colors.earth,
          badgeColor: colors.warningLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildDropdownWidgets(_sectionBDropdowns),
          ),
        );
      case 3:
        stepContent = JagaTanahSectionCard(
          title: 'Informasi Hak & Penguasaan',
          icon: Icons.description_rounded,
          accentColor: colors.secondary,
          badgeColor: colors.surfaceElevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildDropdownWidgets(_sectionCDropdowns),
          ),
        );
      case 4:
      default:
        stepContent = JagaTanahReviewStep(
          draft: _buildDraft(
            category: selectedCategory.value,
            subCategory: selectedSubCategory.value,
            titleController: titleController,
            descriptionController: descriptionController,
            selectedProvince: selectedProvince.value,
            selectedRegency: selectedRegency.value,
            selectedDistrict: selectedDistrict.value,
            selectedVillage: selectedVillage.value,
            landmarkController: landmarkController,
            latitude: latitude.value,
            longitude: longitude.value,
            accuracyMeters: accuracyMeters.value,
            polygonPoints: polygonPoints.value,
            photos: photos.value,
            values: dropdownValues.value,
          ),
          mapPreviewBuilder: mapPreviewBuilder,
          onEditStep: (step) {
            if (isSubmitting) return;
            currentStep.value = step;
            _scrollToTop(scrollController);
          },
        );
    }

    final isFinalStep =
        currentStep.value == JagaTanahStepIndicator.totalSteps - 1;

    return BlocListener<CreateJagaTanahBloc, CreateJagaTanahState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (listenerContext, state) {
        if (state.submitStatus == CreateJagaTanahSubmitStatus.failure) {
          AppToast.showError(
            listenerContext,
            message:
                state.errorMessage ??
                'Gagal mengirim laporan. Silakan coba lagi.',
          );
          return;
        }
        if (state.submitStatus == CreateJagaTanahSubmitStatus.success) {
          _showSubmitSuccessDialog(
            listenerContext,
            report: state.submittedReport,
            isQueuedOffline: state.isQueuedOffline,
          );
        }
      },
      child: PopScope(
        canPop: !isSubmitting,
        child: Scaffold(
          backgroundColor: colors.background,
          appBar: AppPageBar(
            title: 'Buat Laporan Jaga Tanah',
            isBackEnabled: !isSubmitting,
            onBackPressed: () => Navigator.of(context).pop(),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final textScale = MediaQuery.textScalerOf(context).scale(1.0);
              final pinStepHeader =
                  constraints.maxHeight >= 460 && textScale <= 1.35;
              final stepIndicator = JagaTanahStepIndicator(
                currentStep: currentStep.value,
                onStepTap: isSubmitting
                    ? null
                    : (step) {
                        currentStep.value = step;
                        _scrollToTop(scrollController);
                      },
              );

              if (!pinStepHeader) {
                return SingleChildScrollView(
                  controller: scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      stepIndicator,
                      const SizedBox(height: 14),
                      stepContent,
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                    child: stepIndicator,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      child: stepContent,
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  if (currentStep.value > 0) ...[
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                currentStep.value = currentStep.value - 1;
                                _scrollToTop(scrollController);
                              },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          foregroundColor: colors.textPrimary,
                          side: BorderSide(color: colors.borderStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: AppTextStyles.button,
                        ),
                        child: const Text('Kembali'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              if (isFinalStep) {
                                _submit(
                                  context,
                                  currentStep: currentStep,
                                  scrollController: scrollController,
                                  step0FormKey: step0FormKey,
                                  step1FormKey: step1FormKey,
                                  titleController: titleController,
                                  descriptionController: descriptionController,
                                  selectedCategory: selectedCategory,
                                  selectedSubCategory: selectedSubCategory,
                                  categoryError: categoryError,
                                  subCategoryError: subCategoryError,
                                  selectedProvince: selectedProvince,
                                  selectedRegency: selectedRegency,
                                  selectedDistrict: selectedDistrict,
                                  selectedVillage: selectedVillage,
                                  regionErrors: regionErrors,
                                  regionApiUnavailable: regionApiUnavailable,
                                  landmarkController: landmarkController,
                                  latitude: latitude,
                                  longitude: longitude,
                                  gpsError: gpsError,
                                  polygonPoints: polygonPoints,
                                  photos: photos,
                                  photoError: photoError,
                                  dropdownValues: dropdownValues,
                                  dropdownErrors: dropdownErrors,
                                  idempotencyRef: idempotencyRef,
                                );
                              } else {
                                _onNextStep(
                                  context,
                                  currentStep: currentStep,
                                  scrollController: scrollController,
                                  step0FormKey: step0FormKey,
                                  step1FormKey: step1FormKey,
                                  titleController: titleController,
                                  selectedCategory: selectedCategory,
                                  selectedSubCategory: selectedSubCategory,
                                  categoryError: categoryError,
                                  subCategoryError: subCategoryError,
                                  selectedProvince: selectedProvince,
                                  selectedRegency: selectedRegency,
                                  selectedDistrict: selectedDistrict,
                                  selectedVillage: selectedVillage,
                                  regionErrors: regionErrors,
                                  regionApiUnavailable: regionApiUnavailable,
                                  landmarkController: landmarkController,
                                  latitude: latitude,
                                  longitude: longitude,
                                  gpsError: gpsError,
                                  photos: photos,
                                  photoError: photoError,
                                  dropdownValues: dropdownValues,
                                  dropdownErrors: dropdownErrors,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        disabledBackgroundColor: colors.primary.withValues(
                          alpha: 0.45,
                        ),
                        disabledForegroundColor: colors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: (isFinalStep && isSubmitting)
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: colors.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'Mengirim...',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.button.copyWith(
                                      color: colors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              isFinalStep ? 'Kirim' : 'Lanjut',
                              style: AppTextStyles.button.copyWith(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

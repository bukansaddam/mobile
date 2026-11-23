import 'dart:io';
import 'dart:math';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/linmas/activation/presentation/pages/camera_capture_screen.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_form_draft.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_form_options.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_reverse_geocoder.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_attachment_section.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_category_field.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_category_sheet.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_dropdown_field.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_option_sheet.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_review_step.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_section_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_spatial_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_step_indicator.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_text_field.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/location_picker_page.dart';
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

typedef JagaTanahLocationPickerOpener = Future<LocationPickerResult?> Function(
  BuildContext context, {
  String? initialAddress,
  LatLng? initialPosition,
});

typedef JagaTanahAdminAddressResolver = Future<JagaTanahAdminAddress> Function(
  LatLng position,
);

/// Form pelaporan kondisi dan penyalahgunaan tanah 5 langkah (seperti Laporan Harian).
class CreateJagaTanahPage extends HookWidget {
  final bool autoFetchLocation;
  final JagaTanahMapPreviewBuilder? mapPreviewBuilder;
  final JagaTanahLocationPickerOpener? onOpenMapOverride;
  final Future<String?> Function(BuildContext context)? onPickPhotoOverride;
  final Future<String?> Function(BuildContext context)? onPickVideoOverride;
  final JagaTanahAdminAddressResolver? addressResolverOverride;

  const CreateJagaTanahPage({
    super.key,
    this.autoFetchLocation = true,
    this.mapPreviewBuilder,
    this.onOpenMapOverride,
    this.onPickPhotoOverride,
    this.onPickVideoOverride,
    this.addressResolverOverride,
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
    required LatLng position,
    required TextEditingController provinceController,
    required TextEditingController regencyController,
    required TextEditingController districtController,
    required TextEditingController villageController,
    required TextEditingController landmarkController,
    String? fallbackLandmark,
    bool overwriteExisting = true,
  }) async {
    final resolved = addressResolverOverride != null
        ? await addressResolverOverride!(position)
        : await JagaTanahReverseGeocoder.resolve(position);
    if (!context.mounted) return;

    final landmark = resolved.landmarkAddress ?? fallbackLandmark?.trim();
    final hasAnyResolved =
        resolved.province != null ||
        resolved.regency != null ||
        resolved.district != null ||
        resolved.village != null ||
        (landmark != null && landmark.isNotEmpty);

    void assignField(TextEditingController controller, String? value) {
      if (overwriteExisting && hasAnyResolved) {
        controller.text = value ?? '';
      } else if (value != null &&
          value.isNotEmpty &&
          controller.text.trim().isEmpty) {
        controller.text = value;
      }
    }

    assignField(provinceController, resolved.province);
    assignField(regencyController, resolved.regency);
    assignField(districtController, resolved.district);
    assignField(villageController, resolved.village);
    assignField(landmarkController, landmark);
  }

  Future<void> _fetchCurrentLocation(
    BuildContext context, {
    required ValueNotifier<bool> isFetchingLocation,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<double?> accuracyMeters,
    required ValueNotifier<String?> gpsError,
    required TextEditingController provinceController,
    required TextEditingController regencyController,
    required TextEditingController districtController,
    required TextEditingController villageController,
    required TextEditingController landmarkController,
    bool showErrorToast = true,
    bool overwriteExisting = true,
  }) async {
    if (isFetchingLocation.value) return;
    isFetchingLocation.value = true;
    try {
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
      if (!context.mounted) return;

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      accuracyMeters.value = position.accuracy;
      gpsError.value = null;

      await _fillAdminFromCoordinates(
        context,
        position: LatLng(position.latitude, position.longitude),
        provinceController: provinceController,
        regencyController: regencyController,
        districtController: districtController,
        villageController: villageController,
        landmarkController: landmarkController,
        overwriteExisting: overwriteExisting,
      );
    } catch (_) {
      if (showErrorToast && context.mounted) {
        AppToast.showError(context, message: 'Gagal mendeteksi koordinat GPS.');
      }
    } finally {
      if (context.mounted) {
        isFetchingLocation.value = false;
      }
    }
  }

  Future<void> _openMapLocationPicker(
    BuildContext context, {
    required ValueNotifier<bool> isFetchingLocation,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<double?> accuracyMeters,
    required ValueNotifier<String?> gpsError,
    required TextEditingController provinceController,
    required TextEditingController regencyController,
    required TextEditingController districtController,
    required TextEditingController villageController,
    required TextEditingController landmarkController,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final initialPosition = latitude.value != null && longitude.value != null
        ? LatLng(latitude.value!, longitude.value!)
        : null;

    final opener = onOpenMapOverride ?? LocationPickerPage.showWithResult;
    final selected = await opener(
      context,
      initialAddress: landmarkController.text,
      initialPosition: initialPosition,
    );
    if (selected == null || !context.mounted) return;

    latitude.value = selected.latitude;
    longitude.value = selected.longitude;
    accuracyMeters.value = null;
    gpsError.value = null;

    isFetchingLocation.value = true;
    try {
      await _fillAdminFromCoordinates(
        context,
        position: selected.position,
        provinceController: provinceController,
        regencyController: regencyController,
        districtController: districtController,
        villageController: villageController,
        landmarkController: landmarkController,
        fallbackLandmark: selected.address,
      );
    } finally {
      if (context.mounted) {
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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
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
    required TextEditingController provinceController,
    required TextEditingController regencyController,
    required TextEditingController districtController,
    required TextEditingController villageController,
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
      final validText = step1FormKey.currentState != null
          ? step1FormKey.currentState!.validate()
          : (provinceController.text.trim().isNotEmpty &&
                regencyController.text.trim().isNotEmpty &&
                districtController.text.trim().isNotEmpty &&
                villageController.text.trim().isNotEmpty &&
                landmarkController.text.trim().isNotEmpty);

      final hasGps = latitude.value != null && longitude.value != null;
      gpsError.value = hasGps ? null : 'Titik lokasi di peta wajib dipilih';

      final hasPhotos = photos.value.isNotEmpty;
      photoError.value = hasPhotos
          ? null
          : 'Minimal 1 lampiran foto atau video wajib dilampirkan';

      final dropdownIssue = _validateDropdownGroup(
        _sectionADropdowns,
        dropdownValues: dropdownValues,
        dropdownErrors: dropdownErrors,
      );

      if (!validText) {
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
    required TextEditingController provinceController,
    required TextEditingController regencyController,
    required TextEditingController districtController,
    required TextEditingController villageController,
    required TextEditingController landmarkController,
    required double? latitude,
    required double? longitude,
    required double? accuracyMeters,
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
      province: provinceController.text.trim(),
      regency: regencyController.text.trim(),
      district: districtController.text.trim(),
      village: villageController.text.trim(),
      landmarkAddress: landmarkController.text.trim(),
      latitude: latitude ?? 0,
      longitude: longitude ?? 0,
      accuracyMeters: accuracyMeters,
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
    required TextEditingController provinceController,
    required TextEditingController regencyController,
    required TextEditingController districtController,
    required TextEditingController villageController,
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
      provinceController: provinceController,
      regencyController: regencyController,
      districtController: districtController,
      villageController: villageController,
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
  }) {
    final parts = <String>[
      '$categoryId',
      '${subCategoryId ?? ''}',
      title,
      description,
      address,
      latitude.toStringAsFixed(6),
      longitude.toStringAsFixed(6),
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
  }) {
    final ticketNumber = report?.ticketNumber.trim();
    final hasTicket = ticketNumber != null && ticketNumber.isNotEmpty;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Laporan Terkirim',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasTicket) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor Tiket',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ticketNumber,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              'Laporan Jaga Tanah berhasil dikirim dan sedang diproses untuk verifikasi (< 24 jam).',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (context.mounted) {
                Navigator.of(context).maybePop(true);
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: AppTextStyles.button,
            ),
            child: const Text('Selesai'),
          ),
        ],
      ),
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
    required TextEditingController provinceController,
    required TextEditingController regencyController,
    required TextEditingController districtController,
    required TextEditingController villageController,
    required TextEditingController landmarkController,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<String?> gpsError,
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
        provinceController: provinceController,
        regencyController: regencyController,
        districtController: districtController,
        villageController: villageController,
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
        type: 'point',
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
        idempotencyKey: idempotencyKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final provinceController = useTextEditingController();
    final regencyController = useTextEditingController();
    final districtController = useTextEditingController();
    final villageController = useTextEditingController();
    final landmarkController = useTextEditingController();

    final isFetchingLocation = useState(false);
    final latitude = useState<double?>(null);
    final longitude = useState<double?>(null);
    final accuracyMeters = useState<double?>(null);
    final gpsError = useState<String?>(null);

    final photos = useState<List<String>>(const []);
    final photoError = useState<String?>(null);

    final dropdownValues = useState<Map<_DropdownKey, String>>(const {});
    final dropdownErrors = useState<Map<_DropdownKey, String>>(const {});
    final idempotencyRef = useRef<({String signature, String key})?>(null);
    final isSubmitting = context.select<CreateJagaTanahBloc, bool>(
      (bloc) => bloc.state.isSubmitting,
    );

    useEffect(() {
      if (!autoFetchLocation) return null;
      _fetchCurrentLocation(
        context,
        isFetchingLocation: isFetchingLocation,
        latitude: latitude,
        longitude: longitude,
        accuracyMeters: accuracyMeters,
        gpsError: gpsError,
        provinceController: provinceController,
        regencyController: regencyController,
        districtController: districtController,
        villageController: villageController,
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
                JagaTanahSpatialCard(
                  latitude: latitude.value,
                  longitude: longitude.value,
                  isFetchingLocation: isFetchingLocation.value,
                  errorText: gpsError.value,
                  mapPreviewBuilder: mapPreviewBuilder,
                  onOpenMap: () => _openMapLocationPicker(
                    context,
                    isFetchingLocation: isFetchingLocation,
                    latitude: latitude,
                    longitude: longitude,
                    accuracyMeters: accuracyMeters,
                    gpsError: gpsError,
                    provinceController: provinceController,
                    regencyController: regencyController,
                    districtController: districtController,
                    villageController: villageController,
                    landmarkController: landmarkController,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textScale = MediaQuery.textScalerOf(context)
                        .scale(1.0);
                    final useTwoColumns =
                        constraints.maxWidth >= 320 && textScale <= 1.35;

                    final provinceField = JagaTanahTextField(
                      controller: provinceController,
                      label: 'Provinsi',
                      hintText: 'Contoh: Jawa Timur',
                    );
                    final regencyField = JagaTanahTextField(
                      controller: regencyController,
                      label: 'Kabupaten/Kota',
                      hintText: 'Contoh: Kab. Mojokerto',
                    );
                    final districtField = JagaTanahTextField(
                      controller: districtController,
                      label: 'Kecamatan',
                      hintText: 'Contoh: Ngoro',
                    );
                    final villageField = JagaTanahTextField(
                      controller: villageController,
                      label: 'Desa/Kelurahan',
                      hintText: 'Contoh: Sukomulyo',
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
          accentColor: AppColors.earth,
          badgeColor: AppColors.warningLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildDropdownWidgets(_sectionBDropdowns),
          ),
        );
      case 3:
        stepContent = JagaTanahSectionCard(
          title: 'Informasi Hak & Penguasaan',
          icon: Icons.description_rounded,
          accentColor: AppColors.secondary,
          badgeColor: AppColors.grey100,
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
            provinceController: provinceController,
            regencyController: regencyController,
            districtController: districtController,
            villageController: villageController,
            landmarkController: landmarkController,
            latitude: latitude.value,
            longitude: longitude.value,
            accuracyMeters: accuracyMeters.value,
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
          );
        }
      },
      child: PopScope(
        canPop: !isSubmitting,
        child: Scaffold(
          backgroundColor: AppColors.background,
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
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
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
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.grey300),
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
                                  provinceController: provinceController,
                                  regencyController: regencyController,
                                  districtController: districtController,
                                  villageController: villageController,
                                  landmarkController: landmarkController,
                                  latitude: latitude,
                                  longitude: longitude,
                                  gpsError: gpsError,
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
                                  provinceController: provinceController,
                                  regencyController: regencyController,
                                  districtController: districtController,
                                  villageController: villageController,
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
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor: AppColors.primaryDark
                            .withValues(alpha: 0.72),
                        disabledForegroundColor: AppColors.white,
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
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'Mengirim...',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              isFinalStep ? 'Kirim' : 'Lanjut',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.white,
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

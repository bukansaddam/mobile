import 'dart:io';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/linmas/activation/presentation/pages/camera_capture_screen.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/create_jaga_tanah_bloc/create_jaga_tanah_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_attachment_section.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_category_field.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_category_sheet.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_field_label.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/location_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateJagaTanahPage extends HookWidget {
  final bool autoFetchLocation;

  const CreateJagaTanahPage({super.key, this.autoFetchLocation = true});

  static const int _maxAttachments = 5;

  Future<void> _fetchCurrentLocation(
    BuildContext context, {
    required ValueNotifier<bool> isFetchingLocation,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required TextEditingController locationController,
  }) async {
    isFetchingLocation.value = true;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 3));
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission().timeout(
        const Duration(seconds: 3),
      );
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission().timeout(
          const Duration(seconds: 10),
        );
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      if (!context.mounted) return;
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (!context.mounted || placemarks.isEmpty) return;

      final place = placemarks.first;
      final parts = <String>[];
      if (place.street != null && place.street!.trim().isNotEmpty) {
        parts.add(place.street!.trim());
      }
      if (place.subLocality != null &&
          place.subLocality!.trim().isNotEmpty &&
          place.subLocality != place.street) {
        parts.add('Kel. ${place.subLocality!.trim()}');
      }
      if (place.locality != null &&
          place.locality!.trim().isNotEmpty &&
          place.locality != place.subLocality) {
        parts.add('Kec. ${place.locality!.trim()}');
      }
      if (place.subAdministrativeArea != null &&
          place.subAdministrativeArea!.trim().isNotEmpty) {
        parts.add(place.subAdministrativeArea!.trim());
      } else if (place.administrativeArea != null &&
          place.administrativeArea!.trim().isNotEmpty) {
        parts.add(place.administrativeArea!.trim());
      }

      if (parts.isNotEmpty) {
        locationController.text = parts.join(', ');
      }
    } catch (_) {
    } finally {
      if (context.mounted) {
        isFetchingLocation.value = false;
      }
    }
  }

  void _openCategorySheet(
    BuildContext context, {
    required String title,
    required List<JagaTanahCategoryEntity> categories,
    required int? selectedId,
    required ValueChanged<JagaTanahCategoryEntity> onSelected,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => JagaTanahCategorySheet(
        title: title,
        categories: categories,
        selectedId: selectedId,
        onSelected: onSelected,
      ),
    );
  }

  Future<void> _openMapLocationPicker(
    BuildContext context, {
    required TextEditingController locationController,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await LocationPickerPage.showWithResult(
      context,
      initialAddress: locationController.text,
      initialPosition: latitude.value != null && longitude.value != null
          ? LatLng(latitude.value!, longitude.value!)
          : null,
    );
    if (selected != null && context.mounted) {
      locationController.text = selected.address;
      latitude.value = selected.latitude;
      longitude.value = selected.longitude;
    }
  }

  Future<void> _addPhoto(
    BuildContext context,
    ValueNotifier<List<String>> attachments,
  ) async {
    if (attachments.value.length >= _maxAttachments) {
      AppToast.showWarning(
        context,
        message: 'Maksimal $_maxAttachments lampiran.',
      );
      return;
    }

    final path = await CameraCaptureScreen.open(context);
    if (path != null && context.mounted) {
      attachments.value = [...attachments.value, path];
    }
  }

  Future<void> _addVideo(
    BuildContext context,
    ValueNotifier<List<String>> attachments,
  ) async {
    if (attachments.value.length >= _maxAttachments) {
      AppToast.showWarning(
        context,
        message: 'Maksimal $_maxAttachments lampiran.',
      );
      return;
    }
    if (attachments.value.any(FileSecurityUtils.isVideoPath)) {
      AppToast.showWarning(context, message: 'Maksimal 1 video per laporan.');
      return;
    }

    final path = await CameraCaptureScreen.openVideo(context);
    if (path != null && context.mounted) {
      attachments.value = [...attachments.value, path];
    }
  }

  void _handleSuccess(BuildContext context, ComplaintReportEntity report) {
    final ticket = report.ticketNumber;
    AppDialogs.showSuccess(
      context,
      title: 'Laporan Jaga Tanahku Berhasil Dikirim!',
      message: ticket.isEmpty
          ? 'Laporan Jaga Tanahku telah tersimpan di sistem.'
          : 'Laporan $ticket telah tersimpan di sistem.',
      buttonText: 'Kembali',
      onPressed: () => Navigator.pop(context, true),
    );
  }

  void _submit(
    BuildContext context, {
    required GlobalKey<FormState> formKey,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required TextEditingController locationController,
    required ValueNotifier<JagaTanahCategoryEntity?> selectedCategory,
    required ValueNotifier<JagaTanahCategoryEntity?> selectedSubCategory,
    required ValueNotifier<String?> categoryError,
    required ValueNotifier<String?> subCategoryError,
    required ValueNotifier<double?> latitude,
    required ValueNotifier<double?> longitude,
    required ValueNotifier<List<String>> attachments,
  }) {
    final validForm = formKey.currentState?.validate() ?? false;
    final category = selectedCategory.value;
    if (category == null) {
      categoryError.value = 'Kategori laporan wajib dipilih';
      AppToast.showWarning(
        context,
        message: 'Pilih kategori laporan terlebih dahulu.',
      );
      return;
    }

    final subCategory = selectedSubCategory.value;
    if (category.hasSubCategories && subCategory == null) {
      subCategoryError.value = 'Sub-kategori wajib dipilih';
      AppToast.showWarning(
        context,
        message: 'Pilih sub-kategori untuk ${category.label}.',
      );
      return;
    }

    if (!validForm) return;

    if (attachments.value.isEmpty) {
      AppToast.showWarning(
        context,
        message: 'Sertakan minimal 1 foto atau video.',
      );
      return;
    }

    final lat = latitude.value;
    final lng = longitude.value;
    if (lat == null || lng == null) {
      AppToast.showWarning(
        context,
        message: 'Lokasi belum terdeteksi. Pilih lokasi lewat peta.',
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    context.read<CreateJagaTanahBloc>().add(
      SubmitJagaTanahReportEvent(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        address: locationController.text.trim(),
        latitude: lat,
        longitude: lng,
        attachments: attachments.value.map(File.new).toList(),
        categoryId: category.id,
        subCategoryId: subCategory?.id,
      ),
    );
  }

  InputDecoration _textInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final locationController = useTextEditingController();

    final selectedCategory = useState<JagaTanahCategoryEntity?>(null);
    final selectedSubCategory = useState<JagaTanahCategoryEntity?>(null);
    final categoryError = useState<String?>(null);
    final subCategoryError = useState<String?>(null);
    final isFetchingLocation = useState(false);
    final latitude = useState<double?>(null);
    final longitude = useState<double?>(null);
    final attachments = useState<List<String>>(const []);

    useEffect(() {
      if (!autoFetchLocation) return null;
      _fetchCurrentLocation(
        context,
        isFetchingLocation: isFetchingLocation,
        latitude: latitude,
        longitude: longitude,
        locationController: locationController,
      );
      return null;
    }, [autoFetchLocation]);

    final hasVideo = attachments.value.any(FileSecurityUtils.isVideoPath);
    final currentCategory = selectedCategory.value;

    return BlocListener<CreateJagaTanahBloc, CreateJagaTanahState>(
      listenWhen: (prev, curr) => prev.submitStatus != curr.submitStatus,
      listener: (context, state) {
        if (state.submitStatus == CreateJagaTanahSubmitStatus.success &&
            state.submittedReport != null) {
          _handleSuccess(context, state.submittedReport!);
        } else if (state.submitStatus == CreateJagaTanahSubmitStatus.failure) {
          AppToast.showError(
            context,
            message: state.errorMessage ?? 'Gagal mengirim laporan.',
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.topHeaderGradient),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                tooltip: 'Kembali',
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Buat Laporan Jaga Tanahku',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primaryDark,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Laporkan kondisi atau temuan terkait aset tanah secara akurat agar segera ditindaklanjuti.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryDark,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<CreateJagaTanahBloc, CreateJagaTanahState>(
                  buildWhen: (prev, curr) =>
                      prev.categories != curr.categories ||
                      prev.isLoadingCategories != curr.isLoadingCategories ||
                      prev.categoryError != curr.categoryError,
                  builder: (context, state) {
                    return JagaTanahCategoryField(
                      label: 'Kategori Laporan',
                      hintText: 'Pilih kategori Jaga Tanahku',
                      selectedLabel: currentCategory?.label,
                      prefixIcon: currentCategory != null
                          ? JagaTanahCategorySheet.iconFor(currentCategory)
                          : Icons.category_outlined,
                      isLoading: state.isLoadingCategories,
                      errorText: categoryError.value,
                      fetchErrorText: state.categories.isEmpty
                          ? state.categoryError
                          : null,
                      onRetry: () => context.read<CreateJagaTanahBloc>().add(
                        const LoadJagaTanahCategoriesEvent(force: true),
                      ),
                      onTap: () {
                        if (state.categories.isEmpty &&
                            !state.isLoadingCategories) {
                          context.read<CreateJagaTanahBloc>().add(
                            const LoadJagaTanahCategoriesEvent(force: true),
                          );
                          return;
                        }
                        _openCategorySheet(
                          context,
                          title: 'Pilih Kategori Laporan',
                          categories: state.categories,
                          selectedId: currentCategory?.id,
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
                if (currentCategory != null &&
                    currentCategory.hasSubCategories) ...[
                  const SizedBox(height: 18),
                  JagaTanahCategoryField(
                    label: 'Sub-Kategori',
                    hintText: 'Pilih sub-kategori ${currentCategory.label}',
                    selectedLabel: selectedSubCategory.value?.label,
                    prefixIcon: selectedSubCategory.value != null
                        ? JagaTanahCategorySheet.iconFor(
                            selectedSubCategory.value!,
                          )
                        : Icons.account_tree_outlined,
                    errorText: subCategoryError.value,
                    onTap: () => _openCategorySheet(
                      context,
                      title: 'Pilih Sub-Kategori',
                      categories: currentCategory.children,
                      selectedId: selectedSubCategory.value?.id,
                      onSelected: (picked) {
                        selectedSubCategory.value = picked;
                        subCategoryError.value = null;
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                const JagaTanahFieldLabel(label: 'Judul Laporan'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  maxLength: 255,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  style: AppTextStyles.bodyMedium,
                  decoration: _textInputDecoration(
                    'Penggunaan lahan tidak sesuai peruntukan',
                  ).copyWith(counterText: ''),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul laporan tidak boleh kosong';
                    }
                    if (value.trim().length < 5) {
                      return 'Judul minimal 5 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const JagaTanahFieldLabel(label: 'Deskripsi Laporan'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  maxLength: 10000,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  style: AppTextStyles.bodyMedium,
                  decoration: _textInputDecoration(
                    'Jelaskan kondisi aset tanah atau rincian temuan secara detail...',
                  ).copyWith(counterText: ''),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    if (value.trim().length < 10) {
                      return 'Deskripsi minimal 10 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const JagaTanahFieldLabel(label: 'Lokasi Kejadian'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _openMapLocationPicker(
                    context,
                    locationController: locationController,
                    latitude: latitude,
                    longitude: longitude,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: locationController,
                      enabled: false,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: isFetchingLocation.value
                            ? 'Mendeteksi lokasi saat ini...'
                            : 'Ketuk untuk memilih lokasi di map',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.error,
                          size: 20,
                        ),
                        suffixIcon: isFetchingLocation.value
                            ? const UnconstrainedBox(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.map_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                        filled: true,
                        fillColor: AppColors.white,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.grey300,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Lokasi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                JagaTanahAttachmentSection(
                  attachments: attachments.value,
                  maxAttachments: _maxAttachments,
                  hasVideo: hasVideo,
                  onAddPhoto: () => _addPhoto(context, attachments),
                  onAddVideo: () => _addVideo(context, attachments),
                  onRemove: (index) {
                    final next = List<String>.from(attachments.value)
                      ..removeAt(index);
                    attachments.value = next;
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(12),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BlocBuilder<CreateJagaTanahBloc, CreateJagaTanahState>(
            buildWhen: (prev, curr) => prev.isSubmitting != curr.isSubmitting,
            builder: (context, state) {
              return SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => _submit(
                            context,
                            formKey: formKey,
                            titleController: titleController,
                            descriptionController: descriptionController,
                            locationController: locationController,
                            selectedCategory: selectedCategory,
                            selectedSubCategory: selectedSubCategory,
                            categoryError: categoryError,
                            subCategoryError: subCategoryError,
                            latitude: latitude,
                            longitude: longitude,
                            attachments: attachments,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: AppTextStyles.button,
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            'KIRIM',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

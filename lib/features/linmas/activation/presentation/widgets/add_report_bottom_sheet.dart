import 'dart:io';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/pages/camera_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReportBottomSheet extends StatefulWidget {
  final ActivationActivity activity;
  final String capturedPhotoUrl;

  const AddReportBottomSheet({
    super.key,
    required this.activity,
    required this.capturedPhotoUrl,
  });

  static void show(
    BuildContext context, {
    required ActivationActivity activity,
    required String capturedPhotoUrl,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReportBottomSheet(
        activity: activity,
        capturedPhotoUrl: capturedPhotoUrl,
      ),
    );
  }

  @override
  State<AddReportBottomSheet> createState() => _AddReportBottomSheetState();
}

class _AddReportBottomSheetState extends State<AddReportBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late List<String> _photoUrls;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _photoUrls = [widget.capturedPhotoUrl];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _addNewPhoto() async {
    if (_photoUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maksimal 5 foto per laporan bukti.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newPhoto = await CameraCaptureScreen.open(context);
    if (newPhoto != null && mounted) {
      setState(() {
        _photoUrls.add(newPhoto);
      });
    }
  }

  void _removePhoto(int index) {
    if (_photoUrls.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan wajib menyertakan minimal 1 foto.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _photoUrls.removeAt(index);
    });
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;
    if (_photoUrls.isEmpty) return;

    setState(() => _isSubmitting = true);

    final isDoorToDoor =
        widget.activity.category == ActivationCategory.doorToDoor;

    context.read<ActivationBloc>().add(
      SubmitActivationReportApiEvent(
        participantId: widget.activity.id,
        file: File(_photoUrls.first),
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        receiverNik: isDoorToDoor ? _nikController.text.trim() : null,
        receiverName: isDoorToDoor ? _nameController.text.trim() : null,
        onSuccess: () {
          if (mounted) {
            setState(() => _isSubmitting = false);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Penyerahan laporan berhasil disimpan!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onError: (message) {
          if (mounted) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPhotoTile(String pathOrUrl, int index) {
    Widget imageWidget;
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      imageWidget = Image.network(
        pathOrUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 100,
          height: 100,
          color: AppColors.grey200,
          child: const Icon(
            Icons.broken_image_rounded,
            color: AppColors.grey500,
          ),
        ),
      );
    } else {
      imageWidget = Image.file(
        File(pathOrUrl),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 100,
          height: 100,
          color: AppColors.grey200,
          child: const Icon(
            Icons.broken_image_rounded,
            color: AppColors.grey500,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              FullscreenImageViewer.show(
                context,
                imagePathOrUrl: pathOrUrl,
                title: 'Foto Bukti ${index + 1}',
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageWidget,
            ),
          ),
          if (_photoUrls.length > 1)
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: () => _removePhoto(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDoorToDoor =
        widget.activity.category == ActivationCategory.doorToDoor;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporan Bukti Penyerahan',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Foto Bukti Kegiatan',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _photoUrls.length >= 5
                            ? AppColors.warning.withValues(alpha: 0.15)
                            : AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_photoUrls.length}/5 Foto',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _photoUrls.length >= 5
                              ? AppColors.warning
                              : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 108,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        _photoUrls.length + (_photoUrls.length < 5 ? 1 : 0),
                    itemBuilder: (context, idx) {
                      if (idx < _photoUrls.length) {
                        return _buildPhotoTile(_photoUrls[idx], idx);
                      } else {
                        return GestureDetector(
                          onTap: _addNewPhoto,
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_a_photo_rounded,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '+ Foto',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (isDoorToDoor) ...[
                  _buildMandatoryLabel('Nama Penerima'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Nama penerima wajib diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama penerima...',
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildMandatoryLabel('NIK Penerima'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nikController,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'NIK penerima wajib diisi';
                      }
                      if (val.trim().length < 16) {
                        return 'NIK harus terdiri dari 16 digit';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan 16 digit NIK...',
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                Text(
                  'Catatan',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _notesController,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Tambahkan catatan laporan (opsional)...',
                    prefixIcon: const Icon(
                      Icons.note_alt_outlined,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitReport,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : null,
                    label: Text(
                      _isSubmitting ? 'Mengirim...' : 'Kirim',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMandatoryLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

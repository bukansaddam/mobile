import 'dart:io';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/presentation/pages/camera_capture_screen.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

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
  final TextEditingController _kkController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late List<String> _photoUrls;
  double _latitude = -6.8915;
  double _longitude = 107.6107;
  bool _isLoadingGps = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _photoUrls = [widget.capturedPhotoUrl];
    _fetchLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _kkController.dispose();
    _nikController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _houseNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() => _isLoadingGps = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              timeLimit: Duration(seconds: 5),
            ),
          );
          setState(() {
            _latitude = pos.latitude;
            _longitude = pos.longitude;
          });
        }
      }
    } catch (_) {
      // Keep fallback coordinates
    } finally {
      if (mounted) {
        setState(() => _isLoadingGps = false);
      }
    }
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

    final report = ActivationReport(
      id: 'rep-${DateTime.now().millisecondsSinceEpoch}',
      photoUrls: List.from(_photoUrls),
      submittedAt: DateTime.now(),
      latitude: _latitude,
      longitude: _longitude,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      recipientName: isDoorToDoor ? _nameController.text.trim() : null,
      recipientKk: isDoorToDoor ? _kkController.text.trim() : null,
      recipientNik: isDoorToDoor ? _nikController.text.trim() : null,
      rt: isDoorToDoor ? _rtController.text.trim() : null,
      rw: isDoorToDoor ? _rwController.text.trim() : null,
      houseNumber: isDoorToDoor ? _houseNumberController.text.trim() : null,
    );

    context.read<ActivationBloc>().add(
      AddActivationReportEvent(activityId: widget.activity.id, report: report),
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bukti foto laporan (${_photoUrls.length} foto) berhasil dikirim!',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
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
          // Delete photo button
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
                // Drag handle
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

                // Header Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporan Bukti Foto',
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

                // Section Header: Photos Count Badge (Max 5)
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

                // Horizontal List of Captured Photos & Add Photo Tile
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
                        // Add photo button card
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

                // Refreshable GPS Location Card
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.my_location_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Koordinat GPS Terdeteksi',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            _isLoadingGps
                                ? const Text(
                                    'Mengambil lokasi GPS...',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  )
                                : Text(
                                    'Lat: ${_latitude.toStringAsFixed(5)}, Long: ${_longitude.toStringAsFixed(5)}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _fetchLocation,
                        icon: const Icon(
                          Icons.refresh_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        tooltip: 'Refresh Lokasi GPS',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Category Dependent Fields
                if (isDoorToDoor) ...[
                  // 1. Nama Penerima
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

                  // 2. KK Penerima
                  _buildMandatoryLabel('KK Penerima'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _kkController,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Nomor KK penerima wajib diisi';
                      }
                      if (val.trim().length < 16) {
                        return 'Nomor KK harus terdiri dari 16 digit';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan 16 digit No. KK...',
                      prefixIcon: const Icon(
                        Icons.family_restroom_rounded,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. NIK Penerima
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

                  // 4. RT, RW, No Rumah (Sebaris Horizontal - Mandatory)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMandatoryLabel('RT'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _rtController,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Wajib diisi';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: '001',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMandatoryLabel('RW'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _rwController,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Wajib diisi';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: '002',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMandatoryLabel('No. Rumah'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _houseNumberController,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Wajib diisi';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: '12B',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],

                // Field Catatan
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

                // Tombol Kirim Laporan
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
                        : const Icon(Icons.send_rounded),
                    label: Text(
                      _isSubmitting
                          ? 'Mengirim...'
                          : 'Kirim ${_photoUrls.length} Foto Laporan',
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

import 'dart:io';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/activation/presentation/pages/camera_capture_screen.dart';
import 'package:akar/features/activation/presentation/provider/activation_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

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

  late String _currentPhotoUrl;
  double _latitude = -6.8915;
  double _longitude = 107.6107;
  bool _isLoadingGps = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _currentPhotoUrl = widget.capturedPhotoUrl;
    _fetchLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
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

  Future<void> _retakePhoto() async {
    final newPhoto = await CameraCaptureScreen.open(context);
    if (newPhoto != null && mounted) {
      setState(() {
        _currentPhotoUrl = newPhoto;
      });
    }
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final isDoorToDoor =
        widget.activity.category == ActivationCategory.doorToDoor;

    final report = ActivationReport(
      id: 'rep-${DateTime.now().millisecondsSinceEpoch}',
      photoUrl: _currentPhotoUrl,
      submittedAt: DateTime.now(),
      latitude: _latitude,
      longitude: _longitude,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      recipientName: isDoorToDoor ? _nameController.text.trim() : null,
      recipientNik: isDoorToDoor ? _nikController.text.trim() : null,
    );

    context.read<ActivationProvider>().addReport(widget.activity.id, report);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bukti foto laporan berhasil dikirim!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildPhotoPreview(String pathOrUrl) {
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return Image.network(
        pathOrUrl,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: AppColors.grey200,
          child: const Center(
            child: Icon(
              Icons.camera_alt_rounded,
              size: 50,
              color: AppColors.grey500,
            ),
          ),
        ),
      );
    } else {
      return Image.file(
        File(pathOrUrl),
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: AppColors.grey200,
          child: const Center(
            child: Icon(
              Icons.camera_alt_rounded,
              size: 50,
              color: AppColors.grey500,
            ),
          ),
        ),
      );
    }
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

                // Captured Photo Preview Card (Tap for Fullscreen)
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FullscreenImageViewer.show(
                          context,
                          imagePathOrUrl: _currentPhotoUrl,
                          title: 'Foto Laporan Bukti',
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildPhotoPreview(_currentPhotoUrl),
                      ),
                    ),
                    // Retake photo overlay button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: _retakePhoto,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Foto Ulang',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  Text(
                    'Nama Penerima *',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
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
                  Text(
                    'NIK Penerima *',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nikController,
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
                      _isSubmitting ? 'Mengirim...' : 'Kirim Laporan',
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
}

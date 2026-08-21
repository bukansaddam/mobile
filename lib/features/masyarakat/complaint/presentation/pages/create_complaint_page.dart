import 'dart:io';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/features/masyarakat/complaint/data/dummy_complaints.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/location_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class CreateComplaintPage extends StatefulWidget {
  final ComplaintCategory? initialCategory;

  const CreateComplaintPage({super.key, this.initialCategory});

  static Future<bool?> show(
    BuildContext context, {
    ComplaintCategory? initialCategory,
  }) {
    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateComplaintPage(initialCategory: initialCategory),
      ),
    );
  }

  @override
  State<CreateComplaintPage> createState() => _CreateComplaintPageState();
}

class _CreateComplaintPageState extends State<CreateComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedCategory;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!.label;
    }
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        List<String> parts = [];

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

        if (mounted && parts.isNotEmpty) {
          setState(() {
            _locationController.text = parts.join(', ');
          });
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  final List<XFile> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Widget _buildFieldLabel(String labelText, {bool isRequired = true}) {
    return Text.rich(
      TextSpan(
        text: labelText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
        children: isRequired
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Color(0xFFE11D48),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maksimal lampiran adalah 5 gambar.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(pickedFile);
        });
      }
    } catch (e) {
      if (!mounted) return;
      // Fallback untuk simulator / perangkat tanpa modul kamera fisik
      try {
        final XFile? galleryFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (galleryFile != null) {
          setState(() {
            _selectedImages.add(galleryFile);
          });
          return;
        }
      } catch (_) {}

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Modul kamera tidak tersedia: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }
  // Location selection is handled by LocationPickerPage

  void _submitComplaint() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final categoryName =
        _selectedCategory ??
        widget.initialCategory?.label ??
        'Belum Dikategori';

    setState(() {
      _isSubmitting = true;
    });

    final now = DateTime.now();
    final newId =
        'PGD-${now.year}-${(dummyMyComplaints.length + 1).toString().padLeft(3, '0')}';

    final IconData iconData = ComplaintCategory.getIconFor(categoryName);

    final List<String> attachmentPaths = _selectedImages.isNotEmpty
        ? _selectedImages.map((e) => e.path).toList()
        : const ['assets/placeholder_feature.jpg'];

    final newComplaint = ComplaintItem(
      id: newId,
      title: _titleController.text.trim(),
      category: categoryName,
      dateTime: now,
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      attachments: attachmentPaths,
      status: ComplaintStatus.received,
      icon: iconData,
      statusHistory: [
        ComplaintStatusHistory(
          status: ComplaintStatus.received,
          dateTime: now,
          note: 'Laporan pengaduan berhasil masuk ke sistem DUMAS.',
        ),
      ],
    );

    dummyMyComplaints.insert(0, newComplaint);
    dummyMyComplaints.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    dummyPublicComplaints.insert(0, newComplaint);
    dummyPublicComplaints.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF16A34A),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pengaduan Berhasil Dikirim!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Laporan Anda dengan ID $newId telah tersimpan dan sedang menunggu verifikasi petugas.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Future<void> _openMapLocationPicker() async {
    final selectedLocation = await LocationPickerPage.show(
      context,
      initialAddress: _locationController.text,
    );
    if (selectedLocation != null && selectedLocation.isNotEmpty) {
      setState(() {
        _locationController.text = selectedLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF0F172A),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Buat Pengaduan',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Isi formulir pengaduan dengan data yang jujur & jelas agar petugas dapat menindaklanjuti secara cepat.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.primaryDark,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildFieldLabel('Judul Pengaduan'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'Contoh: Jalan Berlubang di Depan Sekolah',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul pengaduan tidak boleh kosong';
                  }
                  if (value.trim().length < 5) {
                    return 'Judul minimal 5 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _buildFieldLabel('Deskripsi Pengaduan'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText:
                      'Jelaskan rincian permasalahan yang terjadi secara detail...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
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

              _buildFieldLabel('Lokasi Kejadian'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _openMapLocationPicker,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _locationController,
                    enabled: false,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: _isFetchingLocation
                          ? 'Mendeteksi lokasi saat ini...'
                          : 'Ketuk untuk memilih lokasi di map',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFFE11D48),
                        size: 20,
                      ),
                      suffixIcon: _isFetchingLocation
                          ? const UnconstrainedBox(
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                            )
                          : null,
                      // const Icon(
                      //     Icons.map_rounded,
                      //     color: Color(0xFF2563EB),
                      //     size: 22,
                      //   ),
                      filled: true,
                      fillColor: AppColors.white,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lampiran Foto',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${_selectedImages.length}/5 foto',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _selectedImages.length >= 5
                          ? AppColors.warning
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 104,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8, bottom: 6),
                  children: [
                    if (_selectedImages.length < 5)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Material(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            onTap: _pickImageFromCamera,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: 86,
                              height: 86,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFCBD5E1),
                                  width: 1.5,
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_rounded,
                                    color: Color(0xFF64748B),
                                    size: 26,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Kamera',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    ...List.generate(_selectedImages.length, (index) {
                      final imageFile = File(_selectedImages[index].path);
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              FullscreenImageViewer.show(
                                context,
                                imagePathOrUrl: imageFile.path,
                                images: _selectedImages
                                    .map((e) => e.path)
                                    .toList(),
                                initialIndex: index,
                                title: 'Lampiran Foto',
                              );
                            },
                            child: Container(
                              width: 86,
                              height: 86,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.file(
                                  imageFile,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image_rounded,
                                        color: Colors.black38,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE11D48),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
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
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitComplaint,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'KIRIM PENGADUAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

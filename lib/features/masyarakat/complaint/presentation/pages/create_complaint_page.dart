import 'dart:io';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/core/widgets/fullscreen_video_viewer.dart';
import 'package:akar/features/linmas/activation/presentation/pages/camera_capture_screen.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/create_complaint_bloc/create_complaint_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/location_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  static const int _maxAttachments = 5;

  final _formKey = GlobalKey<FormState>();
  late final CreateComplaintBloc _bloc;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isFetchingLocation = false;
  double? _latitude;
  double? _longitude;
  final List<String> _attachments = [];

  bool get _hasVideo => _attachments.any(FileSecurityUtils.isVideoPath);

  @override
  void initState() {
    super.initState();
    _bloc = sl<CreateComplaintBloc>();
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

      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

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

  @override
  void dispose() {
    _bloc.close();
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

  Future<void> _addPhoto() async {
    if (_attachments.length >= _maxAttachments) {
      _showMessage('Maksimal $_maxAttachments lampiran.');
      return;
    }

    final path = await CameraCaptureScreen.open(context);
    if (path != null && mounted) {
      setState(() => _attachments.add(path));
    }
  }

  Future<void> _addVideo() async {
    if (_attachments.length >= _maxAttachments) {
      _showMessage('Maksimal $_maxAttachments lampiran.');
      return;
    }
    if (_hasVideo) {
      _showMessage('Maksimal 1 video per pengaduan.');
      return;
    }

    final path = await CameraCaptureScreen.openVideo(context);
    if (path != null && mounted) {
      setState(() => _attachments.add(path));
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _showMessage(String message) {
    AppToast.showWarning(context, message: message);
  }

  void _submitComplaint() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_attachments.isEmpty) {
      _showMessage('Sertakan minimal 1 foto atau video.');
      return;
    }

    final latitude = _latitude;
    final longitude = _longitude;
    if (latitude == null || longitude == null) {
      _showMessage('Lokasi belum terdeteksi. Pilih lokasi lewat peta.');
      return;
    }

    _bloc.add(
      SubmitComplaintEvent(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _locationController.text.trim(),
        latitude: latitude,
        longitude: longitude,
        attachments: _attachments.map(File.new).toList(),
      ),
    );
  }

  void _handleSuccess(ComplaintReportEntity report) {
    final ticket = report.ticketNumber;
    AppDialogs.showSuccess(
      context,
      title: 'Pengaduan Berhasil Dikirim!',
      message: ticket.isEmpty
          ? 'Laporan pengaduan Anda telah tersimpan dan sedang menunggu verifikasi petugas.'
          : 'Laporan $ticket telah tersimpan dan sedang menunggu verifikasi petugas.',
      buttonText: 'Kembali ke Beranda',
      onPressed: () => Navigator.pop(context, true),
    );
  }

  Future<void> _openMapLocationPicker() async {
    final selectedLocation = await LocationPickerPage.showWithResult(
      context,
      initialAddress: _locationController.text,
      initialPosition: _latitude != null && _longitude != null
          ? LatLng(_latitude!, _longitude!)
          : null,
    );
    if (selectedLocation != null && mounted) {
      setState(() {
        _locationController.text = selectedLocation.address;
        _latitude = selectedLocation.latitude;
        _longitude = selectedLocation.longitude;
      });
    }
  }

  Widget _buildAddTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFF64748B), size: 26),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
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
    );
  }

  Widget _buildAttachmentTile(int index) {
    final path = _attachments[index];
    final isVideo = FileSecurityUtils.isVideoPath(path);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            if (isVideo) {
              FullscreenVideoViewer.show(
                context,
                pathOrUrl: path,
                title: 'Video Pengaduan',
              );
              return;
            }
            final photos = _attachments
                .where((item) => !FileSecurityUtils.isVideoPath(item))
                .toList();
            FullscreenImageViewer.show(
              context,
              imagePathOrUrl: path,
              images: photos,
              initialIndex: photos.indexOf(path),
              title: 'Foto Pengaduan',
            );
          },
          child: Container(
            width: 86,
            height: 86,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: isVideo
                  ? Container(
                      color: const Color(0xFF0F172A),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Video',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      cacheWidth: 300,
                      cacheHeight: 300,
                      errorBuilder: (context, error, stackTrace) => const Icon(
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
            onTap: () => _removeAttachment(index),
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateComplaintBloc, CreateComplaintState>(
      bloc: _bloc,
      listenWhen: (previous, current) =>
          current is CreateComplaintSuccess ||
          current is CreateComplaintFailure,
      listener: (context, state) {
        if (state is CreateComplaintSuccess) {
          _handleSuccess(state.report);
        } else if (state is CreateComplaintFailure) {
          AppToast.showError(context, message: state.message);
        }
      },
      child: Scaffold(
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
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
                        filled: true,
                        fillColor: AppColors.white,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
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
                      'Lampiran Foto / Video',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${_attachments.length}/$_maxAttachments lampiran',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _attachments.length >= _maxAttachments
                            ? AppColors.warning
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                const Text(
                  'Maksimal 1 video, sisanya foto. Diambil langsung dari kamera.',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 104,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 6),
                    children: [
                      if (_attachments.length < _maxAttachments) ...[
                        _buildAddTile(
                          icon: Icons.camera_alt_rounded,
                          label: 'Foto',
                          onTap: _addPhoto,
                        ),
                        if (!_hasVideo)
                          _buildAddTile(
                            icon: Icons.videocam_rounded,
                            label: 'Video',
                            onTap: _addVideo,
                          ),
                      ],
                      ...List.generate(
                        _attachments.length,
                        _buildAttachmentTile,
                      ),
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
          child: BlocBuilder<CreateComplaintBloc, CreateComplaintState>(
            bloc: _bloc,
            builder: (context, state) {
              final isSubmitting = state is CreateComplaintSubmitting;

              return SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submitComplaint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'KIRIM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
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

import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
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

class IncidentCategoryItem {
  final int? id;
  final String label;
  final String? code;
  final String? domain;
  final String? color;

  const IncidentCategoryItem({
    this.id,
    required this.label,
    this.code,
    this.domain,
    this.color,
  });

  factory IncidentCategoryItem.fromJson(Map<String, dynamic> json) {
    return IncidentCategoryItem(
      id: (json['id'] as num?)?.toInt(),
      label: (json['label'] ?? json['name'] ?? '').toString().trim(),
      code: json['code']?.toString(),
      domain: json['domain']?.toString(),
      color: json['color']?.toString(),
    );
  }
}

class CreateComplaintPage extends StatefulWidget {
  final ComplaintCategory? initialCategory;
  final bool isInsidentil;

  const CreateComplaintPage({
    super.key,
    this.initialCategory,
    this.isInsidentil = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    ComplaintCategory? initialCategory,
    bool isInsidentil = false,
  }) {
    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateComplaintPage(
          initialCategory: initialCategory,
          isInsidentil: isInsidentil,
        ),
      ),
    );
  }

  @override
  State<CreateComplaintPage> createState() => _CreateComplaintPageState();
}

class _CreateComplaintPageState extends State<CreateComplaintPage> {
  static const int _maxAttachments = 5;

  static const List<IncidentCategoryItem> _fallbackCategories = [
    IncidentCategoryItem(id: 6, label: 'Bencana Alam', color: '#1877F2'),
    IncidentCategoryItem(id: 5, label: 'Keamanan Sosial', color: '#3B82F6'),
    IncidentCategoryItem(id: 4, label: 'Lingkungan', color: '#10B981'),
    IncidentCategoryItem(id: 1, label: 'Sampah', color: '#0D8E34'),
  ];

  final _formKey = GlobalKey<FormState>();
  late final CreateComplaintBloc _bloc;

  bool _isLoadingCategories = false;
  List<IncidentCategoryItem> _categories = [];
  IncidentCategoryItem? _selectedCategory;
  String? _categoryError;

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
    _categories = List.from(_fallbackCategories);
    if (widget.initialCategory != null) {
      _selectedCategory = _categories.firstWhere(
        (c) =>
            c.label.toLowerCase() ==
            widget.initialCategory!.label.toLowerCase(),
        orElse: () => _categories.first,
      );
    }
    _fetchCurrentLocation();
    if (widget.isInsidentil) {
      _loadCategories();
    }
  }

  List<IncidentCategoryItem> _parseIncidentCategories(dynamic raw) {
    List list = [];
    if (raw is Map && raw['data'] is List) {
      list = raw['data'] as List;
    } else if (raw is List) {
      list = raw;
    }

    return list
        .whereType<Map>()
        .map((e) => IncidentCategoryItem.fromJson(Map<String, dynamic>.from(e)))
        .where((e) => e.label.isNotEmpty)
        .toList();
  }

  void _applyLoadedCategories(List<IncidentCategoryItem> items) {
    if (!mounted || items.isEmpty) return;
    setState(() {
      _categories = items;
      if (_selectedCategory == null && widget.initialCategory != null) {
        _selectedCategory = items.firstWhere(
          (c) =>
              c.label.toLowerCase() ==
              widget.initialCategory!.label.toLowerCase(),
          orElse: () => items.first,
        );
      }
    });
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoadingCategories = true);
    try {
      // domain=report: tanpa filter ini endpoint mengembalikan kategori DUMAS,
      // sehingga report_category_id ditolak backend.
      final res = await DioClient.instance.get(
        ApiConstants.categories,
        queryParameters: const {'domain': 'report'},
      );
      if (sl.isRegistered<OfflineMasterCacheLocalDatasource>()) {
        await sl<OfflineMasterCacheLocalDatasource>().saveCache(
          OfflineMasterCacheLocalDatasource.keyCategoriesReport,
          res.data,
        );
      }
      _applyLoadedCategories(_parseIncidentCategories(res.data));
    } catch (_) {
      if (sl.isRegistered<OfflineMasterCacheLocalDatasource>()) {
        final cached = await sl<OfflineMasterCacheLocalDatasource>().getCache(
          OfflineMasterCacheLocalDatasource.keyCategoriesReport,
        );
        if (cached != null) {
          _applyLoadedCategories(_parseIncidentCategories(cached));
        }
      }
    } finally {
      if (mounted) setState(() => _isLoadingCategories = false);
    }
  }

  void _showCategoryPickerSheet() {
    final searchController = TextEditingController();
    List<IncidentCategoryItem> filteredList = List.from(_categories);
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        final sheetColors = bottomSheetContext.appColors;
        return StatefulBuilder(
          builder: (context, setModalState) {
            final searchText = searchController.text.trim();
            final hasSearch = searchText.isNotEmpty;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(bottomSheetContext).size.height * 0.75,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: sheetColors.borderStrong,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pilih Kategori Laporan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: sheetColors.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: sheetColors.textMuted,
                              ),
                              onPressed: () =>
                                  Navigator.pop(bottomSheetContext),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: searchController,
                          onTapOutside: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onChanged: (val) {
                            setModalState(() {
                              filteredList = _categories
                                  .where(
                                    (item) => item.label.toLowerCase().contains(
                                      val.trim().toLowerCase(),
                                    ),
                                  )
                                  .toList();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari kategori kejadian...',
                            hintStyle: TextStyle(
                              color: sheetColors.textHint,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: sheetColors.primary,
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      color: sheetColors.textHint,
                                    ),
                                    onPressed: () {
                                      searchController.clear();
                                      setModalState(() {
                                        filteredList = List.from(_categories);
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: sheetColors.surfaceElevated,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: sheetColors.divider),
                      Expanded(
                        child: filteredList.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 48,
                                        color: sheetColors.textHint,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        hasSearch
                                            ? '"$searchText" tidak ditemukan'
                                            : 'Kategori tidak ditemukan',
                                        style: TextStyle(
                                          color: sheetColors.textMuted,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final item = filteredList[index];
                                  final isSelected =
                                      _selectedCategory?.id != null
                                      ? _selectedCategory?.id == item.id
                                      : _selectedCategory?.label == item.label;

                                  Color? dotColor;
                                  if (item.color != null &&
                                      item.color!.startsWith('#') &&
                                      item.color!.length >= 7) {
                                    try {
                                      final hex = item.color!.replaceFirst(
                                        '#',
                                        '',
                                      );
                                      final argb = int.parse(
                                        'FF$hex',
                                        radix: 16,
                                      );
                                      dotColor = Color.fromARGB(
                                        (argb >> 24) & 0xFF,
                                        (argb >> 16) & 0xFF,
                                        (argb >> 8) & 0xFF,
                                        argb & 0xFF,
                                      );
                                    } catch (_) {}
                                  }

                                  return ListTile(
                                    leading: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: dotColor ?? sheetColors.primary,
                                      ),
                                    ),
                                    title: Text(
                                      item.label,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? sheetColors.primary
                                            : sheetColors.textPrimary,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? Icon(
                                            Icons.check_circle_rounded,
                                            color: sheetColors.primary,
                                          )
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = item;
                                        _categoryError = null;
                                      });
                                      Navigator.pop(bottomSheetContext);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
      if (mounted &&
          _latitude != null &&
          _longitude != null &&
          _locationController.text.trim().isEmpty) {
        setState(() {
          _locationController.text =
              'Lat: ${_latitude!.toStringAsFixed(6)}, Long: ${_longitude!.toStringAsFixed(6)}';
        });
      }
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
    final colors = context.appColors;
    return Text.rich(
      TextSpan(
        text: labelText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: colors.error,
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
    if (widget.isInsidentil && _selectedCategory == null) {
      setState(() => _categoryError = 'Kategori laporan wajib dipilih');
      _showMessage('Pilih kategori laporan terlebih dahulu.');
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
        category: _selectedCategory?.label ?? widget.initialCategory?.label,
        categoryId: _selectedCategory?.id,
        isInsidentil: widget.isInsidentil,
      ),
    );
  }

  void _handleSuccess(ComplaintReportEntity report) {
    final ticket = report.ticketNumber;
    AppDialogs.showSuccess(
      context,
      title: widget.isInsidentil
          ? 'Laporan Insidentil Berhasil Dikirim!'
          : 'Pengaduan Berhasil Dikirim!',
      message: widget.isInsidentil
          ? (ticket.isEmpty
                ? 'Laporan insidentil telah tersimpan di sistem.'
                : 'Laporan $ticket telah tersimpan di sistem.')
          : (ticket.isEmpty
                ? 'Laporan pengaduan Anda telah tersimpan dan sedang menunggu verifikasi petugas.'
                : 'Laporan $ticket telah tersimpan dan sedang menunggu verifikasi petugas.'),
      buttonText: widget.isInsidentil ? 'Kembali' : 'Kembali ke Beranda',
      onPressed: () => Navigator.pop(context, true),
    );
  }

  void _handleQueuedOffline() {
    AppDialogs.showSuccess(
      context,
      title: 'Disimpan di Antrean Offline',
      message: widget.isInsidentil
          ? 'Laporan insidentil disimpan di antrean offline dan akan dikirim otomatis saat online.'
          : 'Pengaduan disimpan di antrean offline dan akan dikirim otomatis saat online.',
      buttonText: widget.isInsidentil ? 'Kembali' : 'Kembali ke Beranda',
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
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.borderStrong, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: colors.textMuted, size: 26),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colors.textMuted,
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
    final colors = context.appColors;
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
              border: Border.all(color: colors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: isVideo
                  ? Container(
                      color: const Color(0xFF0F172A), // media-overlay
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white, // media-overlay
                            size: 28,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Video',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white, // media-overlay
                            ),
                          ),
                        ],
                      ),
                    )
                  : Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      cacheWidth: 300,
                      cacheHeight: 300,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image_rounded,
                        color: colors.textMuted,
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
              decoration: BoxDecoration(
                color: colors.errorSolid,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: colors.onErrorSolid,
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
    final colors = context.appColors;
    return BlocListener<CreateComplaintBloc, CreateComplaintState>(
      bloc: _bloc,
      listenWhen: (previous, current) =>
          current is CreateComplaintSuccess ||
          current is CreateComplaintQueuedOffline ||
          current is CreateComplaintFailure,
      listener: (context, state) {
        if (state is CreateComplaintSuccess) {
          _handleSuccess(state.report);
        } else if (state is CreateComplaintQueuedOffline) {
          _handleQueuedOffline();
        } else if (state is CreateComplaintFailure) {
          AppToast.showError(context, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppPageBar(
          title: widget.isInsidentil ? 'Laporan Insidentil' : 'Buat Pengaduan',
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
                    color: colors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: colors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.isInsidentil
                              ? 'Isi formulir laporan insidentil dengan data yang akurat agar dapat segera ditindaklanjuti.'
                              : 'Isi formulir pengaduan dengan data yang jujur & jelas agar petugas dapat menindaklanjuti secara cepat.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: colors.primaryDark,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (widget.isInsidentil) ...[
                  _buildFieldLabel('Kategori Laporan'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _showCategoryPickerSheet,
                    borderRadius: BorderRadius.circular(14),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Pilih kategori laporan',
                        hintStyle: TextStyle(
                          color: colors.textHint,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.category_outlined,
                          color: colors.primary,
                          size: 20,
                        ),
                        suffixIcon: _isLoadingCategories
                            ? UnconstrainedBox(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.primary,
                                    ),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: colors.textMuted,
                                size: 24,
                              ),
                        filled: true,
                        fillColor: colors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _categoryError != null
                                ? colors.error
                                : colors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: colors.primary,
                            width: 1.5,
                          ),
                        ),
                        errorText: _categoryError,
                      ),
                      child: Text(
                        _selectedCategory?.label ?? 'Pilih kategori laporan',
                        style: TextStyle(
                          fontSize: 14,
                          color: _selectedCategory != null
                              ? colors.textPrimary
                              : colors.textHint,
                          fontWeight: _selectedCategory != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                _buildFieldLabel(
                  widget.isInsidentil ? 'Judul Laporan' : 'Judul Pengaduan',
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  style: TextStyle(fontSize: 14, color: colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: widget.isInsidentil
                        ? 'Contoh: Pohon Tumbang Menutup Jalan'
                        : 'Contoh: Jalan Berlubang di Depan Sekolah',
                    hintStyle: TextStyle(color: colors.textHint, fontSize: 14),
                    filled: true,
                    fillColor: colors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.primary, width: 1.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return widget.isInsidentil
                          ? 'Judul laporan tidak boleh kosong'
                          : 'Judul pengaduan tidak boleh kosong';
                    }
                    if (value.trim().length < 5) {
                      return 'Judul minimal 5 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                _buildFieldLabel(
                  widget.isInsidentil
                      ? 'Deskripsi Laporan'
                      : 'Deskripsi Pengaduan',
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  maxLines: 4,
                  style: TextStyle(fontSize: 14, color: colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: widget.isInsidentil
                        ? 'Jelaskan kronologi atau rincian kejadian secara detail...'
                        : 'Jelaskan rincian permasalahan yang terjadi secara detail...',
                    hintStyle: TextStyle(color: colors.textHint, fontSize: 14),
                    filled: true,
                    fillColor: colors.surface,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.primary, width: 1.5),
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
                      style: TextStyle(fontSize: 14, color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: _isFetchingLocation
                            ? 'Mendeteksi lokasi saat ini...'
                            : 'Ketuk untuk memilih lokasi di map',
                        hintStyle: TextStyle(
                          color: colors.textHint,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: colors.error,
                          size: 20,
                        ),
                        suffixIcon: _isFetchingLocation
                            ? UnconstrainedBox(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.primary,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: colors.surface,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: colors.primary,
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
                    Text(
                      'Lampiran Foto / Video',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_attachments.length}/$_maxAttachments lampiran',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _attachments.length >= _maxAttachments
                            ? colors.warning
                            : colors.textMuted,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  'Maksimal 1 video, sisanya foto. Diambil langsung dari kamera.',
                  style: TextStyle(fontSize: 11.5, color: colors.textMuted),
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
            color: colors.surface,
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
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
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colors.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'KIRIM',
                            style: TextStyle(
                              color: colors.onPrimary,
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

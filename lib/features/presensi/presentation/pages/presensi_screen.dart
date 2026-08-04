import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../provider/presensi_provider.dart';

class PresensiScreen extends StatefulWidget {
  const PresensiScreen({super.key});

  @override
  State<PresensiScreen> createState() => _PresensiScreenState();
}

class _PresensiScreenState extends State<PresensiScreen> {
  GoogleMapController? _mapController;
  late final TextEditingController _kecamatanController;
  late final TextEditingController _kelurahanController;
  late final TextEditingController _addressController;
  late final TextEditingController _rtController;
  late final TextEditingController _rwController;
  double _dragPosition = 0.0;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    final p = context.read<PresensiProvider>();
    _kecamatanController = TextEditingController(text: p.kecamatan);
    _kelurahanController = TextEditingController(text: p.kelurahan);
    _addressController = TextEditingController(text: p.address);
    _rtController = TextEditingController(text: p.rt);
    _rwController = TextEditingController(text: p.rw);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authUser = context.read<AuthProvider>().currentUser;
      final userName = authUser?.name ?? 'Pengguna';
      await context.read<PresensiProvider>().initLocation(userName);
      if (mounted) {
        final updated = context.read<PresensiProvider>();
        _kecamatanController.text = updated.kecamatan;
        _kelurahanController.text = updated.kelurahan;
        _addressController.text = updated.address;
        _rtController.text = updated.rt;
        _rwController.text = updated.rw;

        if (updated.userLatitude != null && updated.userLongitude != null) {
          _recenterMap(updated.userLatitude!, updated.userLongitude!);
        }
      }
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _addressController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    super.dispose();
  }

  void _recenterMap(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PresensiProvider>(
      builder: (context, provider, child) {
        final userLat = provider.userLatitude ?? -6.2088;
        final userLng = provider.userLongitude ?? 106.8456;
        final userPos = LatLng(userLat, userLng);

        final markers = <Marker>{
          Marker(
            markerId: const MarkerId('user_location'),
            position: userPos,
            infoWindow: const InfoWindow(title: 'Lokasi Presensi Anda'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        };

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grey300),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            title: const Text(
              'Presensi Kehadiran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.my_location_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: () => _recenterMap(userLat, userLng),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * 0.5,
                child: GoogleMap(
                  key: const ValueKey('presensi_google_map'),
                  initialCameraPosition: CameraPosition(
                    target: userPos,
                    zoom: 16.5,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (provider.userLatitude != null &&
                        provider.userLongitude != null) {
                      _recenterMap(
                        provider.userLatitude!,
                        provider.userLongitude!,
                      );
                    }
                  },
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
              if (provider.status == PresensiStatus.loadingLocation)
                Positioned.fill(
                  child: Container(
                    color: AppColors.background,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          SizedBox(height: 16),
                          Text(
                            'Mendeteksi Koordinat GPS & Lokasi...',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else ...[
                Positioned(
                  top: 12,
                  left: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            DateFormat(
                              'EEEE, dd MMMM yyyy - HH:mm WIB',
                              'id_ID',
                            ).format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.grey300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Text(
                              'Detail & Lokasi Presensi',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoField(
                              label: 'Nama Anggota',
                              value: provider.userName,
                              icon: Icons.person_rounded,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildEditableField(
                                    label: 'Kecamatan',
                                    controller: _kecamatanController,
                                    icon: Icons.location_city_rounded,
                                    onChanged: provider.updateKecamatan,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildEditableField(
                                    label: 'Kelurahan',
                                    controller: _kelurahanController,
                                    icon: Icons.holiday_village_rounded,
                                    onChanged: provider.updateKelurahan,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildEditableField(
                              label: 'Alamat Lengkap',
                              controller: _addressController,
                              icon: Icons.location_on_rounded,
                              onChanged: provider.updateAddress,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'RT',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: _rtController,
                                        onTapOutside: (event) =>
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus(),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) =>
                                            provider.updateRt(val),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.tag_rounded,
                                            color: AppColors.primary,
                                            size: 16,
                                          ),
                                          filled: true,
                                          fillColor: AppColors.grey100,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: const BorderSide(
                                              color: AppColors.grey300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: const BorderSide(
                                              color: AppColors.grey300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'RW',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: _rwController,
                                        onTapOutside: (event) =>
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus(),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) =>
                                            provider.updateRw(val),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.tag_rounded,
                                            color: AppColors.primary,
                                            size: 16,
                                          ),
                                          filled: true,
                                          fillColor: AppColors.grey100,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: const BorderSide(
                                              color: AppColors.grey300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: const BorderSide(
                                              color: AppColors.grey300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildSlideToPresensiButton(context, provider),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          maxLines: maxLines,
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 16),
            filled: true,
            fillColor: AppColors.grey100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideToPresensiButton(
    BuildContext context,
    PresensiProvider provider,
  ) {
    const double trackHeight = 56.0;
    const double thumbWidth = 54.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - thumbWidth;

        return Container(
          height: trackHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: provider.status == PresensiStatus.submitting
                ? AppColors.grey200
                : AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: _dragPosition + (thumbWidth / 2),
                height: trackHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),

              Center(
                child: Text(
                  provider.status == PresensiStatus.submitting
                      ? 'MEMPROSES PRESENSI...'
                      : _isSubmitted
                      ? 'PRESENSI BERHASIL!'
                      : 'GESER UNTUK PRESENSI ➔',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: provider.status == PresensiStatus.submitting
                        ? AppColors.textSecondary
                        : AppColors.primary,
                  ),
                ),
              ),

              Positioned(
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (provider.status == PresensiStatus.submitting ||
                        _isSubmitted) {
                      return;
                    }
                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx).clamp(
                        0.0,
                        maxDrag,
                      );
                    });
                  },
                  onHorizontalDragEnd: (details) async {
                    if (provider.status == PresensiStatus.submitting ||
                        _isSubmitted) {
                      return;
                    }

                    if (_dragPosition >= maxDrag * 0.85) {
                      setState(() {
                        _dragPosition = maxDrag;
                        _isSubmitted = true;
                      });

                      final success = await provider.submitPresensi();
                      if (success && context.mounted) {
                        _showSuccessPresensiDialog(context, provider);
                      } else {
                        setState(() {
                          _dragPosition = 0.0;
                          _isSubmitted = false;
                        });
                      }
                    } else {
                      setState(() {
                        _dragPosition = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: thumbWidth,
                    height: trackHeight - 4,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: provider.status == PresensiStatus.submitting
                        ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.keyboard_double_arrow_right_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessPresensiDialog(
    BuildContext context,
    PresensiProvider provider,
  ) {
    final result = provider.lastResult;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Presensi Berhasil Dicatat!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bukti presensi Anda telah tercatat dengan ID ${result?.id ?? '-'} pada sistem.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Column(
                  children: [
                    _buildDialogRow('Nama', result?.userName ?? '-'),
                    const SizedBox(height: 6),
                    _buildDialogRow('Kecamatan', result?.kecamatan ?? '-'),
                    const SizedBox(height: 6),
                    _buildDialogRow('Kelurahan', result?.kelurahan ?? '-'),
                    const SizedBox(height: 6),
                    _buildDialogRow(
                      'RT / RW',
                      'RT ${result?.rt ?? '-'} / RW ${result?.rw ?? '-'}',
                    ),
                    const SizedBox(height: 6),
                    _buildDialogRow(
                      'Waktu',
                      DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(result?.timestamp ?? DateTime.now()),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'KEMBALI KE UTAMA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

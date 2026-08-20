import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/panic/domain/entities/panic_entity.dart';
import 'package:akar/features/linmas/panic/presentation/bloc/panic_bloc/panic_bloc.dart';

class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> {
  GoogleMapController? _mapController;
  int _tapCount = 0;
  Timer? _tapResetTimer;
  bool _isExpanded = false;
  final int _selectedRadius = 500;
  // final List<int> _radiusOptions = const [500, 1000, 3000, 5000];

  // void _updateRadius(int radius, double userLat, double userLng) {
  //   setState(() {
  //     _selectedRadius = radius;
  //   });
  //   double zoom = 15.2;
  //   if (radius == 1000) zoom = 14.0;
  //   if (radius == 3000) zoom = 12.5;
  //   if (radius == 5000) zoom = 11.5;

  //   _mapController?.animateCamera(
  //     CameraUpdate.newLatLngZoom(LatLng(userLat, userLng), zoom),
  //   );
  // }

  @override
  void dispose() {
    _tapResetTimer?.cancel();
    super.dispose();
  }

  void _handleEmergencyButtonTap(PanicState state) {
    if (state.status == PanicStatus.sending) return;

    _tapResetTimer?.cancel();

    setState(() {
      _tapCount++;
    });

    if (_tapCount < 3) {
      _tapResetTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _tapCount = 0;
          });
        }
      });
    } else {
      _tapResetTimer?.cancel();
      setState(() {
        _tapCount = 0;
      });

      context.read<PanicBloc>().add(const SendPanicAlertEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PanicBloc>().add(InitPanicLocationEvent());
    });
  }

  void _recenterMap(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PanicBloc, PanicState>(
      listener: (context, state) {
        if (state.status == PanicStatus.success) {
          _showSuccessEmergencyDialog(context, state);
        } else if (state.status == PanicStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        _recenterMap(state.userLatitude, state.userLongitude);
      },
      builder: (context, state) {
        final userLat = state.userLatitude;
        final userLng = state.userLongitude;
        final userLatLng = LatLng(userLat, userLng);

        final filteredMembers = state.nearbyMembers.where((member) {
          final dist = Geolocator.distanceBetween(
            userLat,
            userLng,
            member.latitude,
            member.longitude,
          );
          return dist <= _selectedRadius;
        }).toList();

        final filteredLeaders = state.localLeaders.where((leader) {
          final dist = Geolocator.distanceBetween(
            userLat,
            userLng,
            leader.latitude,
            leader.longitude,
          );
          return dist <= _selectedRadius;
        }).toList();

        final Set<Marker> markers = {
          Marker(
            markerId: const MarkerId('user_sos_location'),
            position: userLatLng,
            infoWindow: const InfoWindow(
              title: 'Lokasi Anda (SOS)',
              snippet: 'Titik Posisi Darurat Saya',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
          ...filteredMembers.map((member) {
            return Marker(
              markerId: MarkerId(member.id),
              position: LatLng(member.latitude, member.longitude),
              infoWindow: InfoWindow(
                title: member.name,
                snippet: '${member.role} • ${member.distanceText}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
              onTap: () {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(member.latitude, member.longitude),
                    16,
                  ),
                );
              },
            );
          }),
          ...filteredLeaders.map((leader) {
            return Marker(
              markerId: MarkerId(leader.id),
              position: LatLng(leader.latitude, leader.longitude),
              infoWindow: InfoWindow(
                title: leader.name,
                snippet: '${leader.role} • ${leader.distanceText}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange,
              ),
              onTap: () {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(leader.latitude, leader.longitude),
                    16,
                  ),
                );
              },
            );
          }),
        };

        final Set<Circle> circles = {
          Circle(
            circleId: const CircleId('user_selected_radius'),
            center: userLatLng,
            radius: _selectedRadius.toDouble(),
            fillColor: AppColors.primary.withValues(alpha: 0.12),
            strokeColor: AppColors.primary,
            strokeWidth: 2,
          ),
        };

        final radiusLabel = _selectedRadius >= 1000
            ? '${(_selectedRadius / 1000).toInt()}km'
            : '${_selectedRadius}m';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.textPrimary,
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
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              'Pusat Bantuan & SOS',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  width: 36,
                  height: 36,
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
                    onPressed: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(userLatLng, 16),
                      );
                    },
                    tooltip: 'Pusatkan Lokasi Saya',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final double bodyHeight = constraints.maxHeight;
              final double topBannerBottom = 60.0;
              final double bottomSheetHeight = _isExpanded
                  ? (bodyHeight * 0.52).clamp(380.0, 480.0)
                  : 235.0;
              final double bottomSheetTop = bodyHeight - bottomSheetHeight;
              final double spaceBetween = bottomSheetTop - topBannerBottom;
              const double radiusCardHeight = 170.0;

              double radiusWidgetTop =
                  topBannerBottom + (spaceBetween / 2) - (radiusCardHeight / 2);

              final double minTop = topBannerBottom + 8.0;
              final double maxTop = bottomSheetTop - radiusCardHeight - 8.0;
              if (maxTop >= minTop) {
                radiusWidgetTop = radiusWidgetTop.clamp(minTop, maxTop);
              } else {
                radiusWidgetTop = minTop;
              }

              return Stack(
                children: [
                  AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.only(bottom: bottomSheetHeight),
                    child: GoogleMap(
                      key: const ValueKey('panic_google_map'),
                      initialCameraPosition: CameraPosition(
                        target: userLatLng,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                        _recenterMap(state.userLatitude, state.userLongitude);
                      },
                      markers: markers,
                      circles: circles,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                  if (state.status == PanicStatus.loading)
                    Positioned.fill(
                      child: Container(
                        color: AppColors.background,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Mendeteksi Posisi & Anggota Terdekat...',
                                style: TextStyle(
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
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(14),
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
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Mode Siaga: ${filteredMembers.length} Anggota Terdekat Dalam Radius $radiusLabel Terdeteksi',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /*
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      top: radiusWidgetTop,
                      right: 14,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: _isExpanded ? 0.0 : 1.0,
                        child: IgnorePointer(
                          ignoring: _isExpanded,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.94),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.16),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.radar_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Radius',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ..._radiusOptions.map((radius) {
                                  final isSelected = _selectedRadius == radius;
                                  final label = radius >= 1000
                                      ? '${(radius / 1000).toInt()}km'
                                      : '${radius}m';

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: InkWell(
                                      onTap: () =>
                                          _updateRadius(radius, userLat, userLng),
                                      borderRadius: BorderRadius.circular(10),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.grey100,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.grey300,
                                            width: isSelected ? 1.5 : 1.0,
                                          ),
                                        ),
                                        child: Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    */
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildBottomPanel(
                        context,
                        state,
                        filteredMembers,
                        filteredLeaders,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel(
    BuildContext context,
    PanicState state,
    List<NearbyMemberEntity> filteredMembers,
    List<NearbyMemberEntity> filteredLeaders,
  ) {
    final totalMembers = filteredMembers.length + filteredLeaders.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alamat Lokasi Darurat Anda',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.fullAddress,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dedicated clear toggle button for elderly users
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _isExpanded
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.people_alt_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isExpanded
                              ? 'Sembunyikan Daftar Anggota'
                              : 'Lihat Anggota Terdekat ($totalMembers)',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),

                        const Text(
                          'Anggota Terdekat (Akan Menerima Notifikasi):',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        if (filteredMembers.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.warning.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Tidak ada anggota terdekat dalam radius ini. Silakan perbesar radius pilihan (1km/3km/5km) di sebelah kanan layar.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            height: 72,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredMembers.length,
                              itemBuilder: (context, index) {
                                final member = filteredMembers[index];

                                return GestureDetector(
                                  onTap: () {
                                    _mapController?.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        LatLng(
                                          member.latitude,
                                          member.longitude,
                                        ),
                                        16,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 220,
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.06,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.25,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 18,
                                          backgroundColor: AppColors.primary,
                                          child: Icon(
                                            Icons.shield_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                member.name,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                member.distanceText,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 14),

                        if (filteredLeaders.isNotEmpty) ...[
                          const Text(
                            'Tokoh / Pejabat Wilayah:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 72,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredLeaders.length,
                              itemBuilder: (context, index) {
                                final leader = filteredLeaders[index];

                                return GestureDetector(
                                  onTap: () {
                                    _mapController?.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        LatLng(
                                          leader.latitude,
                                          leader.longitude,
                                        ),
                                        16,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 200,
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColors.accent.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 18,
                                          backgroundColor: AppColors.accent,
                                          child: Icon(
                                            Icons.stars_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                leader.name,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${leader.role} • ${leader.distanceText}',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.accent,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 14),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.status == PanicStatus.sending
                        ? null
                        : () => _handleEmergencyButtonTap(state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: state.status == PanicStatus.sending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _tapCount == 0
                                ? 'MINTA BANTUAN DARURAT'
                                : 'TEKAN ${3 - _tapCount}X LAGI UNTUK MENGIRIM',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color: _tapCount > 0
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _tapCount > 0
                          ? 'Tekan ${3 - _tapCount}x lagi untuk mengonfirmasi sinyal SOS'
                          : 'Tekan tombol 3x untuk mengirim bantuan darurat',
                      style: TextStyle(
                        fontSize: 11,
                        color: _tapCount > 0
                            ? AppColors.error
                            : AppColors.textSecondary,
                        fontWeight: _tapCount > 0
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessEmergencyDialog(BuildContext context, PanicState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 52,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Permintaan Bantuan Terkirim!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sinyal darurat (SOS) telah berhasil disiarkan secara serentak ke seluruh tim tanggap darurat terdekat.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.nearbyMembers.length} Anggota Menerima Notifikasi',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                          ),
                          const Text(
                            'Seluruh tim terdekat sedang merespons dan menuju titik posisi Anda.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Mengerti'),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/panic/presentation/bloc/panic_bloc/panic_bloc.dart';
import '../widgets/panic_bottom_panel.dart';
import '../widgets/panic_dialogs.dart';
import '../widgets/panic_member_detail_sheet.dart';
import '../widgets/panic_shimmer_loading.dart';
import '../widgets/panic_status_banner.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PanicBloc>().add(const InitPanicLocationEvent());
    });
  }

  @override
  void dispose() {
    _tapResetTimer?.cancel();
    super.dispose();
  }

  void _recenterMap(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.0),
    );
  }

  void _confirmDeactivateEmergency() {
    PanicDialogs.showDeactivateEmergencyDialog(
      context,
      onConfirm: () {
        context.read<PanicBloc>().add(
          const SendPanicAlertEvent(isEmergency: false),
        );
      },
    );
  }

  void _handleEmergencyButtonTap(PanicState state) {
    if (state is PanicActionLoading) return;

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

      context.read<PanicBloc>().add(
        const SendPanicAlertEvent(isEmergency: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PanicBloc, PanicState>(
      listener: (context, state) {
        if (state is PanicActionSuccess) {
          if (state.isEmergencyActive) {
            PanicDialogs.showSuccessEmergencyDialog(
              context,
              notifiedMembersCount: state.nearbyMembers.length,
              onDismiss: () {
                _recenterMap(state.userLatitude, state.userLongitude);
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Sinyal darurat (SOS) telah berhasil dinonaktifkan. Anda dalam status aman.',
                ),
                backgroundColor: Color(0xFF16A34A),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else if (state is PanicActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is PanicFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (state is PanicLoaded) {
          _recenterMap(state.userLatitude, state.userLongitude);
        }
      },
      builder: (context, state) {
        final bloc = context.read<PanicBloc>();
        final userLat = state.userLatitude;
        final userLng = state.userLongitude;
        final userLatLng = LatLng(userLat, userLng);

        final filteredMembers = bloc.filteredMembers;
        final filteredLeaders = bloc.filteredLeaders;

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
                PanicMemberDetailSheet.show(context, member);
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
                PanicMemberDetailSheet.show(context, leader, isLeader: true);
              },
            );
          }),
        };

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
                    onPressed: () => _recenterMap(userLat, userLng),
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
              final double bottomSheetHeight = _isExpanded
                  ? (bodyHeight * 0.52).clamp(380.0, 480.0)
                  : 240.0;

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
                        zoom: 15.5,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                        _recenterMap(userLat, userLng);
                      },
                      markers: markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                  if (state is PanicLoading && state.nearbyMembers.isEmpty)
                    const Positioned.fill(child: PanicShimmerLoading())
                  else ...[
                    Positioned(
                      top: 12,
                      left: 14,
                      right: 14,
                      child: PanicStatusBanner(
                        isEmergencyActive: state.isEmergencyActive,
                        activeMemberCount: filteredMembers.length,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: PanicBottomPanel(
                        fullAddress: state.fullAddress,
                        isEmergencyActive: state.isEmergencyActive,
                        isActionLoading: state is PanicActionLoading,
                        tapCount: _tapCount,
                        isExpanded: _isExpanded,
                        filteredMembers: filteredMembers,
                        filteredLeaders: filteredLeaders,
                        onToggleExpanded: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        onEmergencyButtonPressed: () =>
                            _handleEmergencyButtonTap(state),
                        onDeactivateButtonPressed: _confirmDeactivateEmergency,
                        onMemberTapped: (member, isLeader) {
                          _recenterMap(member.latitude, member.longitude);
                          PanicMemberDetailSheet.show(
                            context,
                            member,
                            isLeader: isLeader,
                          );
                        },
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
}

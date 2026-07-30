import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/home/domain/entities/tracked_location.dart';
import 'package:akar/features/home/presentation/provider/home_provider.dart';
import 'package:akar/features/home/presentation/widgets/notification_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MapTrackingScreen extends StatefulWidget {
  const MapTrackingScreen({super.key});

  @override
  State<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: _buildAppBar(provider),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(provider),
          floatingActionButton: _buildFab(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(HomeProvider provider) {
    return AppBar(
      title: Text(
        '${AppConstants.appName} [MAP TRACKING]',
        style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
      ),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: AppColors.white),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () => NotificationModalSheet.show(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.white,
                    size: 26,
                  ),
                  tooltip: 'Notifikasi Kegiatan',
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(HomeProvider provider) {
    return Column(
      children: [
        _buildMapsSection(provider),
        Expanded(child: _buildListSection(provider)),
      ],
    );
  }

  Widget _buildMapsSection(HomeProvider provider) {
    LatLng initialTarget = const LatLng(-6.2088, 106.8456);
    if (provider.locations.isNotEmpty) {
      initialTarget = LatLng(
        provider.locations.last.latitude,
        provider.locations.last.longitude,
      );
    }

    final Set<Marker> markers = provider.locations.map((loc) {
      final isSelected = provider.selectedLocation == loc;
      return Marker(
        markerId: MarkerId(loc.timestamp.millisecondsSinceEpoch.toString()),
        position: LatLng(loc.latitude, loc.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed,
        ),
        onTap: () {
          provider.selectLocation(loc);
          _animateToCoordinates(loc.latitude, loc.longitude);
        },
      );
    }).toSet();

    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialTarget,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                if (provider.locations.isNotEmpty) {
                  _animateToCoordinates(
                    provider.locations.last.latitude,
                    provider.locations.last.longitude,
                  );
                }
              },
              myLocationEnabled: true,
              markers: markers,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
            ),
            if (provider.errorMessage != null)
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Text(
                    provider.errorMessage!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            if (provider.selectedLocation != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _buildLocationCard(provider, provider.selectedLocation!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(HomeProvider provider, TrackedLocation loc) {
    final timeStr = DateFormat('HH:mm:ss').format(loc.timestamp);
    final dateStr = DateFormat('dd MMM yyyy').format(loc.timestamp);

    return Card(
      elevation: 8,
      shadowColor: AppColors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    loc.address ?? "Unknown Street",
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.grey500),
                  onPressed: () => provider.clearSelectedLocation(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "Lat: ${loc.latitude.toStringAsFixed(6)}, Lng: ${loc.longitude.toStringAsFixed(6)}",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  "$timeStr ($dateStr)",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection(HomeProvider provider) {
    if (provider.locations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 48, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(
              "Belum ada riwayat lokasi",
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final reversedLocations = provider.locations.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            "Riwayat Lokasi (${provider.locations.length})",
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: reversedLocations.length,
            itemBuilder: (context, index) {
              final loc = reversedLocations[index];
              final isSelected = provider.selectedLocation == loc;
              final timeStr = DateFormat('HH:mm:ss').format(loc.timestamp);

              return Card(
                elevation: isSelected ? 4 : 1,
                color: isSelected ? AppColors.accent : AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? AppColors.primary
                        : AppColors.grey200,
                    child: Icon(
                      Icons.my_location,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                  title: Text(
                    loc.address ?? "Resolving address...",
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "Lat: ${loc.latitude.toStringAsFixed(5)}, Lng: ${loc.longitude.toStringAsFixed(5)}",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: Text(
                    timeStr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    provider.selectLocation(loc);
                    _animateToCoordinates(loc.latitude, loc.longitude);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        context.pushNamed('setting');
      },
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.settings, color: AppColors.white),
    );
  }

  Future<void> _animateToCoordinates(double latitude, double longitude) async {
    final controller = _mapController;
    if (controller != null) {
      try {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latitude, longitude), zoom: 16.0),
          ),
        );
      } catch (e) {
        debugPrint("Error animating camera: $e");
      }
    }
  }
}

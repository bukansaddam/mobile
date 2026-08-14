import 'dart:async';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/location_suggestion.dart';
import '../bloc/location_picker_cubit.dart';
import '../bloc/location_picker_state.dart';
import '../widgets/location_search_bar_widget.dart';

class LocationPickerPage extends StatefulWidget {
  final String? initialAddress;
  final LatLng? initialPosition;

  const LocationPickerPage({
    super.key,
    this.initialAddress,
    this.initialPosition,
  });

  static Future<String?> show(
    BuildContext context, {
    String? initialAddress,
    LatLng? initialPosition,
  }) {
    return Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) =>
              sl<LocationPickerCubit>()..init(initialPosition, initialAddress),
          child: LocationPickerPage(
            initialAddress: initialAddress,
            initialPosition: initialPosition,
          ),
        ),
      ),
    );
  }

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  LatLng _currentMapCenter = LocationPickerState.defaultLocation;

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _animateToPosition(LatLng position) async {
    if (_mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 17),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationPickerCubit, LocationPickerState>(
      listenWhen: (previous, current) =>
          current.animateTarget != null ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<LocationPickerCubit>().clearErrorMessage();
        }

        if (state.animateTarget != null) {
          _animateToPosition(state.animateTarget!);
          context.read<LocationPickerCubit>().clearAnimateTarget();
        }
      },
      builder: (context, state) {
        final cubit = context.read<LocationPickerCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(gradient: AppColors.topHeaderGradient),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF0F172A),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'Pilih Lokasi Kejadian',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: state.targetPosition,
                  zoom: 16.5,
                ),
                onMapCreated: (GoogleMapController controller) {
                  if (!_mapController.isCompleted) {
                    _mapController.complete(controller);
                  }
                },
                onCameraMove: (position) {
                  _currentMapCenter = position.target;
                  if (state.suggestions.isNotEmpty) {
                    cubit.clearSuggestions();
                  }
                },
                onCameraIdle: () {
                  cubit.onCameraIdle(_currentMapCenter);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: true,
                mapToolbarEnabled: false,
              ),

              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: LocationSearchBarWidget(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  isSearching: state.isSearching,
                  isLoadingSuggestions: state.isLoadingSuggestions,
                  suggestions: state.suggestions,
                  onChanged: cubit.onSearchTextChanged,
                  onSubmitted: cubit.searchLocation,
                  onSelectSuggestion: (LocationSuggestion suggestion) {
                    FocusScope.of(context).unfocus();
                    _searchController.text = suggestion.displayName;
                    cubit.selectSuggestion(suggestion);
                  },
                  onClear: () {
                    _searchController.clear();
                    cubit.clearSuggestions();
                  },
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 38),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE11D48),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFE11D48,
                              ).withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      Container(
                        width: 4,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE11D48),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: const BorderRadius.all(
                            Radius.elliptical(14, 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                right: 16,
                bottom: 250,
                child: FloatingActionButton(
                  heroTag: 'recenter_gps_fab',
                  onPressed: state.isLocatingUser
                      ? null
                      : cubit.determineUserPosition,
                  backgroundColor: Colors.white,
                  elevation: 4,
                  child: state.isLocatingUser
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.my_location_rounded,
                          color: AppColors.primary,
                        ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.pin_drop_rounded,
                                    size: 14,
                                    color: Color(0xFF2563EB),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Lokasi Terpilih',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (state.isLoadingAddress)
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.selectedAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: state.isLoadingAddress
                                ? null
                                : () {
                                    Navigator.pop(
                                      context,
                                      state.selectedAddress,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Gunakan Lokasi Ini',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

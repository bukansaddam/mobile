import 'dart:async';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_polygon_utils.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_spatial_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Layar peta layar penuh (read-only) untuk meninjau pin lokasi dan arsiran polygon laporan Jaga Tanah.
class JagaTanahFullscreenMapPage extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final List<LatLng> polygonPoints;
  final MapType initialMapType;
  final String title;
  final String? address;
  final String? estimatedArea;
  final JagaTanahMapPreviewBuilder? mapPreviewBuilder;

  const JagaTanahFullscreenMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    this.polygonPoints = const [],
    this.initialMapType = MapType.normal,
    this.title = 'Peta Lokasi',
    this.address,
    this.estimatedArea,
    this.mapPreviewBuilder,
  });

  static Future<void> open(
    BuildContext context, {
    required double? latitude,
    required double? longitude,
    List<LatLng> polygonPoints = const [],
    MapType initialMapType = MapType.normal,
    String title = 'Peta Lokasi',
    String? address,
    String? estimatedArea,
    JagaTanahMapPreviewBuilder? mapPreviewBuilder,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => JagaTanahFullscreenMapPage(
          latitude: latitude,
          longitude: longitude,
          polygonPoints: polygonPoints,
          initialMapType: initialMapType,
          title: title,
          address: address,
          estimatedArea: estimatedArea,
          mapPreviewBuilder: mapPreviewBuilder,
        ),
      ),
    );
  }

  @override
  State<JagaTanahFullscreenMapPage> createState() =>
      _JagaTanahFullscreenMapPageState();
}

class _JagaTanahFullscreenMapPageState
    extends State<JagaTanahFullscreenMapPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  late MapType _mapType;

  @override
  void initState() {
    super.initState();
    _mapType = widget.initialMapType == MapType.hybrid
        ? MapType.satellite
        : widget.initialMapType;
  }

  LatLng? get _center {
    if (widget.latitude != null && widget.longitude != null) {
      return LatLng(widget.latitude!, widget.longitude!);
    }
    return JagaTanahPolygonUtils.centroidOf(widget.polygonPoints);
  }

  Future<void> _fitCamera() async {
    if (!_mapController.isCompleted) return;
    final controller = await _mapController.future;
    final boundsPoints = <LatLng>[
      ...widget.polygonPoints,
      if (widget.latitude != null && widget.longitude != null)
        LatLng(widget.latitude!, widget.longitude!),
    ];
    final bounds = JagaTanahPolygonUtils.boundsOf(boundsPoints);
    if (bounds != null) {
      try {
        await controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 56),
        );
        return;
      } catch (_) {}
    }
    final center = _center;
    if (center != null) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: center, zoom: 17)),
      );
    }
  }

  Widget _buildMapTypeToggle(BuildContext context, AppColorScheme colors) {
    final isSatellite =
        _mapType == MapType.satellite || _mapType == MapType.hybrid;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 200);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedAlign(
              key: const ValueKey('fullscreen_map_type_indicator'),
              duration: duration,
              curve: Curves.easeOutCubic,
              alignment: isSatellite
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _FullscreenMapTab(
                label: 'Peta Default',
                isSelected: !isSatellite,
                duration: duration,
                onTap: () => setState(() => _mapType = MapType.normal),
              ),
              _FullscreenMapTab(
                label: 'Hybrid / Satelit',
                isSelected: isSatellite,
                duration: duration,
                onTap: () => setState(() => _mapType = MapType.satellite),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final center = _center;
    final hasPolygon = widget.polygonPoints.length >= 3;
    final computedArea = hasPolygon
        ? JagaTanahPolygonUtils.formatArea(
            JagaTanahPolygonUtils.calculateAreaSquareMeters(
              widget.polygonPoints,
            ),
          )
        : null;
    final areaLabel =
        (widget.estimatedArea != null && widget.estimatedArea!.trim().isNotEmpty)
        ? widget.estimatedArea!.trim()
        : computedArea;
    final trimmedAddress = widget.address?.trim() ?? '';
    final showBottomCard = hasPolygon || trimmedAddress.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppPageBar(title: widget.title),
      body: center == null
          ? Center(
              child: Text(
                'Koordinat lokasi tidak tersedia.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: widget.mapPreviewBuilder != null
                      ? widget.mapPreviewBuilder!(context, center)
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: center,
                            zoom: 17,
                          ),
                          mapType: _mapType,
                          style: JagaTanahPolygonUtils.cleanMapStyle,
                          onMapCreated: (controller) {
                            if (!_mapController.isCompleted) {
                              _mapController.complete(controller);
                            }
                            if (hasPolygon) {
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) => _fitCamera(),
                              );
                            }
                          },
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          compassEnabled: true,
                          mapToolbarEnabled: false,
                          markers: {
                            if (widget.latitude != null &&
                                widget.longitude != null)
                              Marker(
                                markerId: MarkerId(
                                  JagaTanahPolygonUtils.geometryId(
                                    'fullscreen_pin',
                                    [
                                      LatLng(
                                        widget.latitude!,
                                        widget.longitude!,
                                      ),
                                    ],
                                  ),
                                ),
                                position: LatLng(
                                  widget.latitude!,
                                  widget.longitude!,
                                ),
                              ),
                          },
                          polygons: hasPolygon
                              ? {
                                  Polygon(
                                    polygonId: PolygonId(
                                      JagaTanahPolygonUtils.geometryId(
                                        'fullscreen_polygon',
                                        widget.polygonPoints,
                                      ),
                                    ),
                                    points: List<LatLng>.of(
                                      widget.polygonPoints,
                                    ),
                                    fillColor: colors.primary.withValues(
                                      alpha: 0.28,
                                    ),
                                    strokeColor: colors.primary,
                                    strokeWidth: 3,
                                  ),
                                }
                              : const {},
                        ),
                ),
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: _buildMapTypeToggle(context, colors),
                ),
                if (showBottomCard)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: SafeArea(
                      top: false,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (hasPolygon)
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 4,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.pentagon_outlined,
                                              size: 16,
                                              color: colors.primaryDark,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${widget.polygonPoints.length} titik sudut',
                                              style: AppTextStyles.labelMedium
                                                  .copyWith(
                                                    color: colors.textPrimary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        if (areaLabel != null)
                                          Text(
                                            'Perkiraan luas: $areaLabel',
                                            style: AppTextStyles.labelMedium
                                                .copyWith(
                                                  color: colors.primaryDark,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                      ],
                                    ),
                                  if (trimmedAddress.isNotEmpty) ...[
                                    if (hasPolygon) const SizedBox(height: 4),
                                    Text(
                                      trimmedAddress,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _fitCamera,
                              tooltip: 'Pusatkan Peta',
                              constraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: colors.primaryLight,
                                foregroundColor: colors.primaryDark,
                              ),
                              icon: const Icon(
                                Icons.center_focus_strong_rounded,
                                size: 20,
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
  }
}

class _FullscreenMapTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Duration duration;
  final VoidCallback onTap;

  const _FullscreenMapTab({
    required this.label,
    required this.isSelected,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: AnimatedDefaultTextStyle(
              duration: duration,
              curve: Curves.easeOutCubic,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? colors.primaryDark : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

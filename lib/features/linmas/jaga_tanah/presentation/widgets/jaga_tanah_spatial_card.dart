import 'dart:async';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_polygon_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef JagaTanahMapPreviewBuilder = Widget Function(
  BuildContext context,
  LatLng center,
);

/// Kartu pratinjau peta untuk memilih atau menampilkan titik lokasi dan polygon bidang tanah.
class JagaTanahSpatialCard extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final List<LatLng> polygonPoints;
  final double height;
  final bool isFetchingLocation;
  final bool showMapTypeToggle;
  final MapType initialMapType;
  final String? errorText;
  final VoidCallback? onOpenMap;
  final ValueChanged<MapType>? onFullscreen;
  final JagaTanahMapPreviewBuilder? mapPreviewBuilder;

  const JagaTanahSpatialCard({
    super.key,
    required this.latitude,
    required this.longitude,
    this.polygonPoints = const [],
    this.height = 176,
    this.isFetchingLocation = false,
    this.showMapTypeToggle = false,
    this.initialMapType = MapType.satellite,
    this.errorText,
    this.onOpenMap,
    this.onFullscreen,
    this.mapPreviewBuilder,
  });

  @override
  State<JagaTanahSpatialCard> createState() => _JagaTanahSpatialCardState();
}

class _JagaTanahSpatialCardState extends State<JagaTanahSpatialCard> {
  final Completer<GoogleMapController> _mapController = Completer();
  late MapType _mapType = widget.initialMapType;

  LatLng? get _center => (widget.latitude != null && widget.longitude != null)
      ? LatLng(widget.latitude!, widget.longitude!)
      : JagaTanahPolygonUtils.centroidOf(widget.polygonPoints);

  @override
  void didUpdateWidget(covariant JagaTanahSpatialCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextCenter = _center;
    final prevCenter =
        (oldWidget.latitude != null && oldWidget.longitude != null)
        ? LatLng(oldWidget.latitude!, oldWidget.longitude!)
        : JagaTanahPolygonUtils.centroidOf(oldWidget.polygonPoints);

    final polygonChanged = !listEquals(
      widget.polygonPoints,
      oldWidget.polygonPoints,
    );
    if ((polygonChanged && widget.polygonPoints.length >= 3) ||
        (nextCenter != null && nextCenter != prevCenter)) {
      _fitCamera();
    }
  }

  Future<void> _fitCamera() async {
    if (!_mapController.isCompleted) return;
    final controller = await _mapController.future;
    if (!mounted) return;

    if (widget.polygonPoints.length >= 3) {
      final boundsPoints = <LatLng>[
        ...widget.polygonPoints,
        if (widget.latitude != null && widget.longitude != null)
          LatLng(widget.latitude!, widget.longitude!),
      ];
      final bounds = JagaTanahPolygonUtils.boundsOf(boundsPoints);
      if (bounds != null) {
        try {
          await controller.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 40),
          );
          return;
        } catch (_) {}
      }
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
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedAlign(
              key: const ValueKey('jaga_tanah_map_type_indicator'),
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
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _SpatialMapTypeTab(
                label: 'Peta Default',
                isSelected: !isSatellite,
                duration: duration,
                onTap: () => setState(() => _mapType = MapType.normal),
              ),
              _SpatialMapTypeTab(
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
    final isEditable = widget.onOpenMap != null;
    final hasReadOnlyFullscreen = !isEditable && widget.onFullscreen != null && center != null;
    final VoidCallback? mapTapAction = isEditable
        ? widget.onOpenMap
        : (hasReadOnlyFullscreen ? () => widget.onFullscreen!(_mapType) : null);
    final hasPolygon = widget.polygonPoints.length >= 3;
    final areaLabel = hasPolygon
        ? JagaTanahPolygonUtils.formatArea(
            JagaTanahPolygonUtils.calculateAreaSquareMeters(
              widget.polygonPoints,
            ),
          )
        : null;

    final mapContainer = Container(
      key: const ValueKey('jaga_tanah_spatial_map_container'),
      height: widget.height,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.errorText != null ? colors.error : colors.borderStrong,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (center == null)
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: widget.isFetchingLocation
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: colors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Mencari lokasi GPS...',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_location_alt_outlined,
                            color: colors.primaryDark,
                            size: 34,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Belum ada titik lokasi',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ketuk untuk menandai titik di peta',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            )
          else if (widget.mapPreviewBuilder != null)
            widget.mapPreviewBuilder!(context, center)
          else
            AbsorbPointer(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: center, zoom: 17),
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
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                markers: {
                  if (widget.latitude != null && widget.longitude != null)
                    Marker(
                      markerId: MarkerId(
                        JagaTanahPolygonUtils.geometryId('preview_pin', [
                          LatLng(widget.latitude!, widget.longitude!),
                        ]),
                      ),
                      position: LatLng(widget.latitude!, widget.longitude!),
                    ),
                },
                polygons: hasPolygon
                    ? {
                        Polygon(
                          polygonId: PolygonId(
                            JagaTanahPolygonUtils.geometryId(
                              'preview_polygon',
                              widget.polygonPoints,
                            ),
                          ),
                          points: List<LatLng>.of(widget.polygonPoints),
                          fillColor: colors.primary.withValues(alpha: 0.25),
                          strokeColor: colors.primary,
                          strokeWidth: 3,
                        ),
                      }
                    : const {},
              ),
            ),
          if (mapTapAction != null)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: colors.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(10),
                elevation: 2,
                child: IconButton(
                  onPressed: mapTapAction,
                  tooltip: isEditable
                      ? (widget.polygonPoints.isNotEmpty
                            ? 'Ubah Arsiran'
                            : 'Tambahkan Arsiran')
                      : 'Lihat Peta Layar Penuh',
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  icon: Icon(
                    Icons.fullscreen_rounded,
                    color: colors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showMapTypeToggle) ...[
          _buildMapTypeToggle(context, colors),
          const SizedBox(height: 10),
        ],
        if (mapTapAction != null)
          Semantics(
            button: true,
            label: isEditable
                ? 'Buka peta untuk mengubah titik'
                : 'Buka peta layar penuh',
            child: InkWell(
              onTap: mapTapAction,
              borderRadius: BorderRadius.circular(14),
              child: mapContainer,
            ),
          )
        else
          mapContainer,
        if (hasPolygon && areaLabel != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.border),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 4,
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
                    Flexible(
                      child: Text(
                        '${widget.polygonPoints.length} titik sudut',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Perkiraan luas: $areaLabel',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (isEditable) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: widget.onOpenMap,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              backgroundColor: colors.primaryLight,
              foregroundColor: colors.primaryDark,
              side: BorderSide(
                color: colors.primaryDark.withValues(alpha: 0.25),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            icon: Icon(
              widget.polygonPoints.isNotEmpty
                  ? Icons.edit_location_alt_outlined
                  : Icons.add_location_alt_outlined,
              size: 18,
            ),
            label: Text(
              widget.polygonPoints.isNotEmpty
                  ? 'Ubah Arsiran'
                  : 'Tambahkan Arsiran',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: AppTextStyles.bodySmall.copyWith(color: colors.error),
          ),
        ],
      ],
    );
  }
}

class _SpatialMapTypeTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Duration duration;
  final VoidCallback onTap;

  const _SpatialMapTypeTab({
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

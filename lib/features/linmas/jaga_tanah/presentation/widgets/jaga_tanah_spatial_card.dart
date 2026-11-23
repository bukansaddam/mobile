import 'dart:async';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef JagaTanahMapPreviewBuilder = Widget Function(
  BuildContext context,
  LatLng center,
);

/// Kartu pratinjau peta untuk memilih atau menampilkan titik lokasi pada form Jaga Tanahku.
class JagaTanahSpatialCard extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double height;
  final bool isFetchingLocation;
  final String? errorText;
  final VoidCallback? onOpenMap;
  final JagaTanahMapPreviewBuilder? mapPreviewBuilder;

  const JagaTanahSpatialCard({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 176,
    this.isFetchingLocation = false,
    this.errorText,
    this.onOpenMap,
    this.mapPreviewBuilder,
  });

  @override
  State<JagaTanahSpatialCard> createState() => _JagaTanahSpatialCardState();
}

class _JagaTanahSpatialCardState extends State<JagaTanahSpatialCard> {
  final Completer<GoogleMapController> _mapController = Completer();

  LatLng? get _center => (widget.latitude != null && widget.longitude != null)
      ? LatLng(widget.latitude!, widget.longitude!)
      : null;

  @override
  void didUpdateWidget(covariant JagaTanahSpatialCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextCenter = _center;
    final prevCenter =
        (oldWidget.latitude != null && oldWidget.longitude != null)
        ? LatLng(oldWidget.latitude!, oldWidget.longitude!)
        : null;

    if (nextCenter != null &&
        nextCenter != prevCenter &&
        _mapController.isCompleted) {
      _mapController.future.then((controller) {
        if (!mounted) return;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: nextCenter, zoom: 17),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final center = _center;
    final isEditable = widget.onOpenMap != null;

    final mapContainer = Container(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            'Ketuk untuk pilih lokasi di peta',
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
                mapType: MapType.hybrid,
                onMapCreated: (controller) {
                  if (!_mapController.isCompleted) {
                    _mapController.complete(controller);
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
                  Marker(
                    markerId: const MarkerId('preview_pin'),
                    position: center,
                  ),
                },
              ),
            ),
          if (isEditable) ...[
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: colors.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(10),
                elevation: 2,
                child: IconButton(
                  onPressed: widget.onOpenMap,
                  tooltip: 'Pilih lokasi di peta',
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
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        size: 14,
                        color: colors.primaryDark,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          center != null
                              ? 'Ubah titik lokasi'
                              : 'Pilih di peta',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 11,
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Semantics(
            button: true,
            label: 'Buka peta untuk memilih titik lokasi',
            child: InkWell(
              onTap: widget.onOpenMap,
              borderRadius: BorderRadius.circular(14),
              child: mapContainer,
            ),
          )
        else
          mapContainer,
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

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_polygon_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef JagaTanahPolygonMapBuilder = Widget Function(
  BuildContext context, {
  required LatLng initialCenter,
  required List<LatLng> points,
  required int? selectedIndex,
  required ValueChanged<LatLng> onTapPoint,
  required ValueChanged<int> onSelectPoint,
  required void Function(int index, LatLng position) onMovePoint,
});

/// Layar peta fullscreen untuk menandai, menggeser, dan menghapus titik sudut polygon bidang tanah.
class JagaTanahPolygonPickerPage extends StatefulWidget {
  final LatLng? initialCenter;
  final List<LatLng> initialPoints;
  final JagaTanahPolygonMapBuilder? mapBuilder;

  const JagaTanahPolygonPickerPage({
    super.key,
    this.initialCenter,
    this.initialPoints = const [],
    this.mapBuilder,
  });

  static const LatLng _fallbackCenter = LatLng(-6.200000, 106.816666);

  static Future<List<LatLng>?> open(
    BuildContext context, {
    LatLng? initialCenter,
    List<LatLng> initialPoints = const [],
  }) {
    return Navigator.of(context).push<List<LatLng>>(
      MaterialPageRoute(
        builder: (_) => JagaTanahPolygonPickerPage(
          initialCenter: initialCenter,
          initialPoints: initialPoints,
        ),
      ),
    );
  }

  @override
  State<JagaTanahPolygonPickerPage> createState() =>
      _JagaTanahPolygonPickerPageState();
}

typedef _PolygonVertex = ({int id, int rev, LatLng point});

class _JagaTanahPolygonPickerPageState
    extends State<JagaTanahPolygonPickerPage> {
  int _nextVertexId = 0;
  late List<_PolygonVertex> _vertices;
  int? _selectedIndex;
  Map<int, BitmapDescriptor> _vertexIcons = const {};

  List<LatLng> get _points =>
      _vertices.map((vertex) => vertex.point).toList(growable: false);

  @override
  void initState() {
    super.initState();
    _vertices = widget.initialPoints
        .map((point) => (id: _nextVertexId++, rev: 0, point: point))
        .toList();
    if (_vertices.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadVertexIcons());
    }
  }

  Future<void> _loadVertexIcons() async {
    if (!mounted || widget.mapBuilder != null) return;
    final colors = context.appColors;
    final nextIcons = <int, BitmapDescriptor>{};
    for (var i = 0; i < _vertices.length; i++) {
      final isSelected = i == _selectedIndex;
      nextIcons[i] = await JagaTanahPolygonUtils.createNumberedMarkerIcon(
        i + 1,
        fillColor: isSelected ? colors.errorSolid : colors.primary,
        textColor: isSelected ? colors.onErrorSolid : colors.onPrimary,
        borderColor: colors.surface,
      );
    }
    if (!mounted) return;
    setState(() => _vertexIcons = nextIcons);
  }

  LatLng get _initialCenter =>
      JagaTanahPolygonUtils.centroidOf(_points) ??
      widget.initialCenter ??
      JagaTanahPolygonPickerPage._fallbackCenter;

  void _addPoint(LatLng point) {
    setState(() {
      _vertices = [..._vertices, (id: _nextVertexId++, rev: 0, point: point)];
      _selectedIndex = null;
    });
    _loadVertexIcons();
  }

  void _selectPoint(int index) {
    if (index < 0 || index >= _vertices.length) return;
    setState(() {
      _selectedIndex = _selectedIndex == index ? null : index;
    });
    _loadVertexIcons();
  }

  void _movePoint(int index, LatLng nextPosition, {bool commit = false}) {
    if (index < 0 || index >= _vertices.length) return;
    final current = _vertices[index];
    final updated = List<_PolygonVertex>.of(_vertices);
    updated[index] = (
      id: current.id,
      rev: commit ? current.rev + 1 : current.rev,
      point: nextPosition,
    );
    setState(() {
      _vertices = updated;
    });
  }

  void _removePoint(int index) {
    if (index < 0 || index >= _vertices.length) return;
    final updated = List<_PolygonVertex>.of(_vertices)..removeAt(index);
    setState(() {
      _vertices = updated;
      _selectedIndex = null;
    });
    _loadVertexIcons();
  }

  void _undoPoint() {
    if (_vertices.isEmpty) return;
    setState(() {
      _vertices = _vertices.sublist(0, _vertices.length - 1);
      _selectedIndex = null;
    });
    _loadVertexIcons();
  }

  void _resetPoints() {
    if (_vertices.isEmpty) return;
    setState(() {
      _vertices = const [];
      _selectedIndex = null;
      _vertexIcons = const {};
    });
  }

  void _save() {
    if (_vertices.length < 3) return;
    Navigator.of(context).pop(List<LatLng>.unmodifiable(_points));
  }

  String _guidanceText() {
    final count = _vertices.length;
    if (count == 0) {
      return 'Ketuk peta untuk menandai titik sudut pertama';
    }
    if (count < 3) {
      return 'Tambah ${3 - count} titik lagi. Tahan & geser titik untuk pindah, ketuk titik untuk hapus.';
    }
    return 'Ketuk titik untuk hapus, tahan & geser titik untuk memindahkan posisi.';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final canSave = _points.length >= 3;
    final areaSquareMeters = JagaTanahPolygonUtils.calculateAreaSquareMeters(
      _points,
    );
    final areaLabel = JagaTanahPolygonUtils.formatArea(areaSquareMeters);
    final selectedIdx =
        (_selectedIndex != null && _selectedIndex! < _points.length)
        ? _selectedIndex
        : null;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppPageBar(title: 'Tandai Bidang Tanah'),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (widget.mapBuilder != null)
                  widget.mapBuilder!(
                    context,
                    initialCenter: _initialCenter,
                    points: _points,
                    selectedIndex: selectedIdx,
                    onTapPoint: _addPoint,
                    onSelectPoint: _selectPoint,
                    onMovePoint: (index, pos) =>
                        _movePoint(index, pos, commit: true),
                  )
                else
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialCenter,
                      zoom: 17,
                    ),
                    mapType: MapType.satellite,
                    style: JagaTanahPolygonUtils.cleanMapStyle,
                    onTap: _addPoint,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    compassEnabled: true,
                    mapToolbarEnabled: false,
                    markers: {
                      for (var i = 0; i < _vertices.length; i++)
                        Marker(
                          markerId: MarkerId(
                            'polygon_vertex_${_vertices[i].id}_r${_vertices[i].rev}_n${i}_${i == selectedIdx ? 1 : 0}_${_vertexIcons[i] != null ? 1 : 0}',
                          ),
                          position: _vertices[i].point,
                          anchor: const Offset(0.5, 0.5),
                          draggable: true,
                          consumeTapEvents: true,
                          onTap: () => _selectPoint(i),
                          onDrag: (nextPos) => _movePoint(i, nextPos),
                          onDragEnd: (nextPos) =>
                              _movePoint(i, nextPos, commit: true),
                          icon:
                              _vertexIcons[i] ?? BitmapDescriptor.defaultMarker,
                        ),
                    },
                    polylines: _points.length == 2
                        ? {
                            Polyline(
                              polylineId: PolylineId(
                                JagaTanahPolygonUtils.geometryId(
                                  'polygon_draft_line',
                                  _points,
                                ),
                              ),
                              points: List<LatLng>.of(_points),
                              color: colors.primary,
                              width: 3,
                            ),
                          }
                        : const {},
                    polygons: canSave
                        ? {
                            Polygon(
                              polygonId: PolygonId(
                                JagaTanahPolygonUtils.geometryId(
                                  'polygon_draft_area',
                                  _points,
                                ),
                              ),
                              points: List<LatLng>.of(_points),
                              fillColor: colors.primary.withValues(alpha: 0.25),
                              strokeColor: colors.primary,
                              strokeWidth: 3,
                            ),
                          }
                        : const {},
                  ),
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.borderStrong),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            canSave
                                ? Icons.pentagon_outlined
                                : Icons.touch_app_outlined,
                            size: 18,
                            color: colors.primaryDark,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _guidanceText(),
                              style: AppTextStyles.labelMedium.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
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
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedIdx != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.errorLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.errorBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Titik ${selectedIdx + 1} dipilih',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: colors.errorDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  JagaTanahPolygonUtils.formatCoordinate(
                                    _points[selectedIdx],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _removePoint(selectedIdx),
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: colors.error,
                            ),
                            label: Text(
                              'Hapus Titik',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: colors.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Text(
                        '${_points.length} titik sudut',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        canSave
                            ? 'Perkiraan luas: $areaLabel'
                            : 'Minimal 3 titik untuk simpan',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: canSave
                              ? colors.primaryDark
                              : colors.textSecondary,
                          fontWeight: canSave
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _points.isEmpty ? null : _undoPoint,
                          icon: const Icon(Icons.undo_rounded, size: 18),
                          label: const Text('Undo'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            foregroundColor: colors.textPrimary,
                            side: BorderSide(color: colors.borderStrong),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _points.isEmpty ? null : _resetPoints,
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                          ),
                          label: const Text('Reset'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            foregroundColor: colors.error,
                            side: BorderSide(
                              color: _points.isEmpty
                                  ? colors.border
                                  : colors.errorBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: canSave ? _save : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      disabledBackgroundColor: colors.primary.withValues(
                        alpha: 0.4,
                      ),
                      disabledForegroundColor: colors.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Simpan Bidang',
                      style: AppTextStyles.button.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

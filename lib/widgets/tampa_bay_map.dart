import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector4;
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Data model for a sighting marker placed on the map.
// ---------------------------------------------------------------------------
class MapMarker {
  final String id;
  final double lat;
  final double lng;
  final Color color;
  final String label;

  const MapMarker({
    required this.id,
    required this.lat,
    required this.lng,
    this.color = AppColors.bioTeal,
    this.label = '',
  });
}

// ---------------------------------------------------------------------------
// TampaBayMap  -- a fully custom-painted, interactive map of the Tampa Bay
// region with proper Mercator projection that preserves aspect ratio.
// ---------------------------------------------------------------------------
class TampaBayMap extends StatefulWidget {
  final List<MapMarker> markers;
  final double? userLat;
  final double? userLng;
  final void Function(String markerId)? onMarkerTap;

  const TampaBayMap({
    super.key,
    required this.markers,
    this.userLat,
    this.userLng,
    this.onMarkerTap,
  });

  @override
  State<TampaBayMap> createState() => _TampaBayMapState();
}

class _TampaBayMapState extends State<TampaBayMap>
    with TickerProviderStateMixin {
  late AnimationController _sonarController;
  late AnimationController _pulseController;

  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _sonarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sonarController.dispose();
    _pulseController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details, Size size) {
    if (widget.onMarkerTap == null) return;
    final tapPos = details.localPosition;
    final Matrix4 inv = Matrix4.copy(_transformController.value)..invert();
    final Vector4 v = inv.transform(Vector4(tapPos.dx, tapPos.dy, 0, 1));
    final transformed = Offset(v.x, v.y);

    const hitRadius = 24.0;
    final mapper = _CoordMapper(size);
    for (final m in widget.markers) {
      final mPos = mapper.latLngToPixel(m.lat, m.lng);
      if ((mPos - transformed).distance <= hitRadius) {
        widget.onMarkerTap!(m.id);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = max(constraints.maxHeight, 400.0);
      return GestureDetector(
        onTapDown: (d) => _handleTapDown(d, Size(width, height)),
        child: InteractiveViewer(
          transformationController: _transformController,
          minScale: 1.0,
          maxScale: 4.0,
          boundaryMargin: const EdgeInsets.all(80),
          child: SizedBox(
            width: width,
            height: height,
            child: AnimatedBuilder(
              animation: Listenable.merge([_sonarController, _pulseController]),
              builder: (context, _) {
                return CustomPaint(
                  size: Size(width, height),
                  painter: _TampaBayPainter(
                    markers: widget.markers,
                    userLat: widget.userLat,
                    userLng: widget.userLng,
                    sonarPhase: _sonarController.value,
                    pulsePhase: _pulseController.value,
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Coordinate mapper -- equirectangular projection with cos(lat) correction.
// Uniform scaling preserves geographic proportions on any aspect ratio.
// ---------------------------------------------------------------------------
class _CoordMapper {
  static const double north = 28.15;
  static const double south = 27.30;
  static const double west = -82.85;
  static const double east = -82.20;

  // cos(centerLat) corrects longitude degrees to match latitude degrees
  static final double _cosLat = cos((north + south) / 2 * pi / 180);

  // Projected dimensions in consistent units (degrees-of-latitude equivalent)
  static final double _projW = (east - west) * _cosLat; // ~0.575
  static final double _projH = north - south;            // 0.85

  final double _scale;
  final double _offsetX;
  final double _offsetY;
  final Size size;

  static const double _padding = 20.0;

  _CoordMapper(this.size)
      : _scale = _computeScale(size),
        _offsetX = _computeOffsetX(size),
        _offsetY = _computeOffsetY(size);

  static double _computeScale(Size size) {
    final usableW = size.width - _padding * 2;
    final usableH = size.height - _padding * 2;
    return min(usableW / _projW, usableH / _projH);
  }

  static double _computeOffsetX(Size size) {
    final usableW = size.width - _padding * 2;
    final scale = _computeScale(size);
    final mapW = _projW * scale;
    return _padding + (usableW - mapW) / 2;
  }

  static double _computeOffsetY(Size size) {
    final usableH = size.height - _padding * 2;
    final scale = _computeScale(size);
    final mapH = _projH * scale;
    return _padding + (usableH - mapH) / 2;
  }

  Offset latLngToPixel(double lat, double lng) {
    final x = _offsetX + (lng - west) * _cosLat * _scale;
    final y = _offsetY + (north - lat) * _scale;
    return Offset(x, y);
  }

  List<Offset> pathToPixels(List<List<double>> coords) {
    return coords.map((c) => latLngToPixel(c[0], c[1])).toList();
  }
}

// ---------------------------------------------------------------------------
// The painter that does all the heavy lifting.
// ---------------------------------------------------------------------------
class _TampaBayPainter extends CustomPainter {
  final List<MapMarker> markers;
  final double? userLat;
  final double? userLng;
  final double sonarPhase;
  final double pulsePhase;

  _TampaBayPainter({
    required this.markers,
    this.userLat,
    this.userLng,
    required this.sonarPhase,
    required this.pulsePhase,
  });

  static const Color _waterColor = Color(0xFF0D1F3C);
  static const Color _waterTint = Color(0xFF0E2340);
  static const Color _landColor = Color(0xFF0A1628);
  static const Color _coastGlow = Color(0xFF00E5CC);
  static const Color _bridgeColor = Color(0xFF00E5CC);
  static const Color _textColor = Color(0xFFC0C8D8);
  static const Color _gridColor = Color(0xFF0F2744);

  @override
  void paint(Canvas canvas, Size size) {
    final mapper = _CoordMapper(size);
    _drawBackground(canvas, size);
    _drawGridLines(canvas, size, mapper);
    _drawWaterBodies(canvas, size, mapper);
    _drawDepthContours(canvas, size, mapper);
    _drawLandMasses(canvas, size, mapper);
    _drawBarrierIslands(canvas, size, mapper);
    _drawRivers(canvas, size, mapper);
    _drawBridges(canvas, size, mapper);
    _drawLabels(canvas, size, mapper);
    _drawWaterLabels(canvas, size, mapper);
    _drawMarkers(canvas, size, mapper);
    _drawUserPosition(canvas, size, mapper);
    _drawLiveMonitoringBadge(canvas, size);
    _drawCompassRose(canvas, size);
    _drawScaleBar(canvas, size, mapper);
  }

  @override
  bool shouldRepaint(covariant _TampaBayPainter old) => true;

  // ======================================================================
  // BACKGROUND
  // ======================================================================
  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _waterColor);
    final center = Offset(size.width * 0.45, size.height * 0.45);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: Alignment(
            (center.dx / size.width) * 2 - 1,
            (center.dy / size.height) * 2 - 1,
          ),
          radius: 1.2,
          colors: [_waterTint, _waterColor],
        ).createShader(Offset.zero & size),
    );
  }

  // ======================================================================
  // GRID LINES (lat/lng graticule)
  // ======================================================================
  void _drawGridLines(Canvas canvas, Size size, _CoordMapper mapper) {
    final gridPaint = Paint()
      ..color = _gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final gridLabelColor = _gridColor.withAlpha(180);

    // Latitude lines every 0.1°
    for (double lat = 27.3; lat <= 28.2; lat += 0.1) {
      final left = mapper.latLngToPixel(lat, _CoordMapper.west);
      final right = mapper.latLngToPixel(lat, _CoordMapper.east);
      canvas.drawLine(left, right, gridPaint);
      // Label on left edge
      if (lat >= _CoordMapper.south && lat <= _CoordMapper.north) {
        _drawText(canvas, '${lat.toStringAsFixed(1)}°N',
            left.dx + 2, left.dy - 10, 6, gridLabelColor, align: TextAlign.left);
      }
    }

    // Longitude lines every 0.1°
    for (double lng = -82.8; lng <= -82.2; lng += 0.1) {
      final top = mapper.latLngToPixel(_CoordMapper.north, lng);
      final bottom = mapper.latLngToPixel(_CoordMapper.south, lng);
      canvas.drawLine(top, bottom, gridPaint);
      if (lng >= _CoordMapper.west && lng <= _CoordMapper.east) {
        _drawText(canvas, '${lng.toStringAsFixed(1)}°W',
            bottom.dx, bottom.dy + 2, 6, gridLabelColor);
      }
    }
  }

  // ======================================================================
  // WATER BODIES
  // ======================================================================
  void _drawWaterBodies(Canvas canvas, Size size, _CoordMapper mapper) {
    final waterPaint = Paint()
      ..color = const Color(0xFF102A4A)
      ..style = PaintingStyle.fill;

    // Tampa Bay proper + Old Tampa Bay + Hillsborough Bay
    final bayCoords = [
      [27.58, -82.66], [27.58, -82.56],
      [27.62, -82.52], [27.65, -82.49], [27.68, -82.47],
      [27.72, -82.46], [27.76, -82.45], [27.80, -82.44],
      [27.83, -82.44], [27.85, -82.44],
      [27.87, -82.44], [27.89, -82.43], [27.91, -82.42],
      [27.93, -82.41], [27.95, -82.42], [27.96, -82.44],
      [27.965, -82.46],
      [27.96, -82.48], [27.95, -82.50],
      [27.97, -82.52], [27.98, -82.55], [27.975, -82.58],
      [27.97, -82.60], [27.965, -82.62],
      [27.95, -82.63], [27.93, -82.64], [27.91, -82.64],
      [27.89, -82.64], [27.87, -82.64],
      [27.85, -82.64], [27.83, -82.63], [27.80, -82.63],
      [27.78, -82.63], [27.75, -82.64],
      [27.72, -82.64], [27.70, -82.65],
      [27.68, -82.65], [27.65, -82.66],
      [27.62, -82.66], [27.58, -82.66],
    ];
    _drawFilledPath(canvas, mapper, bayCoords, waterPaint);

    // Boca Ciega Bay (between barrier islands and Pinellas)
    final bocaCiega = [
      [27.85, -82.78], [27.83, -82.78], [27.81, -82.78],
      [27.79, -82.78], [27.77, -82.78], [27.75, -82.77],
      [27.73, -82.76], [27.71, -82.75],
      [27.71, -82.73], [27.73, -82.74], [27.75, -82.75],
      [27.77, -82.76], [27.79, -82.76], [27.81, -82.76],
      [27.83, -82.77], [27.85, -82.77],
    ];
    _drawFilledPath(canvas, mapper, bocaCiega, waterPaint);

    // Clearwater Harbor
    final clearwaterHarbor = [
      [27.98, -82.80], [27.97, -82.80], [27.96, -82.80],
      [27.95, -82.80], [27.94, -82.80],
      [27.94, -82.79], [27.95, -82.79], [27.96, -82.79],
      [27.97, -82.79], [27.98, -82.79],
    ];
    _drawFilledPath(canvas, mapper, clearwaterHarbor, waterPaint);

    // Sarasota Bay
    final sarasotaBay = [
      [27.45, -82.67], [27.43, -82.66], [27.41, -82.65],
      [27.39, -82.64], [27.37, -82.63], [27.35, -82.62],
      [27.33, -82.61],
      [27.33, -82.58], [27.35, -82.59], [27.37, -82.60],
      [27.39, -82.61], [27.41, -82.62], [27.43, -82.63],
      [27.45, -82.64], [27.47, -82.65], [27.49, -82.66],
      [27.50, -82.67], [27.48, -82.67], [27.45, -82.67],
    ];
    _drawFilledPath(canvas, mapper, sarasotaBay, waterPaint);
  }

  // ======================================================================
  // DEPTH CONTOURS (subtle lines inside water bodies)
  // ======================================================================
  void _drawDepthContours(Canvas canvas, Size size, _CoordMapper mapper) {
    final contourPaint = Paint()
      ..color = const Color(0xFF0A2240).withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Main channel depth contour
    final mainChannel = [
      [27.60, -82.60], [27.65, -82.57], [27.70, -82.55],
      [27.75, -82.54], [27.80, -82.53], [27.85, -82.52],
      [27.88, -82.51], [27.90, -82.50],
    ];
    _drawStrokePath(canvas, mapper, mainChannel, contourPaint);

    // Secondary contour
    final secondary = [
      [27.62, -82.63], [27.67, -82.60], [27.72, -82.58],
      [27.77, -82.56], [27.82, -82.55], [27.86, -82.54],
    ];
    _drawStrokePath(canvas, mapper, secondary, contourPaint);

    // Old Tampa Bay contour
    final oldTampa = [
      [27.92, -82.56], [27.94, -82.58], [27.95, -82.60],
      [27.96, -82.61],
    ];
    _drawStrokePath(canvas, mapper, oldTampa, contourPaint);
  }

  // ======================================================================
  // LAND MASSES
  // ======================================================================
  void _drawLandMasses(Canvas canvas, Size size, _CoordMapper mapper) {
    final landPaint = Paint()
      ..color = _landColor
      ..style = PaintingStyle.fill;

    final coastPaint = Paint()
      ..color = _coastGlow.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final coastGlowPaint = Paint()
      ..color = _coastGlow.withAlpha(25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // ----- Pinellas Peninsula -----
    final pinellas = [
      [28.15, -82.78], [28.12, -82.77], [28.08, -82.76],
      [28.05, -82.76], [28.02, -82.76],
      [28.00, -82.77], [27.98, -82.77], [27.96, -82.78],
      [27.94, -82.79], [27.92, -82.79],
      [27.90, -82.79], [27.88, -82.80], [27.86, -82.80],
      [27.84, -82.80], [27.82, -82.80],
      [27.80, -82.80], [27.78, -82.80], [27.77, -82.80],
      [27.76, -82.79], [27.75, -82.78],
      [27.74, -82.77], [27.73, -82.76],
      [27.70, -82.75], [27.69, -82.74],
      [27.68, -82.73], [27.67, -82.72],
      [27.66, -82.71], [27.65, -82.70],
      [27.66, -82.67], [27.67, -82.66],
      [27.68, -82.66], [27.70, -82.65],
      [27.72, -82.64], [27.74, -82.64],
      [27.76, -82.63], [27.78, -82.63],
      [27.80, -82.63], [27.82, -82.63],
      [27.84, -82.63], [27.86, -82.64],
      [27.87, -82.64],
      [27.88, -82.64], [27.89, -82.64],
      [27.90, -82.64], [27.91, -82.64],
      [27.92, -82.64], [27.93, -82.63],
      [27.94, -82.63], [27.95, -82.62],
      [27.96, -82.62], [27.965, -82.62],
      [27.97, -82.62], [27.975, -82.62],
      [27.98, -82.60], [27.98, -82.58],
      [27.975, -82.56],
      [27.97, -82.55], [27.97, -82.54],
      [27.98, -82.53], [27.99, -82.55],
      [28.00, -82.58], [28.01, -82.62],
      [28.02, -82.65], [28.03, -82.68],
      [28.04, -82.70], [28.05, -82.72],
      [28.06, -82.73], [28.08, -82.74],
      [28.10, -82.75], [28.12, -82.76],
      [28.15, -82.78],
    ];

    // ----- Hillsborough / East Shore / Tampa mainland -----
    final hillsborough = [
      [28.15, -82.55], [28.15, -82.20],
      [28.10, -82.20], [28.05, -82.20], [28.00, -82.20],
      [27.95, -82.20], [27.90, -82.20], [27.85, -82.20],
      [27.80, -82.20],
      [27.75, -82.20], [27.70, -82.20], [27.65, -82.20],
      [27.60, -82.20],
      [27.55, -82.20], [27.50, -82.20], [27.45, -82.20],
      [27.40, -82.20], [27.35, -82.20], [27.30, -82.20],
      [27.30, -82.30], [27.30, -82.40], [27.30, -82.50],
      [27.30, -82.55], [27.32, -82.57], [27.34, -82.58],
      [27.36, -82.59], [27.38, -82.60], [27.40, -82.60],
      [27.42, -82.61], [27.44, -82.61], [27.46, -82.62],
      [27.48, -82.63], [27.50, -82.63],
      [27.52, -82.64], [27.54, -82.65], [27.56, -82.66],
      [27.57, -82.66], [27.58, -82.66],
      [27.58, -82.56], [27.60, -82.53],
      [27.62, -82.50], [27.64, -82.48],
      [27.66, -82.47], [27.68, -82.46],
      [27.70, -82.45], [27.72, -82.44],
      [27.74, -82.43], [27.76, -82.43],
      [27.78, -82.42], [27.80, -82.42],
      [27.82, -82.41], [27.84, -82.41],
      [27.86, -82.41], [27.87, -82.41],
      [27.88, -82.40], [27.89, -82.39],
      [27.90, -82.42], [27.91, -82.43],
      [27.85, -82.38], [27.86, -82.37],
      [27.87, -82.37], [27.88, -82.38],
      [27.89, -82.38],
      [27.90, -82.39], [27.91, -82.40],
      [27.92, -82.40], [27.93, -82.39],
      [27.94, -82.39], [27.95, -82.40],
      [27.95, -82.44], [27.96, -82.46],
      [27.965, -82.47], [27.97, -82.48],
      [27.97, -82.50], [27.975, -82.52],
      [27.98, -82.53], [27.985, -82.54],
      [27.99, -82.55], [28.00, -82.55],
      [28.01, -82.54], [28.02, -82.53],
      [28.03, -82.53], [28.04, -82.53],
      [28.05, -82.54], [28.06, -82.55],
      [28.08, -82.55], [28.10, -82.55],
      [28.12, -82.55], [28.15, -82.55],
    ];

    // MacDill AFB peninsula (distinctive Tampa feature)
    final macdill = [
      [27.87, -82.49], [27.86, -82.50], [27.85, -82.51],
      [27.84, -82.51], [27.83, -82.50],
      [27.82, -82.49], [27.815, -82.48],
      [27.82, -82.47], [27.83, -82.47],
      [27.84, -82.47], [27.85, -82.48],
      [27.86, -82.48], [27.87, -82.49],
    ];

    _drawFilledPath(canvas, mapper, pinellas, landPaint);
    _drawStrokePath(canvas, mapper, pinellas, coastPaint);
    _drawStrokePath(canvas, mapper, pinellas, coastGlowPaint);

    _drawFilledPath(canvas, mapper, hillsborough, landPaint);
    _drawStrokePath(canvas, mapper, hillsborough, coastPaint);
    _drawStrokePath(canvas, mapper, hillsborough, coastGlowPaint);

    _drawFilledPath(canvas, mapper, macdill, landPaint);
    _drawStrokePath(canvas, mapper, macdill, coastPaint);
    _drawStrokePath(canvas, mapper, macdill, coastGlowPaint);
  }

  // ======================================================================
  // BARRIER ISLANDS
  // ======================================================================
  void _drawBarrierIslands(Canvas canvas, Size size, _CoordMapper mapper) {
    final islandPaint = Paint()
      ..color = _landColor
      ..style = PaintingStyle.fill;
    final islandCoast = Paint()
      ..color = _coastGlow.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Clearwater Beach island
    _drawIsland(canvas, mapper, [
      [27.98, -82.83], [27.97, -82.83], [27.96, -82.83],
      [27.95, -82.83], [27.94, -82.83],
      [27.94, -82.82], [27.95, -82.82], [27.96, -82.82],
      [27.97, -82.82], [27.98, -82.82],
    ], islandPaint, islandCoast);

    // Sand Key / Belleair Beach
    _drawIsland(canvas, mapper, [
      [27.93, -82.83], [27.92, -82.83], [27.91, -82.83],
      [27.90, -82.83], [27.89, -82.83],
      [27.89, -82.82], [27.90, -82.82], [27.91, -82.82],
      [27.92, -82.82], [27.93, -82.82],
    ], islandPaint, islandCoast);

    // Indian Rocks Beach / Redington
    _drawIsland(canvas, mapper, [
      [27.88, -82.84], [27.87, -82.84], [27.86, -82.84],
      [27.85, -82.84], [27.84, -82.84],
      [27.84, -82.83], [27.85, -82.83], [27.86, -82.83],
      [27.87, -82.83], [27.88, -82.83],
    ], islandPaint, islandCoast);

    // Treasure Island
    _drawIsland(canvas, mapper, [
      [27.78, -82.82], [27.77, -82.82], [27.765, -82.82],
      [27.765, -82.81], [27.77, -82.81], [27.78, -82.81],
    ], islandPaint, islandCoast);

    // St Pete Beach / Long Key
    _drawIsland(canvas, mapper, [
      [27.75, -82.81], [27.74, -82.81], [27.73, -82.80],
      [27.72, -82.80], [27.71, -82.79],
      [27.71, -82.78], [27.72, -82.79], [27.73, -82.79],
      [27.74, -82.80], [27.75, -82.80],
    ], islandPaint, islandCoast);

    // Honeymoon Island
    _drawIsland(canvas, mapper, [
      [28.08, -82.83], [28.07, -82.84], [28.06, -82.84],
      [28.06, -82.83], [28.07, -82.82], [28.08, -82.82],
    ], islandPaint, islandCoast);

    // Caladesi Island
    _drawIsland(canvas, mapper, [
      [28.04, -82.83], [28.03, -82.83], [28.02, -82.83],
      [28.02, -82.82], [28.03, -82.82], [28.04, -82.82],
    ], islandPaint, islandCoast);

    // Anna Maria Island
    _drawIsland(canvas, mapper, [
      [27.56, -82.73], [27.55, -82.73], [27.54, -82.73],
      [27.53, -82.72], [27.52, -82.72],
      [27.52, -82.71], [27.53, -82.71], [27.54, -82.72],
      [27.55, -82.72], [27.56, -82.72],
    ], islandPaint, islandCoast);

    // Longboat Key (partial)
    _drawIsland(canvas, mapper, [
      [27.51, -82.71], [27.49, -82.71], [27.47, -82.70],
      [27.45, -82.70],
      [27.45, -82.69], [27.47, -82.69], [27.49, -82.70],
      [27.51, -82.70],
    ], islandPaint, islandCoast);

    // Siesta Key
    _drawIsland(canvas, mapper, [
      [27.30, -82.56], [27.31, -82.57], [27.32, -82.57],
      [27.33, -82.57],
      [27.33, -82.56], [27.32, -82.56], [27.31, -82.56],
      [27.30, -82.55],
    ], islandPaint, islandCoast);

    // Davis Islands (Tampa)
    _drawIsland(canvas, mapper, [
      [27.935, -82.46], [27.93, -82.465], [27.925, -82.46],
      [27.925, -82.455], [27.93, -82.45], [27.935, -82.455],
    ], islandPaint, islandCoast);

    // Fort De Soto (south tip)
    _drawIsland(canvas, mapper, [
      [27.63, -82.73], [27.62, -82.74], [27.615, -82.73],
      [27.615, -82.72], [27.62, -82.72], [27.63, -82.72],
    ], islandPaint, islandCoast);
  }

  void _drawIsland(Canvas canvas, _CoordMapper mapper,
      List<List<double>> coords, Paint fill, Paint stroke) {
    final points = mapper.pathToPixels(coords);
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  // ======================================================================
  // RIVERS / WATERWAYS
  // ======================================================================
  void _drawRivers(Canvas canvas, Size size, _CoordMapper mapper) {
    final riverPaint = Paint()
      ..color = const Color(0xFF102A4A).withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Hillsborough River
    final hillsRiver = [
      [27.95, -82.46], [27.96, -82.47], [27.97, -82.48],
      [27.98, -82.49], [27.99, -82.49], [28.00, -82.48],
      [28.01, -82.47], [28.02, -82.46],
    ];
    _drawStrokePath(canvas, mapper, hillsRiver, riverPaint);

    // Alafia River
    final alafia = [
      [27.86, -82.40], [27.87, -82.38], [27.87, -82.35],
      [27.87, -82.33], [27.87, -82.30],
    ];
    _drawStrokePath(canvas, mapper, alafia, riverPaint);

    // Little Manatee River
    final littleManatee = [
      [27.72, -82.44], [27.72, -82.40], [27.72, -82.37],
      [27.73, -82.34],
    ];
    _drawStrokePath(canvas, mapper, littleManatee, riverPaint);

    // Manatee River
    final manateeRiver = [
      [27.50, -82.63], [27.51, -82.60], [27.52, -82.57],
      [27.52, -82.54], [27.52, -82.50],
    ];
    _drawStrokePath(canvas, mapper, manateeRiver, riverPaint);

    // Anclote River (Tarpon Springs)
    final anclote = [
      [28.15, -82.78], [28.16, -82.76], [28.17, -82.74],
    ];
    _drawStrokePath(canvas, mapper, anclote, riverPaint);
  }

  // ======================================================================
  // BRIDGES
  // ======================================================================
  void _drawBridges(Canvas canvas, Size size, _CoordMapper mapper) {
    final bridgePaint = Paint()
      ..color = _bridgeColor.withAlpha(140)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final bridgeGlow = Paint()
      ..color = _bridgeColor.withAlpha(40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    _drawBridge(canvas, mapper, 27.967, -82.62, 27.967, -82.55,
        bridgePaint, bridgeGlow, 'COURTNEY CAMPBELL');
    _drawBridge(canvas, mapper, 27.92, -82.63, 27.92, -82.52,
        bridgePaint, bridgeGlow, 'HOWARD FRANKLAND');
    _drawBridge(canvas, mapper, 27.87, -82.63, 27.87, -82.50,
        bridgePaint, bridgeGlow, 'GANDY BRIDGE');
    _drawBridge(canvas, mapper, 27.62, -82.66, 27.62, -82.56,
        bridgePaint, bridgeGlow, 'SKYWAY');

    // Clearwater Memorial Causeway
    _drawBridge(canvas, mapper, 27.975, -82.79, 27.975, -82.82,
        bridgePaint, bridgeGlow, 'CLEARWATER CSWY');

    // Treasure Island Causeway
    _drawBridge(canvas, mapper, 27.775, -82.75, 27.775, -82.80,
        bridgePaint, bridgeGlow, '');

    // Pinellas Bayway (to St Pete Beach)
    _drawBridge(canvas, mapper, 27.72, -82.71, 27.72, -82.77,
        bridgePaint, bridgeGlow, '');
  }

  void _drawBridge(Canvas canvas, _CoordMapper mapper, double lat1,
      double lng1, double lat2, double lng2, Paint paint, Paint glow,
      String label) {
    final a = mapper.latLngToPixel(lat1, lng1);
    final b = mapper.latLngToPixel(lat2, lng2);
    canvas.drawLine(a, b, glow);
    canvas.drawLine(a, b, paint);

    if (label.isNotEmpty) {
      final midX = (a.dx + b.dx) / 2;
      final midY = (a.dy + b.dy) / 2;
      _drawText(canvas, label, midX, midY - 6, 6, _bridgeColor.withAlpha(100));
    }
  }

  // ======================================================================
  // LABELS (land/city)
  // ======================================================================
  void _drawLabels(Canvas canvas, Size size, _CoordMapper mapper) {
    final majorLabels = <String, List<double>>{
      'TAMPA':             [27.96, -82.46],
      'ST PETERSBURG':     [27.77, -82.68],
      'CLEARWATER':        [27.97, -82.73],
      'BRADENTON':         [27.50, -82.57],
      'SARASOTA':          [27.34, -82.54],
    };

    final minorLabels = <String, List<double>>{
      'St Pete Beach':     [27.73, -82.78],
      'New Port Richey':   [28.12, -82.72],
      'Treasure Island':   [27.77, -82.80],
      'Dunedin':           [28.04, -82.73],
      'Safety Harbor':     [27.99, -82.60],
      'Largo':             [27.91, -82.75],
      'Pinellas Park':     [27.85, -82.70],
      'Tarpon Springs':    [28.14, -82.76],
      'Gulfport':          [27.75, -82.70],
      'Indian Rocks Bch':  [27.86, -82.82],
      'Pass-a-Grille':     [27.69, -82.74],
      'Anna Maria':        [27.53, -82.72],
      'Siesta Key':        [27.27, -82.55],
      'Riverview':         [27.88, -82.33],
      'Brandon':           [27.94, -82.29],
      'Temple Terrace':    [28.03, -82.39],
      'Ybor City':         [27.96, -82.44],
      'Davis Islands':     [27.93, -82.46],
      'MacDill AFB':       [27.84, -82.49],
      'Downtown Tampa':    [27.95, -82.47],
      'Apollo Beach':      [27.77, -82.41],
      'Ruskin':            [27.72, -82.43],
      'Fort De Soto':      [27.62, -82.72],
      'Honeymoon Isl.':    [28.07, -82.83],
      'Caladesi Isl.':     [28.03, -82.84],
      'Palmetto':          [27.52, -82.57],
      'Longboat Key':      [27.48, -82.70],
    };

    for (final entry in majorLabels.entries) {
      final pos = mapper.latLngToPixel(entry.value[0], entry.value[1]);
      _drawText(canvas, entry.key, pos.dx, pos.dy, 9, _textColor);
      // Small dot for city center
      canvas.drawCircle(pos, 2.5, Paint()..color = _textColor.withAlpha(120));
    }

    for (final entry in minorLabels.entries) {
      final pos = mapper.latLngToPixel(entry.value[0], entry.value[1]);
      _drawText(canvas, entry.key, pos.dx, pos.dy, 6.5,
          _textColor.withAlpha(140));
      canvas.drawCircle(pos, 1.5, Paint()..color = _textColor.withAlpha(80));
    }
  }

  // ======================================================================
  // WATER LABELS
  // ======================================================================
  void _drawWaterLabels(Canvas canvas, Size size, _CoordMapper mapper) {
    final waterLabelColor = const Color(0xFF1A4A7A);

    final waterLabels = <String, List<double>>{
      'TAMPA BAY':           [27.80, -82.54],
      'OLD TAMPA BAY':       [27.95, -82.58],
      'HILLSBOROUGH BAY':    [27.90, -82.46],
      'BOCA CIEGA BAY':      [27.79, -82.76],
      'GULF OF MEXICO':      [27.60, -82.82],
      'CLEARWATER HARBOR':   [27.96, -82.81],
      'SARASOTA BAY':        [27.40, -82.64],
    };

    for (final entry in waterLabels.entries) {
      final pos = mapper.latLngToPixel(entry.value[0], entry.value[1]);
      _drawText(canvas, entry.key, pos.dx, pos.dy, 7, waterLabelColor,
          italic: true);
    }
  }

  // ======================================================================
  // SIGHTING MARKERS (animated sonar pings)
  // ======================================================================
  void _drawMarkers(Canvas canvas, Size size, _CoordMapper mapper) {
    for (int i = 0; i < markers.length; i++) {
      final m = markers[i];
      final pos = mapper.latLngToPixel(m.lat, m.lng);
      final phase = (sonarPhase + i * 0.25) % 1.0;

      // Three concentric sonar rings
      for (int ring = 0; ring < 3; ring++) {
        final ringPhase = (phase + ring * 0.33) % 1.0;
        final radius = ringPhase * 28;
        final alpha = ((1.0 - ringPhase) * 120).toInt().clamp(0, 255);
        canvas.drawCircle(
          pos,
          radius,
          Paint()
            ..color = m.color.withAlpha(alpha)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }

      // Center dot
      canvas.drawCircle(pos, 4, Paint()..color = m.color);
      canvas.drawCircle(
        pos,
        4,
        Paint()
          ..color = Colors.white.withAlpha(80)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      if (m.label.isNotEmpty) {
        _drawText(canvas, m.label, pos.dx, pos.dy + 14, 7, m.color);
      }
    }
  }

  // ======================================================================
  // USER POSITION
  // ======================================================================
  void _drawUserPosition(Canvas canvas, Size size, _CoordMapper mapper) {
    if (userLat == null || userLng == null) return;
    final pos = mapper.latLngToPixel(userLat!, userLng!);

    final pulseRadius = 8 + pulsePhase * 10;
    final pulseAlpha = ((1.0 - pulsePhase * 0.6) * 80).toInt().clamp(0, 255);
    canvas.drawCircle(
      pos,
      pulseRadius,
      Paint()
        ..color = Colors.blue.withAlpha(pulseAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.drawCircle(pos, 6, Paint()..color = const Color(0xFF4488FF));
    canvas.drawCircle(
      pos,
      6,
      Paint()
        ..color = Colors.white.withAlpha(180)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    _drawText(canvas, 'YOU ARE HERE', pos.dx, pos.dy - 16, 8,
        const Color(0xFF4488FF));
  }

  // ======================================================================
  // LIVE MONITORING BADGE
  // ======================================================================
  void _drawLiveMonitoringBadge(Canvas canvas, Size size) {
    final badgeX = 12.0;
    final badgeY = 12.0;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(badgeX, badgeY, 150, 26),
      const Radius.circular(4),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF112240));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = _coastGlow.withAlpha(80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final dotAlpha = (sin(sonarPhase * pi * 2) * 0.5 + 0.5);
    canvas.drawCircle(
      Offset(badgeX + 14, badgeY + 13),
      4,
      Paint()..color = Colors.red.withAlpha((dotAlpha * 255).toInt()),
    );

    _drawText(canvas, 'LIVE MONITORING', badgeX + 88, badgeY + 7, 10,
        _coastGlow);
  }

  // ======================================================================
  // COMPASS ROSE
  // ======================================================================
  void _drawCompassRose(Canvas canvas, Size size) {
    final cx = size.width - 40;
    final cy = 50.0;
    final r = 20.0;
    final paint = Paint()
      ..color = _coastGlow.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(Offset(cx, cy), r, paint);
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), paint);
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), paint);

    // Diagonal lines
    final d = r * 0.5;
    canvas.drawLine(Offset(cx - d, cy - d), Offset(cx + d, cy + d),
        paint..strokeWidth = 0.5);
    canvas.drawLine(Offset(cx + d, cy - d), Offset(cx - d, cy + d),
        paint..strokeWidth = 0.5);

    final northArrow = Path()
      ..moveTo(cx, cy - r - 4)
      ..lineTo(cx - 4, cy - r + 6)
      ..lineTo(cx + 4, cy - r + 6)
      ..close();
    canvas.drawPath(northArrow, Paint()..color = _coastGlow.withAlpha(160));

    _drawText(canvas, 'N', cx - 3, cy - r - 14, 8, _coastGlow);
    _drawText(canvas, 'S', cx - 2, cy + r + 4, 7, _coastGlow.withAlpha(100));
    _drawText(canvas, 'E', cx + r + 4, cy - 4, 7, _coastGlow.withAlpha(100));
    _drawText(canvas, 'W', cx - r - 14, cy - 4, 7, _coastGlow.withAlpha(100));
  }

  // ======================================================================
  // SCALE BAR
  // ======================================================================
  void _drawScaleBar(Canvas canvas, Size size, _CoordMapper mapper) {
    // 10km scale bar at bottom-left
    // At ~27.7°N, 1° lat ≈ 111km, so 10km ≈ 0.09°
    final start = mapper.latLngToPixel(27.35, -82.80);
    final end = mapper.latLngToPixel(27.35, -82.70);
    // 0.10° lng at 27.7°N ≈ 10km * cos(27.7°) ≈ 8.85km, close enough for display

    final barY = size.height - 24;
    final barStart = Offset(start.dx, barY);
    final barEnd = Offset(end.dx, barY);

    final barPaint = Paint()
      ..color = _coastGlow.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Main bar
    canvas.drawLine(barStart, barEnd, barPaint);
    // End caps
    canvas.drawLine(
        Offset(barStart.dx, barY - 4), Offset(barStart.dx, barY + 4), barPaint);
    canvas.drawLine(
        Offset(barEnd.dx, barY - 4), Offset(barEnd.dx, barY + 4), barPaint);
    // Midpoint tick
    final mid = (barStart.dx + barEnd.dx) / 2;
    canvas.drawLine(Offset(mid, barY - 3), Offset(mid, barY + 3), barPaint);

    _drawText(canvas, '0', barStart.dx, barY + 6, 6,
        _coastGlow.withAlpha(100));
    _drawText(canvas, '~10 km', barEnd.dx, barY + 6, 6,
        _coastGlow.withAlpha(100));
  }

  // ======================================================================
  // HELPERS
  // ======================================================================
  void _drawFilledPath(
      Canvas canvas, _CoordMapper mapper, List<List<double>> coords,
      Paint paint) {
    final points = mapper.pathToPixels(coords);
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  void _drawStrokePath(
      Canvas canvas, _CoordMapper mapper, List<List<double>> coords,
      Paint paint) {
    if (coords.length < 2) return;
    final points = mapper.pathToPixels(coords);
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, String text, double x, double y,
      double fontSize, Color color,
      {TextAlign align = TextAlign.center, bool italic = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: fontSize,
          color: color,
          letterSpacing: 0.8,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double dx;
    switch (align) {
      case TextAlign.left:
        dx = x;
      case TextAlign.right:
        dx = x - tp.width;
      default:
        dx = x - tp.width / 2;
    }
    tp.paint(canvas, Offset(dx, y));
  }
}

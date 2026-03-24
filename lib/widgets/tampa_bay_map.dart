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
// region designed for the "Robotic Manatees Invade Tampa Bay" satirical site.
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

  // Interactive zoom / pan state
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

  // Detect taps on markers.
  void _handleTapDown(TapDownDetails details, Size size) {
    if (widget.onMarkerTap == null) return;
    final tapPos = details.localPosition;
    // Transform tap position when zoomed/panned
    final Matrix4 inv = Matrix4.copy(_transformController.value)..invert();
    final Vector4 v = inv.transform(Vector4(tapPos.dx, tapPos.dy, 0, 1));
    final transformed = Offset(v.x, v.y);

    const hitRadius = 24.0;
    for (final m in widget.markers) {
      final mPos = _CoordMapper.latLngToPixel(m.lat, m.lng, size);
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
// Coordinate mapper -- converts lat/lng into pixel positions.
// ---------------------------------------------------------------------------
class _CoordMapper {
  static const double north = 28.15;
  static const double south = 27.30;
  static const double west = -82.85;
  static const double east = -82.20;

  static Offset latLngToPixel(double lat, double lng, Size size) {
    final x = (lng - west) / (east - west) * size.width;
    final y = (north - lat) / (north - south) * size.height;
    return Offset(x, y);
  }

  static List<Offset> pathToPixels(List<List<double>> coords, Size size) {
    return coords.map((c) => latLngToPixel(c[0], c[1], size)).toList();
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

  // ---- colours -----------------------------------------------------------
  static const Color _waterColor = Color(0xFF0D1F3C);
  static const Color _waterTint = Color(0xFF0E2340);
  static const Color _landColor = Color(0xFF0A1628);
  static const Color _coastGlow = Color(0xFF00E5CC);
  static const Color _bridgeColor = Color(0xFF00E5CC);
  static const Color _textColor = Color(0xFFC0C8D8);

  // ---- main entry --------------------------------------------------------
  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawWaterBodies(canvas, size);
    _drawLandMasses(canvas, size);
    _drawBarrierIslands(canvas, size);
    _drawBridges(canvas, size);
    _drawLabels(canvas, size);
    _drawMarkers(canvas, size);
    _drawUserPosition(canvas, size);
    _drawLiveMonitoringBadge(canvas, size);
    _drawCompassRose(canvas, size);
  }

  @override
  bool shouldRepaint(covariant _TampaBayPainter old) => true;

  // ======================================================================
  // BACKGROUND
  // ======================================================================
  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = _waterColor,
    );
    // subtle radial gradient for depth
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
  // WATER BODIES (drawn as slightly lighter than background to distinguish)
  // ======================================================================
  void _drawWaterBodies(Canvas canvas, Size size) {
    final waterPaint = Paint()
      ..color = const Color(0xFF102A4A)
      ..style = PaintingStyle.fill;

    // Tampa Bay proper + Old Tampa Bay + Hillsborough Bay combined water area
    final bayCoords = [
      // Mouth of Tampa Bay (south)
      [27.58, -82.66], [27.58, -82.56],
      // East shore moving north
      [27.62, -82.52], [27.65, -82.49], [27.68, -82.47],
      [27.72, -82.46], [27.76, -82.45], [27.80, -82.44],
      [27.83, -82.44], [27.85, -82.44],
      // Into Hillsborough Bay
      [27.87, -82.44], [27.89, -82.43], [27.91, -82.42],
      [27.93, -82.41], [27.95, -82.42], [27.96, -82.44],
      [27.965, -82.46],
      // Across top of Hillsborough Bay toward Old Tampa Bay
      [27.96, -82.48], [27.95, -82.50],
      // Old Tampa Bay north end
      [27.97, -82.52], [27.98, -82.55], [27.975, -82.58],
      [27.97, -82.60], [27.965, -82.62],
      // Down the Pinellas side
      [27.95, -82.63], [27.93, -82.64], [27.91, -82.64],
      [27.89, -82.64], [27.87, -82.64],
      // Boca Ciega Bay area
      [27.85, -82.64], [27.83, -82.63], [27.80, -82.63],
      [27.78, -82.63], [27.75, -82.64],
      [27.72, -82.64], [27.70, -82.65],
      [27.68, -82.65], [27.65, -82.66],
      [27.62, -82.66], [27.58, -82.66],
    ];
    _drawFilledPath(canvas, size, bayCoords, waterPaint);
  }

  // ======================================================================
  // LAND MASSES
  // ======================================================================
  void _drawLandMasses(Canvas canvas, Size size) {
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
      // North end near Tarpon Springs / Dunedin
      [28.15, -82.78], [28.12, -82.77], [28.08, -82.76],
      [28.05, -82.76], [28.02, -82.76],
      // Dunedin / Clearwater area - Gulf side
      [28.00, -82.77], [27.98, -82.77], [27.96, -82.78],
      [27.94, -82.79], [27.92, -82.79],
      // Indian Rocks / Belleair area
      [27.90, -82.79], [27.88, -82.80], [27.86, -82.80],
      [27.84, -82.80], [27.82, -82.80],
      // Seminole / Largo Gulf side
      [27.80, -82.80], [27.78, -82.80], [27.77, -82.80],
      // Treasure Island / St Pete Beach area
      [27.76, -82.79], [27.75, -82.78],
      [27.74, -82.77], [27.73, -82.76],
      // South tip of Pinellas near Pass-a-Grille
      [27.70, -82.75], [27.69, -82.74],
      [27.68, -82.73], [27.67, -82.72],
      // Tip turning east
      [27.66, -82.71], [27.65, -82.70],
      // East side of south Pinellas (bay side)
      [27.66, -82.67], [27.67, -82.66],
      [27.68, -82.66], [27.70, -82.65],
      // Up the bay side through Gulfport / St Pete
      [27.72, -82.64], [27.74, -82.64],
      [27.76, -82.63], [27.78, -82.63],
      [27.80, -82.63], [27.82, -82.63],
      [27.84, -82.63], [27.86, -82.64],
      [27.87, -82.64],
      // Pinellas Point area turning north along bay
      [27.88, -82.64], [27.89, -82.64],
      [27.90, -82.64], [27.91, -82.64],
      [27.92, -82.64], [27.93, -82.63],
      // Safety Harbor / Clearwater bay side
      [27.94, -82.63], [27.95, -82.62],
      [27.96, -82.62], [27.965, -82.62],
      [27.97, -82.62], [27.975, -82.62],
      // North Pinellas bay side (Oldsmar / Safety Harbor)
      [27.98, -82.60], [27.98, -82.58],
      [27.975, -82.56],
      // Courtney Campbell area - slight indent
      [27.97, -82.55], [27.97, -82.54],
      // North along Pinellas coast
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
      // North edge of map
      [28.15, -82.55], [28.15, -82.20],
      // East edge going south
      [28.10, -82.20], [28.05, -82.20], [28.00, -82.20],
      [27.95, -82.20], [27.90, -82.20], [27.85, -82.20],
      [27.80, -82.20],
      // Continuing south along east side
      [27.75, -82.20], [27.70, -82.20], [27.65, -82.20],
      [27.60, -82.20],
      // Manatee / Sarasota coast heading west
      [27.55, -82.20], [27.50, -82.20], [27.45, -82.20],
      [27.40, -82.20], [27.35, -82.20], [27.30, -82.20],
      // South edge
      [27.30, -82.30], [27.30, -82.40], [27.30, -82.50],
      // Sarasota coast heading north
      [27.30, -82.55], [27.32, -82.57], [27.34, -82.58],
      [27.36, -82.59], [27.38, -82.60], [27.40, -82.60],
      [27.42, -82.61], [27.44, -82.61], [27.46, -82.62],
      [27.48, -82.63], [27.50, -82.63],
      // Anna Maria Island / Bradenton coast
      [27.52, -82.64], [27.54, -82.65], [27.56, -82.66],
      // Mouth of Tampa Bay south shore
      [27.57, -82.66], [27.58, -82.66],
      // Now going around inside the bay - east shore
      [27.58, -82.56], [27.60, -82.53],
      [27.62, -82.50], [27.64, -82.48],
      [27.66, -82.47], [27.68, -82.46],
      [27.70, -82.45], [27.72, -82.44],
      [27.74, -82.43], [27.76, -82.43],
      [27.78, -82.42], [27.80, -82.42],
      [27.82, -82.41], [27.84, -82.41],
      // Approaching Hillsborough Bay
      [27.86, -82.41], [27.87, -82.41],
      [27.88, -82.40], [27.89, -82.39],
      // Hillsborough Bay east side - MacDill area
      [27.90, -82.42], [27.91, -82.43],
      // Into Hillsborough Bay - Alafia River area
      [27.85, -82.38], [27.86, -82.37],
      [27.87, -82.37], [27.88, -82.38],
      [27.89, -82.38],
      // Back up around Hillsborough Bay
      [27.90, -82.39], [27.91, -82.40],
      [27.92, -82.40], [27.93, -82.39],
      [27.94, -82.39], [27.95, -82.40],
      // Downtown Tampa area
      [27.95, -82.44], [27.96, -82.46],
      [27.965, -82.47], [27.97, -82.48],
      // Old Tampa Bay east side
      [27.97, -82.50], [27.975, -82.52],
      [27.98, -82.53], [27.985, -82.54],
      // Tampa / Westchase area
      [27.99, -82.55], [28.00, -82.55],
      [28.01, -82.54], [28.02, -82.53],
      [28.03, -82.53], [28.04, -82.53],
      [28.05, -82.54], [28.06, -82.55],
      [28.08, -82.55], [28.10, -82.55],
      [28.12, -82.55], [28.15, -82.55],
    ];

    // Draw Pinellas
    _drawFilledPath(canvas, size, pinellas, landPaint);
    _drawStrokePath(canvas, size, pinellas, coastPaint);
    _drawStrokePath(canvas, size, pinellas, coastGlowPaint);

    // Draw Hillsborough/mainland
    _drawFilledPath(canvas, size, hillsborough, landPaint);
    _drawStrokePath(canvas, size, hillsborough, coastPaint);
    _drawStrokePath(canvas, size, hillsborough, coastGlowPaint);
  }

  // ======================================================================
  // BARRIER ISLANDS
  // ======================================================================
  void _drawBarrierIslands(Canvas canvas, Size size) {
    final islandPaint = Paint()
      ..color = _landColor
      ..style = PaintingStyle.fill;
    final islandCoast = Paint()
      ..color = _coastGlow.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Clearwater Beach island
    _drawIsland(canvas, size, [
      [27.98, -82.83], [27.97, -82.83], [27.96, -82.83],
      [27.95, -82.83], [27.94, -82.83],
      [27.94, -82.82], [27.95, -82.82], [27.96, -82.82],
      [27.97, -82.82], [27.98, -82.82],
    ], islandPaint, islandCoast);

    // Sand Key / Belleair Beach
    _drawIsland(canvas, size, [
      [27.93, -82.83], [27.92, -82.83], [27.91, -82.83],
      [27.90, -82.83], [27.89, -82.83],
      [27.89, -82.82], [27.90, -82.82], [27.91, -82.82],
      [27.92, -82.82], [27.93, -82.82],
    ], islandPaint, islandCoast);

    // Indian Rocks Beach / Redington
    _drawIsland(canvas, size, [
      [27.88, -82.84], [27.87, -82.84], [27.86, -82.84],
      [27.85, -82.84], [27.84, -82.84],
      [27.84, -82.83], [27.85, -82.83], [27.86, -82.83],
      [27.87, -82.83], [27.88, -82.83],
    ], islandPaint, islandCoast);

    // Treasure Island
    _drawIsland(canvas, size, [
      [27.78, -82.82], [27.77, -82.82], [27.765, -82.82],
      [27.765, -82.81], [27.77, -82.81], [27.78, -82.81],
    ], islandPaint, islandCoast);

    // St Pete Beach / Long Key
    _drawIsland(canvas, size, [
      [27.75, -82.81], [27.74, -82.81], [27.73, -82.80],
      [27.72, -82.80], [27.71, -82.79],
      [27.71, -82.78], [27.72, -82.79], [27.73, -82.79],
      [27.74, -82.80], [27.75, -82.80],
    ], islandPaint, islandCoast);

    // Anna Maria Island
    _drawIsland(canvas, size, [
      [27.56, -82.73], [27.55, -82.73], [27.54, -82.73],
      [27.53, -82.72], [27.52, -82.72],
      [27.52, -82.71], [27.53, -82.71], [27.54, -82.72],
      [27.55, -82.72], [27.56, -82.72],
    ], islandPaint, islandCoast);

    // Longboat Key (partial)
    _drawIsland(canvas, size, [
      [27.51, -82.71], [27.49, -82.71], [27.47, -82.70],
      [27.45, -82.70],
      [27.45, -82.69], [27.47, -82.69], [27.49, -82.70],
      [27.51, -82.70],
    ], islandPaint, islandCoast);
  }

  void _drawIsland(Canvas canvas, Size size, List<List<double>> coords,
      Paint fill, Paint stroke) {
    final points = _CoordMapper.pathToPixels(coords, size);
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  // ======================================================================
  // BRIDGES
  // ======================================================================
  void _drawBridges(Canvas canvas, Size size) {
    final bridgePaint = Paint()
      ..color = _bridgeColor.withAlpha(140)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final bridgeGlow = Paint()
      ..color = _bridgeColor.withAlpha(40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Courtney Campbell Causeway
    _drawBridge(canvas, size, 27.967, -82.62, 27.967, -82.55,
        bridgePaint, bridgeGlow, 'COURTNEY CAMPBELL');

    // Howard Frankland Bridge
    _drawBridge(canvas, size, 27.92, -82.63, 27.92, -82.52,
        bridgePaint, bridgeGlow, 'HOWARD FRANKLAND');

    // Gandy Bridge
    _drawBridge(canvas, size, 27.87, -82.63, 27.87, -82.50,
        bridgePaint, bridgeGlow, 'GANDY BRIDGE');

    // Sunshine Skyway Bridge
    _drawBridge(canvas, size, 27.62, -82.66, 27.62, -82.56,
        bridgePaint, bridgeGlow, 'SKYWAY');
  }

  void _drawBridge(Canvas canvas, Size size, double lat1, double lng1,
      double lat2, double lng2, Paint paint, Paint glow, String label) {
    final a = _CoordMapper.latLngToPixel(lat1, lng1, size);
    final b = _CoordMapper.latLngToPixel(lat2, lng2, size);
    canvas.drawLine(a, b, glow);
    canvas.drawLine(a, b, paint);

    // tiny bridge label
    final midX = (a.dx + b.dx) / 2;
    final midY = (a.dy + b.dy) / 2;
    _drawText(canvas, label, midX, midY - 6, 6,
        _bridgeColor.withAlpha(100));
  }

  // ======================================================================
  // LABELS
  // ======================================================================
  void _drawLabels(Canvas canvas, Size size) {
    final labels = <String, List<double>>{
      'TAMPA':             [27.96, -82.46],
      'ST PETERSBURG':     [27.77, -82.68],
      'CLEARWATER':        [27.97, -82.73],
      'ST PETE BEACH':     [27.73, -82.78],
      'BRADENTON':         [27.50, -82.57],
      'SARASOTA':          [27.34, -82.54],
      'NEW PORT RICHEY':   [28.12, -82.72],
      'TREASURE ISLAND':   [27.77, -82.78],
      'DUNEDIN':           [28.04, -82.73],
      'SAFETY HARBOR':     [27.99, -82.60],
      'LARGO':             [27.91, -82.75],
      'PINELLAS PARK':     [27.85, -82.70],
    };

    for (final entry in labels.entries) {
      final pos = _CoordMapper.latLngToPixel(
          entry.value[0], entry.value[1], size);
      _drawText(canvas, entry.key, pos.dx, pos.dy, 8, _textColor);
    }
  }

  // ======================================================================
  // SIGHTING MARKERS (animated sonar pings)
  // ======================================================================
  void _drawMarkers(Canvas canvas, Size size) {
    for (int i = 0; i < markers.length; i++) {
      final m = markers[i];
      final pos = _CoordMapper.latLngToPixel(m.lat, m.lng, size);
      // stagger each marker's phase so they don't all pulse together
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

      // Label if present
      if (m.label.isNotEmpty) {
        _drawText(canvas, m.label, pos.dx, pos.dy + 14, 7, m.color);
      }
    }
  }

  // ======================================================================
  // USER POSITION
  // ======================================================================
  void _drawUserPosition(Canvas canvas, Size size) {
    if (userLat == null || userLng == null) return;
    final pos = _CoordMapper.latLngToPixel(userLat!, userLng!, size);

    // Pulsing outer ring
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

    // Bright blue dot
    canvas.drawCircle(
      pos,
      6,
      Paint()..color = const Color(0xFF4488FF),
    );
    canvas.drawCircle(
      pos,
      6,
      Paint()
        ..color = Colors.white.withAlpha(180)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // "YOU ARE HERE" label
    _drawText(canvas, 'YOU ARE HERE', pos.dx, pos.dy - 16, 8,
        const Color(0xFF4488FF));
  }

  // ======================================================================
  // LIVE MONITORING BADGE
  // ======================================================================
  void _drawLiveMonitoringBadge(Canvas canvas, Size size) {
    final badgeX = 12.0;
    final badgeY = 12.0;

    // Badge background
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(badgeX, badgeY, 150, 26),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFF112240),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = _coastGlow.withAlpha(80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Blinking red dot
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

    // Circle
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // N-S line
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), paint);
    // E-W line
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), paint);

    // North arrow (filled triangle)
    final northArrow = Path()
      ..moveTo(cx, cy - r - 4)
      ..lineTo(cx - 4, cy - r + 6)
      ..lineTo(cx + 4, cy - r + 6)
      ..close();
    canvas.drawPath(
      northArrow,
      Paint()..color = _coastGlow.withAlpha(160),
    );

    // Direction labels
    _drawText(canvas, 'N', cx - 3, cy - r - 14, 8, _coastGlow);
    _drawText(canvas, 'S', cx - 2, cy + r + 4, 7, _coastGlow.withAlpha(100));
    _drawText(canvas, 'E', cx + r + 4, cy - 4, 7, _coastGlow.withAlpha(100));
    _drawText(canvas, 'W', cx - r - 14, cy - 4, 7, _coastGlow.withAlpha(100));
  }

  // ======================================================================
  // HELPERS
  // ======================================================================
  void _drawFilledPath(
      Canvas canvas, Size size, List<List<double>> coords, Paint paint) {
    final points = _CoordMapper.pathToPixels(coords, size);
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  void _drawStrokePath(
      Canvas canvas, Size size, List<List<double>> coords, Paint paint) {
    final points = _CoordMapper.pathToPixels(coords, size);
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, String text, double x, double y,
      double fontSize, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: fontSize,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y));
  }
}

import 'package:flutter/material.dart';
import '../models/emergency_models.dart';
import '../theme/app_theme.dart';

class EvacuationMapPainter extends CustomPainter {
  final SafeZoneLocation selectedZone;
  final bool showHazardZones;
  final double animationProgress;

  EvacuationMapPainter({
    required this.selectedZone,
    required this.showHazardZones,
    this.animationProgress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF3F4F8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      bgPaint,
    );

    // Dibuja manzanas/edificaciones urbanas estilo croquis
    final blockPaint = Paint()
      ..color = const Color(0xFFE2E6EE)
      ..style = PaintingStyle.fill;
    final blockBorder = Paint()
      ..color = const Color(0xFFCBD2DF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final blocks = [
      Rect.fromLTWH(size.width * 0.08, size.height * 0.12, size.width * 0.22, size.height * 0.25),
      Rect.fromLTWH(size.width * 0.38, size.height * 0.12, size.width * 0.24, size.height * 0.25),
      Rect.fromLTWH(size.width * 0.70, size.height * 0.12, size.width * 0.22, size.height * 0.25),
      Rect.fromLTWH(size.width * 0.08, size.height * 0.52, size.width * 0.22, size.height * 0.35),
      Rect.fromLTWH(size.width * 0.38, size.height * 0.52, size.width * 0.24, size.height * 0.35),
      Rect.fromLTWH(size.width * 0.70, size.height * 0.52, size.width * 0.22, size.height * 0.35),
    ];

    for (final rect in blocks) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), blockPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), blockBorder);
    }

    // Calles intermedias
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Calles principales
    canvas.drawLine(Offset(0, size.height * 0.44), Offset(size.width, size.height * 0.44), roadPaint);
    canvas.drawLine(Offset(size.width * 0.34, 0), Offset(size.width * 0.34, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.66, 0), Offset(size.width * 0.66, size.height), roadPaint);

    // Zonas de Peligro (Postes colapsados / Vidrios)
    if (showHazardZones) {
      final hazardPaint = Paint()
        ..color = AppTheme.emergencyRed.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill;
      final hazardBorder = Paint()
        ..color = AppTheme.emergencyRed.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final hazardZone = Rect.fromCircle(
        center: Offset(size.width * 0.50, size.height * 0.44),
        radius: 24,
      );
      canvas.drawCircle(hazardZone.center, 24, hazardPaint);
      canvas.drawCircle(hazardZone.center, 24, hazardBorder);

      // Icono X o alerta
      final xPaint = Paint()
        ..color = AppTheme.emergencyRed
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(hazardZone.center.dx - 6, hazardZone.center.dy - 6),
        Offset(hazardZone.center.dx + 6, hazardZone.center.dy + 6),
        xPaint,
      );
      canvas.drawLine(
        Offset(hazardZone.center.dx + 6, hazardZone.center.dy - 6),
        Offset(hazardZone.center.dx - 6, hazardZone.center.dy + 6),
        xPaint,
      );
    }

    // Ruta de Evacuación Segura
    final routePaint = Paint()
      ..color = AppTheme.primaryBlue
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final coords = selectedZone.routeCoordinates;
    if (coords.isNotEmpty) {
      path.moveTo(coords[0].dx * size.width, coords[0].dy * size.height);
      for (int i = 1; i < coords.length; i++) {
        path.lineTo(coords[i].dx * size.width, coords[i].dy * size.height);
      }
      canvas.drawPath(path, routePaint);
    }

    // Origen: "Mi Casa / Hall"
    final homePoint = Offset(size.width * 0.14, size.height * 0.78);
    final homeBg = Paint()..color = const Color(0xFF1A1C1E);
    canvas.drawCircle(homePoint, 12, homeBg);
    final homeInner = Paint()..color = Colors.white;
    canvas.drawCircle(homePoint, 5, homeInner);

    // Destino: "Punto Seguro"
    final destPoint = Offset(
      coords.isNotEmpty ? coords.last.dx * size.width : size.width * 0.84,
      coords.isNotEmpty ? coords.last.dy * size.height : size.height * 0.22,
    );

    // Halo animado del destino
    final pulsePaint = Paint()
      ..color = AppTheme.successGreen.withValues(alpha: 0.25 * animationProgress)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(destPoint, 24 * animationProgress, pulsePaint);

    final destBg = Paint()..color = AppTheme.successGreen;
    canvas.drawCircle(destPoint, 14, destBg);
    final destInner = Paint()..color = Colors.white;
    canvas.drawCircle(destPoint, 6, destInner);
  }

  @override
  bool shouldRepaint(covariant EvacuationMapPainter oldDelegate) {
    return oldDelegate.selectedZone != selectedZone ||
        oldDelegate.showHazardZones != showHazardZones ||
        oldDelegate.animationProgress != animationProgress;
  }
}

class EvacuationMapInteractiveView extends StatefulWidget {
  final SafeZoneLocation selectedZone;
  final ValueChanged<SafeZoneLocation> onZoneSelected;
  final List<SafeZoneLocation> availableZones;

  const EvacuationMapInteractiveView({
    super.key,
    required this.selectedZone,
    required this.onZoneSelected,
    required this.availableZones,
  });

  @override
  State<EvacuationMapInteractiveView> createState() => _EvacuationMapInteractiveViewState();
}

class _EvacuationMapInteractiveViewState extends State<EvacuationMapInteractiveView>
    with SingleTickerProviderStateMixin {
  bool _showHazardZones = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Selector de Puntos Seguros
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.availableZones.map((zone) {
              final isSel = zone.id == widget.selectedZone.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  avatar: Icon(
                    Icons.park_outlined,
                    size: 16,
                    color: isSel ? Colors.white : AppTheme.primaryBlue,
                  ),
                  label: Text('${zone.name} (${zone.district})'),
                  selected: isSel,
                  selectedColor: AppTheme.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    if (val) widget.onZoneSelected(zone);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),

        // Lienzo Vectorial Interactivo
        Container(
          height: 240,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: EvacuationMapPainter(
                      selectedZone: widget.selectedZone,
                      showHazardZones: _showHazardZones,
                      animationProgress: 0.8 + (_animController.value * 0.4),
                    ),
                  );
                },
              ),

              // Botón flotante para alternar riesgos
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      setState(() {
                        _showHazardZones = !_showHazardZones;
                      });
                    },
                    icon: Icon(
                      _showHazardZones ? Icons.visibility_off : Icons.warning_amber,
                      size: 14,
                      color: _showHazardZones ? AppTheme.emergencyRed : AppTheme.textSecondary,
                    ),
                    label: Text(
                      _showHazardZones ? 'Ocultar Riesgos' : 'Ver Riesgos',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _showHazardZones ? AppTheme.emergencyRed : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              // Leyenda inferior
              Positioned(
                bottom: 8,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: Color(0xFF1A1C1E)),
                          SizedBox(width: 4),
                          Text('Tu Casa', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: AppTheme.primaryBlue),
                          SizedBox(width: 4),
                          Text('Ruta Segura', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: AppTheme.successGreen),
                          SizedBox(width: 4),
                          Text('Punto Seguro', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

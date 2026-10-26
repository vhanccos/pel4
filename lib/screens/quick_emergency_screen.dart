import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/emergency_widgets.dart';

class QuickEmergencyScreen extends StatefulWidget {
  const QuickEmergencyScreen({super.key});

  @override
  State<QuickEmergencyScreen> createState() => _QuickEmergencyScreenState();
}

class _QuickEmergencyScreenState extends State<QuickEmergencyScreen>
    with SingleTickerProviderStateMixin {
  bool _isTorchOn = false;
  bool _isAlarmOn = false;
  int _selectedPhaseIndex = 0; // 0: Durante, 1: Después
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _duringSteps = [
    {
      'tag': 'Paso 1',
      'title': 'Agáchate y Cúbrete',
      'subtitle': 'Bajo mesa resistente o muro portante. Protege cuello y cabeza.',
      'icon': Icons.accessibility_new,
      'color': AppTheme.primaryBlue,
    },
    {
      'tag': 'Paso 2',
      'title': 'Evita escaleras y ascensor',
      'subtitle': 'No corras; espera a que cese el movimiento telúrico.',
      'icon': Icons.block,
      'color': AppTheme.emergencyRed,
    },
    {
      'tag': 'Paso 3',
      'title': 'Aléjate de vidrios y cables',
      'subtitle': 'Cuidado con ventanas, mamparas o repisas con objetos pesados.',
      'icon': Icons.warning_amber_rounded,
      'color': AppTheme.alertDarkAmber,
    },
  ];

  final List<Map<String, dynamic>> _afterSteps = [
    {
      'tag': 'Prioridad 1',
      'title': 'Cerrar gas y electricidad',
      'subtitle': 'Previene fugas, chispas e incendios en el domicilio.',
      'icon': Icons.power_settings_new,
      'color': AppTheme.primaryBlue,
    },
    {
      'tag': 'Prioridad 2',
      'title': 'Toma la mochila sísmica',
      'subtitle': 'Lleva botiquín, agua, radio y documentos esenciales.',
      'icon': Icons.backpack_outlined,
      'color': AppTheme.primaryBlue,
    },
    {
      'tag': 'Prioridad 3',
      'title': 'Evacúa con calma al punto seguro',
      'subtitle': 'Caminar sin correr usando calzado seguro y linterna.',
      'icon': Icons.directions_walk,
      'color': AppTheme.successGreen,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerTorch() {
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isTorchOn
            ? 'Linterna SOS activada (Fondo blanco de máxima visibilidad)'
            : 'Linterna SOS desactivada'),
        duration: const Duration(seconds: 2),
        backgroundColor: _isTorchOn ? AppTheme.alertDarkAmber : AppTheme.textPrimary,
      ),
    );
  }

  void _triggerAlarm() {
    setState(() {
      _isAlarmOn = !_isAlarmOn;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isAlarmOn
            ? 'Silbato SOS activado (Frecuencia de auxilio)'
            : 'Silbato SOS desactivado'),
        duration: const Duration(seconds: 2),
        backgroundColor: _isAlarmOn ? AppTheme.emergencyRed : AppTheme.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Demostración de Stack + Positioned para alertas flotantes y capas
    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= 600;

        return Stack(
          children: [
            // Linterna simulada con fondo de pantalla completa
            if (_isTorchOn)
              Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
              ),

            // Contenido principal
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isExpanded ? 32.0 : 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEmergencyStatusCard(),
                    const SizedBox(height: 16),
                    _buildActionTools(isExpanded),
                    const SizedBox(height: 16),
                    _buildQuickSmsButton(),
                    const SizedBox(height: 20),
                    _buildProtocolPhaseSelector(),
                    const SizedBox(height: 16),
                    _buildProtocolStepsList(),
                    const SizedBox(height: 20),
                    _buildSafePointCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Positioned demostrando control espacial sobre el layout
            Positioned(
              top: 10,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.textPrimary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'OFFLINE NATIVO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmergencyStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.emergencySoftRed,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.emergencyRed.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.9 + (_pulseController.value * 0.2),
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.emergencyRed,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.emergencyRed.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Evento sísmico en curso / Alerta',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppTheme.emergencyDarkRed,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Conserva la calma y busca zona segura interna',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.emergencyDarkRed,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.crisis_alert, color: AppTheme.emergencyRed, size: 28),
        ],
      ),
    );
  }

  Widget _buildActionTools(bool isExpanded) {
    return Row(
      children: [
        Expanded(
          child: EmergencyActionCard(
            icon: _isTorchOn ? Icons.flash_on : Icons.flashlight_on,
            label: _isTorchOn ? 'Linterna Activa' : 'Linterna SOS',
            subtitle: 'Máxima visibilidad',
            backgroundColor: _isTorchOn ? AppTheme.alertAmber : const Color(0xFF262C3D),
            foregroundColor: _isTorchOn ? Colors.black : Colors.white,
            isActive: _isTorchOn,
            onTap: _triggerTorch,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: EmergencyActionCard(
            icon: _isAlarmOn ? Icons.volume_up : Icons.notifications_active,
            label: _isAlarmOn ? 'Detener Alarma' : 'Silbato SOS',
            subtitle: 'Frecuencia de auxilio',
            backgroundColor: _isAlarmOn ? AppTheme.emergencyDarkRed : AppTheme.emergencyRed,
            foregroundColor: Colors.white,
            isActive: _isAlarmOn,
            onTap: _triggerAlarm,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSmsButton() {
    return Material(
      color: AppTheme.primaryBlue,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mensajería SMS 119: "Estoy bien y a salvo tras el sismo" preparada.'),
              backgroundColor: AppTheme.primaryBlue,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.sms_outlined, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SMS 119: Estoy a Salvo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Un toque para notificar a la red familiar',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtocolPhaseSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPhaseButton(
              title: 'Durante el Sismo',
              icon: Icons.shield,
              isSelected: _selectedPhaseIndex == 0,
              onTap: () => setState(() => _selectedPhaseIndex = 0),
            ),
          ),
          Expanded(
            child: _buildPhaseButton(
              title: 'Después del Sismo',
              icon: Icons.check_circle_outline,
              isSelected: _selectedPhaseIndex == 1,
              onTap: () => setState(() => _selectedPhaseIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolStepsList() {
    final steps = _selectedPhaseIndex == 0 ? _duringSteps : _afterSteps;

    return Column(
      children: steps.map((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (step['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(step['icon'] as IconData, color: step['color'] as Color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (step['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        step['tag'] as String,
                        style: TextStyle(
                          color: step['color'] as Color,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step['subtitle'] as String,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSafePointCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.softBlueBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on, color: AppTheme.primaryBlue, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Punto Seguro: Parque Zonal',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'A 180 m · Zona demarcada libre de cables',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppTheme.primaryBlue),
                      SizedBox(width: 8),
                      Text('Punto Seguro Local'),
                    ],
                  ),
                  content: const Text(
                    'Parque Zonal a 180 metros.\n\nRuta: Salida por Pasaje Los Pinos hacia explanada principal. Libre de postes y vidrios.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.chevron_right, color: AppTheme.primaryBlue),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/emergency_models.dart';
import '../theme/app_theme.dart';

class EmergencyDirectoryScreen extends StatefulWidget {
  const EmergencyDirectoryScreen({super.key});

  @override
  State<EmergencyDirectoryScreen> createState() => _EmergencyDirectoryScreenState();
}

class _EmergencyDirectoryScreenState extends State<EmergencyDirectoryScreen> {
  int _selectedTab = 0; // 0: Red Familiar (SMS 119), 1: Centrales Nacionales
  final TextEditingController _noteController = TextEditingController(
    text: 'Alergias familiares: Ninguna conocida.\nContacto alterno en Lima: Tío Roberto (987-654-321).\nLlave de paso de agua: Patio trasero.',
  );

  final List<EmergencyContact> _nationalContacts = [
    EmergencyContact(
      number: '116',
      title: 'Bomberos Voluntarios del Perú',
      description: 'Incendios, rescate en estructuras colapsadas y fugas de gas',
      category: 'Rescate',
      icon: Icons.local_fire_department,
      badgeColor: AppTheme.emergencyRed,
    ),
    EmergencyContact(
      number: '105',
      title: 'Policía Nacional del Perú (PNP)',
      description: 'Seguridad ciudadana, orden público y patrullaje de emergencia',
      category: 'Seguridad',
      icon: Icons.local_police,
      badgeColor: AppTheme.primaryBlue,
    ),
    EmergencyContact(
      number: '106',
      title: 'SAMU - Minsa',
      description: 'Atención médica de urgencia, ambulancias y soporte vital',
      category: 'Salud',
      icon: Icons.medical_services,
      badgeColor: AppTheme.successGreen,
    ),
    EmergencyContact(
      number: '115',
      title: 'INDECI / Cruz Roja',
      description: 'Defensa civil, evaluación de daños y primeros auxilios',
      category: 'Defensa Civil',
      icon: Icons.health_and_safety,
      badgeColor: Colors.deepOrange,
    ),
  ];

  final List<Map<String, String>> _additionalHelplines = [
    {
      'title': 'Línea 100 - Ayuda y Protección Familiar',
      'number': '100',
      'detail': 'Protección ante violencia y soporte a personas vulnerables (24h)',
    },
    {
      'title': 'Infosalud Minsa',
      'number': '113',
      'detail': 'Orientación médica telefónica y triaje de emergencias sanitarias',
    },
  ];

  void _copyToClipboard(String number, String title) {
    Clipboard.setData(ClipboardData(text: number));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Número $number ($title) copiado al portapapeles.'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _simulateCall(String number, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk, color: AppTheme.primaryBlue),
            const SizedBox(width: 8),
            Text('Llamar al $number'),
          ],
        ),
        content: Text(
          'Simulando marcado rápido sin internet hacia "$title" ($number).\n\nEn un teléfono físico real se abre la app nativa de llamadas gracias a la directiva tel:$number.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Iniciando llamada telefónica hacia $number...'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
            child: const Text('Marcar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= 600;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Encabezado Superior
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExpanded ? 32.0 : 16.0,
                    vertical: 14.0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
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
                                color: AppTheme.primaryBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.contact_phone, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Directorio de Auxilio Inmediato',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Líneas críticas operativas sin conexión ni saldo',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Segmented Controller (Row + Expanded)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTabButton(
                                title: 'Familia (SMS 119)',
                                icon: Icons.family_restroom,
                                isSelected: _selectedTab == 0,
                                onTap: () => setState(() => _selectedTab = 0),
                              ),
                            ),
                            Expanded(
                              child: _buildTabButton(
                                title: 'Centrales Nacionales',
                                icon: Icons.emergency,
                                isSelected: _selectedTab == 1,
                                onTap: () => setState(() => _selectedTab = 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenido principal de la lista
                Expanded(
                  child: _selectedTab == 0
                      ? _buildFamilyTab(isExpanded)
                      : _buildNationalContactsList(isExpanded),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
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
              size: 16,
              color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 12,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyTab(bool isExpanded) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? 32.0 : 16.0,
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Contacto Seguro fuera de zona sísmica
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Contacto Seguro en Provincia',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFFDBE1FF),
                        child: Text(
                          'R',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tía Rosa Gómez',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Arequipa / Camaná · Línea fija satelital',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Plantilla SMS 119 lista: "ESTOY BIEN".'),
                                backgroundColor: AppTheme.primaryBlue,
                              ),
                            );
                          },
                          icon: const Icon(Icons.sms, size: 18),
                          label: const Text('SMS 119'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _simulateCall('054-284192', 'Tía Rosa Gómez'),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text('Llamar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Protocolo Oficial del 119
          Card(
            color: AppTheme.softBlueBackground,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Protocolo Oficial INDECI: 119',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Las llamadas de voz colapsan las redes. El 119 almacena y retransmite mensajes de voz sin saturar las antenas.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  _build119Step(
                    num: '1',
                    action: 'Grabar Estado de Salud',
                    tag: 'Salida',
                    desc: 'Marcar 119 + 1 + Número celular del familiar para dejar mensaje de 1 min.',
                  ),
                  const SizedBox(height: 8),
                  _build119Step(
                    num: '2',
                    action: 'Escuchar Mensajes Familiares',
                    tag: 'Entrada',
                    desc: 'Marcar 119 + 2 + Número celular para oír los mensajes que dejaron para ti.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nota médica y familiar offline
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nota Familiar y Médica (Guardada en Dispositivo)',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.02),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.save_outlined, size: 14, color: AppTheme.successGreen),
                      SizedBox(width: 4),
                      Text(
                        'Disponible offline ante cortes de energía',
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _build119Step({
    required String num,
    required String action,
    required String tag,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppTheme.primaryBlue,
          child: Text(
            num,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    action,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Requerimiento explícito: ListView.separated para directorio de auxilio
  Widget _buildNationalContactsList(bool isExpanded) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? 32.0 : 16.0,
        vertical: 8.0,
      ),
      itemCount: _nationalContacts.length + 1, // +1 for the additional helplines card
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index < _nationalContacts.length) {
          final c = _nationalContacts[index];

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Número destacado con badge temático
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: c.badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      c.number,
                      style: TextStyle(
                        color: c.badgeColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Información central usando Expanded y Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              c.category,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        c.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Botones rápidos de Copia y Marcado
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20, color: AppTheme.textSecondary),
                      tooltip: 'Copiar número',
                      onPressed: () => _copyToClipboard(c.number, c.title),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: c.badgeColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.call, size: 16, color: Colors.white),
                      ),
                      tooltip: 'Llamada rápida',
                      onPressed: () => _simulateCall(c.number, c.title),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        // Additional Helplines Footer Card
        return Card(
          color: AppTheme.softBlueBackground,
          margin: const EdgeInsets.only(top: 8, bottom: 32),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.support_agent, color: AppTheme.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Líneas Telefónicas de Soporte 24 Horas',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ..._additionalHelplines.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                item['detail']!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _simulateCall(item['number']!, item['title']!),
                          icon: const Icon(Icons.phone, size: 16),
                          label: Text(
                            item['number']!,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

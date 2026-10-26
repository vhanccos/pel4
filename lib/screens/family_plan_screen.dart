import 'package:flutter/material.dart';
import '../models/emergency_models.dart';
import '../theme/app_theme.dart';

class FamilyPlanScreen extends StatefulWidget {
  const FamilyPlanScreen({super.key});

  @override
  State<FamilyPlanScreen> createState() => _FamilyPlanScreenState();
}

class _FamilyPlanScreenState extends State<FamilyPlanScreen> {
  int _selectedTab = 0; // 0: Puntos Seguros, 1: Roles Familiares, 2: Mascotas

  final List<FamilyMember> _members = [
    FamilyMember(
      id: 'm1',
      name: 'Carlos (Papá)',
      role: 'Responsable de Ruta',
      initial: 'C',
      tag: 'Frente',
      taskDescription:
          '1. Toma la mochila sísmica del hall.\n2. Abre la puerta principal y fíjala para evitar bloqueos por deformación.',
      avatarBgColor: const Color(0xFFDBE1FF),
      avatarTextColor: AppTheme.primaryBlue,
    ),
    FamilyMember(
      id: 'm2',
      name: 'Elena (Mamá)',
      role: 'Corte de Servicios',
      initial: 'E',
      tag: 'Seguridad',
      taskDescription:
          '1. Cierra la válvula de gas en cocina.\n2. Baja la llave termoeléctrica principal del pasillo.',
      avatarBgColor: AppTheme.emergencySoftRed,
      avatarTextColor: AppTheme.emergencyRed,
    ),
    FamilyMember(
      id: 'm3',
      name: 'Sofía (Hija)',
      role: 'Cuidado de Mascota',
      initial: 'S',
      tag: 'Acompañamiento',
      taskDescription:
          '1. Sujeta el arnés y correa de Bobby.\n2. Guía al perro con calma hacia el exterior sin correr.',
      avatarBgColor: const Color(0xFFFFF0D4),
      avatarTextColor: AppTheme.alertDarkAmber,
    ),
  ];

  void _addMember() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar Responsable'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre (ej. Hermano Luis)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Rol asignado (ej. Botiquín)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(labelText: 'Tareas en los primeros 60s'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  _members.add(
                    FamilyMember(
                      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameController.text.trim(),
                      role: roleController.text.trim().isNotEmpty
                          ? roleController.text.trim()
                          : 'Asistencia General',
                      initial: nameController.text.trim()[0].toUpperCase(),
                      tag: 'Familia',
                      taskDescription: taskController.text.trim().isNotEmpty
                          ? taskController.text.trim()
                          : 'Asistir con evacuación ordenada.',
                      avatarBgColor: const Color(0xFFDBE1FF),
                      avatarTextColor: AppTheme.primaryBlue,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteMember(String id) {
    setState(() {
      _members.removeWhere((m) => m.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= 600;

        return Scaffold(
          floatingActionButton: _selectedTab == 1
              ? FloatingActionButton.extended(
                  onPressed: _addMember,
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Nuevo Responsable'),
                )
              : null,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? 32.0 : 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Encabezado con estado del plan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plan Familiar Sísmico',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Protocolo de los primeros 60 segundos',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.softBlueBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, size: 16, color: AppTheme.primaryBlue),
                            SizedBox(width: 4),
                            Text(
                              'Plan Activo',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Selector de Pestañas del Plan (Row + Expanded)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSubTab(
                            title: 'Puntos Seguros',
                            icon: Icons.pin_drop_outlined,
                            index: 0,
                          ),
                        ),
                        Expanded(
                          child: _buildSubTab(
                            title: 'Roles (${_members.length})',
                            icon: Icons.people_outline,
                            index: 1,
                          ),
                        ),
                        Expanded(
                          child: _buildSubTab(
                            title: 'Mascotas',
                            icon: Icons.pets_outlined,
                            index: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Contenido según pestaña
                  if (_selectedTab == 0) _buildSafePointsTab(isExpanded),
                  if (_selectedTab == 1) _buildRolesTab(),
                  if (_selectedTab == 2) _buildPetsTab(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubTab({
    required String title,
    required IconData icon,
    required int index,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
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
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12,
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafePointsTab(bool isExpanded) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tarjeta Principal de Punto Seguro
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner visual con Stack + Positioned
              Container(
                height: 120,
                color: const Color(0xFFE2E7FF),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(Icons.park, size: 70, color: Color(0xFF86A5F7)),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          '120 metros',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt, color: Colors.amber, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Zona Libre de Cables',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
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
                        'Punto 1 (Principal)',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Parque Andrés Avelino Cáceres',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ruta segura: Jr. Los Pinos → Pasaje San Agustín → Explanada Central.',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 14),

                    // Fila con métricas usando Row, Expanded, Flexible
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.timer_outlined, size: 18, color: AppTheme.primaryBlue),
                                SizedBox(width: 6),
                                Text(
                                  '~ 2 minutos a pie',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.groups_outlined, size: 18, color: AppTheme.primaryBlue),
                                SizedBox(width: 6),
                                Text(
                                  'Cap. +450 pers.',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Punto de Encuentro Alternativo
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sports_soccer, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Cancha Municipal',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Alternativo',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        'A 350 m · Si el parque principal presenta bloqueos',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Recomendación INDECI
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppTheme.alertDarkAmber, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'En sismos fuertes, reunirse primero en el patio interno antes de salir a la vía pública.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.alertDarkAmber,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRolesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Asignación de Responsabilidades:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        const Text(
          'Primeros 60 segundos: cada integrante tiene una función clara sin duplicar esfuerzos.',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 14),

        // Lista de miembros con Card y Row/Column
        ..._members.map((member) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: member.avatarBgColor,
                        child: Text(
                          member.initial,
                          style: TextStyle(
                            color: member.avatarTextColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              member.role,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: member.avatarBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          member.tag,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: member.avatarTextColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                        onPressed: () => _deleteMember(member.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      member.taskDescription,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPetsTab() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.softBlueBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.pets, color: AppTheme.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Bobby (Golden Retriever)',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.successSoftGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Placa con QR',
                    style: TextStyle(
                      color: AppTheme.successGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPetRequirementRow(
                  icon: Icons.check_circle_outline,
                  title: 'Arnés y correa resistente',
                  detail: 'Ubicados en el perchero junto a la puerta principal.',
                ),
                const Divider(height: 20),
                _buildPetRequirementRow(
                  icon: Icons.lunch_dining_outlined,
                  title: 'Ración de comida (1.5 kg) y botella',
                  detail: 'En el compartimento frontal de la mochila sísmica.',
                ),
                const Divider(height: 20),
                _buildPetRequirementRow(
                  icon: Icons.badge_outlined,
                  title: 'Carnet de vacunas fotocopiado',
                  detail: 'En bolsa hermética junto con los DNI familiares.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetRequirementRow({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryBlue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

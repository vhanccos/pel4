import 'package:flutter/material.dart';
import '../models/emergency_models.dart';
import '../services/local_storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/evacuation_map_view.dart';

class FamilyPlanScreen extends StatefulWidget {
  const FamilyPlanScreen({super.key});

  @override
  State<FamilyPlanScreen> createState() => _FamilyPlanScreenState();
}

class _FamilyPlanScreenState extends State<FamilyPlanScreen> {
  int _selectedTab = 0; // 0: Puntos Seguros / Croquis, 1: Roles Familiares (CRUD), 2: Mascotas (CRUD)

  final List<SafeZoneLocation> _safeZones = const [
    SafeZoneLocation(
      id: 'z1',
      name: 'Parque Andrés Avelino Cáceres',
      district: 'Bustamante / Paucarpata',
      distanceMeters: 120,
      estimatedTime: '2 min a pie',
      capacity: 450,
      description: 'Zona verde amplia, libre de muros altos y sin tendido eléctrico aéreo.',
      safeRoute: 'Jr. Los Pinos → Pasaje San Agustín → Explanada Central.',
      routeCoordinates: [
        Offset(0.14, 0.78),
        Offset(0.34, 0.78),
        Offset(0.34, 0.44),
        Offset(0.66, 0.44),
        Offset(0.66, 0.22),
        Offset(0.82, 0.22),
      ],
      isFreeOfCables: true,
    ),
    SafeZoneLocation(
      id: 'z2',
      name: 'Cancha Deportiva Municipal',
      district: 'Cercado Arequipa',
      distanceMeters: 350,
      estimatedTime: '5 min a pie',
      capacity: 600,
      description: 'Losa deportiva cerrada sin techumbre pesada. Punto de repliegue secundario.',
      safeRoute: 'Av. Las Palmeras → Giro en U por Calle Sucre hacia el portón norte.',
      routeCoordinates: [
        Offset(0.14, 0.78),
        Offset(0.14, 0.44),
        Offset(0.34, 0.44),
        Offset(0.34, 0.18),
        Offset(0.48, 0.18),
      ],
      isFreeOfCables: true,
    ),
    SafeZoneLocation(
      id: 'z3',
      name: 'Plaza de Cayma',
      district: 'Cayma Tradicional',
      distanceMeters: 480,
      estimatedTime: '7 min a pie',
      capacity: 1200,
      description: 'Explanada adoquinada con amplio radio despejado en torno a la parroquia.',
      safeRoute: 'Calle Principal → Pasaje Los Arcos → Ingreso peatonal a la plaza.',
      routeCoordinates: [
        Offset(0.14, 0.78),
        Offset(0.34, 0.78),
        Offset(0.66, 0.78),
        Offset(0.66, 0.52),
        Offset(0.82, 0.52),
      ],
      isFreeOfCables: true,
    ),
  ];

  late SafeZoneLocation _currentSafeZone;

  List<FamilyMember> _members = [
    FamilyMember(
      id: 'm1',
      name: 'Carlos (Papá)',
      role: 'Responsable de Ruta',
      initial: 'C',
      tag: 'Frente',
      taskDescription:
          '1. Toma la mochila sísmica del hall.\n2. Abre la puerta principal y fíjala para evitar bloqueos por deformación.',
      avatarBgValue: 0xFFDBE1FF,
      avatarTextValue: 0xFF0049CC,
      isSafe: true,
    ),
    FamilyMember(
      id: 'm2',
      name: 'Elena (Mamá)',
      role: 'Corte de Servicios',
      initial: 'E',
      tag: 'Seguridad',
      taskDescription:
          '1. Cierra la válvula de gas en cocina.\n2. Baja la llave termoeléctrica principal del pasillo.',
      avatarBgValue: 0xFFFFDAD6,
      avatarTextValue: 0xFFBA1A1A,
      isSafe: true,
    ),
    FamilyMember(
      id: 'm3',
      name: 'Sofía (Hija)',
      role: 'Cuidado de Mascota',
      initial: 'S',
      tag: 'Acompañamiento',
      taskDescription:
          '1. Sujeta el arnés y correa de Bobby.\n2. Guía al perro con calma hacia el exterior sin correr.',
      avatarBgValue: 0xFFFFF0D4,
      avatarTextValue: 0xFF794B00,
      isSafe: false,
    ),
  ];

  List<PetProfile> _pets = [
    PetProfile(
      id: 'p1',
      name: 'Bobby',
      species: 'Perro',
      breed: 'Golden Retriever',
      tagId: 'QR-AQ-8891',
      specialNeeds: 'Arnés de pecho y ración de 1.5kg en mochila.',
      hasVaccinesCopied: true,
      isEvacuated: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentSafeZone = _safeZones.first;
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final loadedMembers = await LocalStorageService.loadMembers();
    if (loadedMembers != null && loadedMembers.isNotEmpty) {
      setState(() => _members = loadedMembers);
    }
    final loadedPets = await LocalStorageService.loadPets();
    if (loadedPets != null && loadedPets.isNotEmpty) {
      setState(() => _pets = loadedPets);
    }
  }

  Future<void> _saveMembers() async {
    await LocalStorageService.saveMembers(_members);
  }

  Future<void> _savePets() async {
    await LocalStorageService.savePets(_pets);
  }

  // --- CRUD FAMILIARES ---
  void _openMemberModal({FamilyMember? memberToEdit}) {
    final nameController = TextEditingController(text: memberToEdit?.name ?? '');
    final roleController = TextEditingController(text: memberToEdit?.role ?? '');
    final taskController = TextEditingController(text: memberToEdit?.taskDescription ?? '');
    String selectedTag = memberToEdit?.tag ?? 'Familia';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      memberToEdit == null ? 'Nuevo Responsable' : 'Editar Responsable',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    labelText: 'Rol en primeros 60s (ej. Corte de luz)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    labelText: 'Instrucciones detalladas de evacuación',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 14),
                const Text('Etiqueta:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: ['Frente', 'Seguridad', 'Acompañamiento', 'Documentos', 'Familia'].map((tag) {
                    final isSel = selectedTag == tag;
                    return ChoiceChip(
                      label: Text(tag),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setModalState(() => selectedTag = tag);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      setState(() {
                        if (memberToEdit == null) {
                          _members.add(
                            FamilyMember(
                              id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                              name: name,
                              role: roleController.text.trim().isNotEmpty ? roleController.text.trim() : 'Asistencia',
                              initial: name[0].toUpperCase(),
                              taskDescription: taskController.text.trim().isNotEmpty
                                  ? taskController.text.trim()
                                  : 'Apoyo general en ruta de salida.',
                              tag: selectedTag,
                              avatarBgValue: 0xFFDBE1FF,
                              avatarTextValue: 0xFF0049CC,
                            ),
                          );
                        } else {
                          memberToEdit.name = name;
                          memberToEdit.role = roleController.text.trim();
                          memberToEdit.initial = name[0].toUpperCase();
                          memberToEdit.taskDescription = taskController.text.trim();
                          memberToEdit.tag = selectedTag;
                        }
                      });
                      _saveMembers();
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(memberToEdit == null ? 'Guardar Responsable' : 'Actualizar Responsable'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _deleteMember(String id) {
    setState(() {
      _members.removeWhere((m) => m.id == id);
    });
    _saveMembers();
  }

  void _toggleMemberSafe(FamilyMember member) {
    setState(() {
      member.isSafe = !member.isSafe;
    });
    _saveMembers();
  }

  // --- CRUD MASCOTAS ---
  void _openPetModal({PetProfile? petToEdit}) {
    final nameController = TextEditingController(text: petToEdit?.name ?? '');
    final breedController = TextEditingController(text: petToEdit?.breed ?? '');
    final tagController = TextEditingController(text: petToEdit?.tagId ?? '');
    final needsController = TextEditingController(text: petToEdit?.specialNeeds ?? '');
    String selectedSpecies = petToEdit?.species ?? 'Perro';
    bool vaccinesCopied = petToEdit?.hasVaccinesCopied ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      petToEdit == null ? 'Registrar Mascota' : 'Editar Mascota',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre de la mascota', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: breedController,
                  decoration: const InputDecoration(labelText: 'Raza / Rasgos físicos', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tagController,
                  decoration: const InputDecoration(labelText: 'N° de Placa, Microchip o QR', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: needsController,
                  decoration: const InputDecoration(labelText: 'Requerimientos (arnés, comida, medicinas)', border: OutlineInputBorder()),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Especie: ', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedSpecies,
                      items: ['Perro', 'Gato', 'Ave', 'Otro'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedSpecies = val);
                      },
                    ),
                    const Spacer(),
                    Checkbox(
                      value: vaccinesCopied,
                      onChanged: (v) => setModalState(() => vaccinesCopied = v ?? true),
                    ),
                    const Text('Vacunas al día', style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      setState(() {
                        if (petToEdit == null) {
                          _pets.add(
                            PetProfile(
                              id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                              name: name,
                              species: selectedSpecies,
                              breed: breedController.text.trim().isNotEmpty ? breedController.text.trim() : 'Mestizo',
                              tagId: tagController.text.trim().isNotEmpty ? tagController.text.trim() : 'Sin placa',
                              specialNeeds: needsController.text.trim().isNotEmpty
                                  ? needsController.text.trim()
                                  : 'Llevar con correa.',
                              hasVaccinesCopied: vaccinesCopied,
                            ),
                          );
                        } else {
                          petToEdit.name = name;
                          petToEdit.species = selectedSpecies;
                          petToEdit.breed = breedController.text.trim();
                          petToEdit.tagId = tagController.text.trim();
                          petToEdit.specialNeeds = needsController.text.trim();
                          petToEdit.hasVaccinesCopied = vaccinesCopied;
                        }
                      });
                      _savePets();
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(petToEdit == null ? 'Guardar Mascota' : 'Actualizar Mascota'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _deletePet(String id) {
    setState(() {
      _pets.removeWhere((p) => p.id == id);
    });
    _savePets();
  }

  void _togglePetEvacuated(PetProfile pet) {
    setState(() {
      pet.isEvacuated = !pet.isEvacuated;
    });
    _savePets();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= 600;

        return Scaffold(
          floatingActionButton: _selectedTab == 1
              ? FloatingActionButton.extended(
                  onPressed: () => _openMemberModal(),
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Nuevo Responsable'),
                )
              : _selectedTab == 2
                  ? FloatingActionButton.extended(
                      onPressed: () => _openPetModal(),
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.add),
                      label: const Text('Registrar Mascota'),
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
                  // Encabezado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Plan Familiar Sísmico',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Protocolo interactivo de evacuación offline',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
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
                            Icon(Icons.offline_bolt, size: 16, color: AppTheme.primaryBlue),
                            SizedBox(width: 4),
                            Text(
                              'Offline Guardado',
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

                  // Subtabs
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
                            title: 'Croquis / Ruta',
                            icon: Icons.map_outlined,
                            index: 0,
                          ),
                        ),
                        Expanded(
                          child: _buildSubTab(
                            title: 'Familia (${_members.length})',
                            icon: Icons.people_outline,
                            index: 1,
                          ),
                        ),
                        Expanded(
                          child: _buildSubTab(
                            title: 'Mascotas (${_pets.length})',
                            icon: Icons.pets_outlined,
                            index: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (_selectedTab == 0) _buildSafePointsTab(),
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

  Widget _buildSafePointsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mapa Interactivo Canvas
        EvacuationMapInteractiveView(
          selectedZone: _currentSafeZone,
          availableZones: _safeZones,
          onZoneSelected: (zone) {
            setState(() {
              _currentSafeZone = zone;
            });
          },
        ),
        const SizedBox(height: 16),

        // Detalle del Punto Seleccionado
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _currentSafeZone.district,
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.successSoftGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bolt, size: 12, color: AppTheme.successGreen),
                          const SizedBox(width: 2),
                          Text(
                            _currentSafeZone.isFreeOfCables ? 'Libre de Cables' : 'Con cables',
                            style: const TextStyle(
                              color: AppTheme.successGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _currentSafeZone.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentSafeZone.description,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.softBlueBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.alt_route, color: AppTheme.primaryBlue, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ruta sugerida a pie:',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                            Text(
                              _currentSafeZone.safeRoute,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 18, color: AppTheme.primaryBlue),
                            const SizedBox(width: 6),
                            Text(
                              _currentSafeZone.estimatedTime,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                        child: Row(
                          children: [
                            const Icon(Icons.groups_outlined, size: 18, color: AppTheme.primaryBlue),
                            const SizedBox(width: 6),
                            Text(
                              'Cap. +${_currentSafeZone.capacity} pers.',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
        ),
      ],
    );
  }

  Widget _buildRolesTab() {
    final safeCount = _members.where((m) => m.isSafe).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tarjeta resumen de estado familiar
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: safeCount == _members.length && _members.isNotEmpty
                ? AppTheme.successSoftGreen
                : AppTheme.softBlueBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: safeCount == _members.length && _members.isNotEmpty
                  ? AppTheme.successGreen.withValues(alpha: 0.3)
                  : AppTheme.primaryBlue.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                safeCount == _members.length && _members.isNotEmpty
                    ? Icons.check_circle
                    : Icons.people_alt,
                color: safeCount == _members.length && _members.isNotEmpty
                    ? AppTheme.successGreen
                    : AppTheme.primaryBlue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monitoreo de Evacuación: $safeCount de ${_members.length} a salvo',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    const Text(
                      'Toca el botón de verificación para marcar a los miembros que ya evacuaron.',
                      style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        if (_members.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('No hay responsables registrados. Pulsa "Nuevo Responsable".')),
          )
        else
          ..._members.map((member) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
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
                              Row(
                                children: [
                                  Text(
                                    member.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  if (member.isSafe)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.successSoftGreen,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'A Salvo',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.successGreen,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                member.role,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        // Acción marcar a salvo
                        IconButton(
                          icon: Icon(
                            member.isSafe ? Icons.verified : Icons.verified_outlined,
                            color: member.isSafe ? AppTheme.successGreen : Colors.grey,
                          ),
                          tooltip: member.isSafe ? 'Marcar como pendiente' : 'Marcar a salvo',
                          onPressed: () => _toggleMemberSafe(member),
                        ),
                        // Editar
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20, color: AppTheme.primaryBlue),
                          onPressed: () => _openMemberModal(memberToEdit: member),
                        ),
                        // Eliminar
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                          onPressed: () => _deleteMember(member.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        member.taskDescription,
                        style: const TextStyle(fontSize: 12, height: 1.4, color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildPetsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_pets.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('No hay mascotas registradas. Pulsa "Registrar Mascota".')),
          )
        else
          ..._pets.map((pet) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    color: AppTheme.softBlueBackground,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.pets, color: AppTheme.primaryBlue),
                            const SizedBox(width: 8),
                            Text(
                              '${pet.name} (${pet.species})',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20, color: AppTheme.primaryBlue),
                              onPressed: () => _openPetModal(petToEdit: pet),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                              onPressed: () => _deletePet(pet.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Raza / Rasgos: ${pet.breed}', style: const TextStyle(fontSize: 13)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.successSoftGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                pet.tagId,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.successGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 18),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.health_and_safety_outlined, size: 20, color: AppTheme.primaryBlue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Requerimientos de evacuación: ${pet.specialNeeds}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: pet.isEvacuated ? AppTheme.successSoftGreen : null,
                                ),
                                onPressed: () => _togglePetEvacuated(pet),
                                icon: Icon(
                                  pet.isEvacuated ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: pet.isEvacuated ? AppTheme.successGreen : AppTheme.primaryBlue,
                                  size: 18,
                                ),
                                label: Text(
                                  pet.isEvacuated ? 'Mascota a Salvo con Familia' : 'Pendiente de Evacuar',
                                  style: TextStyle(
                                    color: pet.isEvacuated ? AppTheme.successGreen : AppTheme.primaryBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
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
            );
          }),
        const SizedBox(height: 60),
      ],
    );
  }
}

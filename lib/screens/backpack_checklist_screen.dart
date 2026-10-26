import 'package:flutter/material.dart';
import '../models/emergency_models.dart';
import '../services/local_storage_service.dart';
import '../theme/app_theme.dart';

class BackpackChecklistScreen extends StatefulWidget {
  const BackpackChecklistScreen({super.key});

  @override
  State<BackpackChecklistScreen> createState() => _BackpackChecklistScreenState();
}

class _BackpackChecklistScreenState extends State<BackpackChecklistScreen> {
  SupplyCategory? _selectedCategory;
  bool _filterOnlyPending = false;

  List<BackpackItem> _items = [
    BackpackItem(
      id: 'v1',
      title: 'Agua embotellada (4L)',
      subtitle: '2 litros por persona por día (mínimo 48 horas)',
      quantity: '4 botellas de 1L selladas',
      category: SupplyCategory.vitales,
      icon: Icons.water_drop,
      isPacked: true,
      expiryDate: '2026-12-15',
    ),
    BackpackItem(
      id: 'v2',
      title: 'Comida enlatada y no perecible',
      subtitle: 'Atún, frejoles listos y abrelatas manual',
      quantity: '4 latas con sistema abre-fácil',
      category: SupplyCategory.vitales,
      icon: Icons.lunch_dining,
      isPacked: true,
      expiryDate: '2027-05-20',
    ),
    BackpackItem(
      id: 'v3',
      title: 'Chocolates / Barras calóricas',
      subtitle: 'Aporte rápido de glucosa y energía en rescate',
      quantity: '4 unidades individuales',
      category: SupplyCategory.vitales,
      icon: Icons.cookie_outlined,
      isPacked: false,
    ),
    BackpackItem(
      id: 'v4',
      title: 'Manta polar térmica ligera',
      subtitle: 'Protección contra hipotermia en la noche',
      quantity: '2 mantas compactas',
      category: SupplyCategory.vitales,
      icon: Icons.bed_outlined,
      isPacked: true,
    ),
    BackpackItem(
      id: 'b1',
      title: 'Alcohol etílico al 70%',
      subtitle: 'Desinfección de heridas y quemaduras menores',
      quantity: '1 frasco de 250ml',
      category: SupplyCategory.botiquin,
      icon: Icons.sanitizer,
      isPacked: true,
    ),
    BackpackItem(
      id: 'b2',
      title: 'Gasas estériles y vendas adhesivas',
      subtitle: 'Inmovilización y contención de hemorragias',
      quantity: '1 paquete surtido + micropore',
      category: SupplyCategory.botiquin,
      icon: Icons.healing,
      isPacked: true,
    ),
    BackpackItem(
      id: 'b3',
      title: 'Tijeras de trauma punta roma',
      subtitle: 'Corte rápido de ropa, vendas y gasas sin riesgo',
      quantity: '1 unidad de acero inoxidable',
      category: SupplyCategory.botiquin,
      icon: Icons.content_cut,
      isPacked: false,
    ),
    BackpackItem(
      id: 'b4',
      title: 'Mascarillas N95 / quirúrgicas',
      subtitle: 'Protección respiratoria ante polvo o humo',
      quantity: 'Paquete sellado x 6',
      category: SupplyCategory.botiquin,
      icon: Icons.masks,
      isPacked: true,
    ),
    BackpackItem(
      id: 'h1',
      title: 'Radio a pilas AM/FM + repuestos',
      subtitle: 'Único medio de comunicación oficial sin internet',
      quantity: '1 radio portátil + 4 pilas AA',
      category: SupplyCategory.herramientas,
      icon: Icons.radio,
      isPacked: true,
    ),
    BackpackItem(
      id: 'h2',
      title: 'Linterna LED dínamo / pilas',
      subtitle: 'Iluminación segura sin riesgo de chispa de gas',
      quantity: '1 linterna de alto lúmenes',
      category: SupplyCategory.herramientas,
      icon: Icons.flashlight_on,
      isPacked: true,
    ),
    BackpackItem(
      id: 'h3',
      title: 'Powerbank 10,000 mAh cargado',
      subtitle: 'Carga de emergencia con cable universal',
      quantity: 'Cargado al 100%',
      category: SupplyCategory.herramientas,
      icon: Icons.battery_charging_full,
      isPacked: false,
    ),
    BackpackItem(
      id: 'h4',
      title: 'Silbato de emergencia de rescate',
      subtitle: 'Señal audible a larga distancia para socorristas',
      quantity: '2 silbatos con cordón',
      category: SupplyCategory.herramientas,
      icon: Icons.volume_up,
      isPacked: true,
    ),
    BackpackItem(
      id: 'd1',
      title: 'Copias de DNI y pólizas de seguro',
      subtitle: 'Documentos familiares en bolsa ziploc hermética',
      quantity: '1 fólder plástico impermeable',
      category: SupplyCategory.documentos,
      icon: Icons.badge,
      isPacked: true,
    ),
    BackpackItem(
      id: 'd2',
      title: 'Monedas fraccionadas en efectivo',
      subtitle: 'S/ 50 a S/ 100 en monedas para compras básicas',
      quantity: 'Sencillo de S/ 1, 2 y 5',
      category: SupplyCategory.documentos,
      icon: Icons.attach_money,
      isPacked: false,
    ),
    BackpackItem(
      id: 'd3',
      title: 'Duplicado de llaves de casa y auto',
      subtitle: 'Permite reingreso o evacuación vehicular rápida',
      quantity: '1 juego completo',
      category: SupplyCategory.documentos,
      icon: Icons.key,
      isPacked: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedBackpack();
  }

  Future<void> _loadSavedBackpack() async {
    final saved = await LocalStorageService.loadBackpack();
    if (saved != null && saved.isNotEmpty) {
      setState(() => _items = saved);
    }
  }

  Future<void> _saveBackpack() async {
    await LocalStorageService.saveBackpack(_items);
  }

  void _toggleItemStatus(String id) {
    setState(() {
      final index = _items.indexWhere((element) => element.id == id);
      if (index != -1) {
        _items[index].isPacked = !_items[index].isPacked;
      }
    });
    _saveBackpack();
  }

  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((i) => i.id == id);
    });
    _saveBackpack();
  }

  void _openItemModal({BackpackItem? itemToEdit}) {
    final titleController = TextEditingController(text: itemToEdit?.title ?? '');
    final subtitleController = TextEditingController(text: itemToEdit?.subtitle ?? '');
    final qtyController = TextEditingController(text: itemToEdit?.quantity ?? '');
    final expiryController = TextEditingController(text: itemToEdit?.expiryDate ?? '');
    SupplyCategory selectedCategory = itemToEdit?.category ?? SupplyCategory.vitales;

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
                      itemToEdit == null ? 'Añadir a la Mochila' : 'Editar Artículo',
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
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Artículo',
                    hintText: 'Ej. Medicamento para la presión',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: subtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción / Ubicación',
                    hintText: 'Ej. Bolsillo lateral derecho',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qtyController,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                          hintText: 'Ej. 2 unidades',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: expiryController,
                        decoration: const InputDecoration(
                          labelText: 'Vencimiento (opcional)',
                          hintText: 'YYYY-MM-DD',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Categoría:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: SupplyCategory.values.map((cat) {
                    final isSel = selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat.displayName),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setModalState(() => selectedCategory = cat);
                      },
                      selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isNotEmpty) {
                      setState(() {
                        if (itemToEdit == null) {
                          _items.add(
                            BackpackItem(
                              id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                              title: title,
                              subtitle: subtitleController.text.trim().isNotEmpty
                                  ? subtitleController.text.trim()
                                  : 'Suministro personal',
                              quantity: qtyController.text.trim().isNotEmpty
                                  ? qtyController.text.trim()
                                  : '1 unidad',
                              category: selectedCategory,
                              icon: selectedCategory.icon,
                              isPacked: false,
                              expiryDate: expiryController.text.trim().isNotEmpty
                                  ? expiryController.text.trim()
                                  : null,
                            ),
                          );
                        } else {
                          itemToEdit.title = title;
                          itemToEdit.subtitle = subtitleController.text.trim();
                          itemToEdit.quantity = qtyController.text.trim();
                          itemToEdit.category = selectedCategory;
                          itemToEdit.icon = selectedCategory.icon;
                          itemToEdit.expiryDate = expiryController.text.trim().isNotEmpty
                              ? expiryController.text.trim()
                              : null;
                        }
                      });
                      _saveBackpack();
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(itemToEdit == null ? 'Guardar Artículo' : 'Actualizar Artículo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final packedCount = _items.where((i) => i.isPacked).length;
    final totalCount = _items.length;
    final progressPercentage = totalCount > 0 ? (packedCount / totalCount) : 0.0;

    final filteredItems = _items.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_filterOnlyPending && item.isPacked) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openItemModal(),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Añadir Artículo'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Mochila Sísmica INDECI',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryDarkBlue, AppTheme.primaryBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Primeras 48 Horas (Offline)',
                            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(progressPercentage * 100).toInt()}% Lista',
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$packedCount de $totalCount artículos listos',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: CircularProgressIndicator(
                            value: progressPercentage,
                            strokeWidth: 7,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progressPercentage >= 0.8 ? const Color(0xFF5FFFA6) : AppTheme.alertAmber,
                            ),
                          ),
                        ),
                        Text(
                          '$packedCount/$totalCount',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.emergencySoftRed,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.emergencyRed.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppTheme.emergencyRed, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Revisar fecha de caducidad de agua y alimentos cada 6 meses.',
                            style: TextStyle(
                              color: AppTheme.emergencyDarkRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Filtros por Categoría (Wrap Layout):',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: _selectedCategory == null && !_filterOnlyPending,
                        onSelected: (val) {
                          setState(() {
                            _selectedCategory = null;
                            _filterOnlyPending = false;
                          });
                        },
                        selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.18),
                      ),
                      FilterChip(
                        avatar: const Icon(Icons.pending_actions, size: 16),
                        label: Text('Pendientes (${totalCount - packedCount})'),
                        selected: _filterOnlyPending,
                        onSelected: (val) {
                          setState(() {
                            _filterOnlyPending = val;
                          });
                        },
                        selectedColor: AppTheme.emergencySoftRed,
                      ),
                      ...SupplyCategory.values.map((cat) {
                        final isSel = _selectedCategory == cat;
                        return FilterChip(
                          avatar: Icon(cat.icon, size: 16),
                          label: Text(cat.displayName),
                          selected: isSel,
                          onSelected: (val) {
                            setState(() {
                              _selectedCategory = val ? cat : null;
                            });
                          },
                          selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.18),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (filteredItems.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, size: 48, color: AppTheme.successGreen),
                      SizedBox(height: 12),
                      Text(
                        '¡Todos los artículos de esta vista están empacados!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverList.separated(
                itemCount: filteredItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item.isPacked ? const Color(0xFFF9FAFD) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: item.isPacked
                            ? Colors.black.withValues(alpha: 0.04)
                            : AppTheme.emergencyRed.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: item.isPacked,
                          activeColor: AppTheme.successGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (_) => _toggleItemStatus(item.id),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.isPacked
                                ? Colors.black.withValues(alpha: 0.05)
                                : AppTheme.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.isPacked ? Colors.grey : AppTheme.primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        decoration: item.isPacked ? TextDecoration.lineThrough : null,
                                        color: item.isPacked ? Colors.grey : AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: item.isPacked ? AppTheme.successSoftGreen : AppTheme.emergencySoftRed,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.isPacked ? 'Listo' : 'Pendiente',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: item.isPacked ? AppTheme.successGreen : AppTheme.emergencyDarkRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.inventory_2_outlined, size: 12, color: AppTheme.primaryBlue),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.quantity,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  ),
                                  if (item.expiryDate != null) ...[
                                    const SizedBox(width: 10),
                                    const Icon(Icons.calendar_today, size: 11, color: Colors.orange),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Vence: ${item.expiryDate}',
                                      style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.primaryBlue),
                          onPressed: () => _openItemModal(itemToEdit: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                          onPressed: () => _deleteItem(item.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 90),
          ),
        ],
      ),
    );
  }
}

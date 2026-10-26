import 'package:flutter/material.dart';
import 'screens/backpack_checklist_screen.dart';
import 'screens/emergency_directory_screen.dart';
import 'screens/family_plan_screen.dart';
import 'screens/quick_emergency_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SismoListoApp());
}

class SismoListoApp extends StatelessWidget {
  const SismoListoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SismoListo PE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    QuickEmergencyScreen(),
    BackpackChecklistScreen(),
    FamilyPlanScreen(),
    EmergencyDirectoryScreen(),
  ];

  final List<String> _screenTitles = const [
    'SismoListo PE',
    'Mochila Sísmica',
    'Plan Familiar',
    'Directorio de Auxilio',
  ];

  @override
  Widget build(BuildContext context) {
    // Uso del slot Scaffold con AppBar, NavigationBar y body adaptativo
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.emergencyRed.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield, color: AppTheme.emergencyRed, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _screenTitles[_currentIndex],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                const Text(
                  'Arequipa / Perú · Offline-First',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppTheme.primaryBlue),
            tooltip: 'Acerca del Laboratorio 04',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'SismoListo PE',
                applicationVersion: '1.0.0 (LAB 04)',
                applicationLegalese: 'UNSA - Plataformas Emergentes\nDiseño para respuesta sísmica offline-first',
                children: const [
                  SizedBox(height: 12),
                  Text(
                    'Implementación nativa en Flutter (Dart) demostrando layouts espaciales:\n'
                    '• Scaffold con NavigationBar y slots nativos\n'
                    '• Column, Row, Flex, Expanded y Flexible\n'
                    '• CustomScrollView con SliverAppBar y SliverList.separated\n'
                    '• Stack y Positioned para alertas flotantes\n'
                    '• Wrap para etiquetas y filtros interactivos\n'
                    '• LayoutBuilder para comportamiento adaptativo.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.emergency_outlined),
            selectedIcon: Icon(Icons.emergency),
            label: 'Emergencia',
          ),
          NavigationDestination(
            icon: Icon(Icons.backpack_outlined),
            selectedIcon: Icon(Icons.backpack),
            label: 'Mochila',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom),
            label: 'Mi Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone),
            label: 'Auxilio',
          ),
        ],
      ),
    );
  }
}

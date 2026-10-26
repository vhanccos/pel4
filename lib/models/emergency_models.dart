import 'package:flutter/material.dart';

enum SupplyCategory {
  vitales,
  botiquin,
  herramientas,
  documentos,
}

extension SupplyCategoryExt on SupplyCategory {
  String get displayName {
    switch (this) {
      case SupplyCategory.vitales:
        return 'Vitales';
      case SupplyCategory.botiquin:
        return 'Botiquín';
      case SupplyCategory.herramientas:
        return 'Herramientas';
      case SupplyCategory.documentos:
        return 'Documentos';
    }
  }

  IconData get icon {
    switch (this) {
      case SupplyCategory.vitales:
        return Icons.water_drop_outlined;
      case SupplyCategory.botiquin:
        return Icons.medical_services_outlined;
      case SupplyCategory.herramientas:
        return Icons.build_outlined;
      case SupplyCategory.documentos:
        return Icons.badge_outlined;
    }
  }
}

class BackpackItem {
  final String id;
  final String title;
  final String subtitle;
  final String quantity;
  final SupplyCategory category;
  final IconData icon;
  bool isPacked;

  BackpackItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.quantity,
    required this.category,
    required this.icon,
    this.isPacked = false,
  });
}

class FamilyMember {
  final String id;
  final String name;
  final String role;
  final String initial;
  final String taskDescription;
  final String tag;
  final Color avatarBgColor;
  final Color avatarTextColor;

  FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    required this.initial,
    required this.taskDescription,
    required this.tag,
    required this.avatarBgColor,
    required this.avatarTextColor,
  });
}

class EmergencyContact {
  final String number;
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color badgeColor;

  EmergencyContact({
    required this.number,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.badgeColor,
  });
}

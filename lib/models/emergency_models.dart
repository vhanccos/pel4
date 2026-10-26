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
  String title;
  String subtitle;
  String quantity;
  SupplyCategory category;
  IconData icon;
  bool isPacked;
  String? expiryDate; // Formato YYYY-MM-DD

  BackpackItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.quantity,
    required this.category,
    required this.icon,
    this.isPacked = false,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'quantity': quantity,
        'category': category.index,
        'icon': icon.codePoint,
        'isPacked': isPacked,
        'expiryDate': expiryDate,
      };

  factory BackpackItem.fromJson(Map<String, dynamic> json) {
    final catIndex = json['category'] as int;
    final cat = SupplyCategory.values[catIndex];
    return BackpackItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      quantity: json['quantity'] as String,
      category: cat,
      icon: cat.icon,
      isPacked: json['isPacked'] as bool? ?? false,
      expiryDate: json['expiryDate'] as String?,
    );
  }
}

class FamilyMember {
  final String id;
  String name;
  String role;
  String initial;
  String taskDescription;
  String tag;
  int avatarBgValue;
  int avatarTextValue;
  bool isSafe;

  FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    required this.initial,
    required this.taskDescription,
    required this.tag,
    required this.avatarBgValue,
    required this.avatarTextValue,
    this.isSafe = false,
  });

  Color get avatarBgColor => Color(avatarBgValue);
  Color get avatarTextColor => Color(avatarTextValue);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'initial': initial,
        'taskDescription': taskDescription,
        'tag': tag,
        'avatarBgValue': avatarBgValue,
        'avatarTextValue': avatarTextValue,
        'isSafe': isSafe,
      };

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json['id'] as String,
        name: json['name'] as String,
        role: json['role'] as String,
        initial: json['initial'] as String,
        taskDescription: json['taskDescription'] as String,
        tag: json['tag'] as String,
        avatarBgValue: json['avatarBgValue'] as int? ?? 0xFFDBE1FF,
        avatarTextValue: json['avatarTextValue'] as int? ?? 0xFF0049CC,
        isSafe: json['isSafe'] as bool? ?? false,
      );
}

class PetProfile {
  final String id;
  String name;
  String species; // Perro, Gato, Ave, etc.
  String breed;
  String tagId; // Placa / QR
  String specialNeeds;
  bool hasVaccinesCopied;
  bool isEvacuated;

  PetProfile({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.tagId,
    required this.specialNeeds,
    this.hasVaccinesCopied = true,
    this.isEvacuated = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'breed': breed,
        'tagId': tagId,
        'specialNeeds': specialNeeds,
        'hasVaccinesCopied': hasVaccinesCopied,
        'isEvacuated': isEvacuated,
      };

  factory PetProfile.fromJson(Map<String, dynamic> json) => PetProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        species: json['species'] as String,
        breed: json['breed'] as String,
        tagId: json['tagId'] as String,
        specialNeeds: json['specialNeeds'] as String,
        hasVaccinesCopied: json['hasVaccinesCopied'] as bool? ?? true,
        isEvacuated: json['isEvacuated'] as bool? ?? false,
      );
}

class SafeZoneLocation {
  final String id;
  final String name;
  final String district;
  final double distanceMeters;
  final String estimatedTime;
  final int capacity;
  final String description;
  final String safeRoute;
  final List<Offset> routeCoordinates; // Puntos para el canvas vectorial
  final bool isFreeOfCables;

  const SafeZoneLocation({
    required this.id,
    required this.name,
    required this.district,
    required this.distanceMeters,
    required this.estimatedTime,
    required this.capacity,
    required this.description,
    required this.safeRoute,
    required this.routeCoordinates,
    this.isFreeOfCables = true,
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

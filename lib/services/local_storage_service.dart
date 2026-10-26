import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emergency_models.dart';

class LocalStorageService {
  static const String keyBackpack = 'sismolisto_backpack_v1';
  static const String keyMembers = 'sismolisto_members_v1';
  static const String keyPets = 'sismolisto_pets_v1';
  static const String keyMedicalNote = 'sismolisto_medical_note_v1';

  static Future<void> saveBackpack(List<BackpackItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((i) => i.toJson()).toList();
    await prefs.setString(keyBackpack, jsonEncode(jsonList));
  }

  static Future<List<BackpackItem>?> loadBackpack() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(keyBackpack);
    if (data == null) return null;
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => BackpackItem.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveMembers(List<FamilyMember> members) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = members.map((m) => m.toJson()).toList();
    await prefs.setString(keyMembers, jsonEncode(jsonList));
  }

  static Future<List<FamilyMember>?> loadMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(keyMembers);
    if (data == null) return null;
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => FamilyMember.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> savePets(List<PetProfile> pets) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = pets.map((p) => p.toJson()).toList();
    await prefs.setString(keyPets, jsonEncode(jsonList));
  }

  static Future<List<PetProfile>?> loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(keyPets);
    if (data == null) return null;
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => PetProfile.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveMedicalNote(String note) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyMedicalNote, note);
  }

  static Future<String?> loadMedicalNote() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyMedicalNote);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender { female, male }

class GenderNotifier extends Notifier<Gender?> {
  @override
  Gender? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('gender');
    if (saved == 'female') {
      state = Gender.female;
    } else if (saved == 'male') {
      state = Gender.male;
    }
  }

  Future<void> setGender(Gender gender) async {
    state = gender;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', gender == Gender.female ? 'female' : 'male');
  }
}

final genderProvider = NotifierProvider<GenderNotifier, Gender?>(() {
  return GenderNotifier();
});

extension GenderColor on Gender? {
  Color get primaryColor {
    if (this == Gender.male) {
      return const Color(0xFF0088FF);
    }
    return const Color(0xFF7B61FF);
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gender_provider.dart';

class UserProfile {
  const UserProfile({required this.name, this.ageRange, this.style});

  final String name;
  final String? ageRange;
  final String? style;
}

class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    final gender = ref.watch(genderProvider);
    _load();
    return UserProfile(name: gender == Gender.male ? 'نادر' : 'هستی');
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final name = preferences.getString('profile_name');
    if (name == null || name.trim().isEmpty) return;
    state = UserProfile(
      name: name,
      ageRange: preferences.getString('profile_age_range'),
      style: preferences.getString('profile_style'),
    );
  }

  Future<void> save({required String name, String? ageRange, String? style}) async {
    final profile = UserProfile(name: name.trim(), ageRange: ageRange, style: style);
    state = profile;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('profile_name', profile.name);
    if (ageRange != null) await preferences.setString('profile_age_range', ageRange);
    if (style != null) await preferences.setString('profile_style', style);
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(ProfileNotifier.new);

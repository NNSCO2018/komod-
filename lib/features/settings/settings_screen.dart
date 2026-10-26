import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/profile_provider.dart';
import '../../core/theme_mode_provider.dart';
import '../calendar/providers/calendar_provider.dart';
import '../closet/providers/closet_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _toPersianNumber(int value) {
    const digits = '۰۱۲۳۴۵۶۷۸۹';
    return value.toString().split('').map((digit) => digits[int.parse(digit)]).join();
  }

  Future<void> _showThemePicker(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('ظاهر برنامه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.light_mode_outlined),
                title: const Text('حالت روشن'),
                onTap: () {
                  ref.read(themeModeProvider.notifier).setMode(ThemeMode.light);
                  Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text('حالت تیره'),
                onTap: () {
                  ref.read(themeModeProvider.notifier).setMode(ThemeMode.dark);
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final clothingCount = ref.watch(closetProvider).length;
    final eventCount = ref.watch(calendarProvider).length;
    final themeMode = ref.watch(themeModeProvider);
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('پروفایل من')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                CircleAvatar(radius: 40, backgroundColor: primary.withValues(alpha: 0.16), child: Icon(Icons.person_outline_rounded, size: 42, color: primary)),
                const SizedBox(height: 12),
                Text(profile.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(profile.style ?? 'استایل خودت را انتخاب کن', style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ProfileStat(value: _toPersianNumber(clothingCount == 0 ? 6 : clothingCount), label: 'لباس'),
                    const _ProfileStat(value: '۱', label: 'استایل'),
                    _ProfileStat(value: _toPersianNumber(eventCount == 0 ? 3 : eventCount), label: 'رویداد'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('تنظیمات حساب', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _SettingTile(icon: Icons.person_outline, title: 'اطلاعات شخصی', subtitle: 'نام، جنسیت و سبک مورد علاقه', onTap: () => context.push('/profile/setup')),
          _SettingTile(icon: Icons.notifications_none_rounded, title: 'اعلان‌ها', subtitle: 'یادآوری رویدادها و پیشنهادها', onTap: () {}),
          _SettingTile(
            icon: Icons.palette_outlined,
            title: 'ظاهر برنامه',
            subtitle: themeMode == ThemeMode.dark ? 'حالت تیره' : 'حالت روشن',
            onTap: () => _showThemePicker(context, ref),
          ),
          const SizedBox(height: 18),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text('خروج از حساب', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
              onTap: () => context.go('/login'),
            ),
          ),
          const SizedBox(height: 18),
          const Center(child: Text('کمد من • نسخه نمایشی', style: TextStyle(fontSize: 12, color: Colors.black45))),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54))]);
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(leading: Icon(icon, color: Theme.of(context).colorScheme.primary), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_left_rounded), onTap: onTap),
    );
  }
}

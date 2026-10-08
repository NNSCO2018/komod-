import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('پروفایل'),
              subtitle: Text('ویرایش اطلاعات حساب'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.notifications_outlined),
              title: Text('اعلان‌ها'),
              subtitle: Text('مدیریت یادآوری‌ها'),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('خروج از حساب', style: TextStyle(color: Colors.red)),
              onTap: () => context.go('/login'),
            ),
          ),
        ],
      ),
    );
  }
}

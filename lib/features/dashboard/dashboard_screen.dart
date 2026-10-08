import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبورد'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'به کمد خوش اومدی!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.push('/closet'),
              child: const Text('برو به کمد لباس‌هات'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push('/suggestion'),
              child: const Text('پیشنهاد پوشش امروز'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push('/calendar'),
              child: const Text('تقویم رویدادها'),
            ),
          ],
        ),
      ),
    );
  }
}

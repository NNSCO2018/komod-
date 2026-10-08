import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/gender_provider.dart';

class GenderScreen extends ConsumerWidget {
  const GenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'جنسیت خود را انتخاب کنید',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'برای تجربه‌ی بهتر',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _GenderCard(
                label: 'خانم',
                icon: Icons.female,
                color: const Color(0xFF7B61FF),
                onTap: () async {
                  await ref.read(genderProvider.notifier).setGender(Gender.female);
                  if (context.mounted) context.go('/login');
                },
              ),
              const SizedBox(height: 16),
              _GenderCard(
                label: 'آقا',
                icon: Icons.male,
                color: const Color(0xFF0088FF),
                onTap: () async {
                  await ref.read(genderProvider.notifier).setGender(Gender.male);
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
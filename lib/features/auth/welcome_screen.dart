import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 112,
                height: 112,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Text('🎉', style: TextStyle(fontSize: 54)),
              ),
              const SizedBox(height: 28),
              const Text(
                'خوش آمدید!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                'کمک می‌کنیم لباس‌هایت را بهتر بشناسی و هر روز با اطمینان استایل بسازی.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.8, color: Colors.black54),
              ),
              const SizedBox(height: 36),
              FilledButton(
                onPressed: () => context.go('/profile/setup'),
                child: const Text('شروع کنیم'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/profile_provider.dart';
import '../calendar/providers/calendar_provider.dart';
import '../closet/providers/closet_provider.dart';
import '../suggestion/saved_outfits_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _toPersianNumber(int value) {
    const digits = '۰۱۲۳۴۵۶۷۸۹';
    return value.toString().split('').map((digit) => digits[int.parse(digit)]).join();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final clothingCount = ref.watch(closetProvider).length;
    final events = ref.watch(calendarProvider);
    final savedOutfitsCount = ref.watch(savedOutfitsProvider).length;
    final nextEvent = events.isEmpty ? null : events.first;
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: primary.withValues(alpha: 0.12),
                  child: Icon(Icons.person_outline, color: primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('سلام ${profile.name}!', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      const Text('امروز آماده‌ای بدرخشی؟', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.go('/settings'),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(colors: [primary, Theme.of(context).colorScheme.secondary]),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('استایل امروزت آماده است', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
                        SizedBox(height: 6),
                        Text('یک ترکیب مینیمال برای روزی پرانرژی', style: TextStyle(color: Colors.white70, height: 1.5)),
                      ],
                    ),
                  ),
                  Icon(Icons.auto_awesome_rounded, size: 46, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text('امروز چه کاری می‌خواهی انجام بدهی؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _ActionCard(icon: Icons.checkroom_outlined, label: 'کمد من', color: primary, onTap: () => context.go('/closet'))),
                const SizedBox(width: 12),
                Expanded(child: _ActionCard(icon: Icons.style_outlined, label: 'استایل جدید', color: const Color(0xFF0088FF), onTap: () => context.go('/suggestion'))),
                const SizedBox(width: 12),
                Expanded(child: _ActionCard(icon: Icons.event_outlined, label: 'تقویم', color: const Color(0xFFE879A9), onTap: () => context.go('/calendar'))),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _DashboardStat(value: _toPersianNumber(clothingCount), label: 'لباس‌های من', icon: Icons.checkroom_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _DashboardStat(value: _toPersianNumber(savedOutfitsCount), label: 'استایل ذخیره‌شده', icon: Icons.favorite_border_rounded)),
              ],
            ),
            const SizedBox(height: 28),
            if (nextEvent != null) ...[
              const Text('نزدیک‌ترین رویداد', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => context.go('/calendar'),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    children: [
                      Icon(Icons.event_outlined, color: primary),
                      const SizedBox(width: 12),
                      Expanded(child: Text(nextEvent.title, style: const TextStyle(fontWeight: FontWeight.w700))),
                      const Icon(Icons.chevron_left_rounded, color: Colors.black38),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
            const Text('پیشنهاد امروز', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => context.go('/suggestion'),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 176,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: const Color(0xFFF4F1FF), borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('کژوال شهری', style: TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 18)),
                          const SizedBox(height: 8),
                          const Text('کت کرم، شلوار جین و کیف روشن؛ مناسب یک قرار دوستانه.', style: TextStyle(color: Colors.black54, height: 1.6)),
                          const SizedBox(height: 10),
                          Text('مشاهده جزئیات', style: TextStyle(color: primary, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.checkroom_rounded, size: 86, color: Color(0xFFD4C8FF)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _NavigationBar(currentIndex: 0),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 7),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({required this.value, required this.label, required this.icon});

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Icon(icon, color: primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        const routes = ['/dashboard', '/closet', '/calendar', '/settings'];
        context.go(routes[index]);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'خانه'),
        NavigationDestination(icon: Icon(Icons.checkroom_outlined), selectedIcon: Icon(Icons.checkroom), label: 'کمد'),
        NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'تقویم'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'پروفایل'),
      ],
    );
  }
}

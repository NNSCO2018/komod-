import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'providers/calendar_provider.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  String _formatDate(DateTime date) {
    final jalali = Jalali.fromDateTime(date);
    return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(calendarProvider);
    final primary = Theme.of(context).colorScheme.primary;
    final demoEvents = [
      ('قرار دوستانه', DateTime.now().add(const Duration(days: 1)), Icons.groups_outlined, const Color(0xFF0088FF)),
      ('جلسه کاری', DateTime.now().add(const Duration(days: 3)), Icons.business_center_outlined, primary),
      ('مهمانی خانوادگی', DateTime.now().add(const Duration(days: 7)), Icons.celebration_outlined, const Color(0xFFE879A9)),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('تقویم استایل')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(22)),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: primary, child: const Icon(Icons.calendar_month_rounded, color: Colors.white)),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('رویدادهای پیش‌رو', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      SizedBox(height: 5),
                      Text('برای هر موقعیت، استایل مناسب آماده کن.', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('این هفته', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...demoEvents.map((event) => _EventCard(title: event.$1, date: _formatDate(event.$2), icon: event.$3, color: event.$4)),
          if (events.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('رویدادهای ثبت‌شده', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...events.map((event) => _EventCard(title: event.title, date: _formatDate(event.date), icon: Icons.event_outlined, color: primary)),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/calendar/add'),
        icon: const Icon(Icons.add),
        label: const Text('رویداد جدید'),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.title, required this.date, required this.icon, required this.color});

  final String title;
  final String date;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, color: color)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 5), Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54))])),
          const Icon(Icons.chevron_left_rounded, color: Colors.black38),
        ],
      ),
    );
  }
}

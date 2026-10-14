import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'models/calendar_event.dart';
import 'providers/calendar_provider.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  String _formatDate(DateTime date) {
    final jalali = Jalali.fromDateTime(date);
    return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}';
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'کاری':
        return Icons.business_center_outlined;
      case 'مهمانی':
        return Icons.celebration_outlined;
      case 'سفر':
        return Icons.flight_takeoff_outlined;
      case 'ورزش':
        return Icons.fitness_center_outlined;
      default:
        return Icons.event_outlined;
    }
  }

  Color _typeColor(String type, Color primary) {
    switch (type) {
      case 'کاری':
        return primary;
      case 'مهمانی':
        return const Color(0xFFE879A9);
      case 'سفر':
        return const Color(0xFF0088FF);
      case 'ورزش':
        return const Color(0xFF22C55E);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, CalendarEvent event) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف رویداد'),
        content: Text('«${event.title}» حذف شود؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('انصراف')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      ref.read(calendarProvider.notifier).removeEvent(event.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(calendarProvider);
    final primary = Theme.of(context).colorScheme.primary;
    final now = DateTime.now();
    final demoEvents = [
      CalendarEvent(id: 'demo-1', title: 'قرار دوستانه', date: now.add(const Duration(days: 1)), type: 'مهمانی', note: 'استایل کژوال و کیف کوچک'),
      CalendarEvent(id: 'demo-2', title: 'جلسه کاری', date: now.add(const Duration(days: 3)), type: 'کاری', note: 'استایل رسمی و کفش کلاسیک'),
      CalendarEvent(id: 'demo-3', title: 'مهمانی خانوادگی', date: now.add(const Duration(days: 7)), type: 'مهمانی', note: 'ترکیب راحت و شیک'),
    ];
    final visibleEvents = events.isEmpty ? demoEvents : events;

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('رویدادهای پیش‌رو', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 5),
                      Text('${visibleEvents.length} رویداد • برای هر موقعیت استایل مناسب بساز.', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(events.isEmpty ? 'نمونه‌های این هفته' : 'رویدادهای من', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          if (visibleEvents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('هنوز رویدادی ثبت نکردی.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
            ),
          ...visibleEvents.map(
            (event) => _EventCard(
              event: event,
              date: _formatDate(event.date),
              icon: _typeIcon(event.type),
              color: _typeColor(event.type, primary),
              onDelete: events.isEmpty ? null : () => _confirmDelete(context, ref, event),
            ),
          ),
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
  const _EventCard({required this.event, required this.date, required this.icon, required this.color, this.onDelete});

  final CalendarEvent event;
  final String date;
  final IconData icon;
  final Color color;
  final VoidCallback? onDelete;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${event.type} • $date', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                if (event.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(event.note, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'models/calendar_event.dart';
import 'providers/calendar_provider.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key});

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  Jalali _selectedDate = Jalali.now();
  String _type = 'عمومی';

  static const _types = ['عمومی', 'کاری', 'مهمانی', 'سفر', 'ورزش'];

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showPersianDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: Jalali(1400, 1, 1),
      lastDate: Jalali(1420, 12, 29),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatJalali(Jalali jalali) =>
      '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}';

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    ref.read(calendarProvider.notifier).addEvent(
          CalendarEvent(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title,
            date: _selectedDate.toDateTime(),
            type: _type,
            note: _noteController.text.trim(),
          ),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final previewText = _titleController.text.trim().isEmpty ? 'عنوان رویداد' : _titleController.text.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('رویداد جدید')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: primary, child: const Icon(Icons.event_available_rounded, color: Colors.white)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(previewText, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 5),
                        Text('${_type} • ${_formatJalali(_selectedDate)}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'عنوان رویداد',
                hintText: 'مثلاً مهمانی دوستانه',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'نوع رویداد',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) => setState(() => _type = value ?? _type),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('تاریخ: ${_formatJalali(_selectedDate)}'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'یادداشت (اختیاری)',
                hintText: 'مثلاً استایل رسمی و کفش پاشنه‌بلند',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _save,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('ذخیره رویداد'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

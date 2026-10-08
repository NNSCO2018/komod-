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
  Jalali _selectedDate = Jalali.now();

  @override
  void dispose() {
    _titleController.dispose();
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

  String _formatJalali(Jalali j) =>
      '${j.year}/${j.month.toString().padLeft(2, '0')}/${j.day.toString().padLeft(2, '0')}';

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    ref.read(calendarProvider.notifier).addEvent(
          CalendarEvent(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title,
            date: _selectedDate.toDateTime(),
          ),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('افزودن رویداد')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان رویداد',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(_formatJalali(_selectedDate)),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('ذخیره'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

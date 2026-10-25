import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calendar_event.dart';

class CalendarNotifier extends Notifier<List<CalendarEvent>> {
  @override
  List<CalendarEvent> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getStringList('calendar_events') ?? [];
    final events = saved
        .map((event) => CalendarEvent.fromJson(jsonDecode(event) as Map<String, dynamic>))
        .toList();
    events.sort((a, b) => a.date.compareTo(b.date));
    state = events;
  }

  Future<void> _persist(List<CalendarEvent> events) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      'calendar_events',
      events.map((event) => jsonEncode(event.toJson())).toList(),
    );
  }

  void addEvent(CalendarEvent event) {
    final updated = [...state, event];
    updated.sort((a, b) => a.date.compareTo(b.date));
    state = updated;
    _persist(state);
  }

  void removeEvent(String id) {
    state = state.where((event) => event.id != id).toList();
    _persist(state);
  }
}

final calendarProvider = NotifierProvider<CalendarNotifier, List<CalendarEvent>>(
  CalendarNotifier.new,
);

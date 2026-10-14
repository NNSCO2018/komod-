import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calendar_event.dart';

class CalendarNotifier extends Notifier<List<CalendarEvent>> {
  @override
  List<CalendarEvent> build() => [];

  void addEvent(CalendarEvent event) {
    final updated = [...state, event];
    updated.sort((a, b) => a.date.compareTo(b.date));
    state = updated;
  }

  void removeEvent(String id) {
    state = state.where((event) => event.id != id).toList();
  }
}

final calendarProvider = NotifierProvider<CalendarNotifier, List<CalendarEvent>>(
  CalendarNotifier.new,
);

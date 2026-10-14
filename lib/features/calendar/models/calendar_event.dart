class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String type;
  final String note;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    this.type = 'عمومی',
    this.note = '',
  });
}

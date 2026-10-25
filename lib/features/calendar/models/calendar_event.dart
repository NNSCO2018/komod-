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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'type': type,
        'note': note,
      };

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => CalendarEvent(
        id: json['id'] as String,
        title: json['title'] as String,
        date: DateTime.parse(json['date'] as String),
        type: json['type'] as String? ?? 'عمومی',
        note: json['note'] as String? ?? '',
      );
}

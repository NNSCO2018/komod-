class ClothingItem {
  final String id;
  final String name;
  final String category;
  final String color;
  final String season;
  final String status;

  const ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.season,
    this.status = 'available',
  });
}

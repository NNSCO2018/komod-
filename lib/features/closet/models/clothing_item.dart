import 'dart:convert';
import 'dart:typed_data';

class ClothingItem {
  final String id;
  final String name;
  final String category;
  final String color;
  final String season;
  final String status;
  final Uint8List? photoBytes;

  const ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.season,
    this.status = 'available',
    this.photoBytes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'color': color,
        'season': season,
        'status': status,
        'photo': photoBytes == null ? null : base64Encode(photoBytes!),
      };

  factory ClothingItem.fromJson(Map<String, dynamic> json) => ClothingItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        color: json['color'] as String? ?? '',
        season: json['season'] as String,
        status: json['status'] as String? ?? 'available',
        photoBytes: json['photo'] == null ? null : base64Decode(json['photo'] as String),
      );
}

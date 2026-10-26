import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedOutfit {
  const SavedOutfit({required this.id, required this.title, required this.items, required this.createdAt});

  final String id;
  final String title;
  final List<String> items;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'items': items,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavedOutfit.fromJson(Map<String, dynamic> json) => SavedOutfit(
        id: json['id'] as String,
        title: json['title'] as String,
        items: (json['items'] as List<dynamic>).cast<String>(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class SavedOutfitsNotifier extends Notifier<List<SavedOutfit>> {
  @override
  List<SavedOutfit> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    state = (preferences.getStringList('saved_outfits') ?? [])
        .map((item) => SavedOutfit.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _persist() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('saved_outfits', state.map((outfit) => jsonEncode(outfit.toJson())).toList());
  }

  void add(SavedOutfit outfit) {
    state = [outfit, ...state];
    _persist();
  }

  void remove(String id) {
    state = state.where((outfit) => outfit.id != id).toList();
    _persist();
  }
}

final savedOutfitsProvider = NotifierProvider<SavedOutfitsNotifier, List<SavedOutfit>>(SavedOutfitsNotifier.new);

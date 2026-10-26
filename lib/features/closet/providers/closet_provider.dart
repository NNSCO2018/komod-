import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/clothing_item.dart';

class ClosetNotifier extends Notifier<List<ClothingItem>> {
  @override
  List<ClothingItem> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getStringList('closet_items') ?? [];
    state = saved
        .map((item) => ClothingItem.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _persist(List<ClothingItem> items) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      'closet_items',
      items.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  void addItem(ClothingItem item) {
    state = [...state, item];
    _persist(state);
  }

  void updateItem(ClothingItem item) {
    state = [for (final current in state) current.id == item.id ? item : current];
    _persist(state);
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
    _persist(state);
  }
}

final closetProvider = NotifierProvider<ClosetNotifier, List<ClothingItem>>(
  ClosetNotifier.new,
);

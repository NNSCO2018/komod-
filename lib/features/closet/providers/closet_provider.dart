import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/clothing_item.dart';

class ClosetNotifier extends Notifier<List<ClothingItem>> {
  @override
  List<ClothingItem> build() => [];

  void addItem(ClothingItem item) {
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final closetProvider = NotifierProvider<ClosetNotifier, List<ClothingItem>>(
  ClosetNotifier.new,
);

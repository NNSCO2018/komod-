import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../closet/models/clothing_item.dart';
import '../closet/providers/closet_provider.dart';

const _topCategories = ['تیشرت', 'پیراهن'];
const _bottomCategories = ['شلوار'];
const _shoeCategories = ['کفش'];
const _outerCategories = ['کت'];

class OutfitSuggestionScreen extends ConsumerStatefulWidget {
  const OutfitSuggestionScreen({super.key});

  @override
  ConsumerState<OutfitSuggestionScreen> createState() => _OutfitSuggestionScreenState();
}

class _OutfitSuggestionScreenState extends ConsumerState<OutfitSuggestionScreen> {
  int _seed = 0;

  ClothingItem? _pickFrom(List<ClothingItem> items, List<String> categories) {
    final matches = items.where((i) => categories.contains(i.category)).toList();
    if (matches.isEmpty) return null;
    final rnd = Random(_seed + matches.length);
    return matches[rnd.nextInt(matches.length)];
  }

  Widget _itemCard(String label, ClothingItem? item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Text(label[0])),
        title: Text(item?.name ?? 'چیزی تو این دسته پیدا نشد'),
        subtitle: item != null ? Text('${item.color} • ${item.season}') : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, [WidgetRef? _]) {
    final items = ref.watch(closetProvider);
    final top = _pickFrom(items, _topCategories);
    final bottom = _pickFrom(items, _bottomCategories);
    final shoes = _pickFrom(items, _shoeCategories);
    final outer = _pickFrom(items, _outerCategories);

    return Scaffold(
      appBar: AppBar(title: const Text('پیشنهاد پوشش امروز')),
      body: items.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'اول چند تا لباس تو کمدت ثبت کن تا بتونم پیشنهاد بدم.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _itemCard('بالاتنه', top),
                _itemCard('پایین‌تنه', bottom),
                _itemCard('کفش', shoes),
                _itemCard('رویه', outer),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => setState(() => _seed++),
                  icon: const Icon(Icons.refresh),
                  label: const Text('پیشنهاد جدید'),
                ),
              ],
            ),
    );
  }
}

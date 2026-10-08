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

  static final _demoItems = [
    ClothingItem(id: 'demo-top', name: 'پیراهن سفید', category: 'پیراهن', color: 'سفید', season: 'همه فصل‌ها'),
    ClothingItem(id: 'demo-bottom', name: 'شلوار جین', category: 'شلوار', color: 'آبی', season: 'همه فصل‌ها'),
    ClothingItem(id: 'demo-shoes', name: 'کفش مشکی', category: 'کفش', color: 'مشکی', season: 'همه فصل‌ها'),
    ClothingItem(id: 'demo-outer', name: 'کت کرم', category: 'کت', color: 'کرم', season: 'پاییز'),
  ];

  ClothingItem? _pickFrom(List<ClothingItem> items, List<String> categories) {
    final matches = items.where((item) => categories.contains(item.category)).toList();
    if (matches.isEmpty) return null;
    return matches[Random(_seed + matches.length).nextInt(matches.length)];
  }

  Widget _itemCard(BuildContext context, String label, IconData icon, ClothingItem? item, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(item?.name ?? 'برای این دسته نمونه‌ای نیست', style: const TextStyle(fontWeight: FontWeight.w700)),
                if (item != null) ...[
                  const SizedBox(height: 3),
                  Text('${item.color} • ${item.season}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: Colors.black38),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(closetProvider);
    final sourceItems = items.isEmpty ? _demoItems : items;
    final primary = Theme.of(context).colorScheme.primary;
    final top = _pickFrom(sourceItems, _topCategories);
    final bottom = _pickFrom(sourceItems, _bottomCategories);
    final shoes = _pickFrom(sourceItems, _shoeCategories);
    final outer = _pickFrom(sourceItems, _outerCategories);

    return Scaffold(
      appBar: AppBar(title: const Text('استایل‌سازی')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primary, Theme.of(context).colorScheme.secondary]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 30),
                SizedBox(height: 14),
                Text('پیشنهاد امروز', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                Text('یک ترکیب هماهنگ برای حال‌وهوای امروزت بساز.', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(child: Text('ترکیب کژوال شهری', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
              Text('${sourceItems.length} لباس در کمد', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 14),
          _itemCard(context, 'بالاتنه', Icons.checkroom_outlined, top, primary),
          _itemCard(context, 'پایین‌تنه', Icons.dry_cleaning_outlined, bottom, const Color(0xFF0088FF)),
          _itemCard(context, 'کفش', Icons.hiking_outlined, shoes, const Color(0xFFE879A9)),
          _itemCard(context, 'رویه', Icons.layers_outlined, outer, const Color(0xFFF59E0B)),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => setState(() => _seed++),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('ساخت پیشنهاد جدید'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_rounded),
            label: const Text('ذخیرهٔ این استایل'),
          ),
        ],
      ),
    );
  }
}

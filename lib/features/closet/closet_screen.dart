import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'models/clothing_item.dart';
import 'providers/closet_provider.dart';

class ClosetScreen extends ConsumerWidget {
  const ClosetScreen({super.key});

  static const _demoItems = [
    ('کت کرم', Icons.checkroom_outlined, Color(0xFFF0DFCC)),
    ('شلوار جین', Icons.dry_cleaning_outlined, Color(0xFFB5CAE2)),
    ('کیف روشن', Icons.shopping_bag_outlined, Color(0xFFE8D7C2)),
    ('کفش مشکی', Icons.hiking_outlined, Color(0xFF4B5563)),
    ('پیراهن سفید', Icons.checkroom_outlined, Color(0xFFF7F7F7)),
    ('اکسسوری', Icons.watch_outlined, Color(0xFFF6DD9C)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(closetProvider);
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('کمد من'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['همه', 'بالاتنه', 'پایین‌تنه', 'کفش', 'اکسسوری']
                  .map((label) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: label == 'همه',
                          selectedColor: primary.withValues(alpha: 0.16),
                          onSelected: (_) {},
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.78),
              itemCount: items.isEmpty ? _demoItems.length : items.length,
              itemBuilder: (context, index) {
                final item = items.isEmpty ? null : items[index];
                final demo = items.isEmpty ? _demoItems[index] : null;
                final name = demo?.$1 ?? item!.name;
                final icon = demo?.$2 ?? Icons.checkroom_outlined;
                final color = demo?.$3 ?? primary.withValues(alpha: 0.14);
                return _ClosetItemCard(name: name, icon: icon, color: color, item: item);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/closet/add'), icon: const Icon(Icons.add), label: const Text('افزودن لباس')),
    );
  }
}

class _ClosetItemCard extends StatelessWidget {
  const _ClosetItemCard({required this.name, required this.icon, required this.color, this.item});

  final String name;
  final IconData icon;
  final Color color;
  final ClothingItem? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item?.photoBytes != null
                  ? Image.memory(item!.photoBytes!, width: double.infinity, fit: BoxFit.cover)
                  : Center(child: Icon(icon, size: 68, color: color)),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(item?.color.isNotEmpty == true ? item!.color : 'آماده پوشیدن', style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}

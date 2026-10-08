import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                final demo = items.isEmpty ? _demoItems[index] : null;
                final name = demo?.$1 ?? items[index].name;
                final icon = demo?.$2 ?? Icons.checkroom_outlined;
                final color = demo?.$3 ?? primary.withValues(alpha: 0.14);
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Center(child: Icon(icon, size: 68, color: color))),
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      const Text('آماده پوشیدن', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/closet/add'), icon: const Icon(Icons.add), label: const Text('افزودن لباس')),
    );
  }
}

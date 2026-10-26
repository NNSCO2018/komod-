import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'models/clothing_item.dart';
import 'providers/closet_provider.dart';

class ClosetScreen extends ConsumerStatefulWidget {
  const ClosetScreen({super.key});

  @override
  ConsumerState<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends ConsumerState<ClosetScreen> {
  String _selectedFilter = 'همه';
  String _query = '';
  bool _searching = false;

  static const _demoItems = [
    ('کت کرم', 'کت', Icons.checkroom_outlined, Color(0xFFF0DFCC)),
    ('شلوار جین', 'شلوار', Icons.dry_cleaning_outlined, Color(0xFFB5CAE2)),
    ('کیف روشن', 'اکسسوری', Icons.shopping_bag_outlined, Color(0xFFE8D7C2)),
    ('کفش مشکی', 'کفش', Icons.hiking_outlined, Color(0xFF4B5563)),
    ('پیراهن سفید', 'پیراهن', Icons.checkroom_outlined, Color(0xFFF7F7F7)),
    ('اکسسوری', 'اکسسوری', Icons.watch_outlined, Color(0xFFF6DD9C)),
  ];

  bool _matchesFilter(String category) {
    switch (_selectedFilter) {
      case 'بالاتنه':
        return ['تیشرت', 'پیراهن', 'کت'].contains(category);
      case 'پایین‌تنه':
        return category == 'شلوار';
      case 'کفش':
        return category == 'کفش';
      case 'اکسسوری':
        return category == 'اکسسوری';
      default:
        return true;
    }
  }

  bool _matchesQuery(String name, String color) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return true;
    return name.toLowerCase().contains(query) || color.toLowerCase().contains(query);
  }

  Future<void> _confirmDelete(ClothingItem item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف لباس'),
        content: Text('«${item.name}» از کمد حذف شود؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('انصراف')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      ref.read(closetProvider.notifier).removeItem(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(closetProvider);
    final primary = Theme.of(context).colorScheme.primary;
    final visibleItems = items.where((item) => _matchesFilter(item.category) && _matchesQuery(item.name, item.color)).toList();
    final visibleDemoItems = _demoItems.where((item) => _matchesFilter(item.$2) && _matchesQuery(item.$1, item.$1)).toList();
    final showDemo = items.isEmpty;
    final count = showDemo ? visibleDemoItems.length : visibleItems.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('کمد من'),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              _searching = !_searching;
              if (!_searching) _query = '';
            }),
            icon: Icon(_searching ? Icons.close_rounded : Icons.search_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searching)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'جست‌وجوی نام یا رنگ لباس',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['همه', 'بالاتنه', 'پایین‌تنه', 'کفش', 'اکسسوری']
                  .map(
                    (label) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: _selectedFilter == label,
                        selectedColor: primary.withValues(alpha: 0.16),
                        onSelected: (_) => setState(() => _selectedFilter = label),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: count == 0
                ? Center(
                    child: Text(
                      'لباسی در این دسته نداری.',
                      style: TextStyle(color: Colors.black.withValues(alpha: 0.55)),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: count,
                    itemBuilder: (context, index) {
                      final item = showDemo ? null : visibleItems[index];
                      final demo = showDemo ? visibleDemoItems[index] : null;
                      return _ClosetItemCard(
                        name: demo?.$1 ?? item!.name,
                        icon: demo?.$3 ?? Icons.checkroom_outlined,
                        color: demo?.$4 ?? primary.withValues(alpha: 0.14),
                        item: item,
                        onTap: item == null ? null : () => context.push('/closet/add', extra: item),
                        onDelete: item == null ? null : () => _confirmDelete(item),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/closet/add'),
        icon: const Icon(Icons.add),
        label: const Text('افزودن لباس'),
      ),
    );
  }
}

class _ClosetItemCard extends StatelessWidget {
  const _ClosetItemCard({
    required this.name,
    required this.icon,
    required this.color,
    this.item,
    this.onTap,
    this.onDelete,
  });

  final String name;
  final IconData icon;
  final Color color;
  final ClothingItem? item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: item?.photoBytes != null
                        ? Image.memory(
                            item!.photoBytes!,
                            fit: BoxFit.cover,
                            cacheWidth: 600,
                          )
                        : Center(child: Icon(icon, size: 68, color: color)),
                  ),
                ),
                if (onDelete != null)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 19),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(
            item?.color.isNotEmpty == true ? item!.color : 'آماده پوشیدن',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    ),
  );
  }
}

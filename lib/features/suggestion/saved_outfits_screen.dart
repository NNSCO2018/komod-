import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'saved_outfits_provider.dart';

class SavedOutfitsScreen extends ConsumerWidget {
  const SavedOutfitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfits = ref.watch(savedOutfitsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('استایل‌های ذخیره‌شده')),
      body: outfits.isEmpty
          ? const Center(
              child: Text('هنوز استایلی ذخیره نکرده‌ای.', style: TextStyle(color: Colors.black54)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: outfits.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final outfit = outfits[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                      child: Icon(Icons.favorite_rounded, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(outfit.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(outfit.items.join(' • '), maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      onPressed: () => ref.read(savedOutfitsProvider.notifier).remove(outfit.id),
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

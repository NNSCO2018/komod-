import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/closet_provider.dart';

class ClosetScreen extends ConsumerWidget {
  const ClosetScreen({super.key});

  String _statusLabel(String status) {
    switch (status) {
      case 'dirty':
        return 'کثیف';
      case 'damaged':
        return 'خراب';
      case 'unavailable':
        return 'ناموجود';
      default:
        return 'موجود';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(closetProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('کمد')),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'هنوز لباسی تو کمدت ثبت نکردی.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.push('/closet/add'),
                      child: const Text('افزودن اولین لباس'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.category} • ${item.color} • ${item.season}'),
                    trailing: Chip(label: Text(_statusLabel(item.status))),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/closet/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'models/clothing_item.dart';
import 'providers/closet_provider.dart';

class AddClothingScreen extends ConsumerStatefulWidget {
  const AddClothingScreen({super.key});

  @override
  ConsumerState<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends ConsumerState<AddClothingScreen> {
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  String _category = 'تیشرت';
  String _season = 'همه فصل‌ها';
  Uint8List? _photoBytes;

  final _categories = const ['تیشرت', 'شلوار', 'کفش', 'کت', 'پیراهن', 'اکسسوری'];
  final _seasons = const ['بهار', 'تابستان', 'پاییز', 'زمستان', 'همه فصل‌ها'];

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _photoBytes = bytes);
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('گرفتن عکس با دوربین'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('انتخاب از گالری'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    ref.read(closetProvider.notifier).addItem(
          ClothingItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            category: _category,
            color: _colorController.text.trim(),
            season: _season,
            photoBytes: _photoBytes,
          ),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('افزودن لباس')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GestureDetector(
              onTap: _showPickerOptions,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  image: _photoBytes != null
                      ? DecorationImage(
                          image: MemoryImage(_photoBytes!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: _photoBytes == null
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.black38),
                          SizedBox(height: 8),
                          Text('افزودن عکس', style: TextStyle(color: Colors.black45)),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'نام لباس',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'دسته',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _category = value ?? _category),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'رنگ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _season,
              decoration: const InputDecoration(
                labelText: 'فصل',
                border: OutlineInputBorder(),
              ),
              items: _seasons
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) => setState(() => _season = value ?? _season),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('ذخیره'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

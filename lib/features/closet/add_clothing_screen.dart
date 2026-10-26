import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'models/clothing_item.dart';
import 'providers/closet_provider.dart';

class AddClothingScreen extends ConsumerStatefulWidget {
  final ClothingItem? item;

  const AddClothingScreen({super.key, this.item});

  @override
  ConsumerState<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends ConsumerState<AddClothingScreen> {
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  String _category = 'تیشرت';
  String _season = 'همه فصل‌ها';
  Uint8List? _photoBytes;
  bool _isAnalyzing = false;
  String? _analysisSummary;

  final _categories = const ['تیشرت', 'شلوار', 'کفش', 'کت', 'پیراهن', 'اکسسوری'];
  final _seasons = const ['بهار', 'تابستان', 'پاییز', 'زمستان', 'همه فصل‌ها'];

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      _nameController.text = item.name;
      _colorController.text = item.color;
      _category = item.category;
      _season = item.season;
      _photoBytes = item.photoBytes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 72,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _photoBytes = bytes;
      _analysisSummary = null;
    });
  }

  Future<void> _analyzeImage() async {
    final photoBytes = _photoBytes;
    if (photoBytes == null) return;

    setState(() => _isAnalyzing = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final suggestions = [
      ('پیراهن', 'سفید', 'همه فصل‌ها'),
      ('شلوار', 'آبی', 'همه فصل‌ها'),
      ('کت', 'کرم', 'پاییز'),
      ('تیشرت', 'مشکی', 'تابستان'),
      ('کفش', 'مشکی', 'همه فصل‌ها'),
    ];
    final suggestion = suggestions[photoBytes.length % suggestions.length];
    setState(() {
      _category = suggestion.$1;
      _colorController.text = suggestion.$2;
      _season = suggestion.$3;
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = '${suggestion.$1} ${suggestion.$2}';
      }
      _analysisSummary = '${suggestion.$1} • ${suggestion.$2} • ${suggestion.$3}';
      _isAnalyzing = false;
    });
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
    final item = ClothingItem(
      id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: _category,
      color: _colorController.text.trim(),
      season: _season,
      photoBytes: _photoBytes,
    );
    if (widget.item == null) {
      ref.read(closetProvider.notifier).addItem(item);
    } else {
      ref.read(closetProvider.notifier).updateItem(item);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item == null ? 'افزودن لباس' : 'ویرایش لباس')),
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
            const SizedBox(height: 16),
            if (_photoBytes != null) ...[
              OutlinedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                icon: _isAnalyzing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(_isAnalyzing ? 'در حال تحلیل عکس...' : 'تشخیص لباس از عکس'),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _analysisSummary ?? 'پس از انتخاب عکس، تشخیص نمایشی را اجرا کن.',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            ],
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
                child: Text(widget.item == null ? 'ذخیره لباس' : 'ذخیره تغییرات'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/gender_provider.dart';
import '../../core/profile_provider.dart';

class InitialProfileScreen extends ConsumerStatefulWidget {
  const InitialProfileScreen({super.key});

  @override
  ConsumerState<InitialProfileScreen> createState() => _InitialProfileScreenState();
}

class _InitialProfileScreenState extends ConsumerState<InitialProfileScreen> {
  late final TextEditingController _nameController;
  String? _ageRange;
  String? _style;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final gender = ref.watch(genderProvider);
    final exampleName = gender == Gender.male ? 'نادر' : 'هستی';
    if (!_initialized) {
      _nameController = TextEditingController(text: profile.name);
      _ageRange = profile.ageRange;
      _style = profile.style;
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('اطلاعات اولیه')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          children: [
            const Text(
              'برای پیشنهادهای دقیق‌تر، چند مورد را وارد کن.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'نام',
                hintText: 'مثلاً $exampleName',
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: _ageRange,
              decoration: const InputDecoration(
                labelText: 'بازه سنی',
                prefixIcon: Icon(Icons.cake_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'زیر ۱۸ سال', child: Text('زیر ۱۸ سال')),
                DropdownMenuItem(value: '۱۸ تا ۲۴ سال', child: Text('۱۸ تا ۲۴ سال')),
                DropdownMenuItem(value: '۲۵ تا ۳۴ سال', child: Text('۲۵ تا ۳۴ سال')),
                DropdownMenuItem(value: '۳۵ سال و بیشتر', child: Text('۳۵ سال و بیشتر')),
              ],
              onChanged: (value) => setState(() => _ageRange = value),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: _style,
              decoration: const InputDecoration(
                labelText: 'استایل مورد علاقه',
                prefixIcon: Icon(Icons.checkroom_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'کژوال', child: Text('کژوال')),
                DropdownMenuItem(value: 'رسمی', child: Text('رسمی')),
                DropdownMenuItem(value: 'مینیمال', child: Text('مینیمال')),
                DropdownMenuItem(value: 'اسپرت', child: Text('اسپرت')),
              ],
              onChanged: (value) => setState(() => _style = value),
            ),
            const SizedBox(height: 36),
            FilledButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isEmpty) return;
                await ref.read(profileProvider.notifier).save(
                      name: name,
                      ageRange: _ageRange,
                      style: _style,
                    );
                if (context.mounted) context.go('/dashboard');
              },
              child: const Text('تایید و ادامه'),
            ),
          ],
        ),
      ),
    );
  }
}

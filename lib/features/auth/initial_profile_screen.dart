import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitialProfileScreen extends StatefulWidget {
  const InitialProfileScreen({super.key});

  @override
  State<InitialProfileScreen> createState() => _InitialProfileScreenState();
}

class _InitialProfileScreenState extends State<InitialProfileScreen> {
  final _nameController = TextEditingController();
  String? _ageRange;
  String? _style;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(
                labelText: 'نام',
                hintText: 'مثلاً سارا',
                prefixIcon: Icon(Icons.person_outline),
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
              onPressed: () => context.go('/dashboard'),
              child: const Text('تایید و ادامه'),
            ),
          ],
        ),
      ),
    );
  }
}

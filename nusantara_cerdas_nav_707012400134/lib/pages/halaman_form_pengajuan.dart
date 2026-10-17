
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';

class HalamanFormPengajuan extends StatefulWidget {
  const HalamanFormPengajuan({super.key});

  @override
  State<HalamanFormPengajuan> createState() =>
      _HalamanFormPengajuanState();
}

class _HalamanFormPengajuanState
    extends State<HalamanFormPengajuan> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();

  bool _setuju = false;
  bool _loading = false;
  String? _sesi;

  bool get _formValid =>
      _namaController.text.trim().isNotEmpty &&
      _emailController.text.trim().contains('@') &&
      _setuju &&
      _sesi != null &&
      !_loading;

  Future<void> _kirimPengajuan() async {
    if (!_formKey.currentState!.validate() ||
        !_setuju ||
        _sesi == null) {
      return;
    }

    setState(() => _loading = true);

    // Simulasi proses pengiriman.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    context.read<PengajuanModel>().tambah(
          nama: _namaController.text.trim(),
          email: _emailController.text.trim(),
          sesi: _sesi!,
        );

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengajuan berhasil dikirim!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pengajuan'),
      ),
      body: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Isi Data Pengajuan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi';
                }
                if (!value.contains('@')) {
                  return 'Email harus mengandung @';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            
            const Text(
            'Pilih Sesi',
            style: TextStyle(fontWeight: FontWeight.bold),
            ),

            RadioGroup<String>(
            groupValue: _sesi,
            onChanged: (value) {
                setState(() {
                _sesi = value;
                });
            },
            child: Column(
                children: [
                RadioListTile<String>(
                    title: const Text('Sesi Pagi'),
                    value: 'Pagi',
                ),
                RadioListTile<String>(
                    title: const Text('Sesi Siang'),
                    value: 'Siang',
                ),
                ],
            ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Saya menyetujui pengajuan ini',
              ),
              value: _setuju,
              onChanged: (value) {
                setState(() => _setuju = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _formValid ? _kirimPengajuan : null,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(
                _loading ? 'Mengirim...' : 'Kirim Pengajuan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

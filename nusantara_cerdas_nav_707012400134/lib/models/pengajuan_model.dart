
import 'package:flutter/foundation.dart';

class Pengajuan {
  Pengajuan({
    required this.id,
    required this.nama,
    this.email = '',
    this.sesi = 'Belum dipilih',
    this.selesai = false,
  });

  final int id;
  final String nama;
  final String email;
  final String sesi;
  bool selesai;
}

class PengajuanModel extends ChangeNotifier {
  final List<Pengajuan> _data = [];
  int _nextId = 1;

  List<Pengajuan> get daftarPengajuan =>
      List.unmodifiable(_data);

  int get jumlahPengajuan => _data.length;

  // Untuk pengajuan dari halaman detail layanan.
  void ajukan(String nama) {
    _data.add(
      Pengajuan(
        id: _nextId++,
        nama: nama,
      ),
    );

    notifyListeners();
  }

  // Untuk pengajuan dari halaman formulir.
  void tambah({
    required String nama,
    required String email,
    required String sesi,
  }) {
    _data.add(
      Pengajuan(
        id: _nextId++,
        nama: nama,
        email: email,
        sesi: sesi,
      ),
    );

    notifyListeners();
  }

  Pengajuan? cari(int id) {
    for (final pengajuan in _data) {
      if (pengajuan.id == id) {
        return pengajuan;
      }
    }

    return null;
  }

  void tandaiSelesai(int id) {
    final pengajuan = cari(id);

    if (pengajuan == null) return;

    pengajuan.selesai = true;
    notifyListeners();
  }
}

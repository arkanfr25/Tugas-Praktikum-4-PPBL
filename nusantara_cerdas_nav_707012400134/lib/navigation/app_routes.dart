import 'package:flutter/material.dart';

import '../pages/halaman_detail_layanan.dart';
import '../pages/halaman_riwayat.dart';
import '../pages/halaman_menu.dart';
import '../pages/halaman_form_pengajuan.dart';
import 'kerangka_navigasi.dart';


class AppRoutes {
  static const String beranda = '/';
  static const String detail = '/detail';
  static const String riwayat = '/riwayat';
  static const String pengaturan = '/pengaturan';
  static const String tentang = '/tentang';
  static const String form = '/form';
  

  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      riwayat: (context) => const HalamanRiwayat(),
      pengaturan: (context) =>
          const HalamanMenu(judul: 'Pengaturan Kota'),
      tentang: (context) =>
          const HalamanMenu(judul: 'Tentang Aplikasi'),
      form: (context) => const HalamanFormPengajuan(),
    };
  }

  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    if (settings.name == detail) {
      final argumen =
          settings.arguments as Map<String, String>?;

      if (argumen == null) {
        return MaterialPageRoute(
          builder: (_) => const HalamanMenu(
            judul: 'Data layanan tidak tersedia',
          ),
        );
      }

      return MaterialPageRoute(
        settings: settings,
        builder: (_) => HalamanDetailLayanan(
          nama: argumen['nama'] ?? 'Layanan',
          dinas: argumen['dinas'] ?? 'Dinas terkait',
          jam: argumen['jam'] ??
              'Jam operasional belum tersedia',
          keterangan:
              argumen['keterangan'] ?? 'Belum ada keterangan.',
        ),
      );
    }

    return null;
  }

  static Route<dynamic> routeTidakDikenal(
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Route Tidak Ditemukan'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Halaman ${settings.name} belum terdaftar.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
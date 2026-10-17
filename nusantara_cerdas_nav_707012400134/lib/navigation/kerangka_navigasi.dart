
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';
import '../pages/halaman_beranda.dart';
import '../pages/halaman_layanan.dart';
import '../pages/halaman_warga.dart';
import 'app_routes.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() =>
      _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _indeksTerpilih = 0;

  final List<Widget> _halaman = const [
    HalamanBeranda(),
    HalamanLayanan(),
    HalamanWarga(),
  ];

  final List<String> _judul = const [
    'Beranda',
    'Layanan',
    'Warga',
  ];

  void _pilihTujuan(int indeks) {
    setState(() {
      _indeksTerpilih = indeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool layarLebar =
        MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(_judul[_indeksTerpilih]),
      ),
      drawer: _buatDrawer(),
      body: layarLebar
          ? Row(
              children: [
                _buatRail(),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _halaman[_indeksTerpilih],
                ),
              ],
            )
          : _halaman[_indeksTerpilih],

      // Tombol pengajuan muncul saat menu Warga dipilih.
      floatingActionButton: _indeksTerpilih == 2
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.form,
                );
              },
              icon: const Icon(Icons.assignment),
              label: const Text('Buat Pengajuan'),
            )
          : null,

      bottomNavigationBar:
          layarLebar ? null : _buatNavigationBar(),
    );
  }

  Widget _buatNavigationBar() {
    return NavigationBar(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: _pilihTujuan,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        const NavigationDestination(
          icon: Icon(Icons.miscellaneous_services_outlined),
          selectedIcon: Icon(Icons.miscellaneous_services),
          label: 'Layanan',
        ),
        NavigationDestination(
          icon: _IkonWargaDenganBadge(
            ikon: Icons.person_outline,
          ),
          selectedIcon: _IkonWargaDenganBadge(
            ikon: Icons.person,
          ),
          label: 'Warga',
        ),
      ],
    );
  }

  Widget _buatRail() {
    return NavigationRail(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: _pilihTujuan,
      extended: true,
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Beranda'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.miscellaneous_services_outlined),
          selectedIcon: Icon(Icons.miscellaneous_services),
          label: Text('Layanan'),
        ),
        NavigationRailDestination(
          icon: _IkonWargaDenganBadge(
            ikon: Icons.person_outline,
          ),
          selectedIcon: _IkonWargaDenganBadge(
            ikon: Icons.person,
          ),
          label: const Text('Warga'),
        ),
      ],
    );
  }

  Widget _buatDrawer() {
    return NavigationDrawer(
      selectedIndex: _indeksTerpilih,
      onDestinationSelected: (indeks) {
        Navigator.pop(context);
        _pilihTujuan(indeks);
      },
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 16, 16),
          child: Text(
            'Nusantara Cerdas Mobile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Beranda'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.miscellaneous_services_outlined),
          selectedIcon: Icon(Icons.miscellaneous_services),
          label: Text('Layanan'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Warga'),
        ),
        const Divider(indent: 20, endIndent: 20),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Pengaturan Kota'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              AppRoutes.pengaturan,
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Tentang Aplikasi'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              AppRoutes.tentang,
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Keluar'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fitur keluar masih berupa simulasi.',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _IkonWargaDenganBadge extends StatelessWidget {
  const _IkonWargaDenganBadge({
    required this.ikon,
  });

  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    final totalPengajuan =
        context.select<PengajuanModel, int>(
      (model) => model.jumlahPengajuan,
    );

    return Badge(
      isLabelVisible: totalPengajuan > 0,
      label: Text('$totalPengajuan'),
      child: Icon(ikon),
    );
  }
}

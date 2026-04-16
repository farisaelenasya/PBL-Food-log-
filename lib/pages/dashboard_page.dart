import 'package:flutter/material.dart';
import 'health_profile_page.dart';
import 'rewards_page.dart';
import 'edit_profile_page.dart';
import 'blood_sugar_analysis_page.dart';
import 'food_photo_input_page.dart';
import 'meal_history_page.dart';
import 'add_glucose_page.dart';
import 'glucose_history_page.dart';
import 'insulin_tracker_page.dart';
import 'notifikasi_page.dart';
import 'manual_food_log_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _indeksAktif = 0;
  final List<double> _dataGlukosa = [90, 105, 98, 115, 108, 120, 110];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildKartuGlukosa(),
                  const SizedBox(height: 20),
                  _buildAksiCepat(),
                  const SizedBox(height: 20),
                  _buildTipsHarian(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildNavBawah(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage())),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blue[100],
                  child: const Icon(Icons.person, color: Color(0xFF2979FF), size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Senin, 24 Okt', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  const Text('Selamat pagi, Alex', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                ],
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 26),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotifikasiPage())),
                color: const Color(0xFF1A1A2E),
              ),
              Positioned(
                right: 10, top: 10,
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKartuGlukosa() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.07), blurRadius: 20, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kadar Gula Darah', style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                  child: const Row(children: [
                    Icon(Icons.arrow_forward, size: 13, color: Colors.green),
                    SizedBox(width: 4),
                    Text('Normal', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('110', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('mg/dL', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGrafikBatang(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RATA-RATA 7 HARI', style: TextStyle(fontSize: 10, color: Colors.grey[400], letterSpacing: 1, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    const Text('108 mg/dL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF), foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0,
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlucoseHistoryPage())),
                  child: const Text('Lihat Detail', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrafikBatang() {
    final double nilaiMaks = _dataGlukosa.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_dataGlukosa.length, (i) {
          final hariIni = i == _dataGlukosa.length - 1;
          final tinggi = (_dataGlukosa[i] / nilaiMaks) * 70;
          return AnimatedContainer(
            duration: Duration(milliseconds: 400 + i * 80),
            width: 28, height: tinggi,
            decoration: BoxDecoration(
              color: hariIni ? const Color(0xFF2979FF) : const Color(0xFFBBDEFB),
              borderRadius: BorderRadius.circular(6),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAksiCepat() {
    final daftarAksi = [
      {'ikon': Icons.water_drop_outlined, 'warna': const Color(0xFF2979FF), 'bg': const Color(0xFFE3F2FD), 'judul': 'Catat Gula Darah', 'subjudul': 'Entri terakhir: 2 jam lalu', 'halaman': const AddGlucosePage()},
      {'ikon': Icons.vaccines_outlined, 'warna': const Color(0xFF00BFA5), 'bg': const Color(0xFFE0F2F1), 'judul': 'Catatan Insulin', 'subjudul': '8 unit menunggu untuk makan malam', 'halaman': const InsulinTrackerPage()},
      {'ikon': Icons.edit_note_outlined, 'warna': const Color(0xFFFF7043), 'bg': const Color(0xFFFBE9E7), 'judul': 'Catat Makanan Manual', 'subjudul': 'Input makanan tanpa foto', 'halaman': const CatatanMakananManualPage()},
      {'ikon': Icons.emoji_events_outlined, 'warna': const Color(0xFFFFB300), 'bg': const Color(0xFFFFF8E1), 'judul': 'Hadiah & Poin', 'subjudul': '750/1000 poin • Level 5', 'halaman': const RewardsPage()},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Aksi Cepat', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF2979FF), fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...daftarAksi.map((aksi) => _buildKartuAksi(aksi)),
        ],
      ),
    );
  }

  Widget _buildKartuAksi(Map<String, dynamic> aksi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: aksi['bg'] as Color, borderRadius: BorderRadius.circular(12)),
          child: Icon(aksi['ikon'] as IconData, color: aksi['warna'] as Color, size: 22),
        ),
        title: Text(aksi['judul'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A1A2E))),
        subtitle: Text(aksi['subjudul'] as String, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => aksi['halaman'] as Widget)),
      ),
    );
  }

  Widget _buildTipsHarian() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF2979FF), Color(0xFF448AFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tips Harian', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 3),
                  Text('Berjalan 15 menit setelah makan dapat membantu menstabilkan kadar gula darah Anda.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBawah() {
    final daftarMenu = [
      {'ikon': Icons.home_rounded, 'label': 'Beranda'},
      {'ikon': Icons.bar_chart_rounded, 'label': 'Laporan'},
      {'ikon': null, 'label': 'Tambah'},
      {'ikon': Icons.history_rounded, 'label': 'Riwayat'},
      {'ikon': Icons.person_outline_rounded, 'label': 'Profil'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(daftarMenu.length, (i) {
          if (i == 2) {
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodPhotoInputPage())),
              child: Container(
                width: 52, height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF2979FF), shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Color(0x442979FF), blurRadius: 12, offset: Offset(0, 4))],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            );
          }

          final aktif = _indeksAktif == i;
          final halamanTujuan = [null, const BloodSugarAnalysisPage(), null, const MealHistoryPage(), const HealthProfilePage()];

          return GestureDetector(
            onTap: () {
              setState(() => _indeksAktif = i);
              if (halamanTujuan[i] != null) Navigator.push(context, MaterialPageRoute(builder: (_) => halamanTujuan[i]!));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(daftarMenu[i]['ikon'] as IconData, color: aktif ? const Color(0xFF2979FF) : Colors.grey[400], size: 24),
                const SizedBox(height: 3),
                Text(daftarMenu[i]['label'] as String,
                  style: TextStyle(fontSize: 10, color: aktif ? const Color(0xFF2979FF) : Colors.grey[400],
                    fontWeight: aktif ? FontWeight.w600 : FontWeight.normal)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
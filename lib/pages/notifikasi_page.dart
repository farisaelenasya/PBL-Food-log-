import 'package:flutter/material.dart';
import '../models/medication_store.dart';
import '../models/medication_entry.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final _store = MedicationStore();

  String _formatWaktu(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  @override
  Widget build(BuildContext context) {
    final daftarObat = _store.semuaObat;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifikasi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
        centerTitle: true,
        actions: [
          if (daftarObat.isNotEmpty)
            TextButton(
              onPressed: () {},
              child: const Text('Tandai Semua', style: TextStyle(color: Color(0xFF2979FF), fontSize: 12)),
            ),
        ],
      ),
      body: daftarObat.isEmpty
          ? _buildKosong()
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 8),

                // Header section Jadwal Obat
                _buildSectionHeader('🔔 Pengingat Obat', '${daftarObat.length} aktif'),
                const SizedBox(height: 10),

                // Daftar obat sebagai notifikasi
                ...daftarObat.map((obat) => _buildKartuNotifObat(obat)),

                const SizedBox(height: 20),

                // Section sistem (contoh statis)
                _buildSectionHeader('ℹ️ Info Kesehatan', ''),
                const SizedBox(height: 10),
                _buildNotifInfo(
                  'Tips Hari Ini',
                  'Jalan kaki 15 menit setelah makan dapat membantu menstabilkan gula darah.',
                  Icons.lightbulb_outline,
                  const Color(0xFFFFF8E1),
                  Colors.orange,
                  '1 jam lalu',
                ),
                _buildNotifInfo(
                  'Cek Gula Darah',
                  'Sudah waktunya mengecek kadar gula darah Anda.',
                  Icons.water_drop_outlined,
                  const Color(0xFFE3F2FD),
                  const Color(0xFF2979FF),
                  '3 jam lalu',
                ),

                const SizedBox(height: 80),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String judul, String sub) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(judul, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
        if (sub.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF2979FF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF2979FF), fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _buildKartuNotifObat(MedicationEntry obat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2979FF).withValues(alpha: 0.15)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.medication_rounded, color: Color(0xFF2979FF), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(obat.namaObat,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                      ),
                      Text(_formatWaktu(obat.dibuatPada),
                        style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${obat.dosis} • ${obat.frekuensi}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined, size: 13, color: Color(0xFF2979FF)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(obat.waktuKonsumsi,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF2979FF), fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  if (obat.catatan.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(obat.catatan,
                      style: TextStyle(fontSize: 11, color: Colors.grey[400], fontStyle: FontStyle.italic),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _tombolAksi('✓ Sudah Diminum', const Color(0xFF2979FF), const Color(0xFFE8F0FE)),
                      const SizedBox(width: 8),
                      _tombolAksi('Tunda', Colors.grey[600]!, Colors.grey[100]!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tombolAksi(String label, Color warnaTeks, Color warnaBg) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: warnaBg, borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(fontSize: 12, color: warnaTeks, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildNotifInfo(String judul, String isi, IconData ikon, Color bg, Color warnaIkon, String waktu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(13)),
              child: Icon(ikon, color: warnaIkon, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(judul, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                      Text(waktu, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(isi, style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKosong() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Belum ada notifikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[400])),
          const SizedBox(height: 8),
          Text('Tambahkan obat di Catatan Insulin\nuntuk menerima pengingat.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[400], height: 1.5)),
        ],
      ),
    );
  }
}
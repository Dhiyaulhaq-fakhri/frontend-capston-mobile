
import 'package:flutter/material.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  final Color hijau = const Color(0xFF006B3F);

  int bulan = 11;
  int tahun = 2026;
  int tanggalDipilih = 10;

  final List<String> namaBulan = [
    'Januari', 'Februari', 'Maret', 'April',
    'Mei', 'Juni', 'Juli', 'Agustus',
    'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    int jumlahHari = DateTime(tahun, bulan + 1, 0).day;
    int hariPertama = DateTime(tahun, bulan, 1).weekday;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        title: const Text(
          'Kalender Ibadah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: hijau,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // KARTU HIJRAH
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: hijau,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KALENDER ISLAM',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '10 Dzulhijjah 1446 H',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Hari Raya Idul Adha',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Mari tingkatkan ibadah dan ketakwaan '
                    'kepada Allah SWT.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Kalender Bulanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // PILIH BULAN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      bulan--;
                      if (bulan < 1) {
                        bulan = 12;
                        tahun--;
                      }
                      tanggalDipilih = 1;
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),

                Text(
                  '${namaBulan[bulan - 1]} $tahun',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      bulan++;
                      if (bulan > 12) {
                        bulan = 1;
                        tahun++;
                      }
                      tanggalDipilih = 1;
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),

            // NAMA HARI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'
              ].map((hari) {
                return Text(
                  hari,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 15),

            // TANGGAL KALENDER
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (hariPertama - 1) + jumlahHari,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                int tanggal = index - hariPertama + 2;

                if (tanggal < 1 || tanggal > jumlahHari) {
                  return const SizedBox();
                }

                bool aktif = tanggal == tanggalDipilih;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tanggalDipilih = tanggal;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: aktif
                          ? hijau
                          : const Color(0xFFE6F2EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '$tanggal',
                        style: TextStyle(
                          color: aktif ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // PENGINGAT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F2EB),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notifications_active,
                      color: Color(0xFF006B3F)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Jangan lupa menjalankan ibadah '
                      'dan amalan sunnah hari ini.',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Agenda Hari Besar Islam',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            agenda('1 Muharram', 'Tahun Baru Islam'),
            agenda('12 Rabiul Awal', 'Maulid Nabi Muhammad SAW'),
            agenda('27 Rajab', 'Isra Mi’raj'),
            agenda('10 Dzulhijjah', 'Hari Raya Idul Adha'),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFECEEFF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Icon(Icons.menu_book,
                      size: 35, color: Color(0xFF006B3F)),
                  SizedBox(height: 10),
                  Text(
                    'Amalan dan Tips Sunnah',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pelajari berbagai amalan sunnah '
                    'untuk meningkatkan kualitas ibadah.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget agenda(String tanggal, String judul) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tanggal,
            style: const TextStyle(
              color: Color(0xFF006B3F),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            judul,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

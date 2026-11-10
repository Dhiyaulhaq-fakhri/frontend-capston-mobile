// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class TrendhargaPage extends StatefulWidget {
  const TrendhargaPage({super.key});

  @override
  State<TrendhargaPage> createState() => _TrendhargaPageState();
}

class _TrendhargaPageState extends State<TrendhargaPage> {
  // Warna Utama
  final Color primaryGreen = const Color(0xFF006B3F);
  final Color bgColor = const Color(0xFFF3F6FF); // Warna background ungu kebiruan
  final Color cardColor = Colors.white;

  // State Hewan yang dipilih (0=Sapi, 1=Kambing, 2=Domba, 3=Kerbau)
  int _selectedAnimalIndex = 0;

  // State Mode (0=Bobot Timbangan, 1=Peta Ukur)
  int _selectedModeIndex = 0;

  // State Bobot (Slider)
  double _currentWeight = 380;

    final List<Map<String, dynamic>> _animalData = [
    {
      'name': 'Sapi',
      'icon': '🐄', // Emoji Sapi
      'unggulan': 'Simental / Limo',
      'hargaUnggulan': 'Rp 72rb – 78rb',
      'lokal': 'Bali / Madura',
      'hargaLokal': 'Rp 65rb – 70rb',
      'rataRata': '380 - 650 kg',
      'minWeight': 200,
      'maxWeight': 800,
    },
    {
      'name': 'Kambing',
      'icon': '🐐', // Emoji Kambing
      'unggulan': 'Boer / Etawa',
      'hargaUnggulan': 'Rp 55rb – 60rb',
      'lokal': 'Kacang / Jawarandu',
      'hargaLokal': 'Rp 45rb – 50rb',
      'rataRata': '25 - 60 kg',
      'minWeight': 10,
      'maxWeight': 100,
    },
    {
      'name': 'Domba',
      'icon': '🐑', // Emoji Domba
      'unggulan': 'Garut / Merino',
      'hargaUnggulan': 'Rp 60rb – 65rb',
      'lokal': 'Ekor Tipis',
      'hargaLokal': 'Rp 50rb – 55rb',
      'rataRata': '30 - 70 kg',
      'minWeight': 15,
      'maxWeight': 120,
    },
    {
      'name': 'Kerbau',
      'icon': '🐃', // Emoji Kerbau
      'unggulan': 'Sumbawa / Murrah',
      'hargaUnggulan': 'Rp 60rb – 65rb',
      'lokal': 'Lokal / Rawa',
      'hargaLokal': 'Rp 55rb – 60rb',
      'rataRata': '350 - 600 kg',
      'minWeight': 200,
      'maxWeight': 700,
    },
  ];

  // Fungsi Hitung Harga Estimasi (Simulasi)
  String _hitungEstimasiHarga() {
    // Ambil harga rata-rata dari data hewan
    double hargaPerKg = 75000; // Default (sapi unggulan)
    if (_selectedAnimalIndex == 1) hargaPerKg = 55000;
    if (_selectedAnimalIndex == 2) hargaPerKg = 60000;
    if (_selectedAnimalIndex == 3) hargaPerKg = 62000;

    double totalMin = _currentWeight * hargaPerKg;
    double totalMax = totalMin + 500000; // Range harga

    // Format ke Rupiah
    String formatRupiah(double value) {
      return "Rp " + value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }

    return '${formatRupiah(totalMin)}  –  ${formatRupiah(totalMax)}';
  }

  @override
  Widget build(BuildContext context) {
    final animal = _animalData[_selectedAnimalIndex];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text("Trendharga", style: TextStyle(color: Color(0xFF006B3F), fontWeight: FontWeight.bold, fontSize: 20)),
            Text("Lihat harga pasar hewan ternak sekarang", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. TAB HEWAN ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDFF), // Biru muda
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (index) {
                  final bool isSelected = _selectedAnimalIndex == index;
                  final data = _animalData[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAnimalIndex = index;
                        // Reset bobot ke tengah saat ganti hewan
                        _currentWeight = (data['minWeight'] + data['maxWeight']) / 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : [],
                      ),
                      child: Column(
                        children: [
                            Text(
                            data['icon'] as String, // Kita panggil Emoji-nya
                            style: TextStyle(
                              fontSize: 24, // Ukuran emoji
                              // Jika emoji aslinya berwarna, color ini tidak akan ngefek
                              // Tapi jika kita pakai emoji teks biasa (monokrom), ini akan berfungsi
                              color: isSelected ? primaryGreen : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4,),
                          // --- BAGIAN BAWAH: NAMA HEWAN ---
                          Text(
                            data['name'] as String, // Memanggil teks 'Sapi', 'Kambing', dll
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // --- 2. HARGA PASAR (2 CARD) ---
            Row(
              children: [
                Expanded(
                  child: _buildPriceCard(
                    title: "TIPE UNGGULAN",
                    ras: animal['unggulan'],
                    harga: animal['hargaUnggulan'],
                    rataRata: animal['rataRata'],
                    icon: Icons.settings,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPriceCard(
                    title: "TIPE LOKAL",
                    ras: animal['lokal'],
                    harga: animal['hargaLokal'],
                    rataRata: animal['rataRata'],
                    icon: Icons.eco,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 3. KALKULATOR ---
            const Text("Kalkulator Bobot & Taksiran Nilai Wajar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text("Hitung bobot karkas dan cek kewajaran penawaran peternak", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),

            // Toggle Mode
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: const Color(0xFFE8EDFF), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  _buildModeButton("Bobot Timbangan", 0, Icons.scale),
                  _buildModeButton("Peta Ukur (Winter)", 1, Icons.map),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Form Kalkulator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Jenis Ternak & Ras", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${animal['name']} ${animal['unggulan']}", style: const TextStyle(fontSize: 13)),
                        const Icon(Icons.chevron_right, size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Slider Bobot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bobot Ternak Hidup", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFE8EDFF), borderRadius: BorderRadius.circular(4)),
                        child: Text("${_currentWeight.toStringAsFixed(0)} kg", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      )
                    ],
                  ),
                  Slider(
                    value: _currentWeight,
                    min: animal['minWeight'].toDouble(),
                    max: animal['maxWeight'].toDouble(),
                    activeColor: primaryGreen,
                    onChanged: (value) {
                      setState(() {
                        _currentWeight = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${animal['name']} (${animal['minWeight']} kg)", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      Text("Standar (300 kg)", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      Text("Jumbo (800 kg)", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Hasil Estimasi
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("HASIL TAKSIRAN OTOMATIS", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)),
                              child: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 10),
                                  SizedBox(width: 4),
                                  Text("Sesuai Standar Pasar", style: TextStyle(color: Colors.green, fontSize: 9)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text("Estimasi Nilai Wajar Hewan", style: TextStyle(fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(_hitungEstimasiHarga(), style: TextStyle(color: primaryGreen, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol Cari
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE67E22), // Oranye
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Cari Hewan Sesuai Bobot di Katalog", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 4. FOOTER BANTUAN ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFE8EDFF), borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFF006B3F), shape: BoxShape.circle),
                        child: const Icon(Icons.support_agent, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ragu dengan Hasil Timbangan?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF172238))),
                            SizedBox(height: 4),
                            Text("Konsultasikan video live timbang digital langsung bersama tim dokter hewan & peternak mitra kami.", style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4C2C), // Hijau tua
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text("Konsultasi Estimasi Hewan ke Peternak Mitra", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildPriceCard({
    required String title,
    required String ras,
    required String harga,
    required String rataRata,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Icon(icon, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Text(ras, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(harga, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text("per kg hidup", style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.scale, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Rata-rata $rataRata", style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String text, int index, IconData icon) {
    final bool isSelected = _selectedModeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            // Jika yang diklik Peta Ukur, munculkan dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Fitur Segera Menyusul"),
                content: const Text("Fitur Peta Ukur (Winter) sedang dalam pengembangan. Silakan gunakan Bobot Timbangan terlebih dahulu."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK", style: TextStyle(color: primaryGreen)),
                  ),
                ],
              ),
            );
            // Kembalikan mode ke Bobot Timbangan
            setState(() {
              _selectedModeIndex = 0;
            });
          } else {
            setState(() {
              _selectedModeIndex = index;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.black : Colors.grey, size: 16),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
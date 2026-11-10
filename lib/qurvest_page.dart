import 'package:flutter/material.dart';

class QurvestPage extends StatefulWidget {
  const QurvestPage({super.key});

  @override
  State<QurvestPage> createState() => _QurvestPageState();
}

class _QurvestPageState extends State<QurvestPage> {
  // Warna Utama
  final Color primaryGreen = const Color(0xFF1B5E20); // Hijau Gelap
  final Color lightGreen = const Color(0xFFE8F5E9); // Hijau Sangat Muda
  final Color bgColor = const Color(0xFFF8F9FA); 

  // State untuk Tab Fitur (Transaksi Aman, dll)
  int _selectedFeatureIndex = 0;

  // State untuk Filter Skema (Semua Skema, Penggemukan, dll)
  int _selectedSchemeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text("Qurvest", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 22)),
            const Text("Investasi Ternak, Berkah untuk Masa Depan", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. BANNER UTAMA ---
            Container(
              decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mulai Qurvest\nSekarang!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.1)),
                        const SizedBox(height: 8),
                        const Text("Tanam modal, rawat bersama,\npetik hasilnya.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Text("Lihat Cara Kerja", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Gambar Kambing & Badge Mulai
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1524024973431-2ad916746881?q=80&w=200&auto=format&fit=crop',
                          width: 100,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), topLeft: Radius.circular(8))),
                        child: Row(
                          children: const [
                            Icon(Icons.play_circle_outline, color: Colors.green, size: 12),
                            SizedBox(width: 4),
                            Text("Mulai dari\nRp 1Jt", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 2. FITUR SCROLLABLE (4 Tombol) ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFeaturePill("Transaksi Aman &\nTerpercaya", Icons.verified_user, 0),
                  _buildFeaturePill("Pemeliharaan\nTransparan", Icons.assignment_turned_in, 1),
                  _buildFeaturePill("Hasil Sesuai\nKesepakatan", Icons.handshake, 2),
                  _buildFeaturePill("Diawasi Syariah", Icons.mosque, 3), // Tambahan
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 3. PILIH MODEL SKEMA ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.dashboard_customize, size: 20),
                    const SizedBox(width: 8),
                    const Text("Pilih Model Skema Investasi Ternak", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                Text("Akad Syariah", style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            const Text("Sesuaikan profil risiko, durasi, dan akad syariah.", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            
            // Filter Skema (Scrollable)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSchemeChip("Semua Skema", 0),
                  _buildSchemeChip("Penggemukan", 1),
                  _buildSchemeChip("Rawat Anakan", 2),
                  _buildSchemeChip("Pembiakan", 3),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Card Panduan Model
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7F2),
                border: Border.all(color: lightGreen),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book, color: primaryGreen, size: 16),
                      const SizedBox(width: 6),
                      const Text("Panduan Model Investasi QRvest", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildPanduanItem("Penggemukan (Fathening)", "Fokus bobot cepat 3-6 bulan jeling usia/bulan. Target penjualan daging kurban berganasi.")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildPanduanItem("Rawat Anakan & Indukan", "Investasi bibit muda & induk 6-12 bulan. Margin akumulatif + dividen anak lahir.")),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 4. PILIHAN PROGRAM ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pilihan Program Investasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: const [
                    Text("Lihat Semua", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Icon(Icons.chevron_right, size: 16),
                  ],
                )
              ],
            ),
            const Text("Tersedia 2 skema aktif berganasi mitra peternak", style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 12),

            // List Program 1
            _buildProgramCard(
              imageUrl: 'https://images.unsplash.com/photo-1484557985045-edf25e08da73?q=80&w=200&auto=format&fit=crop',
              badge1: "Bibit Muda Unggul",
              badge2: "Akad Mudharabah",
              title: "Rawat Cempe Domba Priangan",
              desc: "Investasi pembesaran cempe lepas sapih hingga siap jual dengan margin tinggi.",
              durasi: "8 Bulan",
              est: "Est. +28%",
              modal: "Rp 350.000",
            ),
            const SizedBox(height: 12),

            // List Program 2
            _buildProgramCard(
              imageUrl: 'https://images.unsplash.com/photo-1524024973431-2ad916746881?q=80&w=200&auto=format&fit=crop',
              badge1: "Bagi Hasil Anakan",
              badge2: "Akad Musyarakah",
              title: "Pembiakan Induk Kambing Etawa Unggul",
              desc: "Investasi indukan bunting dengan garansi kelahiran dan dividen berkala dari anakan.",
              durasi: "12 Bulan",
              est: "Dividen Anakan",
              modal: "Rp 750.000",
            ),
            const SizedBox(height: 24),

            // --- 5. PORTOFOLIO SAYA ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.account_balance_wallet, color: primaryGreen, size: 16),
                    ),
                    const SizedBox(width: 8),
                    const Text("Portofolio Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Row(
                  children: const [
                    Text("Lihat Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Icon(Icons.chevron_right, size: 16),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Investasi Aktif", style: TextStyle(color: Colors.white70, fontSize: 11)),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Text("Rp 2.500.000", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 14),
                            Text("+12%", style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Hewan yang Dikelola", style: TextStyle(color: Colors.white70, fontSize: 11)),
                        SizedBox(height: 4),
                        Text("2 Ekor", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Mulai Investasi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text("Mulai Investasi Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Tombol Fitur (Bisa diklik & berubah warna)
  Widget _buildFeaturePill(String text, IconData icon, int index) {
    bool isSelected = _selectedFeatureIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFeatureIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : primaryGreen),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Chip Filter Skema
  Widget _buildSchemeChip(String text, int index) {
    bool isSelected = _selectedSchemeIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSchemeIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            if (text == "Semua Skema") 
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.grid_view, size: 14, color: isSelected ? Colors.white : Colors.black87),
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Item Panduan
  Widget _buildPanduanItem(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          ],
        ),
        const SizedBox(height: 4),
        Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 10, height: 1.3)),
      ],
    );
  }

  // Kartu Program Investasi
  Widget _buildProgramCard({
    required String imageUrl,
    required String badge1,
    required String badge2,
    required String title,
    required String desc,
    required String durasi,
    required String est,
    required String modal,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(imageUrl, width: 90, height: 120, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(4)),
                            child: Text(badge1, style: TextStyle(color: primaryGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 4),
                          Text(badge2, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2)),
                      const SizedBox(height: 4),
                      Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 10, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(durasi, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)),
                            child: Text(est, style: TextStyle(color: primaryGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mulai dari", style: TextStyle(color: Colors.grey, fontSize: 11)),
                Text(modal, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
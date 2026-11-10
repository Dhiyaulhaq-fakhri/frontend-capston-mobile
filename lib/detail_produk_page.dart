import 'package:flutter/material.dart';
import 'package:frontend_capston/chat_page.dart';
import 'package:frontend_capston/kandang_page.dart';
// import 'kandang_page.dart'; // Nanti jika halaman kandang sudah ada
// import 'chat_page.dart';    // Nanti jika halaman chat sudah ada

class DetailProdukPage extends StatelessWidget {
  const DetailProdukPage({super.key});

  // Warna Utama
  final Color primaryGreen = const Color(0xFF1B5E20);
  final Color darkGreen = const Color(0xFF0B3D20);
  final Color bgColor = const Color(0xFFF8F9FA);

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
            Text("Detail", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
            const Text("Detail hewan kurban", style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
      
      // Tombol Beli Sekarang (Sticky di bawah)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Aksi Beli Sekarang
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Lanjut ke halaman pembayaran...")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B), // Warna Emas/Cokelat
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Beli Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20), // Padding bawah agar tidak tertutup tombol
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. GAMBAR PRODUK ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?q=80&w=800&auto=format&fit=crop',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(20)),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text("Siap Qurban", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 2. JUDUL & HARGA ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sapi Limousin Super Grade A", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rp 28.500.000", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(20)),
                        child: const Text("Sapi 7 Jiwa >", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 3. SPESIFIKASI & KARAKTERISTIK ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Spesifikasi & Karakteristik", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildSpecBox("JENIS HEWAN", "🐂 Ras Limousin", "Keturunan Unggul")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSpecBox("BOBOT HIDUP", "⚖️ 420 kg", "Timbang Aktual Digital")),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildSpecBox("UMUR TERNAK", "📅 2 Thn 6 Bulan", "Kupak 2 (Sah Kurban)")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSpecBox("JENIS KELAMIN", "♂️ Jantan", "Testis Simetris & Sehat")),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Kondisi Fisik & Sanitasi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.health_and_safety, color: primaryGreen, size: 20),
                            const SizedBox(width: 8),
                            const Text("Kondisi Fisik & Sanitasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Sangat prima, mata jernih berbinar, cermin hidung basah alami, bebas PMK & LSD, kuku kokoh tidak pincang, nafsu makan konsentrat tinggi.",
                          style: TextStyle(color: Colors.black87, fontSize: 12, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              const Icon(Icons.description, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              const Expanded(child: Text("SKKH No. 524/DISNAK/2024", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                              Text("Lihat Surat ↗", style: TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 4. PATUNGAN SAPI ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1546445317-29f4545e9d53?q=80&w=200&auto=format&fit=crop',
                        width: 80, height: 80, fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Patungan sapi bisa 2 sampai 7 sohibul qurban", style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text("Coba Sekarang", style: TextStyle(color: Colors.white, fontSize: 11)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 5. PETERNAK TERVERIFIKASI ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("PETERNAK TERVERIFIKASI (MITRA AMANAH)", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                          child: Text("BF", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Berkah Farm Mandiri", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(width: 4),
                                  Icon(Icons.verified, color: primaryGreen, size: 16),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Row(
                                children: [
                                  Text("⭐ 4.9", style: TextStyle(color: Color(0xFFFFA726), fontSize: 12, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Text("•  128 Transaksi Sukses", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // TOMBOL KUNJUNGI & CHAT
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Navigasi ke halaman Kandang
                              _navigateToKandang(context);
                            },
                            icon: const Icon(Icons.storefront, size: 16),
                            label: const Text("Kunjungi Kandang"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: darkGreen,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Navigasi ke halaman Chat
                              _navigateToChat(context);
                            },
                            icon: const Icon(Icons.chat_bubble_outline, size: 16),
                            label: const Text("Chat Peternak"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: darkGreen,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 6. GARANSI AKAD AMANAH ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.verified_user, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Garansi Akad Amanah 100%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text("Penggantian hewan sepadan bila terjadi sakit atau cacat sebelum hari H qurban.", style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---
  
  Widget _buildSpecBox(String label, String value, String subValue) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          Text(subValue, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  // Fungsi Navigasi ke Kandang
  void _navigateToKandang(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const KandangPage()));
  }

  // Fungsi Navigasi ke Chat
  void _navigateToChat(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
  }
}
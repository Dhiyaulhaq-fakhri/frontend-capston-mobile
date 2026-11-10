import 'package:flutter/material.dart';
import 'chat_page.dart'; // Import halaman chat yang tadi kita buat

class KandangPage extends StatefulWidget {
  const KandangPage({super.key});

  @override
  State<KandangPage> createState() => _KandangPageState();
}

class _KandangPageState extends State<KandangPage> {
  // Warna Utama
  final Color primaryGreen = const Color(0xFF0F5D3B); // Hijau Gelap
  final Color lightGreen = const Color(0xFFE8F5E9); // Hijau Muda
  final Color bgColor = const Color(0xFFF8F9FA);

  // State untuk Filter Ternak
  int _selectedFilterIndex = 0;

  // State untuk Tombol Ikuti
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. HEADER GAMBAR KANDANG ---
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=800&auto=format&fit=crop', // Gambar sawah/kandang
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- 2. CARD PROFIL TOKO (NEMPEL DI ATAS GAMBAR) ---
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'resources/Image_Shadow.png',
                              width: 60, height: 60, fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Berkah Farm Jonggol", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(width: 4),
                                    Icon(Icons.verified, color: primaryGreen, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text("H. Ridwan Sudrajat • Jonggol, Kab. Bogor", style: TextStyle(color: Colors.grey, fontSize: 11)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isFollowing = !_isFollowing;
                                });
                              },
                              icon: Icon(_isFollowing ? Icons.check : Icons.person_add_alt_1, size: 14, color: Colors.white),
                              label: Text(_isFollowing ? "Diikuti" : "Ikuti", style: const TextStyle(fontSize: 11, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFollowing ? Colors.grey : primaryGreen,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(height: 24),
                      // Statistik
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("⭐ 4.9", "(1.2k)"),
                          _buildStatItem("3.4k", "Terjual"),
                          _buildStatItem("99.8%", "Sukses"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            // --- 3. BADGE SERTIFIKASI ---
            Transform.translate(
              offset: const Offset(0, -20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildCertificationChip("SKKH Bebas PMK", Icons.health_and_safety),
                    const SizedBox(width: 8),
                    _buildCertificationChip("Juleha & MUI Sah", Icons.verified_user),
                    const SizedBox(width: 8),
                    _buildCertificationChip("Hijauan C...", Icons.eco),
                  ],
                ),
              ),
            ),

            // --- 4. FILTER TABS (Scrollable & Interaktif) ---
            Transform.translate(
              offset: const Offset(0, -10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterTab("Semua Ternak (48)", 0),
                    _buildFilterTab("Sapi Kurban (18)", 1),
                    _buildFilterTab("Kambing & Domba (30)", 2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // --- 5. LIST PRODUK (GRID 2 KOLOM) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Hewan Kurban Siap Akad", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("48 Pilihan", style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Agar ikut scroll parent
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, // Menyesuaikan tinggi card
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProductGrid(
                  imageUrl: 'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?q=80&w=400&auto=format&fit=crop',
                  title: "Simental Grade A",
                  price: "22.4 Jt",
                  sub: "Patungan 3.2 Jt",
                  badgeWeight: "420.5 kg",
                  buttonText: "Pilih / Slot",
                  isPrimaryButton: true,
                ),
                _buildProductGrid(
                  imageUrl: 'https://images.unsplash.com/photo-1546445317-29f4545e9d53?q=80&w=400&auto=format&fit=crop',
                  title: "Limousin Kontes",
                  price: "31.5 Jt",
                  sub: "Siap Kirim",
                  badgeWeight: "552.0 kg",
                  buttonText: "Beli Sekarang",
                  isPrimaryButton: true,
                ),
                _buildProductGrid(
                  imageUrl: 'https://images.unsplash.com/photo-1484557985045-edf25e08da73?q=80&w=400&auto=format&fit=crop',
                  title: "Garut Tanduk Mewah",
                  price: "4.25 Jt",
                  sub: "Bebas Ongkir",
                  badgeWeight: "42 kg",
                  buttonText: "Pilih Hewan",
                  isPrimaryButton: false,
                ),
                _buildProductGrid(
                  imageUrl: 'https://images.unsplash.com/photo-1524024973431-2ad916746881?q=80&w=400&auto=format&fit=crop',
                  title: "Etawa Musinnah Sah",
                  price: "3.65 Jt",
                  sub: "Cukup Umur",
                  badgeWeight: "38 kg",
                  buttonText: "Pilih Hewan",
                  isPrimaryButton: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 6. ULASAN SHOHIBUL ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Ulasan Shohibul ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Text(" 4.9", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
                    ],
                  ),
                  Text("Lihat Semua", style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("dr. Fauzan Al-Banjari", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Row(
                          children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 14)),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('"Alhamdulillah amanah. Video akad dan penyembelihan Juleha tepat waktu, daging sampai bersih berpendingin ke..."', style: TextStyle(color: Colors.black87, fontSize: 12, height: 1.4)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 7. LOKASI KANDANG ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.storefront, color: primaryGreen, size: 20)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kunjungan Kandang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text("Jl. Raya Sukamakmur N...", style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Membuka Google Maps...")));
                      },
                      icon: const Icon(Icons.near_me, size: 14),
                      label: const Text("Peta", style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(foregroundColor: primaryGreen, side: BorderSide(color: Colors.grey.shade300)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // --- 8. BOTTOM NAVIGATION (CHAT & KUNJUNGI) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Arahkan ke Halaman Chat
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                  },
                  icon: Icon(Icons.chat_bubble_outline, color: primaryGreen, size: 18),
                  label: Text("Chat Penjual", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Membuka detail kandang...")));
                  },
                  icon: const Icon(Icons.location_on, color: Colors.white, size: 18),
                  label: const Text("Kunjungi Kandang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildCertificationChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: primaryGreen),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid({
    required String imageUrl,
    required String title,
    required String price,
    required String sub,
    required String badgeWeight,
    required String buttonText,
    required bool isPrimaryButton,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar & Badge Bobot
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                  child: Text(badgeWeight, style: const TextStyle(color: Colors.white, fontSize: 9)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(sub, style: TextStyle(color: Colors.grey, fontSize: 9)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: isPrimaryButton
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 11)),
                        )
                      : OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: Text(buttonText, style: const TextStyle(color: Colors.black87, fontSize: 11)),
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
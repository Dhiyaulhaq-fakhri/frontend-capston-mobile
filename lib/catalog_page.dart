import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  // Warna Utama
  final Color primaryGreen = const Color(0xFF006B3F);
  final Color darkGreen = const Color(0xFF0F4C2C);
  final Color bgColor = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari hewan Qurban (Kambing, Sapi,...",
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FILTER CHIPS (Semua, Kambing, Domba, dll) ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildChip("Semua", true),
                  _buildChip("Kambing", false),
                  _buildChip("Domba", false),
                  _buildChip("Sapi", false),
                  _buildChip("Kerbau", false),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- BANNER THRENDHARGA ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA726), // Oranye
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.trending_up, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text("Threndharga", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Cek Fair Value Hewan Qurban",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Hitung estimasi harga pasar wajar secara instan berdasarkan algoritma bobot riil, usia powel, trah bibit, dan fluktuasi regional.",
                    style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5A00), // Cokelat gelap
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Cek Harga Pasar Ternak →", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- FILTER DROPDOWN (Jadobetabek, Bobot) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDropdown("Jadobetabek", Icons.location_on_outlined),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDropdown("Bobot (kg)", Icons.scale_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- HEADER KATALOG (Menampilkan Siap Qurban, Rekomendasi) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Menampilkan Siap Qurban", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Row(
                    children: const [
                      Text("Rekomendasi ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Icon(Icons.swap_vert, size: 16),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- LIST PRODUK ---
            _buildProductCard(
              imageUrl: "https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?q=80&w=600&auto=format&fit=crop",
              badgeText: "Siap Qurban",
              badgeIcon: Icons.check_circle_outline,
              category: "SAPI • GRADE A SUPER",
              title: "Sapi Limousin Super Grade A",
              weight: "420 kg",
              age: "2.5 Thn",
              type: "Sapi", // Sesuai gambar (agak aneh tapi ikutin gambar)
              seller: "Peternak Berkah Farm",
              location: "Bogor, Jabar",
              price: "Rp 28.500.000",
            ),
            const SizedBox(height: 16),

            _buildProductCard(
              imageUrl: "https://images.unsplash.com/photo-1484557985045-edf25e08da73?q=80&w=600&auto=format&fit=crop",
              badgeText: "Bisa Rawat Ternak",
              badgeIcon: Icons.home_outlined,
              category: "DOMBA • PRIANGAN TANDUK",
              title: "Domba Garut Tanduk Mewah",
              weight: "45 kg",
              age: "1.8 Thn",
              type: "Kambing",
              seller: "Sentra Domba Priangan",
              location: "Garut, Jabar",
              price: "Rp 4.200.000",
            ),
            const SizedBox(height: 16),
            
            _buildProductCard(
              imageUrl: "https://images.unsplash.com/photo-1524024973431-2ad916746881?q=80&w=600&auto=format&fit=crop",
              badgeText: "Estimasi ML Sesuai Pasar",
              badgeIcon: Icons.auto_awesome,
              category: "KAMBING • PEDAGING SUPER",
              title: "Kambing Boer Pedaging",
              weight: "55 kg",
              age: "2.0 Thn",
              type: "Kambing",
              seller: "Berkah Jaya Ternak",
              location: "Bekasi, Jabar",
              price: "Rp 3.850.000",
            ),
            const SizedBox(height: 16),

             _buildProductCard(
              imageUrl: "https://images.unsplash.com/photo-1546445317-29f4545e9d53?q=80&w=600&auto=format&fit=crop",
              badgeText: "Siap Qurban",
              badgeIcon: Icons.check_circle_outline,
              category: "KERBAU • SUMBAWA UNGGUL",
              title: "Kerbau Sumbawa Jantan",
              weight: "380 kg",
              age: "3.0 Thn",
              type: "Kerbau",
              seller: "Peternakan Nusantara",
              location: "Tangerang, Banten",
              price: "Rp 24.000.000",
            ),
            
            const SizedBox(height: 30), // Spasi bawah
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryGreen : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildDropdown(String text, IconData icon) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFC8F5D2), // Hijau muda
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: primaryGreen),
              const SizedBox(width: 6),
              Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String imageUrl,
    required String badgeText,
    required IconData badgeIcon,
    required String category,
    required String title,
    required String weight,
    required String age,
    required String type,
    required String seller,
    required String location,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar & Badge Atas
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF0F4C2C), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(badgeIcon, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(badgeText, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border, size: 18, color: Colors.grey),
                ),
              ),
            ],
          ),
          
          // Info Produk
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategori & Dot
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(category, style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),

                // Box Spesifikasi (Bobot, Usia, Kategori)
                Row(
                  children: [
                    Expanded(child: _buildSpecBox("Bobot Riil", weight)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSpecBox("Usia Powel", age)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSpecBox("Kategori", type)),
                  ],
                ),
                const SizedBox(height: 12),

                // Seller & Lokasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storefront, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(seller, style: TextStyle(color: Colors.grey[700], fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(location, style: TextStyle(color: Colors.grey[700], fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Harga & Tombol
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("HARGA AKAD NETTO", style: TextStyle(color: Colors.grey[500], fontSize: 9, fontWeight: FontWeight.bold)),
                        Text(price, style: TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Lihat Detail >", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Abu-abu terang
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:frontend_capston/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qurban App Layout',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Background abu-abu muda
        fontFamily: 'Inter', // Disarankan pakai font Inter/Poppins
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Warna Utama
  final Color primaryGreen = const Color(0xFF1B5E20); // Hijau tua
  final Color softOrange = const Color(0xFFFFA726);  // Oranye

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. Header (Alamat & Notifikasi)
            SliverToBoxAdapter(child: _buildHeader(context)),

            // 2. Search Bar
            SliverToBoxAdapter(child: _buildSearchBar()),

            // 3. Banner Promo (Persiapan Qurban)
            SliverToBoxAdapter(child: _buildBannerPromo()),

            // 4. Menu Kategori (Prediksi, Beli, dll)
            SliverToBoxAdapter(child: _buildCategoryMenu()),

            // 5. Judul Katalog & Filter
            SliverToBoxAdapter(child: _buildCatalogHeader(primaryGreen)),
            SliverToBoxAdapter(child: _buildFilterChips()),

            // 6. Grid Produk (Katalog)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 Kolom
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.68, // Menyesuaikan tinggi kartu
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Data dummy untuk 2 produk
                    if (index == 0) {
                      return _buildProductCard(
                        title: "Limousin Super...",
                        seller: "Mitra Makmur",
                        weight: "620 kg",
                        age: "2.5 Thn",
                        price: "Rp 15jt - 30jt",
                        rating: "4.9",
                        isGuaranteed: true,
                        imageUrl: "https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?q=80&w=600&auto=format&fit=crop", // Gambar Sapi
                      );
                    } else {
                      return _buildProductCard(
                        title: "Kambing Senduro Ras",
                        seller: "Berkah Binar Farm",
                        weight: "48 kg",
                        age: "1.8 Thn",
                        price: "Rp 3jt - 5jt",
                        rating: "4.8",
                        isGuaranteed: false,
                        imageUrl: "https://images.unsplash.com/photo-1524024973431-2ad916746881?q=80&w=600&auto=format&fit=crop", // Gambar Kambing
                      );
                    }
                  },
                  childCount: 2,
                ),
              ),
            ),
            
            // Bottom Padding
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BAGIAN-BAGIAN ---

    Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lokasi (Tidak berubah)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text("Kab. M...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
              const SizedBox(height: 2),
              Text("Home", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          
          // Icon Kanan
          Row(
            children: [
              // Tombol Notifikasi
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(Icons.notifications_none, size: 20),
              ),
              const SizedBox(width: 12),
              
              // --- BAGIAN YANG DIUBAH: LOGO PROFIL ---
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman Register
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Dummy Avatar
                ),
              ),
              // ----------------------------------------
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Cari Sapi Limousin, Kambing Etawa...",
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Tombol Filter
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: primaryGreen, // Warna Hijau Gelap
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerPromo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, const Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: primaryGreen.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Tanggal & Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.white),
                    SizedBox(width: 4),
                    Text("IDULADHA 1446 H", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: softOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("H-48 Hari", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Judul
          const Text(
            "Persiapan Sah Qurban Terbaikmu",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          // Deskripsi
          Text(
            "Sesuai syariat Islam, daging sehat, hewan bebas penyakit, dan sudah cukup umur.",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          // CTA Button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: softOrange, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text("Musinnah (Cukup Umur) & Bebas Cacat", style: TextStyle(color: Colors.white, fontSize: 11)),
              const Spacer(),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoryMenu() {
    // List data untuk menu
    final items = [
      {'icon': Icons.pets, 'label': 'Prediksi', 'sub': 'Estimasi AI', 'badge': 'BARU'},
      {'icon': Icons.storefront, 'label': 'Beli', 'sub': 'Trip Sehat', 'badge': null},
      {'icon': Icons.menu_book, 'label': 'Fikih', 'sub': 'Syariat Sah', 'badge': null},
      {'icon': Icons.handshake, 'label': 'Mitra', 'sub': 'Terverifikasi', 'badge': null},
    ];

    return SizedBox(
      height: 110,
      width: double.infinity,
      // GUNAKAN SingleChildScrollView HORIZONTAL + CENTER
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16), // Jarak awal kiri
              // Iterasi item
              ...List.generate(items.length, (index) {
                final item = items[index];
                return Padding(
                  padding: EdgeInsets.only(
                    // Jarak antar item, item terakhir tidak perlu jarak kanan
                    right: index == items.length - 1 ? 16 : 12, 
                  ),
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        // Icon Container
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(item['icon'] as IconData, color: primaryGreen, size: 20),
                            ),
                            if (item['badge'] != null)
                              Positioned(
                                top: -6,
                                right: -10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(color: softOrange, borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    item['badge'] as String,
                                    style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(item['sub'] as String, style: TextStyle(color: Colors.grey[600], fontSize: 9), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogHeader(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Katalog Pilihan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Lihat Semua", style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Chip Aktif (Semua)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(20)),
            child: const Row(
              children: [
                Icon(Icons.grid_view, size: 14, color: Colors.white),
                SizedBox(width: 6),
                Text("Semua", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _inactiveChip("Sapi Potong & Perah", Icons.pets),
          const SizedBox(width: 8),
          _inactiveChip("Kambing Etawa", Icons.pets),
        ],
      ),
    );
  }

  Widget _inactiveChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 12)),
        ],
      ),
    );
  }

  // --- KARTU PRODUK ---
  Widget _buildProductCard({
    required String title,
    required String seller,
    required String weight,
    required String age,
    required String price,
    required String rating,
    required bool isGuaranteed,
    required String imageUrl,
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
          // Gambar Produk
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Badge Kategori
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(4)),
                  child: const Text("Sapi Qurban", style: TextStyle(color: Colors.white, fontSize: 9)),
                ),
              ),
              // Rating
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 10),
                      const SizedBox(width: 2),
                      Text(rating, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Info Produk
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.verified, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(seller, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Spesifikasi (Berat & Umur)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: [
                            const Text("BOBOT", style: TextStyle(fontSize: 8, color: Colors.grey)),
                            Text(weight, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: [
                            const Text("UMUR", style: TextStyle(fontSize: 8, color: Colors.grey)),
                            Text(age, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Harga
                Text(price, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                
                // Footer (Garansi)
                Row(
                  children: [
                    Icon(isGuaranteed ? Icons.verified_user : Icons.info, size: 12, color: isGuaranteed ? primaryGreen : Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      isGuaranteed ? "Vaksin & SKKH OK" : "Kupuk | Passing",
                      style: TextStyle(fontSize: 10, color: isGuaranteed ? primaryGreen : Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
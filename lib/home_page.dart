import 'package:flutter/material.dart';
import 'package:frontend_capston/login_page.dart';
import 'package:frontend_capston/trendharga_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final Color primaryGreen = const Color(0xFF006B3F); // Hijau Terang
  final Color lightGreen = const Color(0xFFC8F5D2); // Hijau Muda untuk background
  final Color darkGreen = const Color(0xFF003822); // Hijau Tua untuk list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER (HIJAU) ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // 1. Profil & Logout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- BUNGKUS BAGIAN PROFIL DENGAN GESTUREDETECTOR ---
                        GestureDetector(
                          onTap: () {
                            // Navigasi ke halaman Login
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          // Agar efek klik terasa
                          child: Row(
                            children: [
                              // --- BAGIAN YANG DIUBAH ---
                              ClipOval(
                                child: Container(
                                  width: 20, // Sesuaikan ukuran logo
                                  height: 20,
                                  color: Colors.white, // Opsional: background putih agar logo kontras
                                  padding: const EdgeInsets.all(4), // Jarak antara logo dan ujung lingkaran
                                  child: Image.asset(
                                    'resources/Icon 1.png', // <-- GANTI DENGAN PATH LOGO KAMU
                                    fit: BoxFit.contain, // Agar logo tidak gepeng
                                  ),
                                ),
                              ),
                              // ---------------------------
                              
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Selamat Datang", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  Text("Muhammad Ihrash Syahid", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // -----------------------------------------------------

                        // Ikon Logout (Bisa juga dibuat interaktif nanti)
                        const Icon(Icons.logout, color: Colors.white),
                      ],
                    ),

                    // --- UBAH ANGKA DI SINI ---
                    // Dari 20 menjadi 30 atau 40 agar jaraknya lebih lega
                    const SizedBox(height: 32), 
                    // --------------------------


                    // 2. Banner Promo
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'resources/Iklan 4.jpg', // Sesuaikan path
                          fit: BoxFit.fitWidth, // <-- Kunci utamanya di sini
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildCountdownCard(),

              const SizedBox(height: 16),

              // --- SEARCH BAR ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Cari hewan Qurban yang anda inginkan?",
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),

              // --- MENU ICON (QURVEST, EDUKASI, DLL) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Tambahkan context di awal
                    _buildMenuIcon(context, Icons.trending_up, "Qurvest"),
                    _buildMenuIcon(context, Icons.menu_book, "Edukasi"),
                    _buildMenuIcon(context, Icons.calendar_month, "Kalender"),
                    _buildMenuIcon(
                      context, // <-- Tambahkan context di sini juga
                      Icons.monetization_on, 
                      "Trendharga",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TrendhargaPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // --- LIST VERTIKAL (CARI KAMBING, DLL) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Gunakan path aset lokal kamu di sini
                    _buildListCard("Cari Kambing?", "resources/kambing 1.png"),
                    const SizedBox(height: 12),
                    _buildListCard("Cari Domba?", "resources/domba 1.png"),
                    const SizedBox(height: 12),
                    _buildListCard("Cari Sapi?", "resources/sapi 1.png"),
                    const SizedBox(height: 12,),
                    _buildListCard("Cari Kerbau?", "resources/kerbau 1.png")
                  ],
                ),
              ),
              const SizedBox(height: 30), // Spasi bawah
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET CUSTOM ---

  Widget _buildMenuIcon(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {
        // Sekarang 'context' sudah dikenali
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fitur $label segera hadir!")),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildListCard(String title, String imagePath) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Gambar Kiri (Menempel Ujung)
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.asset( // <-- UBAH DARI Image.network KE Image.asset
              imagePath,
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Judul
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          // Icon Panah Kanan
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_forward_ios, color: darkGreen, size: 12),
          )
        ],
      ),
    );
  }

    // --- WIDGET COUNTDOWN IDUL ADHA ---
  Widget _buildCountdownCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryGreen, // Hijau gelap sesuai desain
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Baris 1: Teks & Tombol Panah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Idul Adha sudah semakin dekat!",
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              // Tombol Panah
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_ios, color: primaryGreen, size: 12),
              )
            ],
          ),
          const SizedBox(height: 12),
          
          // Baris 2: Gambar Sapi & Kotak Angka
          Row(
            children: [
              // Gambar Sapi (Kiri)
              // Pastikan gambar sapi kamu transparan (PNG)
              Image.asset(
                'resources/coutdown 1.png', // <-- Sesuaikan path gambar kamu
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              
              // Kotak Angka (Kanan)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeBox("193", "Hari"),
                    _buildTimeBox("2", "Jam"),
                    _buildTimeBox("59", "Menit"),
                    _buildTimeBox("59", "Detik"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper untuk Kotak Angka
  Widget _buildTimeBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F4C2C), // Hijau lebih gelap untuk kontras
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:frontend_capston/edukasi_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _searchController =
      TextEditingController();


  // COLORS
  static const Color pageBg = Color(0xFFFAF8FF);
  static const Color darkGreen = Color(0xFF004D2B);
  static const Color textDark = Color(0xFF172238);
  static const Color textMuted = Color(0xFF59635F);
  static const Color orange = Color(0xFFFFA51E);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,


      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // BANNER
              _banner(),

              const SizedBox(height: 17),

              // SEARCH BAR
              _searchBar(),

              const SizedBox(height: 17),

              // TRANSAKSI & MARKETPLACE
              _sectionTitle(
                'Transaksi & Marketplace',
                color: darkGreen,
              ),

              const SizedBox(height: 15),

              ExpandableFeatureCard(
                icon: Icons.dns_outlined,
                title: 'Katalog Hewan',
                subtitle: 'Temukan pilihan hewan ternak sehat dan sesuai',
                popular: true,
                longDescription: 'Jelajahi berbagai pilihan sapi, kambing, dan domba berkualitas unggul dari peternak terpercaya. Dilengkapi dengan detail bobot, usia, serta jaminan 100% sehat dan layak kurban.',
                // onButtonPressed: () {
                //   // Nanti kalau halaman katalog sudah siap, isi di sini
                //   // Navigator.push(context, MaterialPageRoute(builder: (context) => const CatalogPage()));
                // },
              ),

              const SizedBox(height: 14),

              ExpandableFeatureCard(
                icon: Icons.handshake_outlined,
                title: 'Mengenai Transaksi',
                subtitle: 'Panduan lengkap transaksi',
                popular: false,
                longDescription: 'Pelajari langkah-langkah mudah mulai dari memilih hewan, pilihan metode pembayaran, hingga melacak status pesanan Anda.',
              ),

              const SizedBox(height: 18),

              // INOVASI & LAYANAN
              _sectionTitle(
                'Inovasi & Layanan Unggulan',
                color: orange,
              ),

              const SizedBox(height: 15),

              ExpandableFeatureCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Tabungan Qurban',
                subtitle: 'Rencanakan & cicil kurban',
                popular: true,
                longDescription: 'Tabung dana kurban secara bertahap setiap bulan sesuai kemampuan Anda. Pembayaran terencana agar ibadah kurban terasa ringan tanpa beban di akhir.',
              ),

              const SizedBox(height: 14),

              ExpandableFeatureCard(
                icon: Icons.payments_outlined,
                title: 'Penggemukan',
                subtitle: 'Beli ternak saat anak, panen saat dewasa',
                popular: false,
                longDescription: 'Percayakan perawatan hewan kurban Anda pada mitra peternak berpengalaman. Asupan pakan terjaga dan dapatkan laporan kondisi hewan secara rutin.',
              ),

              const SizedBox(height: 14),

              ExpandableFeatureCard(
                icon: Icons.pets_outlined,
                title: 'Sapi Berkelompok',
                subtitle: 'Patungan sapi lebih ringan',
                popular: false,
                longDescription: 'Solusi cerdas berkurban sapi dengan biaya lebih terjangkau. Gabung bersama 2 - 7 sohibul kurban lainnya untuk mendapatkan sapi kualitas premium'
              ),

              const SizedBox(height: 14),

              ExpandableFeatureCard(
                icon: Icons.trending_up,
                title: 'Qurvest',
                subtitle: 'Investasi anakan, panen untungnya',
                popular: false,
                longDescription: 'Beli bibit ternak sekarang dan biarkan mitra kami merawatnya. Saat panen, pilih untuk mengambil hewan dewasa atau cairkan dalam bentuk bagi hasil penjualan.',
              ),

              const SizedBox(height: 18),

              // FITUR LAINNYA
              _sectionTitle(
                'Fitur - Fitur lainnya',
                color: orange,
              ),

              const SizedBox(height: 15),

              ExpandableFeatureCard(
                icon: Icons.calendar_month_outlined,
                title: 'Kalender Islam',
                subtitle: 'Jadwal kurban & hari besar Islam',
                popular: true,
                longDescription: 'Cek tanggalan Hijriah harian yang akurat. Dilengkapi dengan penanda hari-hari besar Islam dan jadwal puasa sunnah (seperti Arafah dan Tarwiyah) sepanjang tahun.',
              ),

              const SizedBox(height: 14),

              ExpandableFeatureCard(
                icon: Icons.savings_outlined,
                title: 'Trendharga',
                subtitle: 'Pantau grafik harga pasar hewan',
                popular: true,
                longDescription: 'Transparansi harga sapi dan kambing di ujung jari Anda. Lihat riwayat grafik harga terkini dan proyeksi kenaikan menjelang Idul Adha agar perencanaan dana lebih presisi.',
              ),

              const SizedBox(height: 14),

              ExpandableFeatureCard(
                icon: Icons.menu_book_outlined,
                title: 'Edukasi Fiqih',
                subtitle: 'Pahami syarat sah ibadah kurban',
                popular: false,
                longDescription: 'Pelajari tata cara, syarat sah hewan, dan hukum pembagian daging kurban sesuai sunnah. Pastikan ibadah Anda sempurna berdasarkan dalil yang sahih.',
                onButtonPressed: () {
                //   // Nanti kalau halaman katalog sudah siap, isi di sini
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EdukasiPage()));
                },
              ),

              const SizedBox(height: 18),

              // KEMITRAAN
              _sectionTitle(
                'Kemitraan & Pusat Bantuan',
                color: orange,
              ),

              const SizedBox(height: 15),

              ExpandableFeatureCard(
                icon: Icons.support_agent_outlined,
                title: 'Kemitraan',
                subtitle: 'Gabung jadi mitra peternak kami',
                popular: true,
                longDescription: 'Bergabunglah dalam ekosistem Qurbankan. Daftarkan peternakan Anda, jangkau ribuan pembeli digital, dan tingkatkan penjualan hewan kurban dengan sistem yang transparan.',
              ),

              const SizedBox(height: 16),

              // JAMINAN SYARIAH
              _guaranteeCard(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),

      // =====================================
      // BOTTOM NAVIGATION FIXED
      // =====================================

    );
  }

  // ==========================================
  // BANNER
  // ==========================================

  Widget _banner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 166,
        child: Image.asset(
          'resources/menu_banner.png',
          fit: BoxFit.cover,

          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF007A50),
              alignment: Alignment.center,
              child: const Text(
                'Menu Fitur Aplikasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================
  // SEARCH BAR
  // ==========================================

  Widget _searchBar() {
    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.manage_search,
            color: darkGreen,
            size: 20,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: TextField(
              controller: _searchController,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontSize: 12,
                color: textDark,
              ),
              decoration: const InputDecoration(
                hintText:
                    'Cari layanan, fitur, panduan, atau sertifikat...',
                hintStyle: TextStyle(
                  color: Color(0xFF89918D),
                  fontSize: 12,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              _searchController.clear();
            },
            child: Container(
              width: 27,
              height: 27,
              decoration: const BoxDecoration(
                color: Color(0xFFE9EBFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 17,
                color: Color(0xFF596174),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION TITLE
  // ==========================================

  Widget _sectionTitle(
    String title, {
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(width: 4),

        Text(
          title,
          style: const TextStyle(
            color: darkGreen,
            fontSize: 16,
            height: 1.2,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
  // ==========================================
  // GUARANTEE CARD
  // ==========================================

  Widget _guaranteeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECFF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [

          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: darkGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Jaminan Amanah & Syariah 100%',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 15,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Diawasi Dewan Syariah Nasional, Dewan Pakar '
                  'Peternakan IPB, & Sertifikasi Halal.',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET BARU UNTUK CARD YANG BISA EXPAND ---
class ExpandableFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String longDescription; // Deskripsi panjang saat di-expand
  final bool popular;
  final VoidCallback? onButtonPressed; // <-- TAMBAHKAN PARAMETER INI

  const ExpandableFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.longDescription,
    this.popular = false,
    this.onButtonPressed, // <-- TAMBAHKAN DI CONSTRUCTOR
  });

  @override
  State<ExpandableFeatureCard> createState() => _ExpandableFeatureCardState();
}

class _ExpandableFeatureCardState extends State<ExpandableFeatureCard> {
  bool _isExpanded = false;

  final Color darkGreen = const Color(0xFF004D2B);
  final Color iconBg = const Color(0xFFD6E6DF);
  final Color textDark = const Color(0xFF172238);
  final Color textMuted = const Color(0xFF59635F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded; 
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: _isExpanded 
              ? Border.all(color: darkGreen.withValues(alpha: 0.3), width: 1.5) 
              : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // --- BARIS ATAS (Icon, Title, Subtitle) ---
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: darkGreen, size: 23),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textDark,
                                fontSize: 16,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (widget.popular) ...[
                            const SizedBox(width: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDBB),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Populer',
                                style: TextStyle(
                                  color: Color(0xFF4D351D),
                                  fontSize: 10,
                                  height: 1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 12,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                AnimatedRotation(
                  turns: _isExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF7C8781),
                    size: 22,
                  ),
                ),
              ],
            ),

            // --- BAGIAN DESKRIPSI & TOMBOL (MUNCUL SAAT DIKLIK) ---
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                      ),
                      // Bungkus dengan Column untuk menaruh Deskripsi & Tombol
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch, // Agar tombol full width
                        children: [
                          // 1. Teks Deskripsi
                          Text(
                            widget.longDescription,
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // 2. TOMBOL AKSI
                          Align(
                            alignment: Alignment.centerRight, // Posisi tombol di kanan
                            child: SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: widget.onButtonPressed ?? () {
                                  // Aksi default jika onButtonPressed belum diisi
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Halaman belum tersedia')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: darkGreen,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Selengkapnya", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
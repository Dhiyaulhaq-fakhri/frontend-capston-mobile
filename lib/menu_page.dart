
import 'package:flutter/material.dart';

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
  static const Color iconBg = Color(0xFFD6E6DF);
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

              _featureCard(
                icon: Icons.dns_outlined,
                title: 'Katalog Hewan',
                subtitle:
                    'Temukan pilihan hewan ternak sehat dan sesuai',
                popular: true,
              ),

              const SizedBox(height: 14),

              _featureCard(
                icon: Icons.handshake_outlined,
                title: 'Mengenai Transaksi',
                subtitle: 'Panduan lengkap transaksi',
              ),

              const SizedBox(height: 18),

              // INOVASI & LAYANAN
              _sectionTitle(
                'Inovasi & Layanan Unggulan',
                color: orange,
              ),

              const SizedBox(height: 15),

              _featureCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Tabungan Qurban',
                subtitle: 'Rencanakan & cicil kurban',
                popular: true,
              ),

              const SizedBox(height: 14),

              _featureCard(
                icon: Icons.payments_outlined,
                title: 'Penggemukan',
                subtitle:
                    'Beli ternak saat anak, panen saat dewasa',
              ),

              const SizedBox(height: 14),

              _featureCard(
                icon: Icons.pets_outlined,
                title: 'Sapi Berkelompok',
                subtitle: 'Patungan sapi lebih ringan',
              ),

              const SizedBox(height: 14),

              _featureCard(
                icon: Icons.trending_up,
                title: 'Qurvest',
                subtitle: 'Investasi anakan, panen untungnya',
              ),

              const SizedBox(height: 18),

              // FITUR LAINNYA
              _sectionTitle(
                'Fitur - Fitur lainnya',
                color: orange,
              ),

              const SizedBox(height: 15),

              _featureCard(
                icon: Icons.calendar_month_outlined,
                title: 'Kalender Islam',
                subtitle: 'Jadwal kurban & hari besar Islam',
                popular: true,
              ),

              const SizedBox(height: 14),

              _featureCard(
                icon: Icons.savings_outlined,
                title: 'Trendharga',
                subtitle: 'Pantau grafik harga pasar hewan',
              ),

              const SizedBox(height: 14),

              _featureCard(
                icon: Icons.menu_book_outlined,
                title: 'Edukasi Fiqih',
                subtitle: 'Pahami syarat sah ibadah kurban',
              ),

              const SizedBox(height: 18),

              // KEMITRAAN
              _sectionTitle(
                'Kemitraan & Pusat Bantuan',
                color: orange,
              ),

              const SizedBox(height: 15),

              _featureCard(
                icon: Icons.support_agent_outlined,
                title: 'Kemitraan',
                subtitle: 'Gabung jadi mitra peternak kami',
                popular: true,
                
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
          'assets/images/menu_banner.png',
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
  // FEATURE CARD
  // ==========================================

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool popular = false,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 69,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [

          // ICON BOX
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: darkGreen,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          // TITLE & SUBTITLE
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 16,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    if (popular) ...[
                      const SizedBox(width: 7),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
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
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 12,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          // CHEVRON
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF7C8781),
            size: 22,
          ),
        ],
      ),
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

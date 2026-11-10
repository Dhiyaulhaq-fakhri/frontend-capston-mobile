import 'package:flutter/material.dart';
import 'package:frontend_capston/login_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // Warna utama (disamakan dengan RegisterPage)
  final Color primaryGreen = const Color(0xFF1B5E20);
  final Color darkGreen = const Color(0xFF0B3D20);
  final Color lightGreen = const Color(0xFFA7F3A0);

  // Data sementara, nanti diganti dari login/API
  final String _name = "Muhammad Irhash Syahid";
  final String _email = "irhash.syahid@example.com";
  final int _balance = 4250000;
  final int _target = 5000000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. KARTU PROFIL
              _buildHeaderCard(),
              const SizedBox(height: 12),

              // 2. KARTU DOMPET
              _buildWalletCard(),
              const SizedBox(height: 24),

              // 3. MENU LAYANAN
              _buildSectionTitle("Layanan & Kelola Akun"),
              _buildMenuGroup([
                _MenuItem(Icons.notifications_none_rounded, "Pemberitahuan"),
                _MenuItem(Icons.shield_outlined, "Buka Kemitraan"),
                _MenuItem(Icons.account_balance_outlined, "Rekening & Metode Pembayaran"),
                _MenuItem(Icons.fingerprint, "Keamanan & Biometrik Akun"),
              ]),
              const SizedBox(height: 24),

              // 4. MENU SYARIAH & BANTUAN
              _buildSectionTitle("Kepatuhan Syariah & Bantuan"),
              _buildMenuGroup([
                _MenuItem(Icons.favorite_border_rounded, "Wishlist"),
                _MenuItem(Icons.support_agent_rounded, "Pusat Bantuan"),
              ]),
              const SizedBox(height: 24),

              // 5. TOMBOL KELUAR
              _buildLogoutButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // --- LOGIKA ---

  // Format angka: 4250000 -> Rp 4.250.000 (tanpa package intl)
  String _formatRupiah(int value) {
    final text = value.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        );
    return "Rp $text";
  }

  // Navigasi sementara ke halaman placeholder.
  // Ganti dengan halaman asli, contoh: const NotifikasiPage()
  void _navigateTo(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _PlaceholderPage(title: title)),
    );
  }

  // Dialog konfirmasi logout
  Future<void> _showLogoutDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Keluar dari Akun"),
        content: const Text("Apakah kamu yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Keluar", style: TextStyle(color: Color(0xFFB91C1C))),
          ),
        ],
      ),
    );

    // Wajib cek mounted setelah await
    if (confirm == true && mounted) {
      // Hapus semua riwayat halaman agar tidak bisa kembali ke profil
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  // --- WIDGET HELPER ---

  // Kartu header: avatar, nama, email, chip status
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Judul di tengah, tombol edit di kanan
          Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                "Profil Pengguna",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => _navigateTo("Edit Profil"),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Avatar + badge centang
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white24,
                // Ganti dengan AssetImage('resources/foto.jpg') jika sudah ada
                child: Icon(Icons.person, size: 42, color: Colors.white),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(Icons.check_circle, size: 16, color: primaryGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            _name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            _email,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Chip status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_outlined, size: 14, color: darkGreen),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "Shohibul Qurban Terverifikasi • Anggota Premium Qurban",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: darkGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kartu dompet tabungan + progress target
  Widget _buildWalletCard() {
    // Progress otomatis: 4.250.000 / 5.000.000 = 0.85
    final double progress = (_balance / _target).clamp(0.0, 1.0);
    final int percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 16, color: Colors.white70),
              SizedBox(width: 6),
              Text(
                "Dompet Tabungan Syariah (Wadi'ah)",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatRupiah(_balance),
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),

          // Label target
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Target: ${_formatRupiah(_target)} ($percent%)",
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(lightGreen),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Simpanan terjadwal auto-debit",
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _navigateTo("Top Up"),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text("Top Up"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightGreen,
                  foregroundColor: darkGreen,
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Judul tiap grup menu
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
      ),
    );
  }

  // Satu grup menu dalam kartu putih, dipisah Divider
  Widget _buildMenuGroup(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildMenuTile(items[i]),
            if (i != items.length - 1)
              const Divider(height: 1, indent: 16, endIndent: 16),
          ],
        ],
      ),
    );
  }

  // Satu baris menu: ikon, judul, panah
  Widget _buildMenuTile(_MenuItem item) {
    return ListTile(
      onTap: () => _navigateTo(item.title),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF0FB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(item.icon, size: 20, color: darkGreen),
      ),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }

  // Tombol keluar (merah muda)
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _showLogoutDialog,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text("Keluar dari Akun"),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFEE2E2),
          foregroundColor: const Color(0xFFB91C1C),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

// Model data untuk satu item menu
class _MenuItem {
  final IconData icon;
  final String title;
  const _MenuItem(this.icon, this.title);
}

// Halaman sementara, hapus jika halaman asli sudah dibuat
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("Halaman $title (belum dibuat)")),
    );
  }
}
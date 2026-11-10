import 'package:flutter/material.dart';
import 'package:frontend_capston/home_page.dart';
import 'package:frontend_capston/pesanan_page.dart'; 
import 'package:frontend_capston/profil_page.dart';
import 'package:frontend_capston/menu_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Warna Utama
  final Color primaryGreen = const Color(0xFF006B3F);
  final Color activeColor = const Color(0xFFA7F3D0);
  final Color inactiveColor = Colors.white70;

  final List<Widget> _pages = [
    const HomePage(), 
    const MenuPage(), 
    const Center(child: Text("Halaman Katalog")), 
    const Center(child: Text("Halaman Pesanan")), 
    const Center(child: Text("Halaman Akun")), 
    const ProfilPage(),
    const PesananPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      
      // --- REVISI BOTTOM NAVIGATION BAR (HIJAU) ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: primaryGreen, // Background Hijau Gelap
          border: const Border(
            top: BorderSide(color: Colors.white24, width: 1), // Garis pemisah tipis di atas
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -2), // Bayangan ke atas agar terlihat terpisah dari body
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.storefront, "Beranda", 0),
                _buildNavItem(Icons.menu, "Menu", 1),
                _buildNavItem(Icons.grid_view, "Katalog", 2),
                _buildNavItem(Icons.receipt_long, "Pesanan", 3),
                _buildNavItem(Icons.person_outline, "Akun", 4),
                _buildNavItem(Icons.person, "Profil", 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET CUSTOM UNTUK ITEM NAVBAR ---
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            // Jika aktif, pakai warna Oranye. Jika tidak, Putih transparan.
            color: isSelected ? activeColor : inactiveColor, 
            size: 24,
          ),
          const SizedBox(height: 4),
          // Teks Label
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              // Teks juga mengikuti warna icon
              color: isSelected ? activeColor : inactiveColor, 
            ),
          ),
        ],
      ),
    );
  }
}
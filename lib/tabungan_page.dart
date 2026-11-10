// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class TabunganPage extends StatefulWidget {
  const TabunganPage({super.key});

  @override
  State<TabunganPage> createState() => _TabunganPageState();
}

class _TabunganPageState extends State<TabunganPage> {
  // Warna Utama
  final Color primaryGreen = const Color(0xFF0F5D3B); // Hijau Gelap
  final Color lightGreenBg = const Color(0xFFE8F5E9); // Hijau Muda
  final Color orangeAccent = const Color(0xFFF57C00); // Oranye Tombol
  final Color bgColor = const Color(0xFFF8F9FA);

  // State Tab Atas (0=Domba, 1=Sapi)
  int _selectedTabIndex = 0;

  // State Pilihan Tempo (0=Harian, 1=Mingguan, 2=Bulanan)
  int _selectedTempoIndex = 0;

  // State Tabungan (Variabel Dinamis)
  double _totalTabungan = 2450000;
  double _targetTabungan = 3500000;

  // Controllers untuk Dialog
  final TextEditingController _setorController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  @override
  void dispose() {
    _setorController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  // Fungsi Format Rupiah
  String _formatRupiah(double value) {
    return "Rp " + value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // Hitung Persentase
  double get _persentase {
    double percent = (_totalTabungan / _targetTabungan) * 100;
    return percent > 100 ? 100 : percent; // Maksimal 100%
  }

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
            Text("Tabungan", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
            const Text("tabungan kurban anda untuk menjelang idul adha", style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. BANNER INFO ATAS ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: lightGreenBg, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(Icons.verified_user, color: primaryGreen, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Akad Wadi'ah yad Dhamanah • Bebas Biaya Admin DSN",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 2. CARD UTAMA (TABUNGAN) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("CELENGAN KURBAN TERKUMPUL", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF1E885A), borderRadius: BorderRadius.circular(20)),
                        child: const Text("Tersisa 45 Hari lagi", style: TextStyle(color: Colors.white, fontSize: 10)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_formatRupiah(_totalTabungan), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  Text("Target: 1 Ekor Domba Premium (${_formatRupiah(_targetTabungan)})", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 16),
                  
                  // Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${_persentase.toStringAsFixed(0)}% Tercapai", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text("Kurang ${_formatRupiah(_targetTabungan - _totalTabungan)}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _persentase / 100,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Setor & Ubah Target
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton.icon(
                            onPressed: _showDialogSetor,
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 18),
                            label: const Text("Setor Tabungan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orangeAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 45,
                          child: OutlinedButton.icon(
                            onPressed: _showDialogUbahTarget,
                            icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                            label: const Text("Ubah Target", style: TextStyle(color: Colors.white, fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white54),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 3. SIMULASI TARGET HEWAN ---
            const Text("Simulasi Target Hewan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text("Rencanakan tabungan realistis sesuai tempo", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),

            // Tab Scrollable (Domba & Sapi)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTargetTab("Domba / Kambing (2.8 - 4.5 Jt)", 0),
                  _buildTargetTab("Sapi Patungan 1/7 (3.2 Jt)", 1),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 4. PILIH TEMPO SETORAN ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PILIH TEMPO SETORAN", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTempoButton("Harian", "25 Ribu", 0),
                      const SizedBox(width: 8),
                      _buildTempoButton("Mingguan", "175 Ribu", 1),
                      const SizedBox(width: 8),
                      _buildTempoButton("Bulanan", "750 Ribu", 2),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Estimasi Realisasi (Dinamis)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF0F7F2), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.calendar_month, color: primaryGreen, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Estimasi Realisasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                _selectedTempoIndex == 0 
                                    ? "Dengan menyisihkan Rp 25.000/hari, target tabungan Anda tercapai pada 25 Mei 2026 (H-12 Iduladha 1447 H)."
                                    : _selectedTempoIndex == 1
                                        ? "Dengan menyisihkan Rp 175.000/minggu, target tabungan Anda tercapai pada 25 Mei 2026 (H-12 Iduladha 1447 H)."
                                        : "Dengan menyisihkan Rp 750.000/bulan, target tabungan Anda tercapai pada 25 Mei 2026 (H-12 Iduladha 1447 H).",
                                style: const TextStyle(color: Colors.black87, fontSize: 11, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 5. JAMINAN SYARIAH ---
            const Text("Jaminan Syariah & Amanah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildGuaranteeItem(
                    icon: Icons.lock_outline,
                    title: "Escrow Syariah Terisolasi",
                    desc: "Dana titipan aman dan tidak diputar pada instrumen spekulatif (Non-Riba).",
                  ),
                  const SizedBox(height: 12),
                  _buildGuaranteeItem(
                    icon: Icons.pets,
                    title: "Opsi Fleksibel Hahi 1",
                    desc: "Tabungan otomatis ditukar hewan kurban mitra berBobot sehat, diantar hidup ke rumah, atau disalurkan ke desa pelosok.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Tombol Tab Simulasi Target
  Widget _buildTargetTab(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          // Ubah target tabungan dummy sesuai tab yang dipilih
          _targetTabungan = index == 0 ? 3500000 : 3200000; 
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  // Tombol Tempo Setoran
  Widget _buildTempoButton(String label, String value, int index) {
    bool isSelected = _selectedTempoIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTempoIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryGreen : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Item Jaminan Syariah
  Widget _buildGuaranteeItem({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: lightGreenBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: primaryGreen, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  // --- DIALOG FITUR SETOR TABUNGAN ---
  void _showDialogSetor() {
    _setorController.clear(); // Reset inputan
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Setor Tabungan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Masukkan nominal yang ingin disetor:", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 12),
              TextField(
                controller: _setorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  hintText: "Contoh: 500000",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // Ambil input dan konversi ke double
                String input = _setorController.text.replaceAll(RegExp(r'[^0-9]'), '');
                if (input.isNotEmpty) {
                  double nominal = double.tryParse(input) ?? 0;
                  setState(() {
                    _totalTabungan += nominal;
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- DIALOG FITUR UBAH TARGET ---
  void _showDialogUbahTarget() {
    _targetController.text = _targetTabungan.toStringAsFixed(0); // Isi dengan target saat ini
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Ubah Target Tabungan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Masukkan target tabungan baru Anda:", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 12),
              TextField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                String input = _targetController.text.replaceAll(RegExp(r'[^0-9]'), '');
                if (input.isNotEmpty) {
                  double newTarget = double.tryParse(input) ?? 0;
                  if (newTarget > 0) {
                    setState(() {
                      _targetTabungan = newTarget;
                    });
                  }
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
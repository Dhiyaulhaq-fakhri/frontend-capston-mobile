import 'package:flutter/material.dart';

// Status pesanan, dipakai untuk filter chip
enum OrderStatus { berlangsung, selesai, dibatalkan }

// Model data satu kartu pesanan.
// Nanti diganti dengan data dari API (fromJson).
class _Order {
  final OrderStatus status;
  final String category; // contoh: "Sapi Limousin (420 kg)"
  final IconData categoryIcon;
  final Color categoryBg;
  final Color categoryFg;
  final String trxId;
  final String title; // judul status / progress
  final bool titleDot; // titik oranye di depan judul
  final String detail; // "Tujuan: ...", "Atas Nama: ...", "Bobot: ..."
  final String detailBold; // bagian tebal dari detail
  final String location;
  final double? progress; // 0.0 - 1.0, null = tanpa progress bar
  final String? progressLabel; // contoh: "6/7 Shohibul"
  final String? thumbBadge; // contoh: "1/7" (kiri atas foto)
  final bool thumbCheck; // centang di kanan bawah foto
  final String summaryLabel;
  final int amount;
  final String? badgeText; // contoh: "Lunas Escrow"
  final IconData? badgeIcon;
  final String? note; // teks kecil di kanan kotak ringkasan
  final String? image; // path asset, null = placeholder

  const _Order({
    required this.status,
    required this.category,
    required this.categoryIcon,
    required this.categoryBg,
    required this.categoryFg,
    required this.trxId,
    required this.title,
    this.titleDot = false,
    required this.detail,
    this.detailBold = '',
    required this.location,
    this.progress,
    this.progressLabel,
    this.thumbBadge,
    this.thumbCheck = false,
    required this.summaryLabel,
    required this.amount,
    this.badgeText,
    this.badgeIcon,
    this.note,
  }) : image = null;
}

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  // Warna utama (disamakan dengan halaman lain)
  final Color primaryGreen = const Color(0xFF1B5E20);
  final Color darkGreen = const Color(0xFF0B3D20);
  final Color softBox = const Color(0xFFEEF0FB);

  // Filter yang sedang aktif: 0 Semua, 1 Berlangsung, 2 Selesai, 3 Dibatalkan
  int _selectedFilter = 0;

  // Data sementara, nanti diganti dari API
  final List<_Order> _orders = const [
    _Order(
      status: OrderStatus.berlangsung,
      category: "Sapi Limousin (420 kg)",
      categoryIcon: Icons.settings_outlined,
      categoryBg: Color(0xFFC8F5C8),
      categoryFg: Color(0xFF0B3D20),
      trxId: "#TRX-QBN-77291",
      title: "Armada Menuju Lokasi (H-2)",
      titleDot: true,
      detail: "Tujuan: ",
      detailBold: "Masjid Al-Falah Kebayoran Baru",
      location: "Rajegwesi, Tegal",
      thumbCheck: true,
      summaryLabel: "Total Transaksi",
      amount: 29100000,
      badgeText: "Lunas Escrow",
      badgeIcon: Icons.lock_outline,
    ),
    _Order(
      status: OrderStatus.berlangsung,
      category: "Simental 450 kg",
      categoryIcon: Icons.groups_2_outlined,
      categoryBg: Color(0xFFFFE0C2),
      categoryFg: Color(0xFF8A4B0F),
      trxId: "#TRX-PTG-91023",
      title: "Progress Kuota Jamaah",
      detail: "Atas Nama: ",
      detailBold: "M. Irhash Syahid (Porsi 1)",
      location: "Kandang Wedus Dukuhturi, Tegal",
      progress: 6 / 7,
      progressLabel: "6/7 Shohibul",
      thumbBadge: "1/7",
      summaryLabel: "Porsi tersedia (1/7)",
      amount: 4250000,
      badgeText: "Lunas Terverifikasi",
    ),
    _Order(
      status: OrderStatus.berlangsung,
      category: "Domba Garut",
      categoryIcon: Icons.spa_outlined,
      categoryBg: Color(0xFFE2E8E2),
      categoryFg: Color(0xFF0B3D20),
      trxId: "#TRX-RWT-33019",
      title: "Hari ke-45 dari 90 (Fase Penggemukan)",
      detail: "Bobot: ",
      detailBold: "34.5 kg / Target: 40 kg",
      location: "Kandang Wedus Pagedangan, Tegal",
      summaryLabel: "Nilai Investasi Akad",
      amount: 2850000,
      note: "Termasuk Pakan &\nPerawatan 3 Bln",
    ),
  ];

  // Daftar pesanan sesuai filter yang dipilih
  List<_Order> get _filteredOrders {
    switch (_selectedFilter) {
      case 1:
        return _orders.where((o) => o.status == OrderStatus.berlangsung).toList();
      case 2:
        return _orders.where((o) => o.status == OrderStatus.selesai).toList();
      case 3:
        return _orders.where((o) => o.status == OrderStatus.dibatalkan).toList();
      default:
        return _orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = _filteredOrders;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. JUDUL
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                "Daftar Pesanan & Akad",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkGreen),
              ),
            ),

            // 2. FILTER CHIP
            _buildFilterChips(),
            const SizedBox(height: 12),

            // 3. DAFTAR KARTU (atau tampilan kosong)
            Expanded(
              child: orders.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: orders.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => _buildOrderCard(orders[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIKA ---

  // Format angka: 29100000 -> Rp 29.100.000 (tanpa package intl)
  String _formatRupiah(int value) {
    final text = value.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        );
    return "Rp $text";
  }

  // Hitung jumlah pesanan per filter (untuk angka di chip)
  int _countFor(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return _orders.length;
      case 1:
        return _orders.where((o) => o.status == OrderStatus.berlangsung).length;
      case 2:
        return _orders.where((o) => o.status == OrderStatus.selesai).length;
      default:
        return _orders.where((o) => o.status == OrderStatus.dibatalkan).length;
    }
  }

  // Navigasi sementara ke halaman placeholder.
  // Ganti dengan halaman detail asli, contoh: DetailPesananPage(trxId: ...)
  void _openDetail(_Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _DetailPlaceholderPage(trxId: order.trxId),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Baris filter yang bisa digeser ke samping
  Widget _buildFilterChips() {
    const labels = ["Semua", "Berlangsung", "Selesai", "Dibatalkan"];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: labels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final bool isSelected = _selectedFilter == index;
          final int count = _countFor(index);
          // Angka hanya ditampilkan jika ada isinya
          final String text = count > 0 ? "${labels[index]} ($count)" : labels[index];

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? darkGreen : const Color(0xFFE6E9F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : darkGreen,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Tampilan jika filter tidak punya data
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            "Belum ada pesanan di sini",
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Satu kartu pesanan (dipakai untuk ketiga jenis)
  Widget _buildOrderCard(_Order order) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Baris atas: kategori + nomor transaksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: _buildCategoryBadge(order)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E9F7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.trxId,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: darkGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Foto + info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnail(order),
              const SizedBox(width: 12),
              Expanded(child: _buildOrderInfo(order)),
            ],
          ),
          const SizedBox(height: 12),

          // Kotak ringkasan nominal
          _buildSummaryBox(order),
          const SizedBox(height: 12),

          // Tombol detail
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: () => _openDetail(order),
              icon: const Icon(Icons.location_on_outlined, size: 16),
              label: const Text("Lihat Selengkapnya"),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Badge kategori (Sapi / Simental / Domba)
  Widget _buildCategoryBadge(_Order order) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(order.categoryIcon, size: 18, color: darkGreen),
        const SizedBox(width: 6),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: order.categoryBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: order.categoryFg),
            ),
          ),
        ),
      ],
    );
  }

  // Foto hewan. Jika belum ada gambar, tampil placeholder.
  Widget _buildThumbnail(_Order order) {
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: order.image != null
                ? Image.asset(order.image!, width: 84, height: 84, fit: BoxFit.cover)
                : Container(
                    width: 84,
                    height: 84,
                    color: const Color(0xFFD9D2C5),
                    child: const Icon(Icons.pets, size: 34, color: Color(0xFF8A7B63)),
                  ),
          ),
          // Badge kuota di kiri atas
          if (order.thumbBadge != null)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  order.thumbBadge!,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          // Centang di kanan bawah
          if (order.thumbCheck)
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(color: darkGreen, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // Info di samping foto: judul, progress (opsional), detail, lokasi
  Widget _buildOrderInfo(_Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul (dengan titik oranye jika sedang dalam perjalanan)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (order.titleDot) ...[
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 5, right: 6),
                decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              ),
            ],
            Expanded(
              child: Text(
                order.title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: darkGreen),
              ),
            ),
          ],
        ),

        // Progress bar kuota (hanya untuk jenis patungan)
        if (order.progress != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: order.progress!.clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(darkGreen),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                order.progressLabel ?? '',
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ],
        const SizedBox(height: 6),

        // Detail: sebagian teks dicetak tebal
        Text.rich(
          TextSpan(
            text: order.detail,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            children: [
              TextSpan(
                text: order.detailBold,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Lokasi kandang
        Row(
          children: [
            Icon(Icons.storefront_outlined, size: 14, color: darkGreen),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                order.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Kotak ringkasan: label + nominal, badge atau catatan di kanan
  Widget _buildSummaryBox(_Order order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: softBox,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.summaryLabel,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                _formatRupiah(order.amount),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen),
              ),
            ],
          ),
          if (order.badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD5EBD8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (order.badgeIcon != null) ...[
                    Icon(order.badgeIcon, size: 12, color: darkGreen),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    order.badgeText!,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: darkGreen),
                  ),
                ],
              ),
            )
          else if (order.note != null)
            Text(
              order.note!,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}

// Halaman sementara, hapus jika halaman detail asli sudah dibuat
class _DetailPlaceholderPage extends StatelessWidget {
  final String trxId;
  const _DetailPlaceholderPage({required this.trxId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail $trxId")),
      body: Center(child: Text("Halaman detail $trxId (belum dibuat)")),
    );
  }
}
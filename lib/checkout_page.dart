// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';

/// Halaman Checkout Akad & Pengiriman Qurban.
/// Seluruh interaksi berjalan secara lokal (frontend demo), tanpa backend.
class CheckoutQurbanPage extends StatefulWidget {
  const CheckoutQurbanPage({super.key});

  @override
  State<CheckoutQurbanPage> createState() => _CheckoutQurbanPageState();
}

class _CheckoutQurbanPageState extends State<CheckoutQurbanPage> {
  static const Color green = Color(0xFF07532F);
  static const Color mint = Color(0xFFB9F0C8);
  static const Color lavender = Color(0xFFF0F1FF);
  static const Color pageBg = Color(0xFFFAF8FD);
  static const Color ink = Color(0xFF202A3D);
  static const Color muted = Color(0xFF758078);

  final TextEditingController _nameController = TextEditingController(
    text: 'Muhammad Irhash Syahid bin Ahmad Syahid',
  );

  int _shohibulType = 0; // 0 = pribadi, 1 = pahala keluarga
  int _distribution = 0; // 0 = kirim hidup, 1 = sedekah
  int _paymentMethod = -1; // -1 = belum dipilih, 0 = VA, 1 = QRIS
  bool _akadAgreed = true;
  bool _showNameError = false;

  static const int _animalPrice = 28500000;
  static const int _shippingFee = 450000;
  static const int _shippingSubsidy = 450000;
  static const int _infaq = 25000;

  int get _total => _animalPrice + _shippingFee - _shippingSubsidy + _infaq;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _rupiah(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString()}';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _pay() async {
    FocusScope.of(context).unfocus();
    setState(() => _showNameError = _nameController.text.trim().isEmpty);

    if (_nameController.text.trim().isEmpty) {
      _showMessage('Nama shohibul qurban wajib diisi.');
      return;
    }
    if (!_akadAgreed) {
      _showMessage('Centang persetujuan akad terlebih dahulu.');
      return;
    }
    if (_paymentMethod == -1) {
      _showMessage('Pilih metode pembayaran terlebih dahulu.');
      return;
    }

    final method = _paymentMethod == 0 ? 'BCA Syariah VA' : 'QRIS Instant';
    final destination = _distribution == 0
        ? 'Masjid Al-Falah Kebayoran Baru'
        : 'Wilayah 3T & Dhuafa';

    // Konfirmasi akhir sebelum pengguna melanjutkan ke tahap pembayaran.
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.fact_check_outlined, color: green),
            SizedBox(width: 8),
            Expanded(child: Text('Konfirmasi Checkout')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pastikan metode pembayaran dan lokasi sudah sesuai.',
              style: TextStyle(
                color: ink,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: lavender,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('METODE PEMBAYARAN',
                      style: TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(method,
                      style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Text('LOKASI / PENYALURAN',
                      style: TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(destination,
                      style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Total tagihan', style: TextStyle(color: muted, fontSize: 10)),
                      ),
                      Text(
                        _rupiah(_total),
                        style: const TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Kembali', style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          icon: const Icon(Icons.check_circle, color: green, size: 42),
          title: const Text('Data Checkout Siap'),
          content: const Text(
            'Data akad dan pilihan pembayaran berhasil divalidasi di aplikasi. '
            'Integrasi pembuatan invoice dan pembayaran akan ditambahkan '
            'setelah backend tersedia.',
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: green),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 118),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 15),
                    _stepIndicator(),
                    const SizedBox(height: 9),
                    _sectionTitle('Konfirmasi & Akad Qurban', trailing: 'Tahap Akhir: Bayar'),
                    const SizedBox(height: 10),
                    _productCard(),
                    const SizedBox(height: 16),
                    _shohibulCard(),
                    const SizedBox(height: 16),
                    _distributionCard(),
                    const SizedBox(height: 16),
                    _paymentCard(),
                    const SizedBox(height: 16),
                    _costCard(),
                    const SizedBox(height: 15),
                    _escrowNotice(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _header() {
    return Row(
      children: [
        _backButton(),
        const Spacer(),
        const Column(
          children: [
            Text(
              'Checkout',
              style: TextStyle(
                color: green,
                fontSize: 23,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Lihat sampai mana pesanan anda saat di kirim',
              style: TextStyle(
                color: green,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(width: 42),
      ],
    );
  }

  Widget _backButton() {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: 'Kembali',
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back, color: ink, size: 20),
      ),
    );
  }

  Widget _stepIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.circle, size: 8, color: Color(0xFFFFB34F)),
            SizedBox(width: 6),
            Text(
              'LANGKAH 1 DARI 2',
              style: TextStyle(
                color: Color(0xFF56615B),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const LinearProgressIndicator(
            value: .5,
            minHeight: 6,
            backgroundColor: Color(0xFFE7E9EF),
            color: green,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, {String? trailing}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: ink,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(
              color: muted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _whiteCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D3427).withOpacity(.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _productCard() {
    return _whiteCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1524024973431-2ad916746881?w=500',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFDCEBD8),
                          child: const Icon(Icons.pets, color: green, size: 38),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                          color: Colors.black.withOpacity(.45),
                          child: const Text(
                            'Grade A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.verified, color: Color(0xFFFFB45D), size: 13),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "KUPAK 2 • SAH SYAR'I",
                            style: TextStyle(
                              color: green,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sapi Limousin Super',
                      style: TextStyle(
                        color: ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Bobot: ±420 kg • Jantan Dewasa',
                      style: TextStyle(color: muted, fontSize: 10),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.storefront_outlined, color: green, size: 12),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Berkah Farm Mandiri (Bogor)',
                            style: TextStyle(
                              color: Color(0xFF59665E),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            decoration: BoxDecoration(
              color: lavender,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Nilai Qurban',
                    style: TextStyle(color: muted, fontSize: 10),
                  ),
                ),
                Text(
                  _rupiah(_animalPrice),
                  style: const TextStyle(
                    color: green,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardHeading({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: mint,
          child: Icon(icon, color: green, size: 15),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF65746B),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shohibulCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeading(
            icon: Icons.person_pin_circle_outlined,
            title: 'Data Shohibul Qurban',
            subtitle: 'Niat & nama yang diikrarkan saat penyembelihan',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: lavender,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _typeButton('Qurban Pribadi', 0),
                ),
                Expanded(
                  child: _typeButton('Pahala Keluarga', 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Atas Nama (Shohibul Qurban)',
                  style: TextStyle(
                    color: ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Text(
                "Wajib Syar'i",
                style: TextStyle(
                  color: green,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            onChanged: (_) {
              if (_showNameError) setState(() => _showNameError = false);
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Masukkan nama shohibul qurban',
              errorText: _showNameError ? 'Nama wajib diisi' : null,
              filled: true,
              fillColor: lavender,
              contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
              suffixIcon: const Icon(Icons.verified_outlined, color: green, size: 19),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: green, width: 1),
              ),
            ),
            style: const TextStyle(color: ink, fontSize: 12),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nama ini akan dibacakan oleh juru sembelih (Juleha) bersertifikat.',
            style: TextStyle(color: muted, fontSize: 9.5, height: 1.35),
          ),
          const SizedBox(height: 11),
          _akadPanel(),
        ],
      ),
    );
  }

  Widget _typeButton(String title, int value) {
    final selected = _shohibulType == value;
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() => _shohibulType = value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? green : const Color(0xFF5F6B64),
              fontSize: 10,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _akadPanel() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book_outlined, color: green, size: 16),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Lafal Niat Akad Qurban (Wakalah)',
                  style: TextStyle(
                    color: green,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.only(left: 24),
            child: Text(
              '"Bismillahi Allahu Akbar. Saya berniat qurban lillahi Ta’ala dan mewakilkan pembelian, perawatan, hingga penyembelihan secara amanah."',
              style: TextStyle(
                color: Color(0xFF53645A),
                fontSize: 10,
                height: 1.55,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => setState(() => _akadAgreed = !_akadAgreed),
            borderRadius: BorderRadius.circular(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 19,
                  height: 19,
                  child: Checkbox(
                    value: _akadAgreed,
                    activeColor: green,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: (value) => setState(() => _akadAgreed = value ?? false),
                  ),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'Saya mengikrarkan akad qurban amanah sesuai syariat Islam & memberi izin penyembelihan atas nama di atas.',
                    style: TextStyle(
                      color: ink,
                      fontSize: 8.8,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _distributionCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeading(
            icon: Icons.local_shipping_outlined,
            title: 'Metode Distribusi & Penyaluran',
            subtitle: 'Pilih alur logistik penerimaan hewan',
          ),
          const SizedBox(height: 11),
          _distributionOption(
            index: 0,
            title: 'Kirim Hewan Hidup ke Masjid',
            description: 'Dikirim menggunakan armada khusus berpendingin & ventilasi aman.',
            icon: Icons.mosque_outlined,
          ),
          const SizedBox(height: 8),
          _distributionOption(
            index: 1,
            title: 'Salurkan ke Wilayah 3T & Dhuafa',
            description: 'Disembelih di sentra potong syar’i dan didistribusikan ke daerah tertular & rawan pangan.',
            icon: Icons.volunteer_activism_outlined,
          ),
        ],
      ),
    );
  }

  Widget _distributionOption({
    required int index,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final selected = _distribution == index;
    return InkWell(
      onTap: () => setState(() => _distribution = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: selected ? lavender : const Color(0xFFF7F8FD),
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: const Color(0xFFE2E5FF)) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? green : const Color(0xFF8B9690),
                size: 17,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: selected ? green : ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (index == 1)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD5E6DE),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Sedekah\nDaging',
                            style: TextStyle(
                              color: Color(0xFF61736A),
                              fontSize: 7.5,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF68766F),
                      fontSize: 9.5,
                      height: 1.35,
                    ),
                  ),
                  if (index == 0 && selected) ...[
                    const SizedBox(height: 8),
                    _destinationDetails(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _destinationDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mosque_outlined, color: green, size: 15),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Masjid Al-Falah Kebayoran Baru',
                  style: TextStyle(
                    color: ink,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Jl. Cisangiri II No. 1, RT 08 / RW 04, Kebayoran Baru, Jakarta Selatan, 12170',
            style: TextStyle(color: muted, fontSize: 9, height: 1.35),
          ),
          SizedBox(height: 7),
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, color: green, size: 13),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Estimasi: 15 Juni 2024, 08:00 – 12:00 WIB',
                  style: TextStyle(
                    color: green,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeading(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Metode Pembayaran Syariah',
            subtitle: 'Bebas riba & verifikasi instan 24/7',
          ),
          const SizedBox(height: 11),
          _paymentOption(
            index: 0,
            title: 'BCA Syariah VA',
            subtitle: 'Admin Rp 0',
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 8),
          _paymentOption(
            index: 1,
            title: 'QRIS Instant\n(Muamalat/Gopay/BSI)',
            subtitle: 'Maks. Rp 20.000.000 / transaksi',
            icon: Icons.qr_code_2,
          ),
        ],
      ),
    );
  }

  Widget _paymentOption({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _paymentMethod == index;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = index),
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FD),
          borderRadius: BorderRadius.circular(11),
          border: selected ? Border.all(color: green, width: 1.2) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: const Color(0xFF46564D), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? green : const Color(0xFFC3CCC5),
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  Widget _costCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Akad & Biaya',
            style: TextStyle(
              color: ink,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _costRow('Harga Sapi Limousin (420 kg)', _rupiah(_animalPrice)),
          const SizedBox(height: 8),
          _costRow(
            'Armada Khusus Hewan Ternak',
            _rupiah(_shippingFee),
            mutedValue: true,
            strike: true,
          ),
          const SizedBox(height: 7),
          _costRow(
            'Promo Subsidi Ongkir Iduladha',
            '-${_rupiah(_shippingSubsidy)}',
            valueColor: green,
            labelColor: green,
            bold: true,
          ),
          const SizedBox(height: 7),
          _costRow(
            'Pemeriksaan Lab & SKKH Kementan',
            'GRATIS',
            valueColor: green,
            bold: true,
          ),
          const SizedBox(height: 7),
          _costRow(
            'Infaq Operasional Penyaluran',
            _rupiah(_infaq),
            icon: Icons.volunteer_activism_outlined,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            decoration: BoxDecoration(
              color: lavender,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Tagihan Akad',
                        style: TextStyle(
                          color: Color(0xFF596A60),
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sudah termasuk PPN 0%',
                        style: TextStyle(color: muted, fontSize: 8),
                      ),
                    ],
                  ),
                ),
                Text(
                  _rupiah(_total),
                  style: const TextStyle(
                    color: green,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _costRow(
    String label,
    String value, {
    Color labelColor = const Color(0xFF58645D),
    Color valueColor = ink,
    bool mutedValue = false,
    bool strike = false,
    bool bold = false,
    IconData? icon,
  }) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 9.5,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, color: muted, size: 11),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            color: mutedValue ? muted : valueColor,
            fontSize: 10,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            decoration: strike ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }

  Widget _escrowNotice() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBFF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: green,
            child: Icon(Icons.verified_user_outlined, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Color(0xFF5E6871),
                  fontSize: 9.5,
                  height: 1.35,
                ),
                children: [
                  TextSpan(text: 'Dana ditampung dalam '),
                  TextSpan(
                    text: 'Rekening Syariah Escrow. ',
                    style: TextStyle(
                      color: ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: 'Pembayaran baru diteruskan ke peternak setelah hewan diterima sah sesuai kriteria syar’i.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.07),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL AKAD QURBAN',
                    style: TextStyle(
                      color: Color(0xFF65746B),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _rupiah(_total),
                    style: const TextStyle(
                      color: green,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _pay,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B5A00),
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.lock_outline, size: 15),
              label: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Bayar Syar'i",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.chevron_right, size: 17),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

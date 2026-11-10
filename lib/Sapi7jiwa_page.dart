import 'package:flutter/material.dart';

/// Halaman Sapi 7 Jiwa — pemesanan/kelompok qurban patungan 7 orang.
///
/// Cara pakai:
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => const Sapi7JiwaPage()),
/// );
///
/// Tidak membutuhkan package tambahan. Foto sapi menggunakan URL online;
/// ganti URL pada _cowImageUrl jika ingin memakai foto lokal milik sendiri.
class Sapi7JiwaPage extends StatefulWidget {
  const Sapi7JiwaPage({super.key});

  @override
  State<Sapi7JiwaPage> createState() => _Sapi7JiwaPageState();
}

class _Sapi7JiwaPageState extends State<Sapi7JiwaPage> {
  static const Color green = Color(0xFF07532F);
  static const Color darkGreen = Color(0xFF004522);
  static const Color mint = Color(0xFFE3F8E9);
  static const Color lavender = Color(0xFFF0F1FF);
  static const Color pageBg = Color(0xFFFAF8FD);
  static const Color ink = Color(0xFF202A3D);
  static const Color muted = Color(0xFF748078);
  static const String _cowImageUrl =
      'https://images.unsplash.com/photo-1524024973431-2ad916746881?w=1000';

  bool _openGroup = true;
  int? _selectedSlot = 6;
  int _allocation = 0;
  bool _joined = false;

  final List<_Member> _members = [
    _Member(1, 'Ahmad Fauzi, S.E.', 'Atas Nama: Keluarga Ahmad Fauzi', true, true),
    _Member(2, 'dr. Siti Aminah', 'Atas Nama: Alm. Ayah H. Mansur', true, false),
    _Member(3, 'Rian Hidayat', 'Atas Nama: Rian Hidayat', true, false),
    _Member(4, 'Hendra Kurniawan', 'Atas Nama: Hendra & Istri', true, false),
    _Member(5, 'Nurul Izzah', 'Atas Nama: Nurul Izzah', true, false),
  ];

  int get _filledSlots => _members.length + (_joined ? 1 : 0);
  int get _remainingSlots => 7 - _filledSlots;
  String get _selectedPrice => 'Rp 3.200.000';

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _takeSlot() async {
    if (_joined) {
      _snack('Kamu sudah bergabung dalam kelompok sapi ini.');
      return;
    }
    if (_selectedSlot == null) {
      _snack('Pilih slot yang tersedia terlebih dahulu.');
      return;
    }

    final slot = _selectedSlot!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Ambil Slot'),
        content: Text(
          'Kamu akan mengambil Slot $slot pada Kelompok Sapi #04 '
          'dengan biaya $_selectedPrice. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Kembali'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: green),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Ambil Slot'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _joined = true;
        _members.add(
          _Member(
            slot,
            'Anda (Shohibul Qurban)',
            'Atas Nama: Nama pemesan',
            true,
            false,
          ),
        );
        _selectedSlot = null;
      });
      _snack('Slot $slot berhasil dipilih. Lanjutkan proses pembayaran.');
    }
  }

  void _selectSlot(int slot) {
    if (_joined) {
      _snack('Kamu sudah mengambil slot dalam kelompok ini.');
      return;
    }
    setState(() => _selectedSlot = slot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 118),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 16),
                    _topBadges(),
                    const SizedBox(height: 11),
                    _hadithCard(),
                    const SizedBox(height: 18),
                    _groupMode(),
                    const SizedBox(height: 10),
                    _autoMatchInfo(),
                    const SizedBox(height: 17),
                    _cowProductCard(),
                    const SizedBox(height: 18),
                    _groupCard(),
                    const SizedBox(height: 17),
                    _meatEstimateCard(),
                    const SizedBox(height: 17),
                    _guaranteeCard(),
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
        _circleButton(
          Icons.arrow_back,
          () => Navigator.maybePop(context),
        ),
        const Spacer(),
        const Column(
          children: [
            Text(
              'Sapi 7 Jiwa',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: green,
                height: 1.1,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Layanan beli dan rawat ternak',
              style: TextStyle(
                fontSize: 10,
                color: green,
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

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: ink, size: 20),
        tooltip: 'Kembali',
      ),
    );
  }

  Widget _topBadges() {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        _badge(
          'SESUAI FATWA MUI & SUNNAH',
          Icons.verified,
          const Color(0xFFD5F4DF),
          green,
        ),
        _badge(
          'Patungan Maks. 7 Orang',
          Icons.groups_2_outlined,
          const Color(0xFFE1E5FF),
          const Color(0xFF53608A),
        ),
      ],
    );
  }

  Widget _badge(String text, IconData icon, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hadithCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF07552F), Color(0xFF003E21)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: green.withOpacity(.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: Color(0xFFB7E8C8),
              size: 17,
            ),
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Landasan Sunnah Shahih',
                  style: TextStyle(
                    color: Color(0xFFB9E4C8),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '"Kami pernah berkurban bersama Rasulullah SAW pada tahun Hudaibiyah: seekor unta untuk tujuh orang dan seekor sapi untuk tujuh orang."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.45,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'HR. Muslim no. 1318',
                    style: TextStyle(
                      color: Color(0xFFB9E4C8),
                      fontSize: 9,
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

  Widget _groupMode() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _modeButton(
              title: 'Kelompok Terbuka',
              icon: Icons.public,
              selected: _openGroup,
              onTap: () => setState(() => _openGroup = true),
            ),
          ),
          Expanded(
            child: _modeButton(
              title: 'Kelompok Mandiri\n(Keluarga)',
              icon: Icons.lock_outline,
              selected: !_openGroup,
              onTap: () {
                setState(() => _openGroup = false);
                _showPrivateGroupInfo();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: selected ? green : muted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: selected ? green : const Color(0xFF59616B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivateGroupInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kelompok Mandiri'),
        content: const Text(
          'Mode kelompok mandiri ditujukan untuk keluarga atau rombongan '
          'yang ingin mengatur sendiri seluruh 7 nama shohibul qurban. '
          'Fitur pengelolaan anggota keluarga dapat dihubungkan ke backend.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  Widget _autoMatchInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF568A6A)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            _openGroup
                ? 'Sistem memasangkan Anda secara otomatis dengan shohibul qurban terverifikasi se-Indonesia.'
                : 'Mode kelompok mandiri dipilih. Kelompok dapat diisi bersama anggota keluarga Anda.',
            style: const TextStyle(
              color: muted,
              fontSize: 10,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _cowProductCard() {
    return _whiteCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: SizedBox(
              height: 170,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _cowImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFD7E6C9),
                      child: const Center(
                        child: Icon(Icons.pets, color: green, size: 65),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black38,
                          Colors.transparent,
                          Colors.black54,
                        ],
                        stops: [0, .45, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: _photoLabel('420 kg (Kategori Super A)', Icons.crop_square),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: _photoLabel('SKKH Resmi', Icons.verified_outlined),
                  ),
                  const Positioned(
                    left: 11,
                    bottom: 11,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID Tag: #SP-8821-JGG',
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Sapi Simmental Bobot',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '420 kg',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    right: 11,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Mitra Kandang',
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                        Text(
                          'Berkah Farm Jonggol',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _pricePanel(
                  'Harga Total Sapi (7 Slot)',
                  'Rp 22.400.000',
                  '1 Ekor Utuh Dewasa',
                  false,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _pricePanel(
                  'Harga per 1 Slot (1/7)',
                  _selectedPrice,
                  'All-in bebas biaya rawat',
                  true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          const Row(
            children: [
              Expanded(child: _CareFeature(Icons.check_circle_outline, 'Perawatan s/d Hari H')),
              Expanded(child: _CareFeature(Icons.check_circle_outline, 'Sembelih Juleha')),
              Expanded(child: _CareFeature(Icons.check_circle_outline, 'Packing Higienis')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _photoLabel(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: green),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: green,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pricePanel(String title, String price, String subtitle, bool highlight) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFE4F6EA) : lavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: muted,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              color: highlight ? green : ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              color: highlight ? green : muted,
              fontSize: 8,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupCard() {
    final percent = _filledSlots / 7;
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, color: green, size: 10),
              const SizedBox(width: 5),
              const Expanded(
                child: Text(
                  'Kelompok Sapi #04',
                  style: TextStyle(
                    color: green,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _badge(
                _remainingSlots == 0 ? 'Kelompok Penuh' : 'Sisa $_remainingSlots Slot!',
                Icons.hourglass_top,
                const Color(0xFFFFE2C3),
                const Color(0xFF84501A),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Kloter Barokah • Target Selesai H-3',
            style: TextStyle(color: muted, fontSize: 9.5),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$_filledSlots dari 7 Slot Terpenuhi',
                  style: const TextStyle(
                    color: ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${(percent * 100).round()}% Lengkap',
                style: const TextStyle(
                  color: green,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E5FF),
              color: green,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Jika kuota 7 slot penuh, akad kelompok otomatis dikunci dan diterbitkan sertifikat kloter.',
            style: TextStyle(color: muted, fontSize: 9.5, height: 1.35),
          ),
          const SizedBox(height: 11),
          ..._members.map(_memberTile),
          if (_remainingSlots > 0)
            for (final slot in [6, 7])
              if (!_members.any((member) => member.slot == slot))
                _availableSlotTile(slot),
          if (_remainingSlots == 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '✓ Kelompok telah lengkap. Akad kelompok siap diproses.',
                style: TextStyle(
                  color: green,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _memberTile(_Member member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        color: lavender,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: member.isLeader ? darkGreen : green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${member.slot}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (member.isLeader) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8F1C8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Ketua',
                          style: TextStyle(
                            color: green,
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  member.onBehalf,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: muted, fontSize: 8.5),
                ),
              ],
            ),
          ),
          _badge(
            member.paid ? 'Lunas' : 'Menunggu',
            member.paid ? Icons.check_circle : Icons.schedule,
            member.paid ? const Color(0xFFDDE5FF) : const Color(0xFFFFE9CB),
            member.paid ? green : const Color(0xFF8B5C18),
          ),
        ],
      ),
    );
  }

  Widget _availableSlotTile(int slot) {
    final selected = _selectedSlot == slot;
    return GestureDetector(
      onTap: () => _selectSlot(slot),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE0F8E6) : lavender,
          borderRadius: BorderRadius.circular(13),
          border: selected ? Border.all(color: const Color(0xFFC4EBD0)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE6E9FF) : const Color(0xFFE7E9FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$slot',
                style: const TextStyle(
                  color: green,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Slot 0$slot Tersedia',
                        style: const TextStyle(
                          color: green,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.circle, color: Color(0xFFFFA33A), size: 7),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Ketuk untuk mengambil kuota ini',
                    style: TextStyle(color: muted, fontSize: 8.5),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
              decoration: BoxDecoration(
                color: selected ? green : darkGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? Icons.check : Icons.add,
                    color: Colors.white,
                    size: 11,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    selected ? 'Terpilih' : 'Pilih Slot',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _meatEstimateCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.savings_outlined, color: green, size: 20),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Estimasi Hak Daging Qurban',
                  style: TextStyle(
                    color: green,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _badge('1/7 Bagian', Icons.check, const Color(0xFFBDF0C9), green),
            ],
          ),
          const SizedBox(height: 9),
          const Text(
            'Dari total bobot 420 kg sapi, setiap shohibul qurban berhak menerima estimasi karkas bersih:',
            style: TextStyle(color: muted, fontSize: 9.5, height: 1.4),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F9EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PORSI KARKAS ANDA',
                  style: TextStyle(
                    color: green,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '± 18.5 – 21.0 kg',
                      style: TextStyle(
                        color: green,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: Text(
                          'Daging + Tulang + Jeroan',
                          style: TextStyle(
                            color: ink,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Pilih Alokasi Distribusi Porsi Anda:',
            style: TextStyle(
              color: ink,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          _allocationOption(
            index: 0,
            title: 'Kirim 100% ke Alamat Rumah',
            description: 'Dikirimkan dalam cool box thermo-insulated H+1 Iduladha ke alamat Anda.',
            tag: null,
          ),
          _allocationOption(
            index: 1,
            title: 'Bagi 1/3 Pribadi & 2/3 Sedekah',
            description: '±6.5 kg dikirim ke rumah, sisanya (±13 kg) disalurkan ke desa pelosok 3T.',
            tag: 'Sunnah',
          ),
          _allocationOption(
            index: 2,
            title: 'Sedekahkan 100% ke Dhuafa & Pesantren',
            description: 'Seluruh daging disalurkan atas nama Anda kepada mustahik yang sangat membutuhkan.',
            tag: null,
          ),
        ],
      ),
    );
  }

  Widget _allocationOption({
    required int index,
    required String title,
    required String description,
    required String? tag,
  }) {
    final selected = _allocation == index;
    return GestureDetector(
      onTap: () => setState(() => _allocation = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: lavender,
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: const Color(0xFF9BCBAB), width: 1.2) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? green : const Color(0xFF92999D),
                size: 17,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 3,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (tag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE1BD),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Color(0xFF88501C),
                              fontSize: 7.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 8.8,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guaranteeCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, color: green, size: 20),
              SizedBox(width: 6),
              Text(
                'Transparansi & Garansi Syariah',
                style: TextStyle(
                  color: green,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          _guaranteeItem(
            Icons.handshake_outlined,
            'Bagaimana jika kuota tidak genap 7 orang?',
            'Garansi Qurbanakan mengamankan sisa slot yang kosong atau menggabungkannya ke kloter sapi cadangan sehingga tidak ada H-2 tanpa biaya tambahan sepeser pun.',
          ),
          const SizedBox(height: 9),
          _guaranteeItem(
            Icons.video_camera_back_outlined,
            'Akad Wakalah & Live Streaming',
            'Ikrar wakalah pelimpahan sembelih diakses digital via aplikasi. Penyembelihan disiarkan langsung (Live HD) saat hari Tasyrik dengan penyebutan nama shohibul qurban.',
          ),
        ],
      ),
    );
  }

  Widget _guaranteeItem(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: lavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFFBDF0CB),
            child: Icon(icon, color: green, size: 15),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 8.8,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _whiteCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF253A2B).withOpacity(.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _bottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
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
                    '1 Slot Shohibul Qurban  •  Sapi 1/7',
                    style: TextStyle(
                      color: muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _joined ? 'Slot berhasil dipilih' : _selectedPrice,
                    style: const TextStyle(
                      color: green,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Bebas riba • Sertifikat Digital Resmi',
                    style: TextStyle(color: muted, fontSize: 8.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _joined ? null : _takeSlot,
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                disabledBackgroundColor: const Color(0xFF8AA797),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _joined
                        ? 'Slot Diambil'
                        : _selectedSlot == null
                            ? 'Pilih Slot'
                            : 'Ambil Slot $_selectedSlot',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CareFeature(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4C9167), size: 13),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF68766D),
              fontSize: 8,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _Member {
  final int slot;
  final String name;
  final String onBehalf;
  final bool paid;
  final bool isLeader;

  const _Member(
    this.slot,
    this.name,
    this.onBehalf,
    this.paid,
    this.isLeader,
  );
}

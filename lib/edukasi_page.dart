import 'package:flutter/material.dart';

// Model data. Nanti bisa diganti dengan data dari API.
class _Defect {
  final String title;
  final String desc;
  const _Defect(this.title, this.desc);
}

class _AgeRule {
  final IconData icon;
  final String animal;
  final String age;
  final String note;
  const _AgeRule(this.icon, this.animal, this.age, this.note);
}

class _Sunnah {
  final String title;
  final String desc;
  const _Sunnah(this.title, this.desc);
}

class _Faq {
  final String question;
  final String answer;
  const _Faq(this.question, this.answer);
}

class EdukasiPage extends StatefulWidget {
  const EdukasiPage({super.key});

  @override
  State<EdukasiPage> createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  // Warna utama (disamakan dengan halaman lain)
  final Color primaryGreen = const Color(0xFF1B5E20);
  final Color darkGreen = const Color(0xFF0B3D20);
  final Color lightGreen = const Color(0xFFA7F3A0);
  final Color softGreen = const Color(0xFFE8F5EA);

  // Filter yang aktif (baru menyorot chip, belum menyaring konten)
  int _selectedFilter = 0;

  // Nomor amalan sunnah yang sudah dicentang (awalnya 2 pertama, sesuai desain)
  final Set<int> _checkedSunnah = {0, 1};

  static const List<String> _filterLabels = [
    "Semua",
    "Syarat Sah",
    "Dalil & Fatwa",
    "Adab Sembelih",
  ];
  static const List<IconData> _filterIcons = [
    Icons.star_rounded,
    Icons.verified_outlined,
    Icons.menu_book_outlined,
    Icons.content_cut_rounded,
  ];

  // Isi konten disalin dari desain. Mohon diverifikasi oleh Dewan Syariah.
  final List<_Defect> _defects = const [
    _Defect("Buta sebelah (Al-'Awra)", "Yang jelas butanya atau buta total kedua matanya."),
    _Defect("Sakit Nyata (Al-Maridhah)", "Terjangkit PMK aktif, antraks, demam tinggi, atau lesi berat."),
    _Defect("Pincang Nyata (Al-'Arja)", "Pincang parah hingga tak sanggup berjalan sejajar rombongannya."),
    _Defect("Kurus Kering (Al-Kasirah)", "Sangat kurus hingga tidak lagi memiliki sumsum tulang."),
  ];

  final List<_AgeRule> _ageRules = const [
    _AgeRule(Icons.agriculture_outlined, "Sapi / Kerbau", "Min. 2 Tahun",
        "Memasuki tahun ke-3 (Muntihah/sah untuk 7 orang)"),
    _AgeRule(Icons.pets_outlined, "Kambing Kacang", "Min. 1 Tahun",
        "Memasuki tahun ke-2 (Sah untuk 1 orang)"),
    _AgeRule(Icons.cloud_outlined, "Domba / Gibas", "Min. 6 Bulan - 1 Thn",
        "Status Jadza atau telah berganti gigi seri"),
    _AgeRule(Icons.landscape_outlined, "Unta", "Min. 5 Tahun",
        "Memasuki tahun ke-6 (Sah untuk 7 atau 10 orang)"),
  ];

  final List<_Sunnah> _sunnahList = const [
    _Sunnah("Menahan potong kuku & rambut",
        "Berlaku sejak masuk 1 Dzulhijjah hingga hewan selesai disembelih."),
    _Sunnah("Memperbanyak takbir mutlaq & muqayyad",
        "Dimulai sejak fajar hari Arafah sampai akhir hari Tasyrik tiap selesai shalat."),
    _Sunnah("Menyaksikan penyembelihan kurban",
        "Hadir secara langsung di kandang mitra Qurbankan atau menonton via Live Streaming aplikasi."),
    _Sunnah("Memakai sebagian daging kurban",
        "Disunnahkan mencicipi 1/3 porsi kurban sunnah bersama keluarga inti dan disedekahkan sisanya."),
  ];

  // Jawaban masih draf, mohon dicek oleh Dewan Syariah sebelum rilis
  final List<_Faq> _faqs = const [
    _Faq("Bolehkah Patungan 1 Sapi untuk 7 Orang?",
        "Boleh. Satu ekor sapi atau unta dapat dipatungkan hingga 7 orang, sesuai hadis riwayat Muslim. Kambing atau domba hanya untuk 1 orang."),
    _Faq("Bagaimana Rumus Pembagian Daging Kurban?",
        "Umumnya dibagi tiga: sepertiga dimakan sendiri, sepertiga dihadiahkan, dan sepertiga disedekahkan kepada fakir miskin."),
    _Faq("Hukum Kurban Online via Akad Wakalah?",
        "Menurut banyak ulama sah, selama shohibul qurban mewakilkan kepada pihak yang amanah, hewan memenuhi syarat, dan disembelih pada waktunya."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      body: Container(
        // Gradasi hijau muda di bagian atas layar
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD5F5DA), Color(0xFFF6F8FD)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 16),
                _buildIntro(),
                const SizedBox(height: 16),
                _buildFilterChips(),
                const SizedBox(height: 16),
                _buildFeaturedCard(),
                const SizedBox(height: 16),
                _buildDefectCard(),
                const SizedBox(height: 16),
                _buildAgeCard(),
                const SizedBox(height: 16),
                _buildSlaughterCard(),
                const SizedBox(height: 24),
                _buildSunnahSection(),
                const SizedBox(height: 24),
                _buildFaqSection(),
                const SizedBox(height: 16),
                _buildTipsCard(),
                const SizedBox(height: 16),
                _buildConsultCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- LOGIKA ---

  // Tombol yang tujuannya belum dibuat menampilkan pesan singkat
  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$label belum tersedia")),
    );
  }

  // Centang / lepas centang amalan sunnah
  void _toggleSunnah(int index) {
    setState(() {
      if (_checkedSunnah.contains(index)) {
        _checkedSunnah.remove(index);
      } else {
        _checkedSunnah.add(index);
      }
    });
  }

  // --- WIDGET HELPER ---

  // Kartu putih standar yang dipakai berulang
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // Ikon kecil berlatar warna, dipakai di judul kartu
  Widget _buildIconBox(IconData icon, Color bg, Color fg) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, size: 18, color: fg),
    );
  }

  // Tombol kembali + judul halaman
  Widget _buildTopBar() {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              customBorder: const CircleBorder(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, size: 20, color: darkGreen),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edukasi",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: darkGreen),
              ),
              const Text(
                "Bersama, Lebih Mudah Berkurban",
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Pengantar: chip, judul besar, deskripsi, dan tile "Tuntunan"
  Widget _buildIntro() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8F0CE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_outlined, size: 12, color: darkGreen),
                    const SizedBox(width: 4),
                    Text(
                      "Syariat & Fiqih Muamalah",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: darkGreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Edukasi Fiqih",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkGreen),
              ),
              const Text(
                "Kurban & Peternakan",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0A1F12)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Pelajari ilmu shahih, persiapkan kurban dengan benar, syar'i, dan penuh keberkahan.",
                style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(16)),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mosque_outlined, size: 26, color: Colors.white),
              SizedBox(height: 2),
              Text("Tuntunan", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  // Filter chip yang bisa digeser ke samping
  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filterLabels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final bool isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? darkGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? darkGreen : const Color(0xFFDDE3DD)),
              ),
              child: Row(
                children: [
                  Icon(_filterIcons[index], size: 14, color: isSelected ? Colors.amber : darkGreen),
                  const SizedBox(width: 6),
                  Text(
                    _filterLabels[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : darkGreen,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Kartu hijau tua "Panduan Utama"
  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFACC15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: 12, color: Color(0xFF5B4400)),
                SizedBox(width: 4),
                Text("Panduan Utama",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5B4400))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Syarat Sah Hewan Kurban Menurut Syariat Islam & Fatwa MUI",
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ketahui kriteria mutlak hewan kurban sah: batasan umur minimal (poel/kupuk), bebas 4 aib cacat fisik, dan status kesehatan.",
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 12),

          // Foto + label sertifikasi
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Jika gambar belum ada di resources/, tampil placeholder hijau
                  Image.asset(
                    'resources/edukasi_ternak.jpg', // <-- GANTI dengan foto kamu
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF3F7A45),
                      child: const Icon(Icons.landscape_outlined, size: 48, color: Colors.white54),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: lightGreen),
                          const SizedBox(width: 4),
                          const Text(
                            "100% Layak Syariat & Tersertifikasi SKKH",
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: lightGreen, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text("Standar Komisi Fatwa MUI",
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
              ),
              ElevatedButton(
                onPressed: () => _showComingSoon("Artikel panduan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: darkGreen,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Baca Selengkapnya"),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Kartu "4 Cacat yang Membuat Hewan Tidak Sah"
  Widget _buildDefectCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconBox(Icons.warning_amber_rounded, const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "4 Cacat yang Membuat Hewan Tidak Sah",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: darkGreen),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "HR. Tirmidzi\n& Abu Daud",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Berdasarkan sabda Rasulullah ﷺ tentang aib yang mutlak membatalkan sahnya kurban:",
            style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            _defects.length,
            (i) => _buildDefectItem(i + 1, _defects[i]),
          ),
        ],
      ),
    );
  }

  // Satu baris cacat: nomor merah + judul + penjelasan
  Widget _buildDefectItem(int number, _Defect defect) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1E3E3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Color(0xFFFEE2E2), shape: BoxShape.circle),
            child: Text(
              "$number",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(defect.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(defect.desc, style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kartu "Ketentuan Batasan Usia Minimal"
  Widget _buildAgeCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBox(Icons.hourglass_bottom_rounded, softGreen, darkGreen),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ketentuan Batasan Usia Minimal (Musinnah)",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: darkGreen),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Teliti berganti sepasang gigi seri depan (Poel / Kupuk)",
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAgeGrid(),
        ],
      ),
    );
  }

  // Grid 2 kolom. Tiap baris disamakan tingginya dengan IntrinsicHeight.
  Widget _buildAgeGrid() {
    final List<Widget> rows = [];
    for (int i = 0; i < _ageRules.length; i += 2) {
      final bool hasPair = i + 1 < _ageRules.length;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < _ageRules.length ? 8 : 0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildAgeTile(_ageRules[i])),
                const SizedBox(width: 8),
                Expanded(child: hasPair ? _buildAgeTile(_ageRules[i + 1]) : const SizedBox()),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildAgeTile(_AgeRule rule) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: softGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(rule.icon, size: 14, color: darkGreen),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  rule.animal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: darkGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(rule.age, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(rule.note, style: const TextStyle(fontSize: 10, color: Colors.black54, height: 1.3)),
        ],
      ),
    );
  }

  // Kartu "Adab & Rukun Sembelih Halal (Juleha)"
  Widget _buildSlaughterCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Adab & Rukun Sembelih Halal (Juleha)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: darkGreen),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: softGreen, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  "Sesuai Syar'i",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Tata cara penyembelihan wajib memutus 3 saluran vital hewan secara sempurna:",
            style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildStepBox("1. Hulqum", "Saluran Nafas")),
              const SizedBox(width: 8),
              Expanded(child: _buildStepBox("2. Mari'", "Saluran Makanan")),
              const SizedBox(width: 8),
              Expanded(child: _buildStepBox("3. Wadajain", "2 Urat Darah Leher")),
            ],
          ),
          const SizedBox(height: 12),
          _buildCheckLine("Wajib membaca Bismillahi Allahu Akbar saat mengeksekusi"),
          _buildCheckLine("Pisau diyaratkan sangat tajam dan dilarang diasah di depan hewan"),
          _buildCheckLine("Rebahkan hewan ke sisi kiri menghadap kiblat dengan santun"),
        ],
      ),
    );
  }

  Widget _buildStepBox(String title, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E7F5)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: darkGreen)),
          const SizedBox(height: 2),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, height: 1.4)),
          ),
        ],
      ),
    );
  }

  // Bagian checklist amalan sunnah (interaktif)
  Widget _buildSunnahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PANDUAN FIQIH PRAKTIS",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Amalan Sunnah Shohibul Qurban",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: darkGreen),
                  ),
                ],
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: softGreen, shape: BoxShape.circle),
              child: Icon(Icons.check_circle_outline, size: 18, color: darkGreen),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Tandai persiapan amalan sunnah yang dapat Anda lakukan menjelang penyembelihan kurban Anda tahun ini:",
          style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
        ),
        const SizedBox(height: 12),
        ...List.generate(_sunnahList.length, (i) => _buildSunnahItem(i)),
      ],
    );
  }

  Widget _buildSunnahItem(int index) {
    final _Sunnah item = _sunnahList[index];
    final bool checked = _checkedSunnah.contains(index);

    return GestureDetector(
      onTap: () => _toggleSunnah(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEFFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kotak centang buatan sendiri
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: checked ? darkGreen : Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: checked ? darkGreen : Colors.grey.shade400, width: 1.5),
              ),
              child: checked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(item.desc, style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bagian tanya jawab (bisa dibuka-tutup)
  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tanya Jawab Fiqih Populer",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: darkGreen),
            ),
            GestureDetector(
              onTap: () => _showComingSoon("Halaman tanya jawab"),
              child: Row(
                children: [
                  Text(
                    "Lihat Semua",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryGreen),
                  ),
                  Icon(Icons.chevron_right, size: 16, color: primaryGreen),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._faqs.map(_buildFaqTile),
      ],
    );
  }

  Widget _buildFaqTile(_Faq faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E9F2)),
      ),
      clipBehavior: Clip.antiAlias,
      // Hilangkan garis pemisah bawaan ExpansionTile
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          expandedAlignment: Alignment.centerLeft,
          iconColor: Colors.black54,
          collapsedIconColor: Colors.black54,
          leading: Icon(Icons.help_outline_rounded, size: 20, color: primaryGreen),
          title: Text(
            faq.question,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          children: [
            Text(faq.answer, style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.5)),
          ],
        ),
      ),
    );
  }

  // Kartu tips memilih ternak
  Widget _buildTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F5E7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E8CC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.lightbulb_outline, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tips Memilih Ternak Berkualitas",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: darkGreen),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Pastikan mata hewan cerah tidak berair, cermin hidung basah & bersih, nafsu makan aktif, bulu berkilau tidak kusam, serta memiliki dokumen Surat Keterangan Kesehatan Hewan (SKKH).",
                  style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kartu gelap ajakan konsultasi
  Widget _buildConsultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B2E1F),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LAYANAN INTERAKTIF",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                    color: lightGreen,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Konsultasi Dewan Syariah",
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Punya keraguan seputar hewan atau akad kurban? Tanya langsung ke asatidz.",
                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => _showComingSoon("Konsultasi"),
            customBorder: const CircleBorder(),
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
              child: const Icon(Icons.headset_mic_outlined, size: 22, color: Color(0xFF0B2E1F)),
            ),
          ),
        ],
      ),
    );
  }
}
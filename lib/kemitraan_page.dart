// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kemitraan Peternak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1B5E20), // Hijau Tua
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const KemitraanPage(),
    );
  }
}

class KemitraanPage extends StatefulWidget {
  // ignore: use_super_parameters
  const KemitraanPage({Key? key}) : super(key: key);

  @override
  State<KemitraanPage> createState() => _KemitraanPageState();
}

class _KemitraanPageState extends State<KemitraanPage> {
  final TextEditingController _namaPeternakanCtrl = TextEditingController(text: "Berkah Farm Sukabumi");
  final TextEditingController _populasiCtrl = TextEditingController(text: "100 - 300 Ekor (Kandang Komersial Utama)");
  final TextEditingController _alamatCtrl = TextEditingController(text: "Jl. Raya Parungkuda No. 45, RT 03/RW 02, Desa Bojongkokosan, Kec. Parungkuda, Kabupaten Sukabumi, Jawa Barat 43357");
  final TextEditingController _namaPemilikCtrl = TextEditingController(text: "H. Rohman Sudrajat, S.Pt");
  final TextEditingController _whatsappCtrl = TextEditingController(text: "081298448920");

  // State untuk kategori komoditas (multi-select simulation)
  final List<String> _selectedKomoditas = ["Sapi Potong (Limousin/Simental)", "Domba / Kambing Etawa"];

  // --- FUNGSI-FUNGSI INTERAKTIF ---

  void _onBackPressed() {
    print("Navigasi kembali ditekan");
  }

  void _onDaftarMitraPressed() {
    print("Tombol Gratis Biaya Daftar / Banner ditekan");
  }

  void _toggleKomoditas(String komoditas) {
    setState(() {
      if (_selectedKomoditas.contains(komoditas)) {
        _selectedKomoditas.remove(komoditas);
      } else {
        _selectedKomoditas.add(komoditas);
      }
    });
    print("Komoditas terpilih saat ini: $_selectedKomoditas");
  }

  void _onUploadDokumen(String jenisDokumen) {
    print("Memilih file untuk: $jenisDokumen");
    // Logika pemilihan file (image_picker / file_picker) bisa ditaruh di sini
  }

  void _onPinLocationPressed() {
    print("Membuka peta untuk pin lokasi GPS");
  }

  void _onFotoFisikPressed() {
    print("Membuka kamera / galeri untuk foto kandang");
  }

  void _onKonfirmasiPressed() {
    print("Tombol Konfirmasi Penerimaan Hewan ditekan");
    // Validasi form di sini sebelum lanjut
  }

  @override
  void dispose() {
    _namaPeternakanCtrl.dispose();
    _populasiCtrl.dispose();
    _alamatCtrl.dispose();
    _namaPemilikCtrl.dispose();
    _whatsappCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // --- KONTEN UTAMA (SCROLLABLE) ---
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeaderAndHero()),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildStepperIndicator(),
                      const SizedBox(height: 24),
                      _buildTitleSection(),
                      const SizedBox(height: 24),
                      _buildFormSection(),
                      const SizedBox(height: 32),
                      _buildKeuntunganMitraSection(),
                      const SizedBox(height: 24),
                      _buildKisahSuksesCard(),
                      const SizedBox(height: 24),
                      _buildPernyataanCard(),
                      const SizedBox(height: 100), // Spasi untuk bottom button
                    ]),
                  ),
                ),
              ],
            ),
            
            // --- FLOATING BOTTOM BUTTON ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _onKonfirmasiPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE6A817), // Warna Emas/Oranye
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app_outlined, size: 20),
                      SizedBox(width: 8),
                      Text("Konfirmasi Penerimaan Hewan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildHeaderAndHero() {
    return Column(
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: _onBackPressed,
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              const Expanded(
                child: Column(
                  children: [
                    Text("Kemitraan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                    Text("buat toko usaha sendiri dan bergabung dengan kami", style: TextStyle(fontSize: 10, color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
        // Hero Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF2E7D32), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        Icon(Icons.verified, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text("Mitra Terverifikasi DSN-MUI & SKKH", style: TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFFD54F), borderRadius: BorderRadius.circular(20)),
                    child: const Text("GRATIS BIAYA DAFTAR", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Buka Toko Ternak & Raih\nPasar Kurban Nasional", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Jangkau puluhan ribu shohibul qurban & investor QRest tanpa perantara tengkulak. 100% Sesuai Syariat Islam.", style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3.5,
                children: [
                  _buildHeroFeature(Icons.search, "Pencairan H+1\nAkad"),
                  _buildHeroFeature(Icons.attach_money, "Akses Modal\nQRest"),
                  _buildHeroFeature(Icons.medical_services, "Dampingan\nDokter Disnak"),
                  _buildHeroFeature(Icons.monitor_weight, "Timbangan Digital\nIoT"),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroFeature(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildStepperIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.circle, size: 10, color: Color(0xFF1B5E20)),
                SizedBox(width: 6),
                Text("PENDAFTARAN KEMITRAAN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
            Text("Langkah 1 dari 4", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(flex: 1, child: _buildStepProgress(1, "Profil Toko", true)),
            const SizedBox(width: 8),
            Expanded(flex: 1, child: _buildStepProgress(2, "Kandang", false)),
            const SizedBox(width: 8),
            Expanded(flex: 1, child: _buildStepProgress(3, "SKKH Disnak", false)),
            const SizedBox(width: 8),
            Expanded(flex: 1, child: _buildStepProgress(4, "Akad Bank", false)),
          ],
        )
      ],
    );
  }

  Widget _buildStepProgress(int step, String label, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1B5E20) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 4),
        Text("$step. $label", style: TextStyle(fontSize: 10, color: isActive ? Colors.black87 : Colors.grey.shade500, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Data Identitas Peternakan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text("Lengkapi detail toko untuk mulai memasarkan hewan qurban secara terverifikasi.", style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField("Nama Peternakan / Toko Ternak *", "Sesuai plang/akta", _namaPeternakanCtrl, Icons.storefront),
        const SizedBox(height: 16),
        
        const Text("Kategori Komoditas Ternak *", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text("Pilih komoditas yang saat ini siap atau dipelihara di kandang:", style: TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildKomoditasChip("Sapi Potong (Limousin/Simental)"),
            _buildKomoditasChip("Domba / Kambing Etawa"),
            _buildKomoditasChip("Bibit Anakan (Pedet/Cempe)", isAdd: true),
            _buildKomoditasChip("Sapi Perah & Olahan", isAdd: true),
          ],
        ),
        const SizedBox(height: 16),

        _buildInputField("Estimasi Populasi & Kapasitas Kandang *", "", _populasiCtrl, Icons.home_work),
        const SizedBox(height: 16),

        _buildInputField("Alamat Kandang & Titik Presisi GPS *", "", _alamatCtrl, Icons.location_on, maxLines: 3),
        const SizedBox(height: 8),
        _buildMapPreview(),
        const SizedBox(height: 16),

        _buildInputField("Nama Pemilik / Penanggung Jawab *", "", _namaPemilikCtrl, Icons.person),
        const SizedBox(height: 16),

        _buildInputField("Kontak WhatsApp Aktif (Notifikasi Order) *", "", _whatsappCtrl, Icons.phone_android),
        const SizedBox(height: 24),

        const Text("Upload Dokumen Legalitas & Kesehatan Ternak", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const Text("Format didukung: JPG, PNG, atau PDF (Maks. 5MB per berkas)", style: TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 12),
        
        _buildDocumentUploadCard("KTP Penanggung Jawab Toko", "ktp_h_rohman_verif.jpg (1.8 MB)", Icons.badge, true),
        const SizedBox(height: 8),
        _buildDocumentUploadCard("SKKH Resmi dari Dinas Peternakan", "skkh_dinas_peternakan_2024.pdf (2.4 MB)", Icons.health_and_safety, true),
        const SizedBox(height: 8),
        _buildDocumentUploadCard("Sertifikasi Juru Sembelih Halal", "Opsional tapi diutamakan", Icons.workspace_premium, false),
      ],
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (hint.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(hint, style: const TextStyle(fontSize: 10, color: Colors.red)),
            ]
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
            filled: true,
            fillColor: const Color(0xFFF1F3F4),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildKomoditasChip(String text, {bool isAdd = false}) {
    bool isSelected = _selectedKomoditas.contains(text);
    return GestureDetector(
      onTap: () => _toggleKomoditas(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAdd && !isSelected) ...[
              Icon(Icons.add_circle_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                'https://maps.googleapis.com/maps/api/staticmap?center=-6.83742,106.77218&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7C-6.83742,106.77218&key=YOUR_API_KEY', // Ganti dengan URL statik peta asli atau aset
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey.shade300,
                  child: const Center(child: Text("Peta Lokasi (Placeholder)")),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(4)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lat: -6.83742, Long: 106.77218 (AK)", style: TextStyle(color: Colors.white, fontSize: 10)),
                      Text("TERSEMAT", style: TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _onPinLocationPressed,
                icon: const Icon(Icons.location_on, size: 16),
                label: const Text("Ubah Pin Lokasi GPS", style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1B5E20),
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _onFotoFisikPressed,
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text("Foto Fisik Kandang (3)", style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1B5E20),
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDocumentUploadCard(String title, String subtitle, IconData icon, bool isUploaded) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFF1B5E20), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: isUploaded ? Colors.green.shade700 : Colors.grey.shade600)),
              ],
            ),
          ),
          if (isUploaded)
            IconButton(
              onPressed: () => _onUploadDokumen(title),
              icon: const Icon(Icons.sync, color: Colors.grey),
              tooltip: "Ganti File",
            )
          else
            ElevatedButton(
              onPressed: () => _onUploadDokumen(title),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.upload_file, size: 14),
                  SizedBox(width: 4),
                  Text("Unggah", style: TextStyle(fontSize: 11)),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildKeuntunganMitraSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.circle, size: 10, color: Color(0xFF1B5E20)),
            SizedBox(width: 6),
            Text("Keuntungan Mitra Peternak", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        const Text("Solusi hulu-ke-hilir untuk mempercepat perputaran panen qurban Anda.", style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 16),
        _buildBenefitCard(Icons.savings, "Akses Langsung ke Program QRest", "Dapatkan injeksi pembiayaan bibit dan pakan hijauan bernutrisi tinggi dari ribuan investor terverifikasi tanpa bunga riba."),
        _buildBenefitCard(Icons.local_shipping, "Sistem Ekspedisi & Karantina Terpadu", "Armada logistik berstandar \"Animal Welfare\" siap menjemput hewan langsung dari kandang menuju masjid atau titik distribusi nasional."),
        _buildBenefitCard(Icons.monitor_weight, "Sertifikat Timbang Digital & Live Feed", "Fitur integrasi timbangan otomatis dan kamera kandang 24/7 membangun kepercayaan shohibul qurban tanpa perlu tatap muka langsung."),
        _buildBenefitCard(Icons.handshake, "Akad Syariah Wakalah & Tijarah", "Semua transaksi dilindungi akad syariah transparan. Dana pembayaran langsung ditransfer H+1 setelah serah terima hewan disahkan."),
      ],
    );
  }

  Widget _buildBenefitCard(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildKisahSuksesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6), // Warna ungu kebiruan pudar
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("KISAH SUKSES MITRA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.indigo)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 14),
                  const SizedBox(width: 4),
                  Text("4.9 / 5.0", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo.shade900)),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'), // Placeholder
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text("Pak H. Rohman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(width: 4),
                        Icon(Icons.verified, color: Colors.blue, size: 14),
                      ],
                    ),
                    const Text("Barkah Farm • Garut, Jawa Barat", style: TextStyle(fontSize: 11, color: Colors.black54)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(4)),
                          child: const Text("340 Ekor Terjual", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                          child: const Text("Omzet Rp 1,2 Miliar (2023)", style: TextStyle(color: Colors.black87, fontSize: 9)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Text(
              '"Alhamdulillah sejak buka toko di Qurbanan, kami tak lagi pusing memikirkan harga dipermankan tengkulak. Pembayaran cair cepat, sertifikasi dokter olinas sangat transparan, dan kambing domba kami diambil jemaah dan jabodetabek hingga Surabaya."',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPernyataanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pernyataan Amanah Peternak:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    SizedBox(height: 4),
                    Text("Saya menyatakan seluruh hewan qurban yang didaftarkan telah cukup umur syar'i (poel gigi), sehat, bebas cacat fisik (bebas PMK & Antraks), serta saya menyetujui prinsip akad amanah muamalah Qurbanan.", style: TextStyle(fontSize: 11, color: Colors.black87)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Baca Dokumen Pedoman Fatwa MUI Kurban", style: TextStyle(fontSize: 10, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
              Text("Revisi v2.4 (2024)", style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            ],
          )
        ],
      ),
    );
  }
}
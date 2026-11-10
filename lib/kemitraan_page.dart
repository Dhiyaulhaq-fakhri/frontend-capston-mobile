// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class KemitraanPage extends StatefulWidget {
  const KemitraanPage({super.key});

  @override
  State<KemitraanPage> createState() => _KemitraanPageState();
}

class _KemitraanPageState extends State<KemitraanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaToko = TextEditingController(text: 'Berkah Farm Sukabumi');
  final _populasi = TextEditingController(text: '100 - 300 Ekor (Kandang Komersial Utama)');
  final _alamat = TextEditingController(
    text: 'Jl. Raya Parungkuda No. 45, RT 03/RW 02, Desa Bojongkokosan, Kec. Parungkuda, Kabupaten Sukabumi, Jawa Barat 43357',
  );
  final _pemilik = TextEditingController(text: 'H. Rohman Sudrajat, S.Pt');
  final _whatsapp = TextEditingController(text: '081298448920');

  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _kategori = ['Sapi Potong (Limousin/Simmental)'];
  final List<XFile> _fotoKandang = [];
  final Map<String, PlatformFile> _dokumen = {};
  bool _pernyataan = false;
  bool _loadingGps = false;
  bool _submitting = false;
  double? _latitude = -6.83742;
  double? _longitude = 106.77218;

  static const Color forest = Color(0xFF07552F);
  static const Color deepForest = Color(0xFF064526);
  static const Color pale = Color(0xFFF1F2FF);
  static const Color ink = Color(0xFF17213A);
  static const Color muted = Color(0xFF687184);

  @override
  void dispose() {
    _namaToko.dispose();
    _populasi.dispose();
    _alamat.dispose();
    _pemilik.dispose();
    _whatsapp.dispose();
    super.dispose();
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _ambilLokasi() async {
    setState(() => _loadingGps = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _toast('Aktifkan layanan lokasi/GPS terlebih dahulu.');
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _toast('Izin lokasi belum diberikan.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _toast('Izin lokasi ditolak permanen. Aktifkan dari pengaturan aplikasi.');
        await Geolocator.openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      _toast('Lokasi GPS berhasil diperbarui.');
    } catch (e) {
      _toast('Gagal mengambil lokasi: $e');
    } finally {
      if (mounted) setState(() => _loadingGps = false);
    }
  }

  Future<void> _bukaPeta() async {
    if (_latitude == null || _longitude == null) {
      _toast('Ambil lokasi GPS terlebih dahulu.');
      return;
    }
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _toast('Tidak dapat membuka Google Maps.');
    }
  }

  Future<void> _tambahFoto({ImageSource source = ImageSource.gallery}) async {
    try {
      if (source == ImageSource.gallery) {
        final images = await _imagePicker.pickMultiImage(imageQuality: 85);
        if (images.isNotEmpty && mounted) {
          setState(() => _fotoKandang.addAll(images.take(3 - _fotoKandang.length)));
        }
      } else {
        if (_fotoKandang.length >= 3) {
          _toast('Maksimal 3 foto kandang.');
          return;
        }
        final image = await _imagePicker.pickImage(source: source, imageQuality: 85);
        if (image != null && mounted) setState(() => _fotoKandang.add(image));
      }
    } catch (e) {
      _toast('Gagal memilih foto: $e');
    }
  }

  Future<void> _pilihFoto() async {
    if (_fotoKandang.length >= 3) {
      _toast('Maksimal 3 foto kandang.');
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Pilih dari galeri'),
            onTap: () {
              Navigator.pop(context);
              _tambahFoto();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Ambil foto dengan kamera'),
            onTap: () {
              Navigator.pop(context);
              _tambahFoto(source: ImageSource.camera);
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _unggahDokumen(String key) async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (files.isEmpty) return; 

      final file = files.single;
      final fileSize = await file.length();
      if (fileSize != null && fileSize > 5 * 1024 * 1024) {
        _toast('Ukuran file maksimal 5 MB.');
        return;
      }
      setState(() => _dokumen[key] = file);
      _toast('${file.name} berhasil dipilih.');
    } catch (e) {
      _toast('Gagal memilih dokumen: $e');
    }
  }

  String _koordinat() {
    if (_latitude == null || _longitude == null) return 'Lokasi belum tersedia';
    return 'Lat: ${_latitude!.toStringAsFixed(5)}, Long: ${_longitude!.toStringAsFixed(5)}';
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _toast('Periksa kembali data yang wajib diisi.');
      return;
    }
    if (_kategori.isEmpty) {
      _toast('Pilih minimal satu kategori komoditas ternak.');
      return;
    }
    if (!_pernyataan) {
      _toast('Centang pernyataan amanah peternak terlebih dahulu.');
      return;
    }
    if (_dokumen['ktp'] == null || _dokumen['skkh'] == null) {
      _toast('Unggah KTP penanggung jawab dan SKKH terlebih dahulu.');
      return;
    }

    setState(() => _submitting = true);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Daftarkan Toko'),
        content: SingleChildScrollView(
          child: Text(
            'Data kemitraan siap dikirim.\n\n'
            'Nama toko: ${_namaToko.text}\n'
            'Pemilik: ${_pemilik.text}\n'
            'WhatsApp: ${_whatsapp.text}\n'
            'Kategori: ${_kategori.join(', ')}\n'
            'Lokasi: ${_koordinat()}\n'
            'Foto kandang: ${_fotoKandang.length} file\n'
            'Dokumen: ${_dokumen.length} file\n\n'
            'Saat ini data hanya divalidasi di aplikasi. Hubungkan fungsi ini '
            'ke API/backend agar pendaftaran benar-benar tersimpan.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Kembali'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: forest),
            onPressed: () {
              Navigator.pop(dialogContext);
              _toast('Validasi pendaftaran berhasil.');
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
    if (mounted) setState(() => _submitting = false);
  }

  InputDecoration _inputDecoration({String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: pale,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: forest, width: 1.2),
      ),
    );
  }

  Widget _fieldLabel(String title, {bool required = false, String? helper}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7, top: 13),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w700),
            children: [
              TextSpan(text: title),
              if (required)
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 4),
          Text(helper, style: const TextStyle(fontSize: 10.5, color: muted)),
        ],
      ]),
    );
  }

  Widget _textField(
    TextEditingController controller, {
    required String label,
    bool required = false,
    String? helper,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fieldLabel(label, required: required, helper: helper),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 11.5, color: ink),
        decoration: _inputDecoration(suffixIcon: suffixIcon),
        validator: validator ??
            (required
                ? (value) => value == null || value.trim().isEmpty ? '$label wajib diisi.' : null
                : null),
      ),
    ]);
  }

  Widget _sectionCard({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.035), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: child,
      );

  Widget _categoryChip(String text) {
    final selected = _kategori.contains(text);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() {
        selected ? _kategori.remove(text) : _kategori.add(text);
      }),
      child: Container(
        margin: const EdgeInsets.only(right: 6, bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? deepForest : const Color(0xFFE9ECFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(selected ? Icons.check_circle_outline : Icons.add_circle_outline,
              color: selected ? Colors.white : const Color(0xFF7A8294), size: 13),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(fontSize: 10, color: selected ? Colors.white : ink, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _documentTile(String key, String title, String subtitle, IconData icon, {bool optional = false}) {
    final file = _dokumen[key];
    return Container(
      margin: const EdgeInsets.only(top: 7),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(11)),
      child: Row(children: [
        Container(
          width: 29, height: 29,
          decoration: BoxDecoration(color: const Color(0xFFD9F2E6), borderRadius: BorderRadius.circular(7)),
          child: Icon(icon, color: forest, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: ink)),
          Text(file?.name ?? (optional ? 'Opsional tapi diutamakan' : subtitle),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 9, color: file == null ? muted : forest)),
          if (file != null && file.lengthSync() != null)
            Text('${(file.lengthSync()! / (1024 * 1024)).toStringAsFixed(1)} MB',
                style: const TextStyle(fontSize: 8.5, color: muted)),
        ])),
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: file == null ? 'Unggah dokumen' : 'Ganti dokumen',
          onPressed: () => _unggahDokumen(key),
          icon: Icon(file == null ? Icons.upload_file : Icons.refresh, color: forest, size: 19),
        ),
      ]),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: const LinearGradient(
          colors: [Color(0xFF06472A), Color(0xFF08713D)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: forest.withOpacity(.18), blurRadius: 15, offset: const Offset(0, 7))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(20)),
          child: const Text('Mitra Terverifikasi DSN-MUI & SKKH', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: const Color(0xFFFFDDA7), borderRadius: BorderRadius.circular(20)),
          child: const Text('GRATIS BIAYA DAFTAR', style: TextStyle(color: deepForest, fontSize: 8, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 12),
        const Text('Buka Toko Ternak & Raih\nPasar Kurban Nasional',
            style: TextStyle(color: Colors.white, fontSize: 18, height: 1.2, fontWeight: FontWeight.w800)),
        const SizedBox(height: 7),
        Text('Jangkau puluhan ribu shohibul qurban & investor QRvest tanpa perantara tengkulak. 100% Sesuai Syariat Islam.',
            style: TextStyle(color: Colors.white.withOpacity(.85), fontSize: 10.5, height: 1.4)),
        const SizedBox(height: 12),
        Wrap(spacing: 6, runSpacing: 6, children: const [
          _HeroFeature(icon: Icons.account_balance_wallet_outlined, text: 'Pencairan H+1\nAkad'),
          _HeroFeature(icon: Icons.trending_up, text: 'Akses Modal\nQRvest'),
          _HeroFeature(icon: Icons.medical_services_outlined, text: 'Dampingan\nDokter Disnak'),
          _HeroFeature(icon: Icons.sensors, text: 'Timbangan Digital\nIoT'),
        ]),
      ]),
    );
  }

  Widget _progress() {
    return _sectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.circle, color: forest, size: 8),
          const SizedBox(width: 5),
          const Text('PENDAFTARAN KEMITRAAN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: deepForest)),
          const Spacer(),
          const Text('Langkah 1 dari 4', style: TextStyle(fontSize: 9, color: muted)),
        ]),
        const SizedBox(height: 10),
        Row(children: List.generate(4, (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == 3 ? 0 : 5),
            height: 4,
            decoration: BoxDecoration(color: i == 0 ? forest : const Color(0xFFD8DDF3), borderRadius: BorderRadius.circular(8)),
          ),
        ))),
        const SizedBox(height: 6),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('1. Profil Toko', style: TextStyle(fontSize: 8, color: deepForest, fontWeight: FontWeight.w700)),
          Text('2. Kandang', style: TextStyle(fontSize: 8, color: muted)),
          Text('3. SKKH Disnak', style: TextStyle(fontSize: 8, color: muted)),
          Text('4. Akad Bank', style: TextStyle(fontSize: 8, color: muted)),
        ]),
      ]),
    );
  }

  Widget _mapPanel() {
    return Column(children: [
      Container(
        height: 115,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFE5EBDD)),
        child: Stack(fit: StackFit.expand, children: [
          CustomPaint(painter: _MapPainter()),
          const Positioned(left: 12, top: 10, child: Text('Lokasi kandang terdeteksi', style: TextStyle(fontSize: 9, color: forest, fontWeight: FontWeight.w700))),
          const Center(child: Icon(Icons.location_on, color: Color(0xFFB77B32), size: 30)),
          Positioned(
            right: 7, bottom: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(6)),
              child: const Text('TERSEMAT', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 5),
      Text(_koordinat(), style: const TextStyle(fontSize: 9, color: muted)),
      const SizedBox(height: 7),
      Row(children: [
        Expanded(child: OutlinedButton.icon(
          onPressed: _loadingGps ? null : _ambilLokasi,
          icon: _loadingGps
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.location_searching, size: 15),
          label: const Text('Ubah Pin Lokasi GPS', textAlign: TextAlign.center),
          style: OutlinedButton.styleFrom(
            foregroundColor: deepForest, backgroundColor: const Color(0xFFE5E9FF),
            side: BorderSide.none, padding: const EdgeInsets.symmetric(vertical: 10),
            textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
          ),
        )),
        const SizedBox(width: 6),
        Expanded(child: OutlinedButton.icon(
          onPressed: _pilihFoto,
          icon: const Icon(Icons.photo_camera_outlined, size: 15),
          label: const Text('Foto Fisik Kandang (3)', textAlign: TextAlign.center),
          style: OutlinedButton.styleFrom(
            foregroundColor: deepForest, backgroundColor: const Color(0xFFDDEDE5),
            side: BorderSide.none, padding: const EdgeInsets.symmetric(vertical: 10),
            textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
          ),
        )),
      ]),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _bukaPeta,
          icon: const Icon(Icons.map_outlined, size: 15),
          label: const Text('Buka lokasi di Google Maps'),
          style: TextButton.styleFrom(foregroundColor: forest, textStyle: const TextStyle(fontSize: 10)),
        ),
      ),
      if (_fotoKandang.isNotEmpty)
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _fotoKandang.length,
            // ignore: unnecessary_underscores
            separatorBuilder: (_, __) => const SizedBox(width: 7),
            itemBuilder: (context, index) => Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.file(File(_fotoKandang[index].path), width: 72, height: 72, fit: BoxFit.cover),
              ),
              Positioned(right: 0, top: 0, child: InkWell(
                onTap: () => setState(() => _fotoKandang.removeAt(index)),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 13),
                ),
              )),
            ]),
          ),
        ),
    ]);
  }

  Widget _benefitCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 9, offset: const Offset(0, 3))]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 34, height: 34, decoration: BoxDecoration(color: deepForest, borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: Colors.white, size: 19)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 11.5, color: ink, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 9.5, color: muted, height: 1.4)),
        ])),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: ink),
                      ),
                      const Spacer(),
                      Column(children: const [
                        Text('Kemitraan', style: TextStyle(color: deepForest, fontSize: 16, fontWeight: FontWeight.w900)),
                        Text('buat toko usahamu sendiri dan bergabung dengan kami', style: TextStyle(color: forest, fontSize: 8)),
                      ]),
                      const Spacer(),
                      const SizedBox(width: 42),
                    ]),
                    const SizedBox(height: 9),
                    _hero(),
                    const SizedBox(height: 13),
                    _progress(),
                    const SizedBox(height: 18),
                    const Text('Data Identitas Peternakan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: ink)),
                    const SizedBox(height: 4),
                    const Text('Lengkapi detail toko untuk mulai memasarkan hewan qurban secara terverifikasi.',
                        style: TextStyle(fontSize: 10, color: muted)),
                    const SizedBox(height: 10),
                    _sectionCard(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _textField(_namaToko, label: 'Nama Peternakan / Toko Ternak', required: true),
                        _fieldLabel('Kategori Komoditas Ternak', required: true, helper: 'Pilih komoditas yang saat ini siap atau dipelihara di kandang:'),
                        Wrap(children: [
                          _categoryChip('Sapi Potong (Limousin/Simmental)'),
                          _categoryChip('Domba / Kambing Etawa'),
                          _categoryChip('Bibit Anakan (Pedet/Cempe)'),
                          _categoryChip('Sapi Perah & Olahan'),
                        ]),
                        _textField(_populasi, label: 'Estimasi Populasi & Kapasitas Kandang', required: true,
                            suffixIcon: const Icon(Icons.home_work_outlined, size: 17)),
                        _textField(_alamat, label: 'Alamat Kandang & Titik Presisi GPS', required: true, maxLines: 3),
                        const SizedBox(height: 10),
                        _mapPanel(),
                        _textField(_pemilik, label: 'Nama Pemilik / Penanggung Jawab', required: true),
                        _textField(_whatsapp, label: 'Kontak WhatsApp Aktif (Notifikasi Order)', required: true,
                            keyboardType: TextInputType.phone,
                            validator: (v) => v == null || v.trim().length < 9 ? 'Masukkan nomor WhatsApp yang valid.' : null),
                        _fieldLabel('Upload Dokumen Legalitas & Kesehatan Ternak', helper: 'Format didukung: JPG, PNG, atau PDF (Maks. 5MB per berkas)'),
                        _documentTile('ktp', 'KTP Penanggung Jawab Toko', 'Wajib diunggah', Icons.description_outlined),
                        _documentTile('skkh', 'SKKH Resmi dari Dinas Peternakan', 'Wajib diunggah', Icons.health_and_safety_outlined),
                        _documentTile('sertifikat', 'Sertifikasi Juru Sembelih Halal', 'Opsional tapi diutamakan', Icons.workspace_premium_outlined, optional: true),
                      ]),
                    ),
                    const SizedBox(height: 19),
                    const Text('Keuntungan Mitra Peternakan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: ink)),
                    const SizedBox(height: 4),
                    const Text('Solusi hulu-ke-hilir untuk mempercepat perputaran panen qurban Anda.', style: TextStyle(fontSize: 9.5, color: muted)),
                    const SizedBox(height: 10),
                    _benefitCard(Icons.account_balance_wallet_outlined, 'Akses Langsung ke Program QRvest',
                        'Dapatkan injeksi pembiayaan bibit dan pakan hijauan bernutrisi tinggi dari investor terverifikasi tanpa bunga riba.'),
                    _benefitCard(Icons.local_shipping_outlined, 'Sistem Ekspedisi & Karantina Terpadu',
                        'Armada logistik berstandar Animal Welfare siap menjemput hewan qurban langsung dari kandang menuju masjid atau titik distribusi nasional.'),
                    _benefitCard(Icons.videocam_outlined, 'Sertifikat Timbang Digital & Live Feed',
                        'Fitur integrasi timbangan otomatis dan kamera kandang 24/7 membangun kepercayaan shohibul qurban tanpa perlu tatap muka langsung.'),
                    _benefitCard(Icons.gavel_outlined, 'Akad Syariah Wakalah & Tijarah',
                        'Semua transaksi dilindungi akad syariah transparan. Dana pembayaran langsung ditransfer H+1 setelah serah terima hewan disahkan.'),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 3, bottom: 14),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(color: const Color(0xFFE5E9FF), borderRadius: BorderRadius.circular(15)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('KISAH SUKSES MITRA', style: TextStyle(fontSize: 8, color: deepForest, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Row(children: [
                          const CircleAvatar(radius: 21, backgroundColor: Color(0xFFB7C9B9), child: Icon(Icons.person, color: forest)),
                          const SizedBox(width: 9),
                          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Pak H. Rohman', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: ink)),
                            Text('Barokah Farm • Garut, Jawa Barat', style: TextStyle(fontSize: 9, color: muted)),
                            Text('340 Ekor Terjual  •  Omzet Rp 1.2 Miliar (2023)', style: TextStyle(fontSize: 8, color: deepForest, fontWeight: FontWeight.w700)),
                          ])),
                          const Text('★ 4.9 / 5.0', style: TextStyle(fontSize: 9, color: Color(0xFF8A5A00), fontWeight: FontWeight.w800)),
                        ]),
                        const SizedBox(height: 9),
                        const Text('“Alhamdulillah sejak buka toko di QRbarkan, kami tak lagi pusing memikirkan harga dipermainkan tengkulak. Pembayaran cair cepat, sertifikasi dokter dinas sangat transparan, dan kambing domba kami dibeli jamaah dari Jabodetabek hingga Surabaya.”',
                            style: TextStyle(fontSize: 9, color: ink, height: 1.45, fontStyle: FontStyle.italic)),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _pernyataan,
                          activeColor: forest,
                          dense: true,
                          onChanged: (value) => setState(() => _pernyataan = value ?? false),
                          title: const Text.rich(TextSpan(
                            style: TextStyle(fontSize: 9, color: ink, height: 1.4),
                            children: [
                              TextSpan(text: 'Pernyataan Amanah Peternak: ', style: TextStyle(fontWeight: FontWeight.w900, color: deepForest)),
                              TextSpan(text: 'Saya menyatakan seluruh hewan qurban yang didaftarkan telah cukup umur/syarat (poel), sehat, bebas cacat fisik (bebas PMK & antraks), serta saya menyetujui prinsip akad amanah muamalah Qurban.'),
                            ],
                          )),
                        ),
                        const Divider(height: 8),
                        const Row(children: [
                          Expanded(child: Text('Baca Dokumen Pedoman Fatwa MUI Kurban', style: TextStyle(fontSize: 8, color: muted, fontWeight: FontWeight.w600))),
                          Text('Revisi v2.4 (2024)', style: TextStyle(fontSize: 8, color: muted)),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 13),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitting ? null : _submitForm,
                        icon: _submitting
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.how_to_reg_outlined, size: 17),
                        label: const Text('Daftarkan Toko  →'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB87900),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroFeature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _HeroFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 66) / 2,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.13), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(icon, color: const Color(0xFFD7F2DF), size: 16),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
      ]),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white.withOpacity(.9)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final minor = Paint()
      ..color = const Color(0xFFC6D2B9)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final route1 = Path()
      ..moveTo(-5, size.height * .75)
      ..quadraticBezierTo(size.width * .25, size.height * .45, size.width * .45, size.height * .55)
      ..quadraticBezierTo(size.width * .7, size.height * .65, size.width + 10, size.height * .2);
    final route2 = Path()
      ..moveTo(size.width * .15, -5)
      ..quadraticBezierTo(size.width * .25, size.height * .35, size.width * .55, size.height * .35)
      ..quadraticBezierTo(size.width * .75, size.height * .3, size.width * .8, size.height + 5);
    canvas.drawPath(route1, road);
    canvas.drawPath(route2, road);
    canvas.drawLine(Offset(0, size.height * .2), Offset(size.width, size.height * .85), minor);
    canvas.drawLine(Offset(size.width * .1, size.height), Offset(size.width * .9, 0), minor);
    final green = Paint()..color = const Color(0xFFD4E5C8);
    canvas.drawCircle(Offset(size.width * .18, size.height * .25), 17, green);
    canvas.drawCircle(Offset(size.width * .82, size.height * .72), 22, green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

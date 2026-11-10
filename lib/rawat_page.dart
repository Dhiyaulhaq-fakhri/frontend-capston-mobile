// ignore_for_file: unnecessary_import, unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

/// Halaman layanan beli dan rawat ternak.
/// Seluruh data masih dummy sampai backend tersedia.
class RawatTernakPage extends StatefulWidget {
  const RawatTernakPage({
    super.key,
    this.ownerName = 'Muhammad Irhash Syahid',
    this.breederPhone = '6281234567890',
    this.onBack,
  });

  /// Nomor WhatsApp peternak, format internasional tanpa tanda +.
  /// Ganti dengan nomor peternak yang sebenarnya.
  final String breederPhone;
  final String ownerName;
  final VoidCallback? onBack;

  @override
  State<RawatTernakPage> createState() => _RawatTernakPageState();
}

class _RawatTernakPageState extends State<RawatTernakPage> {
  static const Color green = Color(0xFF07532F);
  static const Color darkGreen = Color(0xFF064B2B);
  static const Color pageBg = Color(0xFFFAF8FD);
  static const Color ink = Color(0xFF202A3D);
  static const Color muted = Color(0xFF758078);
  static const Color lavender = Color(0xFFF0F1FF);
  static const Color orange = Color(0xFF8A5100);

  String _selectedEndOption = 'deliver';
  bool _requestingPhoto = false;
  bool _openingContact = false;
  bool _creatingPdf = false;

  static const List<_CareEntry> _entries = [
    _CareEntry(
      title: 'Minggu ke-6',
      date: '2 Hari lalu',
      image: 'resources/rawat_minggu_6.jpg',
      description: 'Pemberian pakan konsentrat & vitamin, kondisi bulu bersih dan lincah.',
      icon: Icons.eco,
      latest: true,
    ),
    _CareEntry(
      title: 'Minggu ke-4',
      date: '16 Hari lalu',
      image: 'resources/rawat_minggu_4.jpg',
      description: 'Cek kesehatan dokter hewan rutin, bebas parasit & vaksinasi booster lengkap.',
      icon: Icons.medical_services,
    ),
    _CareEntry(
      title: 'Minggu ke-2',
      date: '30 Hari lalu',
      image: 'resources/rawat_minggu_2.jpg',
      description: 'Adaptasi pakan hijauan segar & konsentrat fermentasi berjalan baik tanpa kembung.',
      icon: Icons.grass,
    ),
    _CareEntry(
      title: 'Hari ke-1 (Awal Akad)',
      date: '45 Hari lalu',
      image: 'resources/rawat_awal_akad.jpg',
      description: 'Dokumentasi awal serah terima penitipan amanah & pemasangan ear-tag barcode digital.',
      icon: Icons.verified_user_outlined,
    ),
  ];

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ));
  }

  Future<void> _openWhatsApp({required bool requestPhoto}) async {
    if (_openingContact || _requestingPhoto) return;

    setState(() {
      if (requestPhoto) {
        _requestingPhoto = true;
      } else {
        _openingContact = true;
      }
    });

    final message = requestPhoto
        ? 'Assalamu’alaikum, saya ${widget.ownerName}. Mohon kirimkan foto terkini kondisi ternak Domba Garut Anakan dengan ID #RWT-9021. Terima kasih.'
        : 'Assalamu’alaikum, saya ${widget.ownerName}. Saya ingin menghubungi pengelola amanah terkait ternak Domba Garut Anakan ID #RWT-9021.';

    try {
      final phone = widget.breederPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final uri = Uri.parse(
        'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
      );
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) _showMessage('WhatsApp tidak dapat dibuka pada perangkat ini.');
    } catch (e) {
      _showMessage('Tidak dapat membuka WhatsApp: $e');
    } finally {
      if (mounted) {
        setState(() {
          _requestingPhoto = false;
          _openingContact = false;
        });
      }
    }
  }

  Future<void> _downloadReport() async {
    if (_creatingPdf) return;
    setState(() => _creatingPdf = true);
    try {
      final document = pw.Document();
      final regular = pw.Font.helvetica();
      final bold = pw.Font.helveticaBold();

      document.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(34),
          build: (context) => [
            pw.Center(
              child: pw.Text(
                'LAPORAN KESEHATAN DIGITAL TERNAK',
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 17,
                  color: PdfColor.fromInt(0xFF07532F),
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Center(
              child: pw.Text('Layanan Beli dan Rawat Ternak',
                  style: pw.TextStyle(font: regular, fontSize: 10)),
            ),
            pw.SizedBox(height: 20),
            _pdfRow('ID Ternak', '#RWT-9021', regular, bold),
            _pdfRow('Jenis Ternak', 'Domba Garut Anakan', regular, bold),
            _pdfRow('Pemilik', widget.ownerName, regular, bold),
            _pdfRow('Pengelola Amanah', 'Kandang Berkah Al-Ihsan, Garut', regular, bold),
            _pdfRow('Masa Perawatan', 'Hari ke-45', regular, bold),
            pw.SizedBox(height: 12),
            pw.Text('PROGRES BOBOT FISIK',
                style: pw.TextStyle(font: bold, fontSize: 12)),
            pw.SizedBox(height: 6),
            _pdfRow('Awal Beli', '22.0 kg', regular, bold),
            _pdfRow('Saat Ini', '34.5 kg', regular, bold),
            _pdfRow('Target Qurban', '40.0 kg', regular, bold),
            pw.SizedBox(height: 18),
            pw.Text('DOKUMENTASI CITRA DIGITAL',
                style: pw.TextStyle(font: bold, fontSize: 12)),
            pw.SizedBox(height: 8),
            ..._entries.map(
              (entry) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFFDCE5DE),
                  ),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${entry.title}  •  ${entry.date}',
                        style: pw.TextStyle(font: bold, fontSize: 10)),
                    pw.SizedBox(height: 5),
                    pw.Text(entry.description,
                        style: pw.TextStyle(font: regular, fontSize: 9)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text('RINCIAN KESEPAKATAN & BIAYA',
                style: pw.TextStyle(font: bold, fontSize: 12)),
            pw.SizedBox(height: 8),
            _pdfRow('Biaya Pakan & Rawat Bulanan', 'Rp 250.000 / bulan', regular, bold),
            _pdfRow('Status Pembayaran', 'Lunas 3 Bulan', regular, bold),
            _pdfRow(
              'Pilihan akhir masa rawat',
              _selectedEndOption == 'deliver'
                  ? 'Diantar ke Alamat untuk Qurban'
                  : 'Dijual Kembali (Bagi Hasil Pasar)',
              regular,
              bold,
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Text(
              'Laporan ini merupakan ringkasan data demo aplikasi. '
              'Dokumentasi dan status kesehatan perlu diverifikasi oleh pengelola kandang.',
              style: pw.TextStyle(
                font: regular,
                fontSize: 8,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (_) async => document.save(),
        name: 'Laporan_Kesehatan_Ternak_RWT-9021.pdf',
      );
      _showMessage('Laporan PDF siap dicetak atau disimpan.');
    } catch (e) {
      _showMessage('Gagal membuat laporan PDF: $e');
    } finally {
      if (mounted) setState(() => _creatingPdf = false);
    }
  }

  pw.Widget _pdfRow(
    String label,
    String value,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 7),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 155,
            child: pw.Text(label,
                style: pw.TextStyle(font: regular, fontSize: 9)),
          ),
          pw.Expanded(
            child: pw.Text(value,
                style: pw.TextStyle(font: bold, fontSize: 9)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 9, 14, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _header(),
                  const SizedBox(height: 12),
                  _animalSummary(),
                  const SizedBox(height: 13),
                  _quickActions(),
                  const SizedBox(height: 22),
                  _documentationHeading(),
                  const SizedBox(height: 9),
                  _timeline(),
                  const SizedBox(height: 15),
                  _agreementCard(),
                  const SizedBox(height: 17),
                  _downloadButton(),
                  const SizedBox(height: 10),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() => Row(
        children: [
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: widget.onBack ?? () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back, color: ink, size: 19),
              tooltip: 'Kembali',
            ),
          ),
          const Spacer(),
          const Column(
            children: [
              Text('Rawat',
                  style: TextStyle(
                      color: green, fontSize: 21, fontWeight: FontWeight.w900)),
              SizedBox(height: 1),
              Text('Layanan beli dan rawat ternak',
                  style: TextStyle(
                      color: green, fontSize: 9, fontWeight: FontWeight.w600)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 42),
        ],
      );

  Widget _animalSummary() => Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
        decoration: BoxDecoration(
          color: const Color(0xFF145A35),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: green.withOpacity(.13),
                blurRadius: 7,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _badge('TERNAK DALAM PERAWATAN',
                  const Color(0xFF347B51), const Color(0xFFBCE4C8)),
              const Spacer(),
              const Text('ID: #RWT-9021',
                  style: TextStyle(color: Colors.white70, fontSize: 10)),
            ]),
            const SizedBox(height: 11),
            const Text('Domba Garut Anakan',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text('Pemilik: ${widget.ownerName}',
                style: const TextStyle(color: Colors.white70, fontSize: 10)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(9)),
              child: const Row(children: [
                Icon(Icons.home_work, color: Color(0xFFB8E8C7), size: 15),
                SizedBox(width: 7),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pengelola Amanah',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text('Kandang Berkah Al-Ihsan, Garut',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800)),
                      ]),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(9)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Masa Rawat: Hari ke-45',
                        style: TextStyle(color: Colors.white70, fontSize: 10)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: .50,
                        minHeight: 7,
                        backgroundColor: Color(0xFF47785B),
                        valueColor:
                            AlwaysStoppedAnimation(Color(0xFF9DE9B4)),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.13),
                  borderRadius: BorderRadius.circular(9)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PROGRES BOBOT FISIK',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Row(children: [
                      _weightBox('Awal Beli', '22.0 kg'),
                      const SizedBox(width: 5),
                      _weightBox('Saat Ini', '34.5 kg', emphasized: true),
                      const SizedBox(width: 5),
                      _weightBox('Target Qurban', '40.0 kg'),
                    ]),
                    const SizedBox(height: 9),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: .69,
                        minHeight: 7,
                        backgroundColor: Color(0xFF6C8E77),
                        valueColor:
                            AlwaysStoppedAnimation(Color(0xFFA4EABD)),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      );

  Widget _weightBox(String title, String value, {bool emphasized = false}) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(6)),
          child: Column(children: [
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyle(
                      color: emphasized
                          ? const Color(0xFFBDF2C9)
                          : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900)),
            ),
          ]),
        ),
      );

  Widget _badge(String text, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(text,
              style: TextStyle(
                  color: fg, fontSize: 8, fontWeight: FontWeight.w900)),
        ]),
      );

  Widget _quickActions() => Row(children: [
        Expanded(
          child: _quickButton(
            icon: Icons.add_a_photo_outlined,
            text: _requestingPhoto ? 'Membuka...' : 'Minta Foto Terkini',
            onTap: _requestingPhoto
                ? null
                : () => _openWhatsApp(requestPhoto: true),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: _quickButton(
            icon: Icons.message,
            text: _openingContact ? 'Membuka...' : 'Hubungi Peternak',
            onTap: _openingContact
                ? null
                : () => _openWhatsApp(requestPhoto: false),
          ),
        ),
      ]);

  Widget _quickButton({
    required IconData icon,
    required String text,
    required VoidCallback? onTap,
  }) =>
      Material(
        color: lavender,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: green, size: 16),
              const SizedBox(width: 5),
              Flexible(
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: green,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900)),
              ),
            ]),
          ),
        ),
      );

  Widget _documentationHeading() => Row(children: [
        const Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dokumentasi Citra Digital',
                    style: TextStyle(
                        color: ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 2),
                Text('Audit biometrik berkala Kandang Al-Ihsan',
                    style: TextStyle(color: muted, fontSize: 9.5)),
              ]),
        ),
        _badge('Terverifikasi', const Color(0xFFE3F4E9), green),
      ]);

  Widget _timeline() => Column(
        children: List.generate(
          _entries.length,
          (index) => _timelineItem(_entries[index], index),
        ),
      );

  Widget _timelineItem(_CareEntry entry, int index) {
    final isFirst = index == 0;
    final isLast = index == _entries.length - 1;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 38,
            child: Column(children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isFirst
                      ? darkGreen
                      : (index == 1
                          ? const Color(0xFF5D756B)
                          : const Color(0xFFDCE6E1)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFirst
                      ? Icons.check
                      : (index == 1
                          ? Icons.article_outlined
                          : (index == 2
                              ? Icons.grass
                              : Icons.handshake_outlined)),
                  color: isFirst || index == 1 ? Colors.white : green,
                  size: 12,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: const Color(0xFFD3E3DA),
                  ),
                ),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _entryCard(entry),
            ),
          ),
        ],
      ),
    );
  }

  Widget _entryCard(_CareEntry entry) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.025),
                blurRadius: 7,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(entry.title,
                style: const TextStyle(
                    color: ink, fontSize: 11, fontWeight: FontWeight.w900)),
            if (entry.latest) ...[
              const SizedBox(width: 6),
              _badge('Terbaru', const Color(0xFFE7F1E9), green),
            ],
            const Spacer(),
            Text(entry.date,
                style: const TextStyle(color: muted, fontSize: 9)),
          ]),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 145,
              width: double.infinity,
              child: Image.asset(
                entry.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  'resources/domba 1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE6EEE7),
                    child: const Icon(Icons.pets, color: green, size: 48),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            decoration: BoxDecoration(
                color: lavender, borderRadius: BorderRadius.circular(8)),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(entry.icon, color: green, size: 14),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(entry.description,
                        style: const TextStyle(
                            color: Color(0xFF485366),
                            fontSize: 9.5,
                            height: 1.35)),
                  ),
                ]),
          ),
        ]),
      );

  Widget _agreementCard() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.025),
                blurRadius: 7,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: const Color(0xFFE5F0EA),
                  borderRadius: BorderRadius.circular(7)),
              child: const Icon(Icons.receipt_long_outlined,
                  color: green, size: 16),
            ),
            const SizedBox(width: 7),
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rincian Kesepakatan & Biaya',
                        style: TextStyle(
                            color: ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 2),
                    Text('Transparansi akad ijarah pemeliharaan',
                        style: TextStyle(color: muted, fontSize: 9)),
                  ]),
            ),
          ]),
          const SizedBox(height: 11),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: lavender, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Biaya Pakan & Rawat Bulanan',
                          style: TextStyle(color: muted, fontSize: 9)),
                      SizedBox(height: 3),
                      Text('Rp 250.000',
                          style: TextStyle(
                              color: green,
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                    ]),
              ),
              const Text('/ bulan',
                  style: TextStyle(color: muted, fontSize: 9)),
              const SizedBox(width: 6),
              _badge('Lunas 3 Bulan',
                  const Color(0xFFB9F0C9), green),
            ]),
          ),
          const SizedBox(height: 16),
          const Text('Pilihan Akhir Masa Rawat (Hari ke-90)',
              style: TextStyle(
                  color: ink, fontSize: 10, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          _endOption(
            value: 'deliver',
            title: 'Diantar ke Alamat untuk Qurban',
            description:
                'Pengantaran H-3 Idul Adha dengan armada khusus berpendingin & pendamping dokter.',
          ),
          const SizedBox(height: 8),
          _endOption(
            value: 'resell',
            title: 'Dijual Kembali (Bagi Hasil Pasar)',
            description:
                'Ternak dilelang saat puncak Idul Adha dengan skema syirkah mudharabah transparan.',
          ),
        ]),
      );

  Widget _endOption({
    required String value,
    required String title,
    required String description,
  }) {
    final selected = _selectedEndOption == value;
    return InkWell(
      onTap: () => setState(() => _selectedEndOption = value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE4E8FF) : const Color(0xFFF3F4FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFFD9DFFF) : Colors.transparent,
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                color: selected ? green : const Color(0xFFDCE4FF),
                shape: BoxShape.circle),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(
                          color: muted, fontSize: 9, height: 1.35)),
                ]),
          ),
        ]),
      ),
    );
  }

  Widget _downloadButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _creatingPdf ? null : _downloadReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: orange,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.brown.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2,
          ),
          icon: _creatingPdf
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.picture_as_pdf_outlined, size: 17),
          label: Text(
            _creatingPdf
                ? 'Menyiapkan Laporan...'
                : 'Download Laporan Kesehatan Digital (PDF)',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900),
          ),
        ),
      );
}

class _CareEntry {
  const _CareEntry({
    required this.title,
    required this.date,
    required this.image,
    required this.description,
    required this.icon,
    this.latest = false,
  });

  final String title;
  final String date;
  final String image;
  final String description;
  final IconData icon;
  final bool latest;
}

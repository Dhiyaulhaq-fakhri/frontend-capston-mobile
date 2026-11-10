// ignore_for_file: unnecessary_import, use_null_aware_elements, unnecessary_underscores, deprecated_member_use

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Halaman Bukti Transaksi & E-Sertifikat Akad Qurban.
/// Backend belum digunakan: seluruh informasi transaksi masih berupa data demo.
class BuktiTransaksiPage extends StatefulWidget {
  const BuktiTransaksiPage({
    super.key,
    this.onTrackPressed,
    this.onHomePressed,
  });

  /// Isi callback ini jika halaman tracking sudah tersedia.
  final VoidCallback? onTrackPressed;

  /// Isi callback ini jika ingin mengatur navigasi khusus ke beranda.
  final VoidCallback? onHomePressed;

  @override
  State<BuktiTransaksiPage> createState() => _BuktiTransaksiPageState();
}

class _BuktiTransaksiPageState extends State<BuktiTransaksiPage> {
  static const Color green = Color(0xFF07532F);
  static const Color deepGreen = Color(0xFF004522);
  static const Color pageBg = Color(0xFFFAF8FD);
  static const Color ink = Color(0xFF202A3D);
  static const Color muted = Color(0xFF718078);
  static const Color lavender = Color(0xFFF0F1FF);
  static const Color gold = Color(0xFF563400);

  // Data demo — nanti dapat diganti dengan data dari backend.
  static const String reference = '#TRX-QBN-77291';
  static const String animalName = 'Sapi Limousin Super Grade A';
  static const String customerName =
      'Muhammad Irhash Syahid bin Ahmad Syahid';
  static const String animalType = "Sapi Limousin (Kupak 2 / Sah Syar'i)";
  static const String weight = '420 Kilogram Hidup';
  static const String partner = 'Berkah Farm Mandiri (Bogor)';
  static const String earTag = '#QBN-2024-884';
  static const String destination = 'Masjid Al-Falah Kebayoran Baru';
  static const String destinationAddress =
      'Jl. Raya Kebayoran Baru No. 12, Jakarta Selatan';
  static const int total = 28525000;

  bool _creatingPdf = false;
  bool _sharingPdf = false;

  String _formatRupiah(int value) {
    final digits = value.toString();
    final result = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      result.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) result.write('.');
    }
    return 'Rp ${result.toString()}';
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<Uint8List> _buildCertificatePdf() async {
    final pdf = pw.Document();
    final regular = pw.Font.helvetica();
    final bold = pw.Font.helveticaBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(34),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(
              child: pw.Text(
                'LEMBAGA AMANAH QURBAN DIGITAL',
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: PdfColor.fromInt(0xFF07532F),
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'SERTIFIKAT AKAD WAKALAH QURBAN',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: bold, fontSize: 18),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Center(
              child: pw.Text(
                'No: SKT-QBN/1445/VI/77291',
                style: pw.TextStyle(font: regular, fontSize: 9),
              ),
            ),
            pw.SizedBox(height: 24),
            _pdfInfo('Nomor Referensi', reference, regular, bold),
            _pdfInfo('Shohibul Qurban (Pekurban)', customerName, regular, bold),
            _pdfInfo('Jenis & Kualitas', animalType, regular, bold),
            _pdfInfo('Timbangan Akad', weight, regular, bold),
            _pdfInfo('Mitra Penggemukan', partner, regular, bold),
            _pdfInfo('Nomor Kalung/ID', earTag, regular, bold),
            pw.SizedBox(height: 18),
            pw.Text(
              'LAFAZ IKRAR WAKALAH BIL UJRAH',
              style: pw.TextStyle(font: bold, fontSize: 10,
                  color: PdfColor.fromInt(0xFF07532F)),
            ),
            pw.SizedBox(height: 7),
            pw.Text(
              '"Telah sah dan mengikat penyerahan amanah (wakalah) pembelian, pemeliharaan, serta penyembelihan hewan qurban atas nama shohibul qurban sesuai ketentuan syariat Islam."',
              style: pw.TextStyle(font: regular, fontSize: 10, lineSpacing: 4),
            ),
            pw.SizedBox(height: 22),
            pw.Divider(color: PdfColor.fromInt(0xFFCCD8D0)),
            pw.SizedBox(height: 12),
            pw.Text(
              'RINCIAN PEMBAYARAN',
              style: pw.TextStyle(font: bold, fontSize: 11),
            ),
            pw.SizedBox(height: 9),
            _pdfInfo('Harga Pokok Sapi Limousin', 'Rp 27.500.000', regular, bold),
            _pdfInfo('Biaya Rawat & Logistik', 'Rp 1.000.000', regular, bold),
            _pdfInfo('Infaq Operasional Qurban', 'Rp 25.000', regular, bold),
            pw.Divider(),
            _pdfInfo('TOTAL PELUNASAN', _formatRupiah(total), regular, bold),
            pw.SizedBox(height: 18),
            pw.Text('TUJUAN PENYALURAN',
                style: pw.TextStyle(font: bold, fontSize: 10)),
            pw.SizedBox(height: 5),
            pw.Text(destination, style: pw.TextStyle(font: bold, fontSize: 11)),
            pw.Text(destinationAddress,
                style: pw.TextStyle(font: regular, fontSize: 9)),
            pw.Spacer(),
            pw.Center(
              child: pw.Text(
                'Dokumen elektronik ini merupakan bukti akad pada aplikasi Qurbankan.',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: regular, fontSize: 8,
                    color: PdfColors.grey700),
              ),
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }

  pw.Widget _pdfInfo(
    String label,
    String value,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 9),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 145,
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

  Future<void> _downloadPdf() async {
    if (_creatingPdf) return;
    setState(() => _creatingPdf = true);
    try {
      final bytes = await _buildCertificatePdf();
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: 'Bukti_Akad_Qurban_TRX-QBN-77291.pdf',
      );
      _message('Dokumen sertifikat siap dicetak atau disimpan sebagai PDF.');
    } catch (e) {
      _message('Gagal membuat PDF: $e');
    } finally {
      if (mounted) setState(() => _creatingPdf = false);
    }
  }

  Future<void> _shareCertificate() async {
    if (_sharingPdf) return;
    setState(() => _sharingPdf = true);
    try {
      final bytes = await _buildCertificatePdf();
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'Sertifikat_Akad_Qurban_TRX-QBN-77291.pdf',
      );
    } catch (e) {
      _message('Gagal membagikan sertifikat: $e');
    } finally {
      if (mounted) setState(() => _sharingPdf = false);
    }
  }

  void _track() {
    if (widget.onTrackPressed != null) {
      widget.onTrackPressed!.call();
    } else {
      _message('Hubungkan tombol ini ke halaman Tracking melalui onTrackPressed.');
    }
  }

  void _home() {
    if (widget.onHomePressed != null) {
      widget.onHomePressed!.call();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(17, 10, 17, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _header(),
                  const SizedBox(height: 13),
                  _successCard(),
                  const SizedBox(height: 11),
                  _animalBanner(),
                  const SizedBox(height: 13),
                  _sectionTitle(
                    'E-Sertifikat Akad Resmi',
                    trailing: _pill('SHA-256 Digital', lavender, muted),
                    icon: Icons.verified_user_outlined,
                  ),
                  const SizedBox(height: 7),
                  _certificateCard(),
                  const SizedBox(height: 9),
                  _certificateActions(),
                  const SizedBox(height: 13),
                  _paymentCard(),
                  const SizedBox(height: 11),
                  _destinationCard(),
                  const SizedBox(height: 11),
                  _guaranteeCard(),
                  const SizedBox(height: 12),
                  _processCard(),
                  const SizedBox(height: 13),
                  _trackButton(),
                  const SizedBox(height: 8),
                  _homeButton(),
                  const SizedBox(height: 12),
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
          _roundBack(),
          const Spacer(),
          const Column(
            children: [
              Text('Bukti Transaksi',
                  style: TextStyle(
                      color: green, fontSize: 22, fontWeight: FontWeight.w900)),
              SizedBox(height: 2),
              Text('Lihat sampai mana pesanan anda saat di kirim',
                  style: TextStyle(
                      color: green, fontSize: 9, fontWeight: FontWeight.w500)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 42),
        ],
      );

  Widget _roundBack() => Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: ink, size: 19),
        ),
      );

  Widget _successCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF004522), Color(0xFF145B36)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: green.withOpacity(.13),
                blurRadius: 9,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 57,
              height: 57,
              decoration: const BoxDecoration(
                  color: Color(0xFFA8F0BB), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle,
                  color: deepGreen, size: 32),
            ),
            const SizedBox(height: 10),
            _pill('PEMBAYARAN TERVERIFIKASI OTOMATIS',
                const Color(0xFF34744F), const Color(0xFFD2E9D9),
                icon: Icons.verified_outlined),
            const SizedBox(height: 11),
            const Text('Alhamdulillah!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            const Text('Akad Qurban Sah Terbit & Amanah\nDiterima Sempurna',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF9AC5A9), fontSize: 12, height: 1.35)),
            const SizedBox(height: 14),
            Container(height: 1, color: Colors.white.withOpacity(.12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.13),
                  borderRadius: BorderRadius.circular(11)),
              child: Column(
                children: [
                  Row(children: [
                    const Expanded(
                      child: Text('No. Referensi Transaksi',
                          style: TextStyle(
                              color: Color(0xFF9ABDA7), fontSize: 8.5)),
                    ),
                    const Text('Status Dana',
                        style: TextStyle(
                            color: Color(0xFF9ABDA7), fontSize: 8.5)),
                  ]),
                  const SizedBox(height: 5),
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _copy(reference, 'Nomor referensi'),
                        child: const Text(reference,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const Icon(Icons.shield_outlined,
                        color: Color(0xFFFFD27A), size: 11),
                    const SizedBox(width: 3),
                    const Text("Wadi'ah Escrow",
                        style: TextStyle(
                            color: Color(0xFFFFD27A),
                            fontSize: 9,
                            fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 10),
                  Container(height: 1, color: Colors.white.withOpacity(.1)),
                  const SizedBox(height: 8),
                  const Row(children: [
                    Icon(Icons.account_balance_outlined,
                        color: Color(0xFF9ABDA7), size: 12),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text('BSI Virtual Account',
                          style: TextStyle(
                              color: Color(0xFF9ABDA7), fontSize: 9)),
                    ),
                    Text('10 Jun 2024, 14:25 WIB',
                        style: TextStyle(
                            color: Color(0xFF9ABDA7), fontSize: 9)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      );

  Future<void> _copy(String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    _message('$label berhasil disalin.');
  }

  Widget _animalBanner() => ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          height: 155,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'resources/sapi 1.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFDCE8D8),
                  child: const Icon(Icons.pets, color: green, size: 65),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xC9002412)],
                    stops: [0.42, 1],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 11,
                child: Row(children: [
                  const Expanded(
                    child: Text(animalName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900)),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.22),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.verified_outlined,
                        color: Colors.white, size: 19),
                  ),
                ]),
              ),
            ],
          ),
        ),
      );

  Widget _sectionTitle(String title,
          {Widget? trailing, IconData? icon}) =>
      Row(children: [
        if (icon != null) Icon(icon, color: green, size: 16),
        if (icon != null) const SizedBox(width: 5),
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  color: ink, fontSize: 14, fontWeight: FontWeight.w900)),
        ),
        if (trailing != null) trailing,
      ]);

  Widget _pill(String text, Color background, Color foreground,
      {IconData? icon}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, color: foreground, size: 11),
            const SizedBox(width: 4),
          ],
          Text(text,
              style: TextStyle(
                  color: foreground,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .15)),
        ]),
      );

  Widget _whiteCard({required Widget child, EdgeInsets padding = const EdgeInsets.all(14)}) =>
      Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF253A2D).withOpacity(.035),
                blurRadius: 9,
                offset: const Offset(0, 3))
          ],
        ),
        child: child,
      );

  Widget _certificateCard() => _whiteCard(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 13),
        child: Column(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: const BoxDecoration(
                  color: Color(0xFFEEF5F0), shape: BoxShape.circle),
              child: const Icon(Icons.workspace_premium_outlined,
                  color: green, size: 20),
            ),
            const SizedBox(height: 8),
            const Text('LEMBAGA AMANAH QURBAN DIGITAL',
                style: TextStyle(
                    color: muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .7)),
            const SizedBox(height: 4),
            const Text('SERTIFIKAT AKAD WAKALAH QURBAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: deepGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            _pill('No: SKT-QBN/1445/VI/77291',
                const Color(0xFFF0F1F5), muted),
            const SizedBox(height: 14),
            Container(height: 1, color: const Color(0xFFE9EDF0)),
            const SizedBox(height: 13),
            _highlightInfo('Shohibul Qurban (Pekurban):', customerName),
            const SizedBox(height: 9),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: lavender, borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                _detailRow('Jenis & Kualitas:', animalType),
                _detailRow('Timbangan Akad:', weight),
                _detailRow('Mitra Penggemukan:', partner, valueGreen: true),
                _detailRow('Nomor Kalung/ID:', earTag),
              ]),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xFFF0F7F2),
                  borderRadius: BorderRadius.circular(10)),
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('❞ LAFAZ IKRAR WAKALAH BIL UJRAH',
                        style: TextStyle(
                            color: green,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 5),
                    Text(
                      '"Telah sah dan mengikat penyerahan amanah (wakalah) pembelian, pemeliharaan, serta penyembelihan hewan qurban atas nama shohibul qurban sesuai ketentuan syariat Islam."',
                      style: TextStyle(
                          color: Color(0xFF69786F),
                          fontSize: 9,
                          height: 1.5,
                          fontStyle: FontStyle.italic),
                    ),
                  ]),
            ),
            const SizedBox(height: 13),
            Container(height: 1, color: const Color(0xFFE9EDF0)),
            const SizedBox(height: 12),
            Row(children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                    color: lavender, borderRadius: BorderRadius.circular(8)),
                child: QrImageView(
                  data: 'QURBANKAN|$reference|SHA-256|VERIFIED',
                  version: QrVersions.auto,
                  padding: const EdgeInsets.all(3),
                  eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square, color: deepGreen),
                  dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: deepGreen),
                ),
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('QR Verifikasi',
                          style: TextStyle(color: muted, fontSize: 8)),
                      SizedBox(height: 3),
                      Text('Tervalidasi MUI',
                          style: TextStyle(
                              color: green,
                              fontSize: 10,
                              fontWeight: FontWeight.w900)),
                    ]),
              ),
              Container(
                width: 49,
                height: 49,
                decoration: const BoxDecoration(
                    color: deepGreen, shape: BoxShape.circle),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user_outlined,
                          color: Colors.white, size: 17),
                      Text('SAH\nSYARIAT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 6,
                              fontWeight: FontWeight.w900,
                              height: 1.05)),
                    ]),
              ),
            ]),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('DPS Qurbankan',
                  style: TextStyle(color: muted, fontSize: 7)),
            ),
          ],
        ),
      );

  Widget _highlightInfo(String label, String value) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: lavender, borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(
                  color: muted, fontSize: 8.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: deepGreen,
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.w900)),
        ]),
      );

  Widget _detailRow(String label, String value, {bool valueGreen = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 5,
            child: Text(label,
                style: const TextStyle(color: muted, fontSize: 8.5)),
          ),
          Expanded(
            flex: 7,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: valueGreen ? green : ink,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800)),
          ),
        ]),
      );

  Widget _certificateActions() => Row(children: [
        Expanded(
          child: _actionButton(
            icon: Icons.download,
            label: _creatingPdf ? 'Menyiapkan...' : 'Unduh PDF',
            onTap: _creatingPdf ? null : _downloadPdf,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _actionButton(
            icon: Icons.share_outlined,
            label: _sharingPdf ? 'Menyiapkan...' : 'Bagikan Akad',
            onTap: _sharingPdf ? null : _shareCertificate,
          ),
        ),
      ]);

  Widget _actionButton(
          {required IconData icon,
          required String label,
          required VoidCallback? onTap}) =>
      Material(
        color: const Color(0xFFE4E8FF),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: green, size: 15),
              const SizedBox(width: 5),
              Flexible(
                child: Text(label,
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

  Widget _paymentCard() => _whiteCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.receipt_long_outlined, color: green, size: 17),
            SizedBox(width: 6),
            Text('Rincian Pembayaran & Akad',
                style: TextStyle(
                    color: ink, fontSize: 13, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 11),
          _moneyRow('Harga Pokok Sapi Limousin', 'Rp 27.500.000'),
          _moneyRow('Biaya Rawat & Logistik', 'Rp 1.000.000'),
          _moneyRow('Infaq Operasional Qurban', 'Rp 25.000'),
          const SizedBox(height: 9),
          Container(height: 1, color: const Color(0xFFEEF0F2)),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL PELUNASAN',
                        style: TextStyle(
                            color: muted,
                            fontSize: 8,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('Status: LUNAS 100%',
                        style: TextStyle(
                            color: green,
                            fontSize: 8,
                            fontWeight: FontWeight.w900)),
                  ]),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(_formatRupiah(total),
                    style: const TextStyle(
                        color: green,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ]),
        ]),
      );

  Widget _moneyRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(color: muted, fontSize: 10))),
          Text(value,
              style: const TextStyle(
                  color: ink, fontSize: 10, fontWeight: FontWeight.w700)),
        ]),
      );

  Widget _destinationCard() => _whiteCard(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                color: Color(0xFFEEF5F0), shape: BoxShape.circle),
            child: const Icon(Icons.local_shipping_outlined,
                color: green, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Expanded(
                      child: Text('TUJUAN PENYALURAN',
                          style: TextStyle(
                              color: muted,
                              fontSize: 8,
                              fontWeight: FontWeight.w900)),
                    ),
                    _pill('Ternak Hidup',
                        const Color(0xFFB8F0C8), green),
                  ]),
                  const SizedBox(height: 5),
                  Text(destination,
                      style: const TextStyle(
                          color: ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(destinationAddress,
                      style: const TextStyle(color: muted, fontSize: 9)),
                  const SizedBox(height: 6),
                  const Row(children: [
                    Icon(Icons.access_time, color: green, size: 13),
                    SizedBox(width: 5),
                    Text('Estimasi Tiba: 15 Juni 2024',
                        style: TextStyle(
                            color: green,
                            fontSize: 9,
                            fontWeight: FontWeight.w800)),
                  ]),
                ]),
          ),
        ]),
      );

  Widget _guaranteeCard() => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
            color: const Color(0xFFE9ECFF),
            borderRadius: BorderRadius.circular(13)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.health_and_safety_outlined, color: green, size: 17),
            SizedBox(width: 6),
            Text('Jaminan 100% Amanah & Sehat',
                style: TextStyle(
                    color: green, fontSize: 12, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 9),
          _guaranteeLine(
              'Garansi Kematian/Cacat:',
              '100% langsung diganti hewan sepadan tanpa biaya tambahan hingga hari penyembelihan.'),
          const SizedBox(height: 7),
          _guaranteeLine(
              'Sertifikat Kesehatan (SKKH):',
              'Hewan telah diperiksa dokter hewan dinas dan bebas PMK & LSD.'),
        ]),
      );

  Widget _guaranteeLine(String title, String description) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, color: green, size: 14),
          const SizedBox(width: 5),
          Expanded(
            child: Text.rich(TextSpan(
                style: const TextStyle(
                    color: Color(0xFF53665A), fontSize: 9, height: 1.35),
                children: [
                  TextSpan(
                      text: title,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  TextSpan(text: ' $description'),
                ])),
          ),
        ],
      );

  Widget _processCard() => _whiteCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.alt_route, color: green, size: 17),
            SizedBox(width: 6),
            Text('Proses Selanjutnya',
                style: TextStyle(
                    color: ink, fontSize: 13, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 11),
          _processStep(
            icon: Icons.check,
            done: true,
            title: 'Akad Sah & Alokasi Kandang',
            description:
                'Hewan terisolasi aman dengan perawatan nutrisi harian di mitra farm.',
          ),
          _processStep(
            icon: Icons.local_shipping_outlined,
            done: false,
            title: 'Pengiriman Armada Khusus',
            description:
                'Truk pengangkut ber-GPS diberangkatkan H-2 menuju lokasi pemesanan.',
          ),
          _processStep(
            icon: Icons.camera_alt_outlined,
            done: false,
            last: true,
            title: 'Laporan Serah Terima & Video Qurban',
            description:
                'Dokumentasi foto serah terima fisik hewan di masjid diunggah real-time.',
          ),
        ]),
      );

  Widget _processStep({
    required IconData icon,
    required bool done,
    required String title,
    required String description,
    bool last = false,
  }) =>
      IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 22,
            child: Column(children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    color: done ? green : const Color(0xFFE2E8F8),
                    shape: BoxShape.circle),
                child: Icon(icon,
                    color: done ? Colors.white : const Color(0xFF7E8CA5),
                    size: 11),
              ),
              if (!last)
                Expanded(
                  child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: const Color(0xFFD8E1ED)),
                ),
            ]),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: done ? green : ink,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(description,
                        style: const TextStyle(
                            color: muted, fontSize: 9, height: 1.35)),
                  ]),
            ),
          ),
        ]),
      );

  Widget _trackButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _track,
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          ),
          icon: const Icon(Icons.navigation_outlined, size: 16),
          label: const Text('Lacak Pengiriman Ternak Sekarang',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
        ),
      );

  Widget _homeButton() => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _home,
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFFE4E8FF),
            foregroundColor: green,
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.home_outlined, size: 15),
          label: const Text('Kembali ke Beranda Qurban',
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900)),
        ),
      );
}

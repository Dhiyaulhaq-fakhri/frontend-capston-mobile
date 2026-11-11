// ignore_for_file: unnecessary_import, unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

/// Halaman pemindaian QR untuk konfirmasi serah terima ternak.
///
/// Data pada halaman ini masih berupa data demo frontend.
/// Gunakan [onVerified] untuk menghubungkan hasil verifikasi ke halaman
/// berikutnya setelah backend siap.
class ScanSampaiPage extends StatefulWidget {
  const ScanSampaiPage({
    super.key,
    this.onBack,
    this.onVerified,
    this.driverPhone = '6281234567890',
  });

  final VoidCallback? onBack;
  final ValueChanged<String>? onVerified;

  /// Nomor WhatsApp driver dalam format internasional tanpa tanda +.
  final String driverPhone;

  @override
  State<ScanSampaiPage> createState() => _ScanSampaiPageState();
}

class _ScanSampaiPageState extends State<ScanSampaiPage> {
  static const Color green = Color(0xFF145A35);
  static const Color deepGreen = Color(0xFF064B2B);
  static const Color pageBg = Color(0xFFFAF8FD);
  static const Color ink = Color(0xFF202A3D);
  static const Color muted = Color(0xFF748078);
  static const Color paleGreen = Color(0xFFE0F0E7);
  static const String expectedTag = '#SP-8821-JGG';
  static const String expectedOrder = 'Qurbankan';

  late final MobileScannerController _scannerController;
  final ImagePicker _imagePicker = ImagePicker();
  bool _handlingScan = false;
  bool _torchOn = false;
  bool _verified = false;
  String? _scannedValue;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  bool _isExpectedCode(String value) {
    final normalized = value.trim().toUpperCase();
    return normalized.contains(expectedTag) ||
        normalized.contains(expectedTag.replaceAll('#', '')) ||
        normalized.contains(expectedOrder) ||
        normalized.contains('ORD-99214-QRN');
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handlingScan || _verified) return;

    String? value;
    for (final barcode in capture.barcodes) {
      final candidate = barcode.rawValue?.trim();
      if (candidate != null && candidate.isNotEmpty) {
        value = candidate;
        break;
      }
    }
    if (value == null) return;

    setState(() => _handlingScan = true);
    await _scannerController.stop();

    if (_isExpectedCode(value)) {
      if (mounted) {
        setState(() => _scannedValue = value);
        await _showVerificationDialog(value);
      }
    } else {
      _showMessage('QR tidak cocok dengan pesanan #ORD-99214-QRN. Coba pindai QR yang benar.');
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (mounted && !_verified) {
        setState(() => _handlingScan = false);
        await _scannerController.start();
      }
    }
  }

  Future<void> _showVerificationDialog(String code) async {
    if (!mounted) return;
    final continueVerification = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const CircleAvatar(
          backgroundColor: paleGreen,
          child: Icon(Icons.qr_code_scanner, color: green),
        ),
        title: const Text(
          'QR Berhasil Dipindai',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kode QR sesuai dengan data pesanan. Pastikan data ternak dan kondisi fisik sudah diperiksa sebelum mengonfirmasi penerimaan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, height: 1.45, color: muted),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F1FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text('KODE TERBACA',
                      style: TextStyle(fontSize: 9, color: muted)),
                  const SizedBox(height: 4),
                  Text(
                    code,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: green,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Pindai Ulang',
                style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Gunakan Kode'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (continueVerification == true) {
      setState(() {
        _handlingScan = false;
        _scannedValue = code;
      });
      _showMessage('Kode cocok. Tekan Verifikasi & Konfirmasi Terima untuk menyelesaikan serah terima.');
    } else {
      setState(() {
        _handlingScan = false;
        _scannedValue = null;
      });
      await _scannerController.start();
    }
  }

  Future<void> _confirmReceipt(String code) async {
    setState(() {
      _verified = true;
      _handlingScan = false;
      _scannedValue = code;
    });
    await _scannerController.stop();
    widget.onVerified?.call(code);
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.verified_rounded, color: green, size: 52),
        title: const Text('Penerimaan Terkonfirmasi',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
          'Data QR berhasil diverifikasi. Status demo berubah menjadi 100% cocok & terverifikasi.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, height: 1.45),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: green),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Selesai'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickQrFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (image == null || !mounted) return;

      final BarcodeCapture? result =
          await _scannerController.analyzeImage(image.path);

      final value = result?.barcodes
          .map((barcode) => barcode.rawValue)
          .whereType<String>()
          .firstWhere(
            (item) => item.trim().isNotEmpty,
            orElse: () => '',
          );

      if (value == null || value.isEmpty) {
        _showMessage('QR tidak ditemukan pada gambar yang dipilih.');
        return;
      }

      if (_isExpectedCode(value)) {
        setState(() {
          _handlingScan = true;
          _scannedValue = value;
        });
        await _showVerificationDialog(value);
      } else {
        _showMessage('QR pada gambar tidak sesuai dengan pesanan ini.');
      }
    } catch (e) {
      _showMessage('Gagal membaca gambar: $e');
    }
  }

  Future<void> _toggleTorch() async {
    try {
      await _scannerController.toggleTorch();
      if (!mounted) return;
      setState(() => _torchOn = !_torchOn);
    } catch (_) {
      _showMessage('Flash tidak tersedia pada kamera ini.');
    }
  }

  Future<void> _switchCamera() async {
    try {
      await _scannerController.switchCamera();
    } catch (_) {
      _showMessage('Tidak dapat mengganti kamera.');
    }
  }

  Future<void> _manualInput() async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Input Kode Manual',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan kode QR atau nomor tag ternak yang tertera pada kalung.',
              style: TextStyle(fontSize: 12, color: muted, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Contoh: SP-8821-JGG',
                filled: true,
                fillColor: const Color(0xFFF0F1FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: green),
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Periksa Kode'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (!mounted || value == null || value.trim().isEmpty) return;
    if (_isExpectedCode(value)) {
      setState(() {
        _handlingScan = true;
        _scannedValue = value;
      });
      await _scannerController.stop();
      await _showVerificationDialog(value);
    } else {
      _showMessage('Kode tidak cocok. Periksa kembali kode tag atau QR pesanan.');
    }
  }

  Future<void> _contactDriver() async {
    final phone = widget.driverPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final message = 'Assalamu’alaikum Pak Asep Mulyana, saya penerima pesanan '
        '#ORD-99214-QRN. Saya ingin mengonfirmasi proses serah terima '
        'Sapi Simental Super dengan tag $expectedTag.';
    final uri = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) _showMessage('WhatsApp tidak dapat dibuka.');
    } catch (e) {
      _showMessage('Gagal membuka WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                children: [
                  _header(),
                  const SizedBox(height: 14),
                  _verificationNotice(),
                  const SizedBox(height: 12),
                  _scannerPanel(),
                  const SizedBox(height: 16),
                  _animalCard(),
                  const SizedBox(height: 12),
                  _verificationStatus(),
                  const SizedBox(height: 12),
                  _manualEntry(),
                  const SizedBox(height: 15),
                  _confirmButton(),
                  const SizedBox(height: 9),
                  _driverButton(),
                  const SizedBox(height: 6),
                ],
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
              icon: const Icon(Icons.arrow_back, color: ink, size: 20),
              tooltip: 'Kembali',
            ),
          ),
          const Spacer(),
          const Text(
            'Scan sampai',
            style: TextStyle(
              color: green,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      );

  Widget _verificationNotice() => Container(
        padding: const EdgeInsets.fromLTRB(13, 12, 12, 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD6E8DE),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.verified_user_outlined,
                color: green, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 7,
                    runSpacing: 4,
                    children: [
                      const Text('VERIFIKASI SERAH TERIMA',
                          style: TextStyle(
                              color: green,
                              fontSize: 9,
                              fontWeight: FontWeight.w900)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Order #ORD-99214-QRN',
                            style: TextStyle(
                                color: deepGreen,
                                fontSize: 8,
                                fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Arahkan kamera ke kalung QR Tag di leher hewan untuk validasi data fisik & aktivasi serah terima resmi bergaransi amanah.',
                    style: TextStyle(
                        color: Color(0xFF5F7068),
                        fontSize: 10,
                        height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _scannerPanel() => Container(
        height: 402,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF242631),
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!_verified)
              MobileScanner(
                controller: _scannerController,
                onDetect: _onDetect,
                errorBuilder: (context, error) => Container(
                  color: const Color(0xFF303642),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.no_photography_outlined,
                          color: Colors.white, size: 38),
                      const SizedBox(height: 10),
                      const Text(
                        'Kamera belum dapat diakses',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Izinkan akses kamera pada pengaturan aplikasi, atau gunakan input kode manual.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white70, fontSize: 11, height: 1.4),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                color: const Color(0xFF173D2B),
                child: const Center(
                  child: Icon(Icons.verified_rounded,
                      color: Color(0xFF9BE9B2), size: 90),
                ),
              ),
            Container(color: Colors.black.withOpacity(.36)),
            Positioned(
              top: 13,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECECF4),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: _verified ? green : const Color(0xFF17613A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        _verified
                            ? 'QR Terverifikasi'
                            : (_handlingScan
                                ? 'Memeriksa QR...'
                                : 'Mendeteksi QR Tag'),
                        style: const TextStyle(
                            color: ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w800),
                      ),
                    ]),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF303747).withOpacity(.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Jarak Ideal: 20–40 cm',
                        style: TextStyle(color: Colors.white, fontSize: 9)),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  children: [
                    _corner(Alignment.topLeft),
                    _corner(Alignment.topRight),
                    _corner(Alignment.bottomLeft),
                    _corner(Alignment.bottomRight),
                    Positioned(
                      left: 30,
                      right: 30,
                      top: 121,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8AE5A7),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8AE5A7).withOpacity(.7),
                              blurRadius: 9,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 142,
                        height: 142,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC928),
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5))
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.qr_code_2,
                                size: 88, color: Color(0xFF111827)),
                            const Spacer(),
                            const Text(expectedTag,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      top: 110,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF252A3A).withOpacity(.9),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Posisikan kode di dalam bingkai',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 40,
              right: 40,
              bottom: 13,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFF252D40),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _scannerControl(
                      icon: _torchOn ? Icons.flash_on : Icons.flashlight_on,
                      tooltip: 'Flash',
                      onTap: _toggleTorch,
                    ),
                    _scannerControl(
                      icon: Icons.cameraswitch_outlined,
                      tooltip: 'Ganti kamera',
                      onTap: _switchCamera,
                    ),
                    _scannerControl(
                      icon: Icons.photo_library_outlined,
                      tooltip: 'Pilih gambar QR',
                      onTap: _pickQrFromGallery,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _corner(Alignment alignment) {
    final isLeft = alignment == Alignment.topLeft ||
        alignment == Alignment.bottomLeft;
    final isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: 33,
        height: 33,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: isTop
                  ? const BorderSide(color: Color(0xFF91E9AC), width: 4)
                  : BorderSide.none,
              bottom: !isTop
                  ? const BorderSide(color: Color(0xFF91E9AC), width: 4)
                  : BorderSide.none,
              left: isLeft
                  ? const BorderSide(color: Color(0xFF91E9AC), width: 4)
                  : BorderSide.none,
              right: !isLeft
                  ? const BorderSide(color: Color(0xFF91E9AC), width: 4)
                  : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _scannerControl({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) =>
      IconButton(
        onPressed: _verified ? null : onTap,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFF3C4355),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF3C4355),
          disabledForegroundColor: Colors.white54,
        ),
        icon: Icon(icon, size: 20),
      );

  Widget _animalCard() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.035),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.circle, color: green, size: 9),
            const SizedBox(width: 5),
            const Expanded(
              child: Text('Data Ternak Ditunggu',
                  style: TextStyle(
                      color: ink, fontSize: 14, fontWeight: FontWeight.w900)),
            ),
            _pill('1 Ekor Sapi', const Color(0xFFDCEBE2), green),
          ]),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(
                  'resources/sapi 1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE7EFE8),
                    child: const Icon(Icons.pets, color: green, size: 35),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sapi Simental Super',
                        style: TextStyle(
                            color: ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 3),
                    Text('Tag: #SP-8821-JGG',
                        style: TextStyle(
                            color: green,
                            fontSize: 11,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 3),
                    Text('Mitra: Berkah Farm Jonggol (H. Ridwan)',
                        style: TextStyle(color: muted, fontSize: 9.5)),
                    SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.local_shipping_outlined,
                          color: muted, size: 12),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text('Driver Tiba: B 9421 KDA',
                            style: TextStyle(color: muted, fontSize: 9)),
                      ),
                    ]),
                  ]),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PEMERIKSAAN CEPAT DI LOKASI:',
                      style: TextStyle(
                          color: muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  _checkLine('Segel Kalung Tag QR masih utuh & tidak koyak'),
                  const SizedBox(height: 5),
                  _checkLine('Surat Keterangan Kesehatan Hewan (SKKH) sah'),
                ]),
          ),
        ]),
      );

  Widget _checkLine(String text) => Row(children: [
        const Icon(Icons.check_box, color: green, size: 16),
        const SizedBox(width: 7),
        Expanded(
          child: Text(text,
              style: const TextStyle(color: ink, fontSize: 9.5)),
        ),
        const Icon(Icons.verified_user_outlined, color: green, size: 16),
      ]);

  Widget _verificationStatus() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: green,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: green.withOpacity(.13),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: Color(0xFF9DE9B4), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline,
                  color: deepGreen, size: 25),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('STATUS PEMINDAIAN',
                        style: TextStyle(
                            color: Color(0xFFB9DCC6),
                            fontSize: 9,
                            fontWeight: FontWeight.w900)),
                    Text(
                      _verified
                          ? '100% Cocok & Terverifikasi'
                          : 'Menunggu Pemindaian',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    ),
                  ]),
            ),
            const Icon(Icons.shield_outlined,
                color: Color(0xFF72A889), size: 30),
          ]),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 7),
            decoration: BoxDecoration(
              color: deepGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              _statusValue('Nomor Ear-Tag', '#SP-8821', flex: 1),
              _verticalDivider(),
              _statusValue('Timbang Terkini', '421.5 kg', flex: 1),
              _verticalDivider(),
              _statusValue('Status Halal', 'Sesuai\nSyariat', flex: 1),
            ]),
          ),
          const SizedBox(height: 9),
          const Row(children: [
            Text('Penerima Hak Qurban:',
                style: TextStyle(color: Color(0xFFB9DCC6), fontSize: 9)),
            Spacer(),
            Text('Ahmad Fauzi (Shohibul Qurban)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800)),
          ]),
        ]),
      );

  Widget _statusValue(String label, String value, {required int flex}) =>
      Expanded(
        flex: flex,
        child: Column(children: [
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF9EC9AC),
                  fontSize: 8,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.35,
                  fontWeight: FontWeight.w900)),
        ]),
      );

  Widget _verticalDivider() => Container(
        width: 1,
        height: 49,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        color: Colors.white24,
      );

  Widget _manualEntry() => Material(
        color: const Color(0xFFE9ECFF),
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: _manualInput,
          borderRadius: BorderRadius.circular(11),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
            child: Row(children: [
              const Icon(Icons.qr_code_2, color: green, size: 18),
              const SizedBox(width: 7),
              const Expanded(
                child: Text('QR Tag kotor atau rusak?',
                    style: TextStyle(color: ink, fontSize: 10)),
              ),
              const Text('Input Kode Manual',
                  style: TextStyle(
                      color: deepGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w900)),
            ]),
          ),
        ),
      );

  Widget _confirmButton() => SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: _verified
              ? null
              : () {
                  if (_scannedValue != null) {
                    _confirmReceipt(_scannedValue!);
                  } else {
                    _showMessage(
                      'Pindai QR tag atau masukkan kode manual terlebih dahulu.',
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF39A00),
            foregroundColor: Colors.white,
            disabledBackgroundColor: green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 2,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.verified, size: 21),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                _verified ? 'Penerimaan Terverifikasi' : 'Verifikasi & Konfirmasi Terima',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 7),
            const Icon(Icons.arrow_forward, size: 19),
          ]),
        ),
      );

  Widget _driverButton() => SizedBox(
        height: 46,
        child: OutlinedButton.icon(
          onPressed: _contactDriver,
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFFE4E8FF),
            foregroundColor: ink,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          icon: const Icon(Icons.phone_in_talk_outlined, size: 15),
          label: const Text('Hubungi Driver (Pak Asep Mulyana)',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      );

  Widget _pill(String text, Color background, Color foreground) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: TextStyle(
                color: foreground,
                fontSize: 8,
                fontWeight: FontWeight.w900)),
      );
}

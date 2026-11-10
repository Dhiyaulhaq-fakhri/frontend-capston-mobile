// ignore_for_file: deprecated_member_use, unnecessary_import

import 'dart:async';
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Payment gateway demo. Integrasi API/payment gateway dilakukan belakangan.
class PaymentGatewayPage extends StatefulWidget {
  const PaymentGatewayPage({super.key});

  @override
  State<PaymentGatewayPage> createState() => _PaymentGatewayPageState();
}

class _PaymentGatewayPageState extends State<PaymentGatewayPage> {
  static const green = Color(0xFF07532F);
  static const deepGreen = Color(0xFF004522);
  static const pageBg = Color(0xFFFAF8FD);
  static const ink = Color(0xFF202A3D);
  static const muted = Color(0xFF718078);
  static const lavender = Color(0xFFF0F1FF);
  static const mint = Color(0xFFEFF7F2);
  static const reference = '#TRX-QBN-77291';
  static const vaNumber = '9870 0812 3456 7890';
  static const recipient = 'QURBANKAN - MUHAMMAD IRHASH';
  static const total = 28525000;

  Timer? _timer;
  Duration _remaining = const Duration(hours: 23, minutes: 59, seconds: 40);
  bool _checking = false;
  bool _checked = false;
  bool _mobileExpanded = true;
  bool _atmExpanded = false;
  bool _internetExpanded = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _clock {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _money(int value) {
    final input = value.toString();
    final out = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      out.write(input[i]);
      final rest = input.length - i - 1;
      if (rest > 0 && rest % 3 == 0) out.write('.');
    }
    return 'Rp ${out.toString()}';
  }

  Future<void> _copy(String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('$label berhasil disalin'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  Future<void> _checkStatus() async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _checked = false;
    });
    // Simulasi pemeriksaan status lokal, bukan request ke payment gateway.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _checking = false;
      _checked = true;
    });
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(Icons.hourglass_top_rounded, color: Color(0xFFB87916), size: 42),
        title: const Text('Menunggu Pembayaran'),
        content: const Text(
          'Belum ada pembayaran yang terdeteksi. Status ini masih simulasi frontend. '
          'Pengecekan otomatis akan aktif setelah backend dan payment gateway diintegrasikan.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: green),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti'),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 14),
                    _countdownCard(),
                    const SizedBox(height: 12),
                    _referenceCard(),
                    const SizedBox(height: 12),
                    _methodTab(),
                    const SizedBox(height: 12),
                    _virtualAccountCard(),
                    const SizedBox(height: 12),
                    _guideCard(),
                    const SizedBox(height: 12),
                    _sandboxCard(),
                  ],
                ),
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
              tooltip: 'Kembali',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back, color: ink, size: 20),
            ),
          ),
          const Spacer(),
          const Column(
            children: [
              Text('Payment gateway',
                  style: TextStyle(color: green, fontSize: 23, fontWeight: FontWeight.w900, height: 1.05)),
              SizedBox(height: 3),
              Text('Lihat sampai mana pesanan anda saat di kirim',
                  style: TextStyle(color: green, fontSize: 9.5, fontWeight: FontWeight.w500)),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 42),
        ],
      );

  Widget _countdownCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF07532F), Color(0xFF236B42)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [BoxShadow(color: green.withOpacity(.12), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -28,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: Colors.white.withOpacity(.055), shape: BoxShape.circle),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer, color: Color(0xFFFFC15C), size: 16),
                    const SizedBox(width: 5),
                    const Expanded(
                      child: Text('SELESAIKAN DALAM',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .35)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(.13), borderRadius: BorderRadius.circular(8)),
                      child: Text(_clock,
                          style: const TextStyle(
                            color: Color(0xFFFFD8A7),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .8,
                            fontFeatures: [FontFeature.tabularFigures()],
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text.rich(
                  TextSpan(
                    style: TextStyle(color: Color(0xFFD8E7DD), fontSize: 10),
                    children: [
                      TextSpan(text: 'Batas Akhir: '),
                      TextSpan(text: '15 Jun 2024, 15:25 WIB',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _card({required Widget child, EdgeInsets padding = const EdgeInsets.all(14)}) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF2F1F6), width: .5),
          boxShadow: [BoxShadow(color: const Color(0xFF1B3325).withOpacity(.025), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: child,
      );

  Widget _copyButton(String label, VoidCallback onTap) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.copy_outlined, size: 14, color: green),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(color: green, fontSize: 9, fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
      );

  Widget _referenceCard() => _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Nomor Referensi', style: TextStyle(color: muted, fontSize: 9)),
                SizedBox(height: 3),
                Text(reference, style: TextStyle(color: ink, fontSize: 16, fontWeight: FontWeight.w900)),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFFFEBD5), borderRadius: BorderRadius.circular(20)),
              child: const Text('Menunggu Pembayaran',
                  style: TextStyle(color: Color(0xFF69451E), fontSize: 8.5, fontWeight: FontWeight.w800)),
            ),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(11, 10, 10, 10),
            decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(9)),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Total Tagihan (Nett)', style: TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(_money(total), style: const TextStyle(color: green, fontSize: 20, fontWeight: FontWeight.w900)),
                ]),
              ),
              _copyButton('Salin', () => _copy(total.toString(), 'Nominal tagihan')),
            ]),
          ),
          const SizedBox(height: 11),
          const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.verified_outlined, color: green, size: 15),
            SizedBox(width: 7),
            Expanded(
              child: Text("Dana ditampung otomatis di Rekening Penitipan Syariah (Wad'iah Escrow)",
                  style: TextStyle(color: muted, fontSize: 9.5, height: 1.4)),
            ),
          ]),
        ]),
      );

  Widget _methodTab() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: const Color(0xFFE9ECF7), borderRadius: BorderRadius.circular(11)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: const Color(0xFF155632), borderRadius: BorderRadius.circular(8)),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.account_balance_outlined, color: Colors.white, size: 17),
            SizedBox(width: 6),
            Text('Virtual Account', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
          ]),
        ),
      );

  Widget _virtualAccountCard() => _card(
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 40, height: 40, alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFFEDEEFF), borderRadius: BorderRadius.circular(9)),
              child: const Text('BSI', style: TextStyle(color: green, fontSize: 16, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 11),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Bank Syariah Indonesia', style: TextStyle(color: ink, fontSize: 13, fontWeight: FontWeight.w900)),
              SizedBox(height: 2),
              Text('Virtual Account Syariah Terintegrasi', style: TextStyle(color: muted, fontSize: 8.5, fontWeight: FontWeight.w600)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFD8E9E1), borderRadius: BorderRadius.circular(5)),
              child: const Text('Otomatis', style: TextStyle(color: Color(0xFF3C5A4A), fontSize: 8, fontWeight: FontWeight.w800)),
            ),
          ]),
          const SizedBox(height: 19),
          Container(
            padding: const EdgeInsets.fromLTRB(11, 11, 10, 10),
            decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(9)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('NOMOR VIRTUAL ACCOUNT', style: TextStyle(color: Color(0xFF53635B), fontSize: 8.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 7),
              Row(children: [
                const Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(vaNumber, style: TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: .5)),
                  ),
                ),
                const SizedBox(width: 7),
                ElevatedButton.icon(
                  onPressed: () => _copy(vaNumber.replaceAll(' ', ''), 'Nomor Virtual Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepGreen, foregroundColor: Colors.white, elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                    minimumSize: Size.zero,
                  ),
                  icon: const Icon(Icons.copy_outlined, size: 14),
                  label: const Text('Salin VA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 13),
          const Padding(padding: EdgeInsets.only(left: 4),
            child: Text('Nama Penerima Rekening', style: TextStyle(color: muted, fontSize: 8.5, fontWeight: FontWeight.w700))),
          const SizedBox(height: 5),
          const Padding(padding: EdgeInsets.only(left: 4),
            child: Text(recipient, style: TextStyle(color: ink, fontSize: 14, fontWeight: FontWeight.w900))),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: mint, borderRadius: BorderRadius.circular(9)),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.bolt, color: green, size: 16),
              SizedBox(width: 6),
              Expanded(child: Text(
                'Pembayaran akan terverifikasi seketika secara otomatis oleh sistem tanpa perlu konfirmasi manual atau upload struk transfer.',
                style: TextStyle(color: Color(0xFF63746A), fontSize: 9.5, height: 1.5),
              )),
            ]),
          ),
        ]),
      );

  Widget _guideCard() => _card(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Panduan Cara Membayar', style: TextStyle(color: ink, fontSize: 15, fontWeight: FontWeight.w900)),
          const SizedBox(height: 9),
          _guide(
            title: 'BSI Mobile / BYOND', icon: Icons.phone_iphone_outlined,
            expanded: _mobileExpanded,
            onChanged: (v) => setState(() => _mobileExpanded = v),
            steps: const [
              'Buka aplikasi BSI Mobile atau BYOND, lalu login dengan akun Anda.',
              'Pilih menu Bayar / Beli lalu pilih kategori E-Commerce › Qurbankan.',
              'Masukkan nomor Virtual Account 9870 0812 3456 7890.',
              'Pastikan nama dan nominal sudah sesuai, lalu masukkan PIN transaksi.',
            ],
          ),
          const SizedBox(height: 7),
          _guide(
            title: 'ATM Bersama / Prima / Link', icon: Icons.atm_outlined,
            expanded: _atmExpanded,
            onChanged: (v) => setState(() => _atmExpanded = v),
            steps: const [
              'Masukkan kartu ATM dan PIN Anda.',
              'Pilih menu Transfer atau Pembayaran Virtual Account.',
              'Pilih bank tujuan Bank Syariah Indonesia jika diminta.',
              'Masukkan nomor Virtual Account, periksa nama dan nominal, lalu konfirmasi.',
            ],
          ),
          const SizedBox(height: 7),
          _guide(
            title: 'Internet Banking', icon: Icons.language,
            expanded: _internetExpanded,
            onChanged: (v) => setState(() => _internetExpanded = v),
            steps: const [
              'Login ke layanan internet banking bank Anda melalui situs resmi.',
              'Buka menu Transfer / Pembayaran Virtual Account.',
              'Masukkan nomor Virtual Account yang tertera pada halaman ini.',
              'Periksa detail transaksi dan selesaikan pembayaran sesuai instruksi bank.',
            ],
          ),
        ]),
      );

  Widget _guide({
    required String title,
    required IconData icon,
    required bool expanded,
    required ValueChanged<bool> onChanged,
    required List<String> steps,
  }) => Container(
        decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(9)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent),
          child: ExpansionTile(
            key: PageStorageKey<String>('guide-$title'),
            initiallyExpanded: expanded,
            onExpansionChanged: onChanged,
            tilePadding: const EdgeInsets.symmetric(horizontal: 10),
            childrenPadding: const EdgeInsets.fromLTRB(11, 0, 11, 11),
            visualDensity: const VisualDensity(vertical: -2),
            leading: Icon(icon, color: green, size: 18),
            title: Text(title, style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w900)),
            trailing: Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF66746C), size: 19),
            children: List.generate(steps.length, (i) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 19, height: 19, alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xFFD4E7DC), shape: BoxShape.circle),
                  child: Text('${i + 1}', style: const TextStyle(color: green, fontSize: 9, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(steps[i], style: const TextStyle(color: Color(0xFF65736B), fontSize: 9.5, height: 1.35)),
                )),
              ]),
            )),
          ),
        ),
      );

  Widget _sandboxCard() => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: const Color(0xFFE5E8FF), borderRadius: BorderRadius.circular(13)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.terminal, color: green, size: 15),
            SizedBox(width: 6),
            Text('PAYMENT GATEWAY SANDBOX', style: TextStyle(color: ink, fontSize: 8.5, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _checking ? null : _checkStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: green,
                disabledBackgroundColor: Colors.white, disabledForegroundColor: green.withOpacity(.6),
                elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: _checking
                  ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: green))
                  : const Icon(Icons.sync, size: 17),
              label: Text(_checking ? 'Memeriksa Status...' : 'Cek Status Transaksi',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
            ),
          ),
          if (_checked) ...[
            const SizedBox(height: 7),
            const Text('Status terakhir: Menunggu pembayaran (simulasi)',
                style: TextStyle(color: Color(0xFF66746C), fontSize: 8.5)),
          ],
        ]),
      );
}

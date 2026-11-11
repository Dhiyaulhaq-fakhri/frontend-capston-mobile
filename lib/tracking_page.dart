// ignore_for_file: prefer_final_fields, unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend_capston/sampai_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  static const Color green = Color(0xFF064B2B);
  static const Color ink = Color(0xFF182238);
  static const Color muted = Color(0xFF687366);
  static const Color pale = Color(0xFFF0F1FF);
  static const Color background = Color(0xFFF9F7FC);

  final MapController _mapController = MapController();

  // Rute demo: Bogor -> Tol Jagorawi -> Jakarta Selatan.
  final List<LatLng> _route = const [
    LatLng(-6.5971, 106.8060), // Bogor
    LatLng(-6.5650, 106.8170),
    LatLng(-6.5260, 106.8330),
    LatLng(-6.4900, 106.8460),
    LatLng(-6.4550, 106.8580),
    LatLng(-6.4200, 106.8680),
    LatLng(-6.3850, 106.8650),
    LatLng(-6.3500, 106.8520),
    LatLng(-6.3150, 106.8350),
    LatLng(-6.2800, 106.8150),
    LatLng(-6.2610, 106.8000), // Jakarta Selatan
  ];

  LatLng? _devicePosition;
  bool _gpsLoading = false;
  bool _receiptConfirmed = false;
  bool _journeySmooth = true;
  bool _gpsAvailable = false;

  LatLng get _vehiclePosition =>
      _devicePosition ?? const LatLng(-6.4350, 106.8620);

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _updateGps() async {
    setState(() => _gpsLoading = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _message('GPS belum aktif. Silakan aktifkan layanan lokasi.');
        await Geolocator.openLocationSettings();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _message('Izin lokasi belum diberikan.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _message('Izin lokasi ditolak permanen. Aktifkan melalui pengaturan aplikasi.');
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
      final point = LatLng(position.latitude, position.longitude);
      setState(() {
        _devicePosition = point;
        _gpsAvailable = true;
      });
      _mapController.move(point, 14);
      _message('Lokasi perangkat berhasil diperbarui.');
    } catch (e) {
      _message('Tidak dapat mengambil lokasi GPS: $e');
    } finally {
      if (mounted) setState(() => _gpsLoading = false);
    }
  }

  Future<void> _openRouteInMaps() async {
    final origin = '${_route.first.latitude},${_route.first.longitude}';
    final destination = '${_route.last.latitude},${_route.last.longitude}';
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _message('Tidak dapat membuka aplikasi peta.');
    }
  }

  Future<void> _callDriver() async {
    final uri = Uri(scheme: 'tel', path: '081234567890');
    if (!await launchUrl(uri)) {
      _message('Perangkat tidak dapat membuka aplikasi telepon.');
    }
  }

  void _showJourneyCondition() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Kondisi Perjalanan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ink)),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle, color: green),
              title: const Text('Lancar'),
              subtitle: const Text('Kendaraan bergerak sesuai estimasi perjalanan.'),
              onTap: () {
                setState(() => _journeySmooth = true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              title: const Text('Ada keterlambatan'),
              subtitle: const Text('Tampilkan status perjalanan mengalami kendala.'),
              onTap: () {
                setState(() => _journeySmooth = false);
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _confirmReceipt() async {
  final bool? lanjut = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        content: const Text(
          'Pastikan metode pembayaran dan lokasi '
          'sudah sesuai sebelum mengonfirmasi pesanan.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Kembali'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Lanjut'),
          ),
        ],
      );
    },
  );

  if (!mounted) return;

  if (lanjut == true) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScanSampaiPage(),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 16),
                    _shipmentCard(),
                    const SizedBox(height: 22),
                    _mapCard(),
                    const SizedBox(height: 22),
                    _historyCard(),
                    const SizedBox(height: 22),
                    _driverCard(),
                    const SizedBox(height: 22),
                    _paymentCard(),
                    const SizedBox(height: 25),
                    _confirmationButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: ink),
            tooltip: 'Kembali',
          ),
        ),
        const Spacer(),
        const Column(
          children: [
            Text('Tracking', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: green)),
            Text('Lihat sampai mana pesanan anda saat di kirim',
                style: TextStyle(fontSize: 10, color: green, fontWeight: FontWeight.w500)),
          ],
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _shipmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF004522),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: green.withOpacity(.15), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _pill(
            _receiptConfirmed ? 'PESANAN DITERIMA' : 'DALAM PENGIRIMAN',
            color: const Color(0xFF286B49),
            textColor: const Color(0xFFB9E5C8),
            icon: _receiptConfirmed ? Icons.check_circle : Icons.circle,
          ),
          const Spacer(),
          const Text('#TRX-QBN-77291', style: TextStyle(color: Color(0xFFB9D7C5), fontSize: 10)),
        ]),
        const SizedBox(height: 13),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.network(
              'https://images.unsplash.com/photo-1524024973431-2ad916746881?w=400',
              width: 62,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 62,
                height: 64,
                color: const Color(0xFFB7C8A9),
                child: const Icon(Icons.pets, color: green, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Sapi Limousin Super Grade A',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
              SizedBox(height: 2),
              Text('Bobot: 420 kg • Bersertifikat Sehat',
                  style: TextStyle(color: Color(0xFFB9D7C5), fontSize: 10)),
              SizedBox(height: 4),
              Row(children: [
                Icon(Icons.verified, color: Color(0xFFFFD18A), size: 14),
                SizedBox(width: 4),
                Expanded(child: Text("Syar'i & Memenuhi Syarat Qurban",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: const Color(0xFF07542E), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Expanded(child: _shipmentInfo('Estimasi Tiba', _receiptConfirmed ? 'Selesai' : '15 Jun 2024', '09.00 - 12.00 WIB (H-2)')),
            const SizedBox(width: 8),
            Expanded(child: _shipmentInfo('Tujuan Pengiriman', 'Masjid Al-Falah', 'Kebayoran Baru, Jaksel')),
          ]),
        ),
      ]),
    );
  }

  Widget _shipmentInfo(String label, String value, String sub) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Color(0xFF9BC9A9), fontSize: 9, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(sub, style: const TextStyle(color: Color(0xFFB9D7C5), fontSize: 9)),
    ]);
  }

  Widget _mapCard() {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _iconBox(Icons.near_me_outlined, const Color(0xFFE1E6FF), green),
          const SizedBox(width: 9),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Live Tracking Rute', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: ink)),
            Text('Bogor → Tol Jagorawi → Jakarta Selatan', style: TextStyle(fontSize: 10, color: muted)),
          ])),
          _pill(
            _gpsAvailable ? 'GPS Aktif' : 'GPS Demo',
            color: const Color(0xFFD9E9E0),
            textColor: const Color(0xFF52685B),
            icon: Icons.circle,
          ),
        ]),
        const SizedBox(height: 11),
        ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: SizedBox(
            height: 178,
            child: Stack(children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(-6.4350, 106.8620),
                  initialZoom: 10.7,
                  minZoom: 5,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.qurban_app',
                  ),
                  PolylineLayer(polylines: [
                    Polyline(points: _route, strokeWidth: 5, color: const Color(0xFF158A50)),
                  ]),
                  MarkerLayer(markers: [
                    Marker(
                      point: _route.first,
                      width: 28,
                      height: 28,
                      child: const Icon(Icons.location_on, color: Color(0xFF1885D2), size: 27),
                    ),
                    Marker(
                      point: _route.last,
                      width: 28,
                      height: 28,
                      child: const Icon(Icons.location_on, color: Color(0xFFE04E4E), size: 27),
                    ),
                    Marker(
                      point: _vehiclePosition,
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(color: green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.local_shipping, color: Colors.white, size: 19),
                      ),
                    ),
                  ]),
                ],
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Column(children: [
                  _mapControl(Icons.add, () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1)),
                  const SizedBox(height: 5),
                  _mapControl(Icons.remove, () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1)),
                ]),
              ),
              Positioned(
                left: 8,
                bottom: 7,
                child: Material(
                  color: Colors.white.withOpacity(.95),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: _openRouteInMaps,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                      child: Row(children: [
                        Icon(Icons.open_in_new, size: 12, color: green),
                        SizedBox(width: 4),
                        Text('Buka peta', style: TextStyle(fontSize: 9, color: green, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFE0F8E9), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            const CircleAvatar(radius: 14, backgroundColor: green, child: Icon(Icons.local_shipping, color: Colors.white, size: 16)),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Posisi: ${_devicePosition == null ? 'Tol Jagorawi KM 19' : 'Lokasi perangkat terdeteksi'}',
                  style: const TextStyle(fontSize: 10, color: ink, fontWeight: FontWeight.w700)),
              Text(_devicePosition == null ? 'Laju Kecepatan: 58 km/jam' : 'Lat ${_devicePosition!.latitude.toStringAsFixed(5)}, Long ${_devicePosition!.longitude.toStringAsFixed(5)}',
                  style: const TextStyle(fontSize: 9, color: muted)),
            ])),
            TextButton(
              onPressed: _showJourneyCondition,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFB8F2C8),
                foregroundColor: green,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(_journeySmooth ? 'Lancar' : 'Terlambat', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
            ),
          ]),
        ),
        const SizedBox(height: 9),
        Row(children: [
          Expanded(child: _conditionTile(Icons.air, 'Ventilasi Boks', 'Optimal & Sejuk')),
          const SizedBox(width: 8),
          Expanded(child: _conditionTile(Icons.water_drop_outlined, 'Cairan Tubuh', 'Cukup & Tenang')),
        ]),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _gpsLoading ? null : _updateGps,
            icon: _gpsLoading
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.my_location, size: 15),
            label: const Text('Perbarui Lokasi GPS'),
            style: OutlinedButton.styleFrom(
              foregroundColor: green,
              side: const BorderSide(color: Color(0xFFD5E3D9)),
              textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _conditionTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        CircleAvatar(radius: 13, backgroundColor: Colors.white, child: Icon(icon, color: green, size: 15)),
        const SizedBox(width: 7),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 8, color: muted)),
          Text(value, style: const TextStyle(fontSize: 9, color: ink, fontWeight: FontWeight.w800)),
        ])),
      ]),
    );
  }

  Widget _historyCard() {
    final items = [
      _HistoryItem('Pesanan Dikonfirmasi', 'Kandang mitra Ciomas telah mengunci alokasi sapi terpilih.', '10 Jun, 14:20', true, false),
      _HistoryItem('Pembayaran Berhasil', 'Terverifikasi otomatis via Payment Gateway Escrow.', '10 Jun, 14:25', true, false),
      _HistoryItem('Pemeriksaan SKKH Terbit', 'Disnak Approved: Bebas PMK & Sehat', '14 Jun, 08:00', true, false),
      _HistoryItem(
        _receiptConfirmed ? 'Hewan Telah Diterima' : 'Ternak Dalam Perjalanan',
        _receiptConfirmed ? 'Penerimaan hewan telah dikonfirmasi oleh pihak tujuan.' : 'Armada Khusus Colt Diesel (B 9128 TDA) melaju terenana dari Bogor.',
        _receiptConfirmed ? 'Selesai' : 'Sedang Berjalan',
        _receiptConfirmed,
        !_receiptConfirmed,
      ),
      _HistoryItem('Serah Terima di Lokasi', 'Penimbangan ulang dan penandatanganan berita acara bersama panitia qurban.', '', _receiptConfirmed, false),
    ];

    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Riwayat Perjalanan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: ink)),
          const Spacer(),
          Text(_receiptConfirmed ? 'Selesai' : 'Tahap 4 dari 5',
              style: const TextStyle(fontSize: 10, color: green, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 13),
        ...List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return _timelineItem(item, isLast);
        }),
      ]),
    );
  }

  
Widget _timelineItem(_HistoryItem item, bool isLast) {
  final done = item.done || _receiptConfirmed;
  final active = item.active && !_receiptConfirmed;

  final color = done
      ? green
      : (active ? const Color(0xFFB9E8C7) : const Color(0xFFDCE2F6));

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        SizedBox(
          width: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: active
                      ? Border.all(color: green, width: 2)
                      : null,
                ),
                child: Icon(
                  done ? Icons.check : Icons.circle,
                  color: done
                      ? Colors.white
                      : (active ? green : const Color(0xFF758096)),
                  size: 12,
                ),
              ),
              if (!isLast)
                Container(
                  width: 1.5,
                  height: 24,
                  color: const Color(0xFFC7D0C8),
                ),
            ],
          ),
        ),

        const SizedBox(width: 7),

        // Timeline content
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: active || done
                            ? ink
                            : const Color(0xFF7D8794),
                      ),
                    ),
                  ),
                  if (item.time.isNotEmpty)
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 8.5,
                        color: muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 3),

              Text(
                item.description,
                style: TextStyle(
                  fontSize: 9.5,
                  color: active || done
                      ? muted
                      : const Color(0xFF92999D),
                  height: 1.35,
                ),
              ),

              if (item.title == 'Pemeriksaan SKKH Terbit')
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: pale,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '✓ Disnak Approved: Bebas PMK & Sehat',
                    style: TextStyle(
                      fontSize: 8.5,
                      color: green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

              if (active)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pale,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Armada sedang menuju titik tujuan. Pantau posisi melalui peta tracking di atas.',
                    style: TextStyle(
                      fontSize: 9,
                      color: muted,
                      height: 1.3,
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


  Widget _driverCard() {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Armada & Pawang Hewan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: ink)),
          const Spacer(),
          const Text('Tersertifikasi PBPH', style: TextStyle(fontSize: 9, color: muted, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFDCE7DC),
            child: Icon(Icons.person, color: green, size: 31),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Pak Hendra Setiawan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: ink)),
            Text('Colt Diesel Center • B 9128 TDA', style: TextStyle(fontSize: 9.5, color: muted)),
            SizedBox(height: 3),
            Text('Pawang Pendamping: Mang Ujang', style: TextStyle(fontSize: 9, color: muted)),
          ])),
          const Text('★ 4.9', style: TextStyle(fontSize: 12, color: Color(0xFF805000), fontWeight: FontWeight.w800)),
          const SizedBox(width: 5),
          Material(
            color: green,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: _callDriver,
              icon: const Icon(Icons.call, color: Colors.white, size: 19),
              tooltip: 'Telepon sopir',
            ),
          ),
        ]),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: const Color(0xFFE4E8FF), borderRadius: BorderRadius.circular(9)),
          child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline, color: Color(0xFF916000), size: 15),
            SizedBox(width: 5),
            Expanded(child: Text('Log Perjalanan: Hewan telah diberi minum dan istirahat sejenak 15 menit di Rest Area KM 21 Cibubur untuk mencegah stres.',
                style: TextStyle(fontSize: 9.5, color: ink, height: 1.4))),
          ]),
        ),
      ]),
    );
  }

  Widget _paymentCard() {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _iconBox(Icons.receipt_long_outlined, const Color(0xFFDDEBE3), green),
          const SizedBox(width: 9),
          const Text('Rincian Pembayaran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: ink)),
          const Spacer(),
          _pill('Lunas (BCA VA)', color: green, textColor: Colors.white, icon: Icons.circle),
        ]),
        const SizedBox(height: 14),
        _priceRow('Harga Hewan Qurban (420 kg)', 'Rp 28.500.000'),
        _priceRow('Ongkos Kirim Armada Khusus Ternak', 'Rp 450.000'),
        _priceRow('Asuransi Pengiriman Ternak Sehat', 'Rp 150.000'),
        const Divider(height: 20),
        Row(children: [
          const Text('Total Dibayar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: ink)),
          const Spacer(),
          const Text('Rp 29.100.000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: green)),
        ]),
      ]),
    );
  }

  Widget _priceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 10, color: muted))),
        Text(price, style: const TextStyle(fontSize: 10.5, color: ink, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _confirmationButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _confirmReceipt,
        icon: Icon(_receiptConfirmed ? Icons.check_circle_outline : Icons.how_to_reg_outlined, size: 17),
        label: Text(_receiptConfirmed ? 'Penerimaan Hewan Terkonfirmasi' : 'Konfirmasi Penerimaan Hewan  →'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _receiptConfirmed ? green : const Color(0xFFB87900),
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.025), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: child,
    );
  }

  Widget _iconBox(IconData icon, Color bg, Color fg) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9)),
      child: Icon(icon, color: fg, size: 18),
    );
  }

  Widget _pill(String text, {required Color color, required Color textColor, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: textColor, size: 8),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: textColor, fontSize: 8.5, fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _mapControl(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(width: 29, height: 29, child: Icon(icon, size: 17, color: ink)),
      ),
    );
  }
}

class _HistoryItem {
  final String title;
  final String description;
  final String time;
  final bool done;
  final bool active;

  const _HistoryItem(this.title, this.description, this.time, this.done, this.active);
}

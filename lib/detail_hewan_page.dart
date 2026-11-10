
import 'package:flutter/material.dart';

class DetailHewanPage extends StatefulWidget {
  const DetailHewanPage({super.key});

  @override
  State<DetailHewanPage> createState() => _DetailHewanPageState();
}

class _DetailHewanPageState extends State<DetailHewanPage> {
  final Color hijau = const Color(0xFF006B3F);
  final Color krem = const Color(0xFFFFF5C2);
  final Color emas = const Color(0xFFB87900);

  bool favorit = false;

  void tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: krem,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text(
              'Detail Hewan Ternak',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Detail Hewan Qurban',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 5, 12, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // FOTO HEWAN
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'resources/sapi-limosin.jpg',
                          width: double.infinity,
                          height: 175,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 175,
                              width: double.infinity,
                              color: const Color(0xFFE6E6E6),
                              child: const Icon(
                                Icons.pets,
                                size: 65,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),

                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: hijau,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '✓ Siap Qurban',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 17,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 19,
                            onPressed: () {
                              setState(() {
                                favorit = !favorit;
                              });
                            },
                            icon: Icon(
                              favorit
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favorit ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sapi Limousin Super Grade A',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Rp 28.500.000',
                              style: TextStyle(
                                color: Color(0xFF006B3F),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hijau,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                        onPressed: () {
                          tampilkanPesan('Informasi hewan berhasil dibuka');
                        },
                        child: const Text(
                          'Siap Qurban',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // SPESIFIKASI
            const Text(
              'Spesifikasi & Karakteristik',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: [
                spesifikasi(
                  Icons.pets,
                  'JENIS HEWAN',
                  'Sapi Limousin',
                ),
                spesifikasi(
                  Icons.monitor_weight_outlined,
                  'BOBOT HIDUP',
                  '420 Kg',
                ),
                spesifikasi(
                  Icons.calendar_month,
                  'UMUR HEWAN',
                  '2 Thn 6 Bulan',
                ),
                spesifikasi(
                  Icons.male,
                  'JENIS KELAMIN',
                  'Jantan',
                ),
              ],
            ),

            const SizedBox(height: 12),

            // KONDISI FISIK
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: Color(0xFF006B3F),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Kondisi Fisik & Sanitasi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Sangat prima, mata jernih, bersih, '
                    'tidak menunjukkan tanda-tanda penyakit. '
                    'Kondisi kaki dan pinggang kuat, memenuhi '
                    'standar kesehatan ternak.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Color(0xFF006B3F),
                          size: 16,
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Sudah memenuhi standar kesehatan',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // INFORMASI PETERNAK
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Peternak',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFD6E6DF),
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF006B3F),
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bapak Ahmad Peternak',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Peternak Terverifikasi',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.verified,
                        color: Color(0xFF006B3F),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      tombolKecil(
                        Icons.location_on,
                        'Kuningan, Jawa Barat',
                      ),
                      tombolKecil(
                        Icons.store,
                        'Chat Peternak',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // JAMINAN SYARIAH
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: hijau,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Garansi Amanah & Syariah',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Hewan dipilih berdasarkan standar '
                          'kelayakan dan ketentuan qurban.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // TOMBOL BELI
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 15),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: emas,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              tampilkanPesan(
                'Silakan lanjutkan ke proses pemesanan',
              );
            },
            child: const Text(
              'Beli Sekarang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET SPESIFIKASI
  Widget spesifikasi(
    IconData icon,
    String judul,
    String isi,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: hijau, size: 16),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            isi,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TOMBOL KECIL
  Widget tombolKecil(IconData icon, String teks) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F2EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: hijau),
          const SizedBox(width: 5),
          Text(
            teks,
            style: const TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }
}

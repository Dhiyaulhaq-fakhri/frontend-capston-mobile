import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Warna Utama
  final Color primaryGreen = const Color(0xFF0F5D3B);
  final Color bgColor = const Color(0xFFF3F6FF); // Background chat agak kebiruan
  final Color bubbleSeller = const Color(0xFFE8EDFF);
  final Color bubbleBuyer = const Color(0xFF0F5D3B);

  // Controller untuk input chat
  final TextEditingController _chatController = TextEditingController();
  
  // List untuk menyimpan chat tambahan dari user (fitur lokal)
  final List<String> _userMessages = [];

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        _userMessages.add(_chatController.text);
        _chatController.clear();
      });
      // Scroll ke bawah (bisa ditambahkan dengan ScrollController nanti)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: primaryGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.storefront, color: primaryGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Kandang Berkah 🏠", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    const Text("Online • Responsif (< 5 mnt)", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                )
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black87), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // --- AREA CHAT (SCROLLABLE) ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Header Toko di dalam chat
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.store, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Berkah Farm Jonggol (H. Ridwan)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Row(
                              children: [
                                const Icon(Icons.verified, color: Colors.blue, size: 12),
                                const SizedBox(width: 4),
                                Text("SKKH & DSN-MUI", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                const SizedBox(width: 8),
                                const Icon(Icons.star, color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text("4.9 (1.2k)", style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: bubbleSeller, borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.receipt_long, color: primaryGreen, size: 16),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Card Produk (Sapi)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network('https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?q=80&w=100&auto=format&fit=crop', width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)), child: const Text("SUPER A", style: TextStyle(color: Colors.white, fontSize: 8))),
                                    const SizedBox(width: 4),
                                    const Text("#SP-8821-JGG • Jonggol", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text("Sapi Simental Bobot 420 kg", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text("Rp 22.400.000", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                                const Text("| Patungan: Rp 3.2jt/slot", style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                          ),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)), child: const Text("Rawat H-3", style: TextStyle(color: Colors.green, fontSize: 9))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.local_offer_outlined, size: 14, color: primaryGreen),
                              label: const Text("Ajukan Nego Syariah", style: TextStyle(fontSize: 11)),
                              style: OutlinedButton.styleFrom(foregroundColor: primaryGreen, side: BorderSide(color: Colors.grey.shade300)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.shopping_cart_outlined, size: 14, color: Colors.white),
                              label: const Text("Beli / Ambil Slot", style: TextStyle(fontSize: 11, color: Colors.white)),
                              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Chip Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoChip("Apakah gigi sudah poel?"),
                    _buildInfoChip("Bisa video call timbang live?"),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Jaminan Perlindungan
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(Icons.shield, color: primaryGreen, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Jaminan Perlindungan Transaksi Syariah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                            const SizedBox(height: 2),
                            const Text("Semua pembayaran & akad resmi dilakukan melalui sistem rekening bersama Qurban. (garansi penggantian hewan jika cacat/mati).", style: TextStyle(color: Colors.black87, fontSize: 10, height: 1.3)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 5. CHAT BUBBLE (PEMBELI - KANAN)
                _buildBubbleBuyer(
                  "Assalamu'alaikum Pak Haji Ridwan, saya tertarik dengan Sapi Simental #SP-8821-JGG ini untuk kurban keluarga besar. Apakah bobot 420 kg ini hasil timbang terbaru minggu ini?",
                  "09:16",
                ),
                const SizedBox(height: 16),

                // 6. CHAT BUBBLE (PENJUAL - KIRI) + MEDIA
                _buildBubbleSeller(
                  "Wa'alaikumssalam wr. wb. Pak Irhash. Betul sekali pak, penimbangan terakhir dilakukan kemarin pagi (Selasa) dengan timbangan digital tersertifikasi Dinas Peternakan. Bobot bersih tercatat 421.5 kg, nafsu makan sangat bagus dan gigi sudah poel 2 pasang (sah musinnah).",
                  "H. Ridwan • Berkah Farm",
                  "09:18",
                  // Gambar Live Timbang
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.network('https://images.unsplash.com/photo-1546445317-29f4545e9d53?q=80&w=400&auto=format&fit=crop', height: 150, width: double.infinity, fit: BoxFit.cover),
                            Positioned(
                              top: 8, left: 8,
                              child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)), child: const Text("Live Cam Timbang lot!", style: TextStyle(color: Colors.white, fontSize: 9))),
                            ),
                            Center(child: Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle), child: const Icon(Icons.play_arrow, color: Colors.black, size: 30))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(6)), child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 16)),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("SKKH_Resmi_Disnak_Bogor.pdf", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                  Text("1.8 MB • Ditandatangani Dokter Hewan", style: TextStyle(color: Colors.grey, fontSize: 9)),
                                ],
                              ),
                            ),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)), child: const Text("Valid", style: TextStyle(color: Colors.green, fontSize: 9))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 7. CARD PENAWARAN RESMI
                _buildOfferCard(),
                const SizedBox(height: 16),

                // 8. CHAT BUBBLE (PEMBELI - KANAN)
                _buildBubbleBuyer(
                  "Alhamdulillah, penawarannya sangat menarik pak. Kalau saya ambil 2 slot patungan apakah pengiriman daging karkasnya bisa dialokasikan sebagian ke daerah asal saya di Garut?",
                  "09:21",
                ),
                const SizedBox(height: 16),

                // 9. CHAT BUBBLE (PENJUAL - KIRI)
                _buildBubbleSeller(
                  "Tentu sangat bisa pak! Di form checkout nanti bapak bisa pilih opsi 'Bagi 1/3 Pribadi & 2/3 Sedekah Pelosok' atau atur multi-alamat (Jakarta & Garut). Daging kurban akan dikemas higienis dengan thermo-box berpendingin agar tetap segar sampai tujuan.",
                  null,
                  "09:23",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_shipping, color: primaryGreen, size: 16),
                            const SizedBox(width: 6),
                            const Text("Armada Cold-Chain Berlisensi Halal MUI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 10. CHAT DARI USER (LOKAL)
                ..._userMessages.map((msg) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildBubbleBuyer(msg, "Baru saja"),
                  );
                }),
              ],
            ),
          ),

          // --- AREA INPUT CHAT (BOTTOM) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: bubbleSeller, shape: BoxShape.circle),
                    child: Icon(Icons.add, color: primaryGreen),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(24)),
                      child: TextField(
                        controller: _chatController,
                        decoration: const InputDecoration(
                          hintText: "Ketik pesan ke Berkah Far...",
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.mic_none, color: Colors.grey), onPressed: () {}),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 12, color: Colors.grey),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  // Bubble Chat Pembeli (Kanan)
  Widget _buildBubbleBuyer(String text, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: bubbleBuyer, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time, style: const TextStyle(color: Colors.white70, fontSize: 9)),
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, color: Colors.lightBlueAccent, size: 12),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // Bubble Chat Penjual (Kiri)
  Widget _buildBubbleSeller(String text, String? senderName, String time, [Widget? extraContent]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16), bottomRight: Radius.circular(16))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (senderName != null) ...[
                Text(senderName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87)),
                const SizedBox(height: 4),
              ],
              Text(text, style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
              // ignore: use_null_aware_elements
              if (extraContent != null) extraContent,
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 9)),
            ],
          ),
        ),
      ],
    );
  }

  // Card Penawaran Resmi
  Widget _buildOfferCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_offer, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  const Text("Penawaran Resmi Khusus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF8B5A00), borderRadius: BorderRadius.circular(4)),
                child: const Text("BERLAKU 24 JAM", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E885A), borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sapi Simental #SP-8821-JGG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 2),
                        const Text("Early-Bird Promo + Rawat Gratis H-1 Iduladha", style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.shade200, borderRadius: BorderRadius.circular(4)),
                      child: const Text("~Rp 500rb", style: TextStyle(color: Colors.brown, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Harga Sapi Utuh", style: TextStyle(color: Colors.white70, fontSize: 10)),
                        SizedBox(height: 4),
                        Text("Rp 21.900.000", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Rp 22.400.000", style: TextStyle(color: Colors.white54, fontSize: 10, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("Opsi Patungan (1/7)", style: TextStyle(color: Colors.white70, fontSize: 10)),
                        SizedBox(height: 4),
                        Text("Rp 3.120.000", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("per slot / nama", style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text("Ajukan Diskusi Ulang", style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFC107), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text("Terima & Akad →", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
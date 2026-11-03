import 'dart:ui'; // Diperlukan untuk ImageFilter (efek blur)
import 'package:flutter/material.dart';
import 'package:frontend_capston/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk menangkap input user nanti
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State untuk checkbox dan visibility password
  bool _isAgreed = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Warna Utama
  final Color primaryGreen = const Color(0xFF1B5E20);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Karena background sudah kamu siapkan, kita asumsikan ada di asset.
      // Ganti 'assets/background_qurban.jpg' dengan path gambar kamu.
      // Jika belum ada, kamu bisa ganti dengan Container(color: Colors.grey) sementara.
      body: Stack(
        children: [
          // 1. BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'resources/bg_auth.png', // <-- GANTI PATH INI
              fit: BoxFit.cover,
              // Jika error karena asset belum ada, pakai ini sementara:
              // errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[800]),
            ),
          ),
          
          // Opsional: Overlay gelap agar teks form lebih terbaca
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          // 2. FORM CONTAINER (Efek Kaca / Glassmorphism)
          // --- GANTI SELURUH BAGIAN SafeArea MENJADI INI ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Stack(
                  clipBehavior: Clip.none, // Penting: agar logo bisa keluar dari batas Stack
                  alignment: Alignment.center,
                  children: [
                    
                    // 1. KOTAK UTAMA (CARD KACA)
                    // Kita beri margin top 30 agar ada ruang untuk logo di atasnya
                    Container(
                      margin: const EdgeInsets.only(top: 50), 
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            // Padding atas 70 agar teks "Buat Akun Baru" turun dan tidak tertutup logo
                            padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // --- JUDUL ---
                                const Text(
                                  "Buat Akun Baru",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Bergabung di ekosistem jual beli & rawat ternak amanah berstandar syariah",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                const SizedBox(height: 24),

                                // --- FORM INPUT ---
                                _buildLabel("Nama Lengkap"),
                                _buildTextField(
                                  hint: "Contoh: Muhammad Ihrash Syahid",
                                  icon: Icons.person_outline,
                                  controller: _nameController,
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Nomor WhatsApp / HP"),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text("🇮🇩", style: TextStyle(fontSize: 16)),
                                          SizedBox(width: 4),
                                          Text("+62", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildTextField(
                                        hint: "812-3456-7890",
                                        icon: null,
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Alamat Email"),
                                _buildTextField(
                                  hint: "nama@email.com",
                                  icon: Icons.alternate_email,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Kata Sandi"),
                                _buildTextField(
                                  keyName: "password_field",
                                  hint: "Minimal 8 karakter unik",
                                  icon: Icons.lock_outline,
                                  controller: _passwordController,
                                  isPassword: true,
                                  obscureText: _obscurePassword,
                                  onToggleVisibility: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Konfirmasi Kata Sandi"),
                                _buildTextField(
                                  keyName: "confirm_password_field",
                                  hint: "Ulangi kata sandi",
                                  icon: Icons.shield_outlined,
                                  controller: _confirmPasswordController,
                                  isPassword: true,
                                  obscureText: _obscureConfirmPassword,
                                  onToggleVisibility: () {
                                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                  },
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: _isAgreed,
                                        activeColor: primaryGreen,
                                        side: const BorderSide(color: Colors.grey),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        onChanged: (value) {
                                          setState(() => _isAgreed = value ?? false);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: "Saya menyetujui ",
                                          style: TextStyle(fontSize: 11, color: Colors.black87),
                                          children: [
                                            TextSpan(text: "Syarat & Ketentuan ", style: TextStyle(fontWeight: FontWeight.bold)),
                                            TextSpan(text: "serta "),
                                            TextSpan(text: "Kebijakan Privasi ", style: TextStyle(fontWeight: FontWeight.bold)),
                                            TextSpan(text: "Akad Syariah TernakKu."),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // --- TOMBOL DAFTAR ---
                                SizedBox(
                                  width: double.infinity, // Memenuhi lebar layar
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Logika Register di sini
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryGreen,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text(
                                      "Daftar Akun Sekarang",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Sudah punya akun? ", style: TextStyle(fontSize: 12, color: Colors.black54)),
                                    GestureDetector(
                                      onTap: () {
                                        // Arahkan kembali ke halaman Login
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LoginPage()),
                                        );
                                      },
                                      child: Text(
                                        "Masuk di sini",
                                        style: TextStyle(fontSize: 12, color: primaryGreen, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 2. LOGO QURBANKAN (DIPOSISIKAN DI ATAS KOTAK KACA)
                    // Karena kita pakai Stack, kita bisa atur posisinya dengan Positioned
                    Positioned(
                      top: 0, // Nempel di paling atas Stack
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.eco, color: primaryGreen, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "QURBANKAN",
                              style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Label di atas input
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
        ),
      ),
    );
  }

  // TextField Custom
    Widget _buildTextField({
    required String hint,
    IconData? icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    String? keyName, // Tambahkan parameter keyName
  }) {
    return TextField(
      key: ValueKey(keyName ?? hint), // Gunakan ValueKey agar state stabil
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
        prefixIcon: icon != null ? Icon(icon, color: primaryGreen, size: 20) : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Hilangkan garis border bawaan
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen, width: 1.5), // Garis hijau saat fokus
        ),
      ),
    );
  }
}
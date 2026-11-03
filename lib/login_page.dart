import 'dart:ui'; // Diperlukan untuk ImageFilter (efek blur)
import 'package:flutter/material.dart';
import 'package:frontend_capston/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State untuk visibility password
  bool _obscurePassword = true;

  // Warna Utama
  final Color primaryGreen = const Color(0xFF1B5E20);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND (Gunakan path yang sama dengan Register)
          Positioned.fill(
            child: Image.asset(
              'resources/bg_auth.png', // <-- Sesuaikan path background kamu
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay gelap tipis
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          // 2. FORM CONTAINER
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Stack(
                  clipBehavior: Clip.none, // Penting: agar logo bisa keluar dari batas Stack
                  alignment: Alignment.center,
                  children: [
                    
                    // 1. KOTAK UTAMA (CARD KACA)
                    // Margin top 30 ini sama persis seperti di Register
                    Container(
                      margin: const EdgeInsets.only(top: 50), 
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            // Padding atas 70 agar teks "Masuk" turun dan tidak tertutup logo
                            padding: const EdgeInsets.fromLTRB(24, 70, 24, 30),
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
                                  "Masuk",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Masuk untuk mencoba lebih banyak fitur menarik dan solutif",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                const SizedBox(height: 24),

                                // --- FORM INPUT ---
                                _buildLabel("Email / Nomer Hp"),
                                _buildTextField(
                                  hint: "nama@email.com",
                                  icon: Icons.alternate_email,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Kata Sandi"),
                                _buildTextField(
                                  keyName: "login_password_field",
                                  hint: "Minimal 8 karakter unik",
                                  icon: Icons.lock_outline,
                                  controller: _passwordController,
                                  isPassword: true,
                                  obscureText: _obscurePassword,
                                  onToggleVisibility: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                const SizedBox(height: 24),

                                // --- TOMBOL MASUK ---
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Logika Login di sini
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryGreen,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text(
                                      "Masuk",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // --- FOOTER DAFTAR ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Belum punya akun? ", style: TextStyle(fontSize: 12, color: Colors.black54)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                                        );
                                      },
                                      child: Text(
                                        "Daftar di sini",
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

  // --- WIDGET HELPER (SAMA SEPERTI DI REGISTER) ---

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

  Widget _buildTextField({
    required String hint,
    IconData? icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    String? keyName,
  }) {
    return TextField(
      key: ValueKey(keyName ?? hint),
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
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen, width: 1.5),
        ),
      ),
    );
  }
}
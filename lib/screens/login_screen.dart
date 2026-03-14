import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _obscure = true;
  bool _obscureR = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _logo(),
              const SizedBox(height: 32),
              _tabBar(),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _tab.index == 0
                    ? _LoginForm(
                        key: const ValueKey('login'),
                        obscure: _obscure,
                        onToggleObscure: () =>
                            setState(() => _obscure = !_obscure),
                        loading: _loading,
                        onSubmit: _fakeLogin,
                      )
                    : _RegisterForm(
                        key: const ValueKey('register'),
                        obscure: _obscureR,
                        onToggleObscure: () =>
                            setState(() => _obscureR = !_obscureR),
                        loading: _loading,
                        onSubmit: _fakeLogin,
                      ),
              ),
              const SizedBox(height: 24),
              _divider(),
              const SizedBox(height: 20),
              _socialButtons(),
              const SizedBox(height: 32),
              _footer(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [C.pinkLight, C.pinkDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(color: C.pinkGlow, blurRadius: 24, spreadRadius: 4),
            ],
          ),
          child: const Icon(
            Icons.shield_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text('SafeHer ID', style: TS.h(26)),
        const SizedBox(height: 4),
        Text('Aplikasi keamanan untuk wanita Indonesia', style: TS.r(13)),
      ],
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: C.surface3,
          borderRadius: BorderRadius.circular(13),
        ),
        child: TabBar(
          controller: _tab,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [C.pinkLight, C.pinkDark],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: C.textMuted,
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 14),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Masuk'),
            Tab(text: 'Daftar'),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: C.border, height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('atau', style: TS.r(12, c: C.textMuted)),
          ),
          Expanded(child: Divider(color: C.border, height: 1)),
        ],
      ),
    );
  }

  Widget _socialButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _SocialBtn(
              icon: Icons.g_mobiledata_rounded,
              label: 'Google',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SocialBtn(
              icon: Icons.phone_android_rounded,
              label: 'WhatsApp',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Text(
      'Dengan masuk, kamu menyetujui Syarat & Ketentuan\ndan Kebijakan Privasi SafeHer ID.',
      textAlign: TextAlign.center,
      style: TS.r(11, c: C.textMuted, h: 1.55),
    );
  }

  void _fakeLogin() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppShell()),
      );
    }
  }
}

class _LoginForm extends StatelessWidget {
  final bool obscure, loading;
  final VoidCallback onToggleObscure, onSubmit;
  const _LoginForm({
    super.key,
    required this.obscure,
    required this.loading,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _DarkField(
            label: 'Email / No. HP',
            hint: 'contoh@email.com',
            icon: Icons.person_outline_rounded,
            type: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _DarkField(
            label: 'Kata Sandi',
            hint: 'Masukkan kata sandi',
            icon: Icons.lock_outline_rounded,
            obscure: obscure,
            suffix: GestureDetector(
              onTap: onToggleObscure,
              child: Icon(
                obscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: C.textMuted,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Lupa kata sandi?',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: C.pink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 22),
          _SubmitBtn(label: 'Masuk', loading: loading, onTap: onSubmit),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final bool obscure, loading;
  final VoidCallback onToggleObscure, onSubmit;
  const _RegisterForm({
    super.key,
    required this.obscure,
    required this.loading,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _DarkField(
            label: 'Nama Lengkap',
            hint: 'Nama kamu',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 14),
          _DarkField(
            label: 'Email',
            hint: 'contoh@email.com',
            icon: Icons.email_outlined,
            type: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _DarkField(
            label: 'No. WhatsApp',
            hint: '+62 8xx-xxxx-xxxx',
            icon: Icons.phone_outlined,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          _DarkField(
            label: 'Kata Sandi',
            hint: 'Min. 8 karakter',
            icon: Icons.lock_outline_rounded,
            obscure: obscure,
            suffix: GestureDetector(
              onTap: onToggleObscure,
              child: Icon(
                obscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: C.textMuted,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Password strength bar
          _PasswordStrengthBar(),
          const SizedBox(height: 22),
          _SubmitBtn(label: 'Buat Akun', loading: loading, onTap: onSubmit),
        ],
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StrBar(color: C.danger)),
        const SizedBox(width: 4),
        Expanded(child: _StrBar(color: C.warning)),
        const SizedBox(width: 4),
        Expanded(child: _StrBar(color: C.surface3)),
        const SizedBox(width: 10),
        Text('Sedang', style: TS.r(11, c: C.warning)),
      ],
    );
  }
}

class _StrBar extends StatelessWidget {
  final Color color;
  const _StrBar({required this.color});
  @override
  Widget build(BuildContext context) => Container(
    height: 4,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

class _DarkField extends StatelessWidget {
  final String label, hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType type;
  const _DarkField({
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TS.r(12)),
        const SizedBox(height: 7),
        Container(
          decoration: BoxDecoration(
            color: C.surface2,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: C.border),
          ),
          child: TextField(
            obscureText: obscure,
            keyboardType: type,
            style: GoogleFonts.inter(color: C.textPri, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: C.textMuted, fontSize: 14),
              prefixIcon: Icon(icon, color: C.textMuted, size: 18),
              suffixIcon: suffix != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: suffix,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitBtn extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;
  const _SubmitBtn({
    required this.label,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [C.pinkLight, C.pinkDark],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: C.pinkGlow,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: C.surface2,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: C.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: C.textSec, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TS.b(13, c: C.textSec)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/panic_screen.dart';
import 'screens/report_screen.dart';

class C {
  static const bg = Color(0xFF0D0D14);
  static const surface = Color(0xFF14141E);
  static const surface2 = Color(0xFF1A1A28);
  static const surface3 = Color(0xFF222236);

  static const pink = Color(0xFFE91E8C);
  static const pinkLight = Color(0xFFFF4DB8);
  static const pinkDark = Color(0xFFB0156A);
  static const pinkGlow = Color(0x55E91E8C);
  static const pinkSoft = Color(0x1AE91E8C);

  static const danger = Color(0xFFE91E8C);
  static const safe = Color(0xFF00E676);
  static const warning = Color(0xFFFFAB00);
  static const info = Color(0xFF448AFF);

  static const textPri = Color(0xFFF2F2FF);
  static const textSec = Color(0xFFAAAAAF);
  static const textMuted = Color(0xFF555570);
  static const border = Color(0xFF252540);
}

class TS {
  static TextStyle h(double sz, {Color? c, double? ls}) => GoogleFonts.inter(
    fontSize: sz,
    fontWeight: FontWeight.w700,
    color: c ?? C.textPri,
    letterSpacing: ls,
  );
  static TextStyle b(double sz, {Color? c}) => GoogleFonts.inter(
    fontSize: sz,
    fontWeight: FontWeight.w600,
    color: c ?? C.textPri,
  );
  static TextStyle r(double sz, {Color? c, double? h}) => GoogleFonts.inter(
    fontSize: sz,
    fontWeight: FontWeight.w400,
    color: c ?? C.textSec,
    height: h,
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SafeHerApp());
}

class SafeHerApp extends StatelessWidget {
  const SafeHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHer ID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: C.bg,
        colorScheme: const ColorScheme.dark(primary: C.pink),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  int idx = 0;

  void goTo(int i) => setState(() => idx = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: IndexedStack(
        index: idx,
        children: const [
          HomeScreen(),
          MapScreen(),
          PanicScreen(),
          ReportScreen(),
        ],
      ),
      bottomNavigationBar: _BottomBar(idx: idx, onTap: goTo),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int idx;
  final ValueChanged<int> onTap;
  const _BottomBar({required this.idx, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: C.surface,
        border: Border(top: BorderSide(color: C.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                i: 0,
                idx: idx,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.map_rounded,
                label: 'Peta',
                i: 1,
                idx: idx,
                onTap: onTap,
              ),
              _SosItem(active: idx == 2, onTap: () => onTap(2)),
              _NavItem(
                icon: Icons.assignment_rounded,
                label: 'Laporan',
                i: 3,
                idx: idx,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                i: 4,
                idx: idx,
                onTap: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int i, idx;
  final ValueChanged<int> onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.i,
    required this.idx,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final on = i == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(i),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: on ? C.pink : C.textMuted),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                color: on ? C.pink : C.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SosItem extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _SosItem({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [C.pinkLight, C.pinkDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: C.pinkGlow,
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                'SOS',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final Color? borderColor;
  final double radius;
  const DCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? C.surface2,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? C.border),
      ),
      child: child,
    );
  }
}

class PinkBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool sm;
  final IconData? icon;
  const PinkBtn({
    super.key,
    required this.label,
    this.onTap,
    this.sm = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: sm ? 38 : 50,
        decoration: BoxDecoration(
          gradient: onTap != null
              ? const LinearGradient(
                  colors: [C.pinkLight, C.pinkDark],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: onTap == null ? C.surface3 : null,
          borderRadius: BorderRadius.circular(sm ? 10 : 13),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: C.pinkGlow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: sm ? 14 : 18),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: sm ? 12 : 14,
                  fontWeight: FontWeight.w700,
                  color: onTap != null ? Colors.white : C.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

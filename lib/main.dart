import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/panic_button_screen.dart';
import 'screens/report_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const SafeHerApp());
}

class C {
  static const bg       = Color(0xFFF7F5FF); 
  static const primary  = Color(0xFF6C3CE1);
  static const soft     = Color(0xFFEDE8FF);
  static const rose     = Color(0xFFFF4D7D); 
  static const roseSoft = Color(0xFFFFE8EF);
  static const teal     = Color(0xFF00BFA5); 
  static const tealSoft = Color(0xFFE0F7F4);
  static const amber    = Color(0xFFFF9800); 
  static const white    = Color(0xFFFFFFFF);
  static const card     = Color(0xFFFFFFFF);
  static const border   = Color(0xFFE8E0FF);
  static const textDark = Color(0xFF1A1033);
  static const textGrey = Color(0xFF7B6F8E);
}

class SafeHerApp extends StatelessWidget {
  const SafeHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: C.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: C.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: C.white,
          foregroundColor: C.textDark,
          elevation: 0,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: C.textDark,
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _idx = 0;

  final _screens = const [
    HomeScreen(),
    MapScreen(),
    PanicScreen(),
    ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: _BottomNav(
        current: _idx,
        onTap: (i) => setState(() => _idx = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: C.white,
        border: Border(top: BorderSide(color: C.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              _Item(icon: Icons.home_rounded,     label: 'Home',   idx: 0, current: current, onTap: onTap),
              _Item(icon: Icons.map_rounded,       label: 'Peta',   idx: 1, current: current, onTap: onTap),
              _SOSItem(active: current == 2, onTap: () => onTap(2)),
              _Item(icon: Icons.edit_note_rounded, label: 'Laporan',idx: 3, current: current, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final int idx, current;
  final ValueChanged<int> onTap;
  const _Item({required this.icon, required this.label,
    required this.idx, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final on = idx == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(idx),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24,
              color: on ? C.primary : C.textGrey),
            const SizedBox(height: 3),
            Text(label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                color: on ? C.primary : C.textGrey,
              )),
          ],
        ),
      ),
    );
  }
}

class _SOSItem extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _SOSItem({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.rose,
                boxShadow: active ? [
                  BoxShadow(color: C.rose.withOpacity(0.4),
                    blurRadius: 12, spreadRadius: 2)
                ] : [],
              ),
              child: Center(
                child: Text('SOS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
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
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const SafeHerApp());
}

class C {
  // BACKGROUND
  static const bg = Color(0xFF0E0E12);

  // CARD
  static const card = Color(0xFF1A1A22);

  // PRIMARY COLORS
  static const primary = Color(0xFFFF2D8F);
  static const secondary = Color(0xFF9B4DFF);

  // SOS
  static const rose = Color(0xFFFF2D8F);

  // TEXT
  static const white = Color(0xFFFFFFFF);
  static const textGrey = Color(0xFF9E9EAA);

  // BORDER
  static const border = Color(0xFF2A2A35);
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: C.bg,

        colorScheme: const ColorScheme.dark(
          primary: C.primary,
        ),

        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: C.bg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: C.white,
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
      body: IndexedStack(
        index: _idx,
        children: _screens,
      ),
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

  const _BottomNav({
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: C.bg,
        border: Border(
          top: BorderSide(color: C.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              _Item(
                icon: Icons.home_rounded,
                label: 'Home',
                idx: 0,
                current: current,
                onTap: onTap,
              ),
              _Item(
                icon: Icons.map_rounded,
                label: 'Peta',
                idx: 1,
                current: current,
                onTap: onTap,
              ),
              _SOSItem(
                active: current == 2,
                onTap: () => onTap(2),
              ),
              _Item(
                icon: Icons.edit_note_rounded,
                label: 'Laporan',
                idx: 3,
                current: current,
                onTap: onTap,
              ),
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
  final int idx;
  final int current;
  final ValueChanged<int> onTap;

  const _Item({
    required this.icon,
    required this.label,
    required this.idx,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = idx == current;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(idx),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: active ? C.primary : C.textGrey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? C.primary : C.textGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SOSItem extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _SOSItem({
    required this.active,
    required this.onTap,
  });

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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF2D8F),
                    Color(0xFF9B4DFF),
                  ],
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: C.primary.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: const Center(
                child: Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
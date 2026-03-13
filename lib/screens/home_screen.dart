import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              _header(),
              const SizedBox(height: 20),

              _metricRow(),
              const SizedBox(height: 20),

              _safetyTip(),
              const SizedBox(height: 24),

              _label('Fitur Utama'),
              const SizedBox(height: 14),
              _serviceGrid(),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label('Laporan Terbaru'),
                  Text(
                    'Semua',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: C.pink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _incidentList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, Kirana', style: TS.h(20)),
              const SizedBox(height: 2),
              Text('Tetap jaga keamananmu ya!', style: TS.r(13)),
            ],
          ),
        ),
        _TopBtn(icon: Icons.search_rounded),
        const SizedBox(width: 8),
        _TopBtn(icon: Icons.notifications_outlined),
        const SizedBox(width: 8),
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [C.pink, Color(0xFF9C27B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              'K',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricRow() {
    return Row(
      children: [
        Expanded(
          child: DCard(
            padding: const EdgeInsets.all(16),
            borderColor: C.safe.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: C.safe.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: C.safe,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: C.safe.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'LIVE',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: C.safe,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Relatif Aman', style: TS.h(15, c: C.safe)),
                const SizedBox(height: 3),
                Text('Status area\nlokasimu saat ini', style: TS.r(10, h: 1.4)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DCard(
            padding: const EdgeInsets.all(16),
            borderColor: C.pink.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: C.pinkSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: C.pink,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Text('', style: TS.h(18)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('7', style: TS.h(26, c: C.pink)),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text('hari', style: TS.r(11, c: C.pink)),
                    ),
                  ],
                ),
                Text('Streak amanmu!', style: TS.r(10)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String t) => Text(t, style: TS.b(14, c: C.textSec));

  Widget _safetyTip() {
    return DCard(
      padding: const EdgeInsets.all(14),
      borderColor: C.warning.withOpacity(0.25),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: C.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: C.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Hari Ini',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: C.warning,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Hindari jalan sepi setelah pukul 21.00.Selalu pilih rute yang ramai.',
                  style: TS.r(11, h: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceGrid() {
    final services = [
      _Svc(Icons.map_rounded, 'Peta Aman', 'Lihat area rawan', C.info, 1),
      _Svc(Icons.sos_rounded, 'Panic Button', 'Kirim sinyal SOS', C.pink, 2),
      _Svc(
        Icons.assignment_rounded,
        'Laporan',
        'Laporkan kejadian',
        C.warning,
        3,
      ),
      _Svc(
        Icons.lightbulb_rounded,
        'Tips Aman',
        'Cara lindungi diri',
        C.safe,
        0,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: services.length,
      itemBuilder: (ctx, i) => _ServiceTile(svc: services[i]),
    );
  }

  Widget _incidentList() {
    final list = [
      _Inc(
        'Pelecehan Verbal',
        'Jl. Sudirman · 2.3 km',
        '2j lalu',
        C.danger,
        'Tinggi',
      ),
      _Inc(
        'Pencurian Tas',
        'Stasiun Gambir · 4 km',
        '5j lalu',
        C.warning,
        'Sedang',
      ),
      _Inc(
        'Area Rawan Malam',
        'Tanah Abang · 5.5 km',
        '1h lalu',
        C.danger,
        'Tinggi',
      ),
    ];
    return Column(children: list.map((e) => _IncTile(inc: e)).toList());
  }
}

class _Svc {
  final IconData icon;
  final String label, sub;
  final Color color;
  final int nav;
  const _Svc(this.icon, this.label, this.sub, this.color, this.nav);
}

class _Inc {
  final String title, loc, time, level;
  final Color color;
  const _Inc(this.title, this.loc, this.time, this.color, this.level);
}

class _TopBtn extends StatelessWidget {
  final IconData icon;
  const _TopBtn({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: C.surface2,
        shape: BoxShape.circle,
        border: Border.all(color: C.border),
      ),
      child: Icon(icon, color: C.textSec, size: 17),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final _Svc svc;
  const _ServiceTile({super.key, required this.svc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (svc.nav > 0) {
          context.findAncestorStateOfType<AppShellState>()?.goTo(svc.nav);
        }
      },
      child: DCard(
        padding: const EdgeInsets.all(14),
        borderColor: svc.color.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: svc.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: svc.color.withOpacity(0.2)),
              ),
              child: Icon(svc.icon, color: svc.color, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(svc.label, style: TS.b(13)),
                Text(svc.sub, style: TS.r(10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IncTile extends StatelessWidget {
  final _Inc inc;
  const _IncTile({super.key, required this.inc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 42,
            decoration: BoxDecoration(
              color: inc.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(inc.title, style: TS.b(13)),
                const SizedBox(height: 3),
                Text(inc.loc, style: TS.r(11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(label: inc.level, color: inc.color),
              const SizedBox(height: 5),
              Text(inc.time, style: TS.r(10)),
            ],
          ),
        ],
      ),
    );
  }
}

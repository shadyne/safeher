import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart' show C;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              _buildHeader(),
              const SizedBox(height: 20),
              _buildStatusCard(),
              const SizedBox(height: 28),
              Text('Fitur Utama',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: C.textDark)),
              const SizedBox(height: 14),

              _buildFeatureGrid(sw),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Laporan Terbaru',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: C.textDark)),
                  Text('Lihat semua',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, color: C.primary,
                      fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              _buildIncidentList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hai, Kirana 👋',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: C.textDark)),
              const SizedBox(height: 2),
              Text('Tetap aman ya hari ini',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13, color: C.textGrey)),
            ],
          ),
        ),
        Container(
          width: 44, height: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [C.primary, Color(0xFFAB82FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text('K',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18, fontWeight: FontWeight.w800,
                color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C3CE1), Color(0xFF9B6DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_rounded, color: Colors.white, size: 38),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Area',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: Colors.white70,
                    fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text('Relatif Aman',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20, fontWeight: FontWeight.w800,
                    color: Colors.white)),
                const SizedBox(height: 2),
                Text('Lokasi kamu saat ini aman',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(double sw) {
    final items = [
      _Feat(Icons.map_rounded,          'Peta Aman',    'Lihat area rawan',  C.primary,  C.soft,    1),
      _Feat(Icons.sos_rounded,          'Panic Button', 'Kirim sinyal SOS',  C.rose,     C.roseSoft, 2),
      _Feat(Icons.edit_note_rounded,    'Laporan',      'Laporkan kejadian', C.amber,    Color(0xFFFFF3E0), 3),
      _Feat(Icons.lightbulb_rounded,    'Tips Aman',    'Cara lindungi diri',C.teal,    C.tealSoft, -1),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: items.map((f) => _FeatureCard(feat: f)).toList(),
    );
  }

  Widget _buildIncidentList() {
    final list = [
      _Inc('Pelecehan Verbal',  'Jl. Sudirman · 2.3 km', '2j lalu',  C.rose,  'Tinggi'),
      _Inc('Pencurian Tas',     'Stasiun Gambir · 4 km',  '5j lalu',  C.amber, 'Sedang'),
      _Inc('Pelecehan Fisik',   'Tanah Abang · 5.5 km',   '1h lalu',  C.rose,  'Tinggi'),
    ];
    return Column(
      children: list.map((i) => _IncidentTile(inc: i)).toList(),
    );
  }
}

class _Feat {
  final IconData icon;
  final String label, sub;
  final Color color, bg;
  final int navIdx;
  const _Feat(this.icon, this.label, this.sub, this.color, this.bg, this.navIdx);
}

class _Inc {
  final String title, loc, time, level;
  final Color color;
  const _Inc(this.title, this.loc, this.time, this.color, this.level);
}

class _FeatureCard extends StatelessWidget {
  final _Feat feat;
  const _FeatureCard({super.key, required this.feat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (feat.navIdx >= 0) {
          final shell = context.findAncestorStateOfType<State>();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Membuka ${feat.label}...'),
              duration: const Duration(seconds: 1),
              backgroundColor: feat.color,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.border),
          boxShadow: [
            BoxShadow(color: feat.color.withOpacity(0.06),
              blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: feat.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(feat.icon, color: feat.color, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feat.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: C.textDark)),
                Text(feat.sub,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, color: C.textGrey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IncidentTile extends StatelessWidget {
  final _Inc inc;
  const _IncidentTile({super.key, required this.inc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 4, height: 44,
            decoration: BoxDecoration(
              color: inc.color,
              borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(inc.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: C.textDark)),
                const SizedBox(height: 3),
                Text(inc.loc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: C.textGrey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: inc.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(inc.level,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: inc.color)),
              ),
              const SizedBox(height: 4),
              Text(inc.time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10, color: C.textGrey)),
            ],
          ),
        ],
      ),
    );
  }
}
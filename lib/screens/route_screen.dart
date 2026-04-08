import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});
  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  int _selected = -1;

  static const _routes = [
    _RouteData(
      label: 'Rute A',
      tag: 'Lebih Cepat',
      tagColor: Color(0xFF448AFF),
      duration: '12 menit',
      distance: '2.1 km',
      riskLevel: 68,
      riskLabel: 'Risiko Tinggi',
      riskColor: Color(0xFFE91E8C),
      via: 'via Jl. Sudirman → Jl. Thamrin',
      incidents: [
        '3 laporan pelecehan minggu ini',
        'Jalur sepi malam hari',
        'Minim penerangan',
      ],
      pros: ['Lebih cepat 8 menit', 'Jalan utama'],
      cons: ['Rawan pelecehan', 'Sepi di malam hari'],
    ),
    _RouteData(
      label: 'Rute B',
      tag: 'Lebih Aman',
      tagColor: Color(0xFF00E676),
      duration: '20 menit',
      distance: '3.4 km',
      riskLevel: 35,
      riskLabel: 'Risiko Rendah',
      riskColor: Color(0xFF00E676),
      via: 'via Jl. Gatot Subroto → Jl. HR Rasuna Said',
      incidents: ['Jalur ramai 24 jam', 'CCTV terpasang', 'Banyak warung buka'],
      pros: ['Lebih aman (risiko 35%)', 'Ramai & terang', 'Ada CCTV'],
      cons: ['8 menit lebih lama', 'Jarak lebih jauh'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Column(
        children: [
          _topBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
              children: [
                _originDestCard(),
                const SizedBox(height: 16),
                _summaryBanner(),
                const SizedBox(height: 20),
                Text('Pilih Rute', style: TS.b(14, c: C.textSec)),
                const SizedBox(height: 12),
                ..._routes.asMap().entries.map(
                  (e) => _RouteCard(
                    route: e.value,
                    selected: _selected == e.key,
                    onTap: () => setState(() => _selected = e.key),
                  ),
                ),
                if (_selected >= 0) ...[
                  const SizedBox(height: 20),
                  _detailPanel(_routes[_selected]),
                  const SizedBox(height: 16),
                  PinkBtn(
                    label: 'Mulai Navigasi',
                    icon: Icons.navigation_rounded,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                          backgroundColor: C.surface2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: C.pink.withOpacity(0.4)),
                          ),
                          content: Row(
                            children: [
                              const Icon(
                                Icons.navigation_rounded,
                                color: C.pink,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Navigasi via ${_routes[_selected].label} dimulai!',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: C.textPri,
                                ),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Container(
      color: C.surface,
      padding: const EdgeInsets.fromLTRB(18, 52, 18, 14),
      child: Row(
        children: [
          const Icon(Icons.alt_route_rounded, color: C.pink, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text('Perbandingan Rute', style: TS.h(20))),
        ],
      ),
    );
  }

  Widget _originDestCard() {
    return DCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _LocRow(
            icon: Icons.my_location_rounded,
            color: C.safe,
            label: 'Dari',
            value: 'Lokasi saat ini',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: List.generate(
                3,
                (i) => Container(
                  width: 2,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  color: C.border,
                ),
              ),
            ),
          ),
          _LocRow(
            icon: Icons.location_on_rounded,
            color: C.pink,
            label: 'Ke',
            value: 'Stasiun MRT Dukuh Atas',
          ),
        ],
      ),
    );
  }

  Widget _summaryBanner() {
    return DCard(
      padding: const EdgeInsets.all(14),
      borderColor: C.warning.withOpacity(0.3),
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
              Icons.compare_arrows_rounded,
              color: C.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Rute A lebih cepat 8 menit, Rute B lebih aman (risiko 35% vs 68%)',
              style: TS.r(12, h: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailPanel(_RouteData r) {
    return DCard(
      borderColor: r.riskColor.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Detail ${r.label}', style: TS.b(13)),
              const Spacer(),
              StatusBadge(label: r.riskLabel, color: r.riskColor),
            ],
          ),
          const SizedBox(height: 14),
          // Risk bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tingkat Risiko', style: TS.r(11)),
                  Text(
                    '${r.riskLevel}%',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: r.riskColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: r.riskLevel / 100,
                  minHeight: 8,
                  backgroundColor: C.surface3,
                  valueColor: AlwaysStoppedAnimation(r.riskColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DetailRow('Kondisi Jalur', r.incidents),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _ProCon('Keunggulan', r.pros, C.safe)),
              const SizedBox(width: 10),
              Expanded(child: _ProCon('Kekurangan', r.cons, C.danger)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value;
  const _LocRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TS.r(10)),
            Text(value, style: TS.b(13)),
          ],
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  final _RouteData route;
  final bool selected;
  final VoidCallback onTap;
  const _RouteCard({
    required this.route,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? route.tagColor.withOpacity(0.07) : C.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? route.tagColor.withOpacity(0.5) : C.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: route.tagColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                route.label == 'Rute A'
                    ? Icons.bolt_rounded
                    : Icons.shield_rounded,
                color: route.tagColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(route.label, style: TS.b(14)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: route.tagColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: route.tagColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          route.tag,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: route.tagColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    route.via,
                    style: TS.r(10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Stat(Icons.access_time_rounded, route.duration),
                      const SizedBox(width: 12),
                      _Stat(Icons.straighten_rounded, route.distance),
                      const SizedBox(width: 12),
                      _Stat(
                        Icons.warning_rounded,
                        '${route.riskLevel}% risiko',
                        color: route.riskColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? route.tagColor : C.surface3,
                border: Border.all(color: selected ? route.tagColor : C.border),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _Stat(this.icon, this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 11, color: color ?? C.textMuted),
        const SizedBox(width: 3),
        Text(label, style: TS.r(10, c: color ?? C.textSec)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final List<String> items;
  const _DetailRow(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TS.r(11, c: C.textMuted)),
        const SizedBox(height: 6),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 5, color: C.textMuted),
                const SizedBox(width: 8),
                Expanded(child: Text(item, style: TS.r(11))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProCon extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;
  const _ProCon(this.title, this.items, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TS.b(11, c: color)),
          const SizedBox(height: 6),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(
                      color == C.safe
                          ? Icons.add_rounded
                          : Icons.remove_rounded,
                      size: 12,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(child: Text(item, style: TS.r(10))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteData {
  final String label, tag, duration, distance, riskLabel, via;
  final Color tagColor, riskColor;
  final int riskLevel;
  final List<String> incidents, pros, cons;
  const _RouteData({
    required this.label,
    required this.tag,
    required this.tagColor,
    required this.duration,
    required this.distance,
    required this.riskLevel,
    required this.riskLabel,
    required this.riskColor,
    required this.via,
    required this.incidents,
    required this.pros,
    required this.cons,
  });
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _ctrl = MapController();
  static const _jakarta = LatLng(-6.2088, 106.8456);

  LatLng? _userPos;
  bool _loading = true;
  String _filter = 'Semua';
  int? _selected;

  final _filters = ['Semua', 'Pelecehan', 'Pencurian', 'Kekerasan'];

  final _zones = const [
    _Zone(
      'Kawasan Blok M',
      LatLng(-6.2441, 106.7987),
      ZLv.high,
      'Pelecehan',
      23,
    ),
    _Zone(
      'Pasar Tanah Abang',
      LatLng(-6.1862, 106.8148),
      ZLv.high,
      'Pencurian',
      18,
    ),
    _Zone(
      'Jl. Sudirman',
      LatLng(-6.2109, 106.8218),
      ZLv.medium,
      'Pelecehan',
      9,
    ),
    _Zone(
      'Halte TransJakarta',
      LatLng(-6.1751, 106.8272),
      ZLv.medium,
      'Pencurian',
      11,
    ),
    _Zone(
      'Kawasan Menteng',
      LatLng(-6.1944, 106.8340),
      ZLv.low,
      'Kekerasan',
      3,
    ),
  ];

  List<_Zone> get _shown => _filter == 'Semua'
      ? _zones
      : _zones.where((z) => z.type == _filter).toList();

  @override
  void initState() {
    super.initState();
    _initLoc();
  }

  Future<void> _initLoc() async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.whileInUse ||
          perm == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final ll = LatLng(pos.latitude, pos.longitude);
        if (mounted) {
          setState(() => _userPos = ll);
          _ctrl.move(ll, 14);
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Column(
        children: [
          _topBar(),
          _filterBar(),
          Expanded(child: _map()),
          _panel(),
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
          Icon(Icons.map_rounded, color: C.pink, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text('Peta Aman', style: TS.h(20))),
          GestureDetector(
            onTap: () {
              if (_userPos != null) _ctrl.move(_userPos!, 15);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: C.pinkSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: C.pink.withOpacity(0.3)),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: C.pink,
                      ),
                    )
                  : const Icon(
                      Icons.my_location_rounded,
                      color: C.pink,
                      size: 18,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBar() {
    return Container(
      height: 46,
      color: C.surface,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (_, i) {
          final on = _filters[i] == _filter;
          return GestureDetector(
            onTap: () => setState(() {
              _filter = _filters[i];
              _selected = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: on ? C.pink : C.surface3,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: on ? C.pink : C.border),
              ),
              child: Text(
                _filters[i],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                  color: on ? Colors.white : C.textSec,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _map() {
    final zones = _shown;
    return FlutterMap(
      mapController: _ctrl,
      options: MapOptions(
        initialCenter: _jakarta,
        initialZoom: 13.0,
        minZoom: 9,
        maxZoom: 18,
        onTap: (_, _) => setState(() => _selected = null),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'id.safeher.app',
          maxZoom: 19,
        ),

        CircleLayer(
          circles: zones
              .map(
                (z) => CircleMarker(
                  point: z.pos,
                  radius: z.lv == ZLv.high
                      ? 450
                      : z.lv == ZLv.medium
                      ? 300
                      : 200,
                  useRadiusInMeter: true,
                  color: z.color.withOpacity(0.15),
                  borderColor: z.color.withOpacity(0.6),
                  borderStrokeWidth: 2.0,
                ),
              )
              .toList(),
        ),

        MarkerLayer(
          markers: zones.asMap().entries.map((entry) {
            final i = entry.key;
            final z = entry.value;
            final sel = _selected == i;
            return Marker(
              point: z.pos,
              width: sel ? 42 : 34,
              height: sel ? 42 : 34,
              child: GestureDetector(
                onTap: () => setState(() {
                  _selected = _selected == i ? null : i;
                  _ctrl.move(z.pos, 15);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: z.color,
                    border: Border.all(
                      color: sel ? Colors.white : z.color.withOpacity(0.4),
                      width: sel ? 3 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: z.color.withOpacity(sel ? 0.6 : 0.35),
                        blurRadius: sel ? 14 : 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    z.lv == ZLv.high
                        ? Icons.warning_rounded
                        : z.lv == ZLv.medium
                        ? Icons.info_rounded
                        : Icons.check_circle_rounded,
                    color: Colors.white,
                    size: sel ? 22 : 17,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        if (_userPos != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _userPos!,
                width: 44,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: C.pink,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: C.pinkGlow,
                        blurRadius: 16,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_pin_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

        if (_selected != null && _selected! < zones.length)
          MarkerLayer(
            markers: [
              Marker(
                point: zones[_selected!].pos,
                width: 200,
                height: 72,
                alignment: Alignment.topCenter,
                child: _Popup(
                  zone: zones[_selected!],
                  onClose: () => setState(() => _selected = null),
                ),
              ),
            ],
          ),

        const _Legend(),
      ],
    );
  }

  Widget _panel() {
    final zones = _shown;
    return Container(
      color: C.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: C.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Row(
              children: [
                Text('Daerah Rawan', style: TS.b(13)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: C.pinkSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${zones.length} area',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: C.pink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 84,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              scrollDirection: Axis.horizontal,
              itemCount: zones.length,
              itemBuilder: (_, i) => _ZoneChip(
                zone: zones[i],
                onTap: () {
                  setState(() => _selected = i);
                  _ctrl.move(zones[i].pos, 15);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ZLv { high, medium, low }

class _Zone {
  final String name, type;
  final LatLng pos;
  final ZLv lv;
  final int count;
  const _Zone(this.name, this.pos, this.lv, this.type, this.count);

  Color get color {
    switch (lv) {
      case ZLv.high:
        return C.danger;
      case ZLv.medium:
        return C.warning;
      case ZLv.low:
        return C.safe;
    }
  }

  String get lvLabel {
    switch (lv) {
      case ZLv.high:
        return 'Tinggi';
      case ZLv.medium:
        return 'Sedang';
      case ZLv.low:
        return 'Rendah';
    }
  }
}

class _Legend extends StatelessWidget {
  const _Legend();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: C.surface.withOpacity(0.93),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LI(C.danger, 'Tinggi'),
              const SizedBox(height: 5),
              _LI(C.warning, 'Sedang'),
              const SizedBox(height: 5),
              _LI(C.safe, 'Rendah'),
              const SizedBox(height: 5),
              _LI(C.info, 'Kamu'),
            ],
          ),
        ),
      ),
    );
  }
}

class _LI extends StatelessWidget {
  final Color c;
  final String t;
  const _LI(this.c, this.t);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(shape: BoxShape.circle, color: c),
        ),
        const SizedBox(width: 5),
        Text(t, style: GoogleFonts.inter(fontSize: 10, color: C.textSec)),
      ],
    );
  }
}

class _Popup extends StatelessWidget {
  final _Zone zone;
  final VoidCallback onClose;
  const _Popup({required this.zone, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: zone.color.withOpacity(0.55)),
        boxShadow: [const BoxShadow(color: Colors.black45, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, color: zone.color, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  zone.name,
                  style: TS.b(11),
                  overflow: TextOverflow.ellipsis,
                ),
                Text('${zone.count} laporan · ${zone.type}', style: TS.r(9)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Icon(
              Icons.close_rounded,
              color: C.textMuted,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneChip extends StatelessWidget {
  final _Zone zone;
  final VoidCallback onTap;
  const _ZoneChip({required this.zone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 144,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: zone.color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: zone.color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusBadge(label: zone.lvLabel, color: zone.color),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.name,
                  style: TS.b(11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('${zone.count} laporan · ${zone.type}', style: TS.r(9)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

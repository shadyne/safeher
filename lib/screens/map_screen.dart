import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart' show C;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final MapController _mapCtrl = MapController();

  static const _jakarta = LatLng(-6.2088, 106.8456);

  List<Marker> _markers = [];
  List<CircleMarker> _circles = [];

  LatLng? _userLocation;

  bool _loadingLocation = true;
  String _activeFilter = 'Semua';

  final List<_Zone> _zones = const [
    _Zone('Kawasan Blok M', LatLng(-6.2441,106.7987), ZoneLevel.high,'Pelecehan'),
    _Zone('Pasar Tanah Abang',LatLng(-6.1862,106.8148), ZoneLevel.high,'Pencurian'),
    _Zone('Jl. Sudirman',LatLng(-6.2109,106.8218), ZoneLevel.medium,'Pelecehan'),
    _Zone('Halte TransJakarta',LatLng(-6.1751,106.8272), ZoneLevel.medium,'Pencurian'),
    _Zone('Kawasan Menteng',LatLng(-6.1944,106.8340), ZoneLevel.low,'Kekerasan'),
  ];

  final List<String> _filters = ['Semua','Pelecehan','Pencurian','Kekerasan'];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {

      LocationPermission perm = await Geolocator.checkPermission();

      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse) {

        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        _userLocation = LatLng(pos.latitude, pos.longitude);

        _mapCtrl.move(_userLocation!, 14);
      }

    } catch (_) {}

    setState(() {
      _loadingLocation = false;
    });

    _buildOverlays();
  }

  void _buildOverlays() {

    final markers = <Marker>[];
    final circles = <CircleMarker>[];

    final filtered = _activeFilter == 'Semua'
        ? _zones
        : _zones.where((z) => z.type == _activeFilter).toList();

    for (final z in filtered) {

      final color = z.level == ZoneLevel.high
          ? Colors.red
          : z.level == ZoneLevel.medium
              ? Colors.orange
              : Colors.green;

      markers.add(
        Marker(
          point: z.pos,
          width: 40,
          height: 40,
          child: Icon(
            Icons.location_on,
            size: 36,
            color: color,
          ),
        ),
      );

      circles.add(
        CircleMarker(
          point: z.pos,
          radius: z.level == ZoneLevel.high
              ? 40
              : z.level == ZoneLevel.medium
                  ? 30
                  : 20,
          color: color.withOpacity(0.15),
          borderStrokeWidth: 2,
          borderColor: color,
        ),
      );
    }

    if (_userLocation != null) {
      markers.add(
        Marker(
          point: _userLocation!,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 30,
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
      _circles = circles;
    });
  }

  void _goToMyLocation() {
    if (_userLocation != null) {
      _mapCtrl.move(_userLocation!, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Column(
        children: [
          _buildTopBar(),
          _buildFilters(),
          Expanded(child: _buildMap()),
          _buildZoneList(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: C.white,
      padding: const EdgeInsets.fromLTRB(20,52,20,14),
      child: Row(
        children: [

          Expanded(
            child: Text(
              'Peta Aman',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: C.textDark,
              ),
            ),
          ),

          if (_loadingLocation)
            const SizedBox(
              width:20,
              height:20,
              child: CircularProgressIndicator(
                strokeWidth:2,
                color:C.primary,
              ),
            )
          else
            GestureDetector(
              onTap: _goToMyLocation,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: C.soft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: C.primary,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height:46,
      color:C.white,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16,0,16,8),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (_,i){

          final on = _filters[i] == _activeFilter;

          return GestureDetector(
            onTap: (){
              setState(() => _activeFilter = _filters[i]);
              _buildOverlays();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds:180),
              margin: const EdgeInsets.only(right:8),
              padding: const EdgeInsets.symmetric(horizontal:16,vertical:6),
              decoration: BoxDecoration(
                color: on ? C.primary : C.soft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _filters[i],
                style: GoogleFonts.plusJakartaSans(
                  fontSize:12,
                  fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                  color: on ? Colors.white : C.textGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapCtrl,
      options: const MapOptions(
        initialCenter: _jakarta,
        initialZoom: 13.5,
      ),
      children: [

        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.app',
        ),

        CircleLayer(
          circles: _circles,
        ),

        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }

  Widget _buildZoneList() {

    final filtered = _activeFilter == 'Semua'
        ? _zones
        : _zones.where((z) => z.type == _activeFilter).toList();

    return Container(
      color:C.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            width:36,
            height:4,
            margin: const EdgeInsets.symmetric(vertical:10),
            decoration: BoxDecoration(
              color:C.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(
            height:90,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16,0,16,12),
              scrollDirection: Axis.horizontal,
              itemCount: filtered.length,
              itemBuilder: (_,i) {

                final zone = filtered[i];

                return _ZoneChip(
                  zone: zone,
                  onTap: (){
                    _mapCtrl.move(zone.pos, 15);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum ZoneLevel { high, medium, low }

extension ZoneLevelExt on ZoneLevel {

  String get label {
    switch (this) {
      case ZoneLevel.high: return 'Tinggi';
      case ZoneLevel.medium: return 'Sedang';
      case ZoneLevel.low: return 'Rendah';
    }
  }

  Color get color {
    switch (this) {
      case ZoneLevel.high: return Colors.red;
      case ZoneLevel.medium: return Colors.orange;
      case ZoneLevel.low: return Colors.green;
    }
  }
}

class _Zone {

  final String name;
  final String type;
  final LatLng pos;
  final ZoneLevel level;

  const _Zone(this.name,this.pos,this.level,this.type);
}

class _ZoneChip extends StatelessWidget {

  final _Zone zone;
  final VoidCallback onTap;

  const _ZoneChip({
    super.key,
    required this.zone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final c = zone.level.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:148,
        margin: const EdgeInsets.only(right:10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:c.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color:c.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal:8,vertical:3),
              decoration: BoxDecoration(
                color:c.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                zone.level.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize:10,
                  fontWeight: FontWeight.w700,
                  color:c,
                ),
              ),
            ),

            Text(
              zone.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize:12,
                fontWeight: FontWeight.w700,
                color:C.textDark,
              ),
              maxLines:2,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              zone.type,
              style: GoogleFonts.plusJakartaSans(
                fontSize:10,
                color:C.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
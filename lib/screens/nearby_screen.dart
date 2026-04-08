import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});
  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen>
    with SingleTickerProviderStateMixin {
  bool _searching = true;
  final Set<int> _requested = {};
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const _users = [
    _NearbyUser(
      name: 'Alya',
      distance: '120m',
      status: 'Sedang berjalan',
      rating: 4.9,
      trips: 23,
      avatar: 'A',
      color: Color(0xFFE91E8C),
      isOnline: true,
    ),
    _NearbyUser(
      name: 'Sinta',
      distance: '300m',
      status: 'Siap menemani',
      rating: 4.7,
      trips: 15,
      avatar: 'S',
      color: Color(0xFF9C27B0),
      isOnline: true,
    ),
    _NearbyUser(
      name: 'Rara',
      distance: '450m',
      status: 'Sedang berjalan',
      rating: 4.8,
      trips: 31,
      avatar: 'R',
      color: Color(0xFF448AFF),
      isOnline: true,
    ),
    _NearbyUser(
      name: 'Dina',
      distance: '780m',
      status: 'Siap menemani',
      rating: 5.0,
      trips: 8,
      avatar: 'D',
      color: Color(0xFF00E676),
      isOnline: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _searching = false);
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _request(BuildContext context, int idx) {
    HapticFeedback.mediumImpact();
    setState(() => _requested.add(idx));
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
            const Icon(Icons.check_circle_rounded, color: C.safe, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Permintaan ke ${_users[idx].name} berhasil dikirim (prototype)',
                style: GoogleFonts.inter(fontSize: 13, color: C.textPri),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Column(
        children: [
          _topBar(),
          Expanded(child: _searching ? _loadingState() : _mainContent(context)),
        ],
      ),
    );
  }

  Widget _topBar() {
    return AppTopBar(
      title: 'Mode Temenin Jalan',
      showBack: true,
      actions: [
        if (!_searching)
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Opacity(
              opacity: _pulseAnim.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: C.safe.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.safe.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.safe,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: C.safe,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _loadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: C.pink.withOpacity(0.3), width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: C.pinkSoft,
                      border: Border.all(
                        color: C.pink.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.radar_rounded,
                      color: C.pink,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Mencari pengguna di sekitarmu...', style: TS.b(15)),
          const SizedBox(height: 8),
          Text('Radius pencarian: 1km', style: TS.r(13)),
        ],
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
      children: [
        _infoCard(),
        const SizedBox(height: 20),
        Row(
          children: [
            Text('Pengguna Terdekat', style: TS.b(14, c: C.textSec)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: C.pinkSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_users.length} orang',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: C.pink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._users.asMap().entries.map(
          (e) => _UserCard(
            user: e.value,
            requested: _requested.contains(e.key),
            onRequest: () => _request(context, e.key),
          ),
        ),
      ],
    );
  }

  Widget _infoCard() {
    return DCard(
      padding: const EdgeInsets.all(14),
      borderColor: C.pink.withOpacity(0.25),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: C.pinkSoft,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.shield_rounded, color: C.pink, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Apa itu Temenin Jalan?', style: TS.b(12)),
                const SizedBox(height: 3),
                Text(
                  'Temukan pengguna SafeHer terdekat untuk menemanimu berjalan agar lebih aman.',
                  style: TS.r(11, h: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final _NearbyUser user;
  final bool requested;
  final VoidCallback onRequest;
  const _UserCard({
    required this.user,
    required this.requested,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: requested ? C.pink.withOpacity(0.3) : C.border,
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [user.color, user.color.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    user.avatar,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (user.isOnline)
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: C.safe,
                      shape: BoxShape.circle,
                      border: Border.all(color: C.surface2, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user.name, style: TS.b(14)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: C.surface3,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user.distance,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: C.textSec,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(user.status, style: TS.r(11)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFAB00),
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${user.rating}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: C.textPri,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('${user.trips}x perjalanan', style: TS.r(10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: requested ? null : onRequest,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: requested ? C.safe.withOpacity(0.12) : C.pinkSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: requested
                      ? C.safe.withOpacity(0.3)
                      : C.pink.withOpacity(0.3),
                ),
              ),
              child: requested
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: C.safe,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Terkirim',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: C.safe,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_add_rounded,
                          color: C.pink,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Temenin',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: C.pink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyUser {
  final String name, distance, status, avatar;
  final double rating;
  final int trips;
  final Color color;
  final bool isOnline;
  const _NearbyUser({
    required this.name,
    required this.distance,
    required this.status,
    required this.rating,
    required this.trips,
    required this.avatar,
    required this.color,
    required this.isOnline,
  });
}

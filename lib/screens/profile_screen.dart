import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Set<int> _invited = {};

  static const _nearbyUsers = [
    _NUser('Alya', 'A', '120m', 4.9, 23, Color(0xFFE91E8C), true),
    _NUser('Sinta', 'S', '300m', 4.7, 15, Color(0xFF9C27B0), true),
    _NUser('Rara', 'R', '450m', 4.8, 31, Color(0xFF448AFF), true),
    _NUser('Dewi', 'D', '680m', 5.0, 8, Color(0xFF00E676), false),
    _NUser('Putri', 'P', '920m', 4.6, 12, Color(0xFFFFAB00), true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: ListView(
        children: [
          AppTopBar(title: 'Profil Saya'),
          _profileHeader(),
          _statRow(),
          const SizedBox(height: 8),
          _sectionLabel('Ajak Jalan Bareng', Icons.people_rounded, C.pink),
          _nearbyBanner(),
          ..._nearbyUsers.asMap().entries.map(
            (e) => _NearbyCard(
              user: e.value,
              invited: _invited.contains(e.key),
              onInvite: () => _invite(context, e.key),
            ),
          ),
          const SizedBox(height: 20),
          _sectionLabel('Menu Akun', Icons.manage_accounts_rounded, C.textSec),
          _menuItem(Icons.shield_rounded, 'Keamanan Akun', C.safe),
          _menuItem(Icons.notifications_rounded, 'Notifikasi', C.info),
          _menuItem(Icons.lock_rounded, 'Privasi & Data', C.warning),
          _menuItem(Icons.help_rounded, 'Bantuan', C.textSec),
          _menuItem(Icons.info_rounded, 'Tentang SafeHer', C.textSec),
          const SizedBox(height: 12),
          _logoutBtn(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _invite(BuildContext context, int idx) {
    HapticFeedback.mediumImpact();
    setState(() => _invited.add(idx));
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
                'Permintaan ke ${_nearbyUsers[idx].name} berhasil dikirim! (prototype)',
                style: GoogleFonts.inter(fontSize: 13, color: C.textPri),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      color: C.surface,
      padding: const EdgeInsets.fromLTRB(18, 56, 18, 24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
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
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text('Kirana Putri', style: TS.h(20)),
          const SizedBox(height: 4),
          Text('kirana.putri@email.com', style: TS.r(13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: C.safe.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.safe.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, color: C.safe, size: 14),
                const SizedBox(width: 5),
                Text(
                  'Akun Terverifikasi',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: C.safe,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow() {
    return Container(
      color: C.surface,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Row(
        children: [
          _StatBox('7', 'Streak\nAman', C.pink),
          _vDivider(),
          _StatBox('3', 'Laporan\nDikirim', C.info),
          _vDivider(),
          _StatBox('12', 'Jalan\nBersama', C.safe),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
    width: 1,
    height: 36,
    color: C.border,
    margin: const EdgeInsets.symmetric(horizontal: 12),
  );

  Widget _sectionLabel(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(title, style: TS.b(13, c: C.textSec)),
        ],
      ),
    );
  }

  Widget _nearbyBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: C.pinkSoft,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: C.pink.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.radar_rounded, color: C.pink, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${_nearbyUsers.length} pengguna SafeHer terdeteksi dalam radius 1km',
              style: TS.r(12, h: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.surface2,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: C.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TS.b(13))),
            const Icon(
              Icons.chevron_right_rounded,
              color: C.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: C.danger.withOpacity(0.07),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: C.danger.withOpacity(0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded, color: C.danger, size: 18),
              const SizedBox(width: 8),
              Text('Keluar', style: TS.b(14, c: C.danger)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatBox(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TS.h(22, c: color)),
          const SizedBox(height: 3),
          Text(label, textAlign: TextAlign.center, style: TS.r(10, h: 1.3)),
        ],
      ),
    );
  }
}

class _NearbyCard extends StatelessWidget {
  final _NUser user;
  final bool invited;
  final VoidCallback onInvite;
  const _NearbyCard({
    required this.user,
    required this.invited,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: invited ? C.safe.withOpacity(0.05) : C.surface2,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: invited ? C.safe.withOpacity(0.3) : C.border),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: user.color,
                ),
                child: Center(
                  child: Text(
                    user.avatar,
                    style: GoogleFonts.inter(
                      fontSize: 18,
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
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: C.surface3,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.distance,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: C.textSec,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFAB00),
                      size: 12,
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
          GestureDetector(
            onTap: invited ? null : onInvite,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: invited ? C.safe.withOpacity(0.12) : C.pinkSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: invited
                      ? C.safe.withOpacity(0.3)
                      : C.pink.withOpacity(0.3),
                ),
              ),
              child: invited
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
                          Icons.directions_walk_rounded,
                          color: C.pink,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ajak Jalan',
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

class _NUser {
  final String name, avatar, distance;
  final double rating;
  final int trips;
  final Color color;
  final bool isOnline;
  const _NUser(
    this.name,
    this.avatar,
    this.distance,
    this.rating,
    this.trips,
    this.color,
    this.isOnline,
  );
}

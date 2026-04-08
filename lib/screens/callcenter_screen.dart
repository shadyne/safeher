import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class CallCenterScreen extends StatelessWidget {
  const CallCenterScreen({super.key});

  static const _contacts = [
    _CCContact(
      icon: Icons.local_police_rounded,
      name: 'Polisi',
      number: '110',
      desc: 'Laporan kejahatan & keamanan',
      color: Color(0xFF448AFF),
      category: 'Darurat',
    ),
    _CCContact(
      icon: Icons.medical_services_rounded,
      name: 'Ambulans',
      number: '118',
      desc: 'Pertolongan medis darurat',
      color: Color(0xFF00E676),
      category: 'Darurat',
    ),
    _CCContact(
      icon: Icons.local_fire_department_rounded,
      name: 'Pemadam Kebakaran',
      number: '113',
      desc: 'Kebakaran & bencana',
      color: Color(0xFFFFAB00),
      category: 'Darurat',
    ),
    _CCContact(
      icon: Icons.support_agent_rounded,
      name: 'Hotline KPPPA',
      number: '129',
      desc: 'Pengaduan kekerasan perempuan & anak',
      color: Color(0xFFE91E8C),
      category: 'Perlindungan Perempuan',
    ),
    _CCContact(
      icon: Icons.phone_in_talk_rounded,
      name: 'LBH APIK Jakarta',
      number: '021-8779-8287',
      desc: 'Bantuan hukum untuk perempuan',
      color: Color(0xFFE91E8C),
      category: 'Perlindungan Perempuan',
    ),
    _CCContact(
      icon: Icons.favorite_rounded,
      name: 'Into The Light',
      number: '119 ext. 8',
      desc: 'Konseling krisis & kesehatan jiwa',
      color: Color(0xFF9C27B0),
      category: 'Kesehatan Mental',
    ),
    _CCContact(
      icon: Icons.psychology_rounded,
      name: 'Yayasan Pulih',
      number: '021-788-42580',
      desc: 'Trauma & pemulihan psikologis',
      color: Color(0xFF9C27B0),
      category: 'Kesehatan Mental',
    ),
    _CCContact(
      icon: Icons.gavel_rounded,
      name: 'Komnas Perempuan',
      number: '021-3903-963',
      desc: 'Advokasi hak perempuan',
      color: Color(0xFF448AFF),
      category: 'Advokasi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Group by category
    final Map<String, List<_CCContact>> grouped = {};
    for (final c in _contacts) {
      grouped.putIfAbsent(c.category, () => []).add(c);
    }

    return Scaffold(
      backgroundColor: C.bg,
      body: Column(
        children: [
          _topBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
              children: [
                _infoCard(),
                const SizedBox(height: 20),
                ...grouped.entries.map(
                  (e) => _CategorySection(title: e.key, contacts: e.value),
                ),
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
          const Icon(Icons.phone_rounded, color: C.pink, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text('Kontak Darurat', style: TS.h(20))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  '24 Jam',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: C.safe,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return DCard(
      padding: const EdgeInsets.all(14),
      borderColor: C.info.withOpacity(0.25),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: C.info.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.info_rounded, color: C.info, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tekan tombol "Hubungi" untuk menghubungi layanan darurat. Semua nomor berlaku untuk Indonesia.',
              style: TS.r(11, h: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final List<_CCContact> contacts;
  const _CategorySection({required this.title, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: C.pink,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(title, style: TS.b(13, c: C.textSec)),
            ],
          ),
        ),
        ...contacts.map((c) => _ContactCard(contact: c)),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final _CCContact contact;
  const _ContactCard({required this.contact});

  void _call(BuildContext context) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: C.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: contact.color.withOpacity(0.4)),
        ),
        content: Row(
          children: [
            Icon(Icons.phone_rounded, color: contact.color, size: 18),
            const SizedBox(width: 10),
            Text(
              'Menghubungi ${contact.name} (${contact.number})...',
              style: GoogleFonts.inter(fontSize: 13, color: C.textPri),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: contact.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: contact.color.withOpacity(0.25)),
            ),
            child: Icon(contact.icon, color: contact.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: TS.b(13)),
                const SizedBox(height: 2),
                Text(
                  contact.number,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: contact.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(contact.desc, style: TS.r(11)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _call(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: contact.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: contact.color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_rounded, color: contact.color, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'Hubungi',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: contact.color,
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

class _CCContact {
  final IconData icon;
  final String name, number, desc, category;
  final Color color;
  const _CCContact({
    required this.icon,
    required this.name,
    required this.number,
    required this.desc,
    required this.color,
    required this.category,
  });
}

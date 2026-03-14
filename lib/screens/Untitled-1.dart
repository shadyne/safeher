import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

// ═══════════════════════════════════════════════════════
//  TIPS & KEAMANAN SCREEN
//  • Search bar
//  • Kategori chips
//  • Featured tip card
//  • Grid tips artikel
//  • Detail article view
// ═══════════════════════════════════════════════════════
class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});
  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  String _cat = 'Semua';
  String _search = '';
  _Tip? _selected;

  final _cats = [
    'Semua',
    'Di Jalan',
    'Transportasi',
    'Digital',
    'Darurat',
    'Hukum',
  ];

  final _tips = [
    _Tip(
      id: 1,
      title: 'Cara Aman Pulang Malam Sendiri',
      preview:
          'Pilih rute ramai, kabari orang terdekat, dan aktifkan berbagi lokasi.',
      content:
          '''Pulang malam sendirian bisa terasa khawatir. Berikut langkah-langkah yang bisa kamu lakukan:

**Sebelum berangkat:**
• Kabari orang terdekat jam berapa kamu pulang dan rute yang diambil
• Pastikan HP terisi daya minimal 50%
• Aktifkan berbagi lokasi ke kontak darurat

**Di perjalanan:**
• Pilih jalan yang terang dan ramai, meski sedikit lebih jauh
• Hindari pakai earphone di kedua telinga — tetap waspada dengan suara sekitar
• Pegang HP dengan waspada, jangan sambil scroll di jalanan sepi
• Jalan dengan langkah pasti dan percaya diri

**Naik transportasi:**
• Duduk dekat penumpang wanita lain atau di dekat sopir/kondektur
• Screenshot rute dan bagikan ke teman
• Jangan tertidur jika naik kendaraan umum malam hari

**Tanda bahaya:**
Jika merasa diikuti, segera masuk ke tempat ramai (minimarket, warung, masjid). Hubungi seseorang dan berpura-pura sedang ditunggu.''',
      cat: 'Di Jalan',
      icon: Icons.directions_walk_rounded,
      color: C.pink,
      readTime: '3 menit',
      important: true,
    ),
    _Tip(
      id: 2,
      title: 'Keamanan Digital: Lindungi Privasi Online',
      preview:
          'Jangan sembarangan share lokasi di media sosial dan waspada phishing.',
      content:
          '''Di era digital, keamanan online sama pentingnya dengan keamanan fisik.

**Media sosial:**
• Jangan posting lokasi real-time (check-in saat masih di tempat)
• Hindari foto yang menunjukkan alamat rumah atau rutin harian
• Setting akun ke privat
• Berhati-hati dengan followers yang tidak dikenal

**Password & akun:**
• Gunakan password berbeda untuk setiap akun penting
• Aktifkan 2FA (two-factor authentication)
• Jangan gunakan nama, tanggal lahir, atau info mudah ditebak

**Waspadai:**
• Pesan dari nomor tidak dikenal yang meminta data pribadi
• Link mencurigakan, meski dari teman (akun mereka mungkin dibobol)
• Aplikasi yang minta izin akses berlebihan

**Jika terjadi kebocoran data:**
Segera ganti password, lapor ke platform terkait, dan jika berkaitan dengan ancaman, hubungi SafeHer ID atau Komnas Perempuan.''',
      cat: 'Digital',
      icon: Icons.security_rounded,
      color: C.info,
      readTime: '4 menit',
      important: false,
    ),
    _Tip(
      id: 3,
      title: 'Naik Ojek Online dengan Aman',
      preview:
          'Verifikasi driver, bagikan rute, dan ketahui hak-hakmu sebagai penumpang.',
      content:
          '''Ojek online sudah jadi bagian sehari-hari. Ini cara membuatnya lebih aman:

**Sebelum naik:**
• Selalu cocokkan plat nomor, nama, dan foto driver dengan aplikasi
• Jangan naik jika ada perbedaan — batalkan dan laporkan
• Bagikan detail perjalanan ke kontak darurat
• Pastikan rute di aplikasi sudah benar sebelum berangkat

**Selama perjalanan:**
• Pantau rute di aplikasi, waspada jika driver menyimpang
• Duduk di belakang, bukan di samping untuk mobil
• Jangan tertidur, terutama malam hari
• Simpan nomor darurat 110 di kunci layar

**Hak penumpang:**
• Kamu berhak membatalkan tanpa alasan
• Laporkan driver berperilaku tidak pantas langsung di aplikasi
• Screenshot detail driver sebelum berangkat sebagai bukti

**Fitur keamanan aplikasi:**
Aktifkan "Bagikan Perjalanan" dan fitur "Tombol Darurat" yang ada di Gojek/Grab.''',
      cat: 'Transportasi',
      icon: Icons.motorcycle_rounded,
      color: C.warning,
      readTime: '3 menit',
      important: false,
    ),
    _Tip(
      id: 4,
      title: 'Apa yang Harus Dilakukan Saat Darurat',
      preview: 'Langkah cepat dan tepat saat menghadapi situasi berbahaya.',
      content:
          '''Saat situasi darurat, panik adalah musuh utama. Ini yang perlu kamu ingat:

**Segera lakukan:**
1. Pergi ke tempat ramai atau terang
2. Hubungi kontak darurat atau 110 (Polisi)
3. Berteriak "TOLONG!" atau "KEBAKARAN!" — kata "kebakaran" lebih efektif menarik perhatian
4. Gunakan fitur SOS di SafeHer ID

**Nomor darurat Indonesia:**
• 110 — Polisi
• 119 — Ambulans / Gawat darurat
• 129 — SAR / BASARNAS
• 021-3903553 — Komnas Perempuan

**Jika mengalami pelecehan:**
• Tegur dengan tegas: "Hentikan! Ini tidak pantas!"
• Cari bantuan orang sekitar
• Abadikan bukti jika aman dilakukan
• Laporkan ke polisi — ini BUKAN salahmu

**Setelah kejadian:**
Ceritakan pada orang yang dipercaya. Simpan semua bukti. Hubungi LBH atau Komnas Perempuan untuk pendampingan hukum gratis.''',
      cat: 'Darurat',
      icon: Icons.emergency_rounded,
      color: C.danger,
      readTime: '2 menit',
      important: true,
    ),
    _Tip(
      id: 5,
      title: 'Hak Hukummu Sebagai Korban',
      preview: 'Kenali hakmu, cara melapor, dan lembaga yang bisa membantu.',
      content:
          '''Setiap wanita yang mengalami kekerasan punya hak hukum yang dilindungi negara.

**Undang-undang yang melindungimu:**
• UU No. 23/2004 — KDRT
• UU No. 12/2022 — TPKS (Tindak Pidana Kekerasan Seksual)
• UU No. 11/2008 — ITE (untuk ancaman digital)

**Cara melapor:**
1. Datang ke Polsek/Polres terdekat
2. Minta "Perlindungan Saksi dan Korban"
3. Boleh didampingi pengacara/LSM
4. Simpan semua bukti: screenshot, foto, catatan kronologi

**Layanan pendampingan GRATIS:**
• LBH APIK: 021-788-42580
• Komnas Perempuan: 021-3903553
• LPSK: 1500-454
• Yayasan Pulih: 021-788-42580

**Kamu tidak sendirian.** Melaporkan adalah keberanian. Tim SafeHer ID bisa membantu menghubungkanmu ke lembaga yang tepat.''',
      cat: 'Hukum',
      icon: Icons.gavel_rounded,
      color: C.safe,
      readTime: '5 menit',
      important: false,
    ),
    _Tip(
      id: 6,
      title: 'Tips di Tempat Parkir & Gedung Sepi',
      preview: 'Waspada di tempat parkir, lift, dan area minim penerangan.',
      content:
          '''Tempat parkir dan area sepi adalah lokasi yang perlu kewaspadaan ekstra.

**Di tempat parkir:**
• Pilih tempat parkir yang terang dan dekat pintu masuk
• Perhatikan lingkungan sekitar sebelum keluar dari kendaraan
• Siapkan kunci dari dalam kendaraan, bukan setelah keluar
• Percayai instingmu — jika merasa tidak aman, minta diantar petugas

**Di lift:**
• Jangan masuk lift dengan orang asing yang terasa mencurigakan
• Berdiri dekat panel tombol
• Jika ada yang masuk dan membuatmu tidak nyaman, tekan tombol lantai terdekat dan keluar
• Telepon seseorang saat di lift sendirian

**Di gedung/koridor sepi:**
• Perhatikan siapa yang ada di sekitarmu
• Hindari mengecek HP sambil berjalan di area sepi
• Percepat langkah, jangan tunjukkan keragu-raguan

**Self-defense dasar:**
• Targetkan mata, hidung, dan lutut
• Suaramu adalah senjata — berteriak keras
• Lari lebih efektif dari berkelahi''',
      cat: 'Di Jalan',
      icon: Icons.local_parking_rounded,
      color: C.warning,
      readTime: '3 menit',
      important: false,
    ),
  ];

  List<_Tip> get _filtered {
    var list = _cat == 'Semua'
        ? _tips
        : _tips.where((t) => t.cat == _cat).toList();
    if (_search.isNotEmpty) {
      list = list
          .where(
            (t) =>
                t.title.toLowerCase().contains(_search.toLowerCase()) ||
                t.preview.toLowerCase().contains(_search.toLowerCase()),
          )
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (_selected != null) {
      return _DetailView(
        tip: _selected!,
        onBack: () => setState(() => _selected = null),
      );
    }

    return Scaffold(
      backgroundColor: C.bg,
      body: Column(
        children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _searchBar(),
                  _catBar(),
                  if (_cat == 'Semua' && _search.isEmpty) _featuredCard(),
                  _tipsList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────
  Widget _header() {
    return Container(
      color: C.surface,
      padding: const EdgeInsets.fromLTRB(4, 48, 18, 14),
      child: Row(
        children: [
          // Tombol back — muncul jika bisa pop
          Builder(
            builder: (context) {
              return Navigator.canPop(context)
                  ? IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: C.textSec,
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  : const SizedBox(width: 18);
            },
          ),
          const Icon(Icons.lightbulb_rounded, color: C.pink, size: 20),
          Expanded(child: Text('Tips & Keamanan', style: TS.h(20))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: C.pinkSoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.pink.withOpacity(0.3)),
            ),
            child: Text(
              '${_tips.length} Tips',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: C.pink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search ───────────────────────────────────────────
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: C.surface2,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: C.border),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _search = v),
          style: GoogleFonts.inter(color: C.textPri, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cari tips keamanan...',
            hintStyle: GoogleFonts.inter(color: C.textMuted, fontSize: 14),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: C.textMuted,
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }

  // ── Category chips ───────────────────────────────────
  Widget _catBar() {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        scrollDirection: Axis.horizontal,
        itemCount: _cats.length,
        itemBuilder: (_, i) {
          final on = _cats[i] == _cat;
          return GestureDetector(
            onTap: () => setState(() => _cat = _cats[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: on ? C.pink : C.surface2,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: on ? C.pink : C.border),
              ),
              child: Text(
                _cats[i],
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

  // ── Featured big card ────────────────────────────────
  Widget _featuredCard() {
    final t = _tips.firstWhere((t) => t.important);
    return GestureDetector(
      onTap: () => setState(() => _selected = t),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1A0A18), C.pinkDark.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: C.pink.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: C.pinkSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'PENTING',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: C.pink,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(t.title, style: TS.h(16)),
                  const SizedBox(height: 6),
                  Text(
                    t.preview,
                    style: TS.r(12, h: 1.45),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: C.textMuted,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(t.readTime, style: TS.r(11)),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: C.pink,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Baca selengkapnya',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: C.pink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: t.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.color.withOpacity(0.2)),
              ),
              child: Icon(t.icon, color: t.color, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tips list ────────────────────────────────────────
  Widget _tipsList() {
    final list = _filtered;
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: C.textMuted),
            const SizedBox(height: 12),
            Text('Tidak ada tips ditemukan', style: TS.b(14, c: C.textMuted)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: list
            .map(
              (t) => Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _TipCard(
                  tip: t,
                  onTap: () => setState(() => _selected = t),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────
class _Tip {
  final int id;
  final String title, preview, content, cat, readTime;
  final IconData icon;
  final Color color;
  final bool important;
  const _Tip({
    required this.id,
    required this.title,
    required this.preview,
    required this.content,
    required this.cat,
    required this.readTime,
    required this.icon,
    required this.color,
    required this.important,
  });
}

// ── Tip card (list item) ──────────────────────────────
class _TipCard extends StatelessWidget {
  final _Tip tip;
  final VoidCallback onTap;
  const _TipCard({required this.tip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tip.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: tip.color.withOpacity(0.2)),
              ),
              child: Icon(tip.icon, color: tip.color, size: 24),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tip.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tip.cat,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: tip.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (tip.important) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: C.pinkSoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Penting',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: C.pink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    tip.title,
                    style: TS.b(13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: C.textMuted,
                        size: 11,
                      ),
                      const SizedBox(width: 3),
                      Text(tip.readTime, style: TS.r(10)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: C.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  DETAIL VIEW — artikel penuh
// ═══════════════════════════════════════════════════════
class _DetailView extends StatelessWidget {
  final _Tip tip;
  final VoidCallback onBack;
  const _DetailView({required this.tip, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        backgroundColor: C.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: C.textSec,
            size: 22,
          ),
          onPressed: onBack,
        ),
        title: Text(tip.cat, style: TS.r(14)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: C.textSec,
              size: 22,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: C.textSec, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header artikel
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tip.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: tip.color.withOpacity(0.2)),
              ),
              child: Icon(tip.icon, color: tip.color, size: 28),
            ),
            const SizedBox(height: 14),
            Text(tip.title, style: TS.h(22)),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: tip.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tip.cat,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: tip.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.access_time_rounded,
                  color: C.textMuted,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text('Baca ${tip.readTime}', style: TS.r(12)),
                const SizedBox(width: 10),
                const Icon(
                  Icons.menu_book_rounded,
                  color: C.textMuted,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text('SafeHer ID', style: TS.r(12)),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: C.border, height: 1),
            const SizedBox(height: 20),

            // Konten artikel — parsing markdown sederhana
            ..._parseContent(tip.content),

            const SizedBox(height: 30),
            // CTA
            DCard(
              borderColor: C.pink.withOpacity(0.25),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sos_rounded, color: C.pink, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Butuh bantuan segera?', style: TS.b(13)),
                            Text(
                              'Gunakan fitur SOS darurat SafeHer ID',
                              style: TS.r(11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PinkBtn(
                    label: 'Buka Panic Button',
                    icon: Icons.warning_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  List<Widget> _parseContent(String content) {
    final widgets = <Widget>[];
    for (final line in content.split('\n')) {
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 10));
      } else if (line.startsWith('**') && line.endsWith('**')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 6),
            child: Text(line.replaceAll('**', ''), style: TS.b(15)),
          ),
        );
      } else if (line.startsWith('• ') || line.startsWith('* ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: C.pink,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(line.substring(2), style: TS.r(14, h: 1.6)),
                ),
              ],
            ),
          ),
        );
      } else if (RegExp(r'^\d+\.').hasMatch(line)) {
        final num = line.split('.').first;
        final text = line.substring(num.length + 1).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: C.pinkSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      num,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: C.pink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(text, style: TS.r(14, h: 1.6))),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(line, style: TS.r(14, h: 1.65)),
          ),
        );
      }
    }
    return widgets;
  }
}

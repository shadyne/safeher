import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Column(
        children: [
          _header(),
          _tabBar(),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: const [_FormTab(), _HistoryTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      color: C.surface,
      padding: const EdgeInsets.fromLTRB(18, 52, 18, 14),
      child: Row(
        children: [
          Icon(Icons.assignment_rounded, color: C.pink, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text('Laporan Kejadian', style: TS.h(20))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: C.pinkSoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.pink.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_rounded, size: 11, color: C.pink),
                const SizedBox(width: 4),
                Text(
                  'Anonim',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: C.pink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      color: C.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: C.surface3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tab,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [C.pinkLight, C.pinkDark],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: C.textMuted,
          labelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Buat Laporan'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
    );
  }
}

class _FormTab extends StatefulWidget {
  const _FormTab();
  @override
  State<_FormTab> createState() => _FormTabState();
}

class _FormTabState extends State<_FormTab> {
  bool _anon = true;
  String? _cat;
  bool _done = false;
  final _locCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final _cats = const [
    _Cat(Icons.record_voice_over_rounded, 'Verbal', C.warning),
    _Cat(Icons.pan_tool_rounded, 'Fisik', C.danger),
    _Cat(Icons.wallet_rounded, 'Pencurian', C.pink),
    _Cat(Icons.bolt_rounded, 'Kekerasan', C.danger),
    _Cat(Icons.theater_comedy_rounded, 'Penipuan', C.info),
    _Cat(Icons.more_horiz_rounded, 'Lainnya', C.textMuted),
  ];

  @override
  void dispose() {
    _locCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _success();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _anonToggle(),
          const SizedBox(height: 20),
          _sec('Kategori Kejadian'),
          const SizedBox(height: 12),
          _catGrid(),
          const SizedBox(height: 20),
          _sec('Lokasi Kejadian'),
          const SizedBox(height: 10),
          _locField(),
          const SizedBox(height: 20),
          _sec('Deskripsi'),
          const SizedBox(height: 10),
          _descField(),
          const SizedBox(height: 12),
          _photoBtn(),
          const SizedBox(height: 24),
          _submitBtn(),
          const SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_rounded, size: 11, color: C.textMuted),
                const SizedBox(width: 4),
                Text(
                  'Laporan dienkripsi sebelum dipublikasikan',
                  style: TS.r(11, c: C.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _sec(String t) => Text(t, style: TS.b(13, c: C.textSec));

  Widget _anonToggle() {
    return GestureDetector(
      onTap: () => setState(() => _anon = !_anon),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _anon ? C.pinkSoft : C.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _anon ? C.pink.withOpacity(0.4) : C.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _anon ? C.pink.withOpacity(0.15) : C.surface3,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: _anon ? C.pink.withOpacity(0.3) : C.border,
                ),
              ),
              child: Icon(
                _anon ? Icons.person_off_rounded : Icons.person_rounded,
                color: _anon ? C.pink : C.textMuted,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _anon ? 'Mode Anonim Aktif' : 'Dengan Identitas',
                    style: TS.b(13, c: _anon ? C.pink : C.textPri),
                  ),
                  Text(
                    _anon
                        ? 'Namamu tidak akan terlihat'
                        : 'Namamu muncul di laporan',
                    style: TS.r(11),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _anon ? C.pink : C.surface3,
                border: Border.all(
                  color: _anon ? C.pink : C.border,
                  width: 1.5,
                ),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 160),
                alignment: _anon ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
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

  Widget _catGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: _cats.length,
      itemBuilder: (_, i) {
        final c = _cats[i];
        final sel = _cat == c.label;
        return GestureDetector(
          onTap: () => setState(() => _cat = c.label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: sel ? c.color.withOpacity(0.12) : C.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: sel ? c.color.withOpacity(0.5) : C.border,
                width: sel ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(c.icon, color: sel ? c.color : C.textMuted, size: 26),
                const SizedBox(height: 7),
                Text(
                  c.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                    color: sel ? c.color : C.textSec,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _locField() {
    return Container(
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(Icons.location_on_rounded, color: C.pink, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: _locCtrl,
              style: GoogleFonts.inter(color: C.textPri, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Nama jalan atau tempat...',
                hintStyle: GoogleFonts.inter(color: C.textMuted, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                setState(() => _locCtrl.text = 'Jl. Sudirman, Jakarta Pusat'),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: C.pinkSoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    color: C.pink,
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'GPS',
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

  Widget _descField() {
    return Container(
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: C.border),
      ),
      child: TextField(
        controller: _descCtrl,
        maxLines: 4,
        style: GoogleFonts.inter(color: C.textPri, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Ceritakan apa yang terjadi...',
          hintStyle: GoogleFonts.inter(color: C.textMuted, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _photoBtn() {
    return GestureDetector(
      onTap: () async {
        final p = ImagePicker();
        await p.pickImage(source: ImageSource.gallery);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: C.surface2,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: C.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add_photo_alternate_rounded,
              color: C.pink,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text('Lampirkan Foto (opsional)', style: TS.r(13)),
            const Spacer(),
            Text(
              'Pilih',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: C.pink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitBtn() {
    final ok = _cat != null;
    return PinkBtn(
      label: 'Kirim Laporan',
      icon: Icons.send_rounded,
      onTap: ok
          ? () {
              FocusScope.of(context).unfocus();
              setState(() => _done = true);
            }
          : null,
    );
  }

  Widget _success() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 7,
                      backgroundColor: C.surface3,
                      valueColor: const AlwaysStoppedAnimation(C.safe),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  const Icon(Icons.check_rounded, color: C.safe, size: 44),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text('Laporan Terkirim!', style: TS.h(22)),
            const SizedBox(height: 10),
            Text(
              'Laporanmu sedang diverifikasi tim SafeHer.\nMakasih udah bantu komunitas!',
              textAlign: TextAlign.center,
              style: TS.r(14, h: 1.65),
            ),
            const SizedBox(height: 32),
            PinkBtn(
              label: 'Buat Laporan Lain',
              icon: Icons.add_rounded,
              onTap: () => setState(() {
                _done = false;
                _cat = null;
                _locCtrl.clear();
                _descCtrl.clear();
                _anon = true;
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    final list = [
      _Hist(
        'Pelecehan Verbal',
        'Jl. Sudirman',
        '10 Mar 2024',
        'Diverifikasi',
        C.safe,
      ),
      _Hist(
        'Pencurian',
        'Stasiun Gambir',
        '28 Feb 2024',
        'Dalam Review',
        C.warning,
      ),
    ];
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 56, color: C.textMuted),
            const SizedBox(height: 12),
            Text('Belum ada laporan', style: TS.b(16, c: C.textMuted)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: list.length,
      itemBuilder: (_, i) => _HistCard(h: list[i]),
    );
  }
}

class _Cat {
  final IconData icon;
  final String label;
  final Color color;
  const _Cat(this.icon, this.label, this.color);
}

class _Hist {
  final String title, loc, date, status;
  final Color color;
  const _Hist(this.title, this.loc, this.date, this.status, this.color);
}

class _HistCard extends StatelessWidget {
  final _Hist h;
  const _HistCard({required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: C.pinkSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.description_rounded,
              color: C.pink,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(h.title, style: TS.b(13)),
                const SizedBox(height: 3),
                Text('${h.loc} · ${h.date}', style: TS.r(11)),
              ],
            ),
          ),
          StatusBadge(label: h.status, color: h.color),
        ],
      ),
    );
  }
}

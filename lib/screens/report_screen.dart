import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart' show C;

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
          _buildHeader(),
          _buildTabs(),
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

  Widget _buildHeader() {
    return Container(
      color: C.bg
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Text('Laporan Kejadian',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.w800,
                color: C.textDark)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: C.soft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_rounded, size: 12, color: C.primary),
                const SizedBox(width: 4),
                Text('Anonim tersedia',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: C.primary,
                    fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: C.bg
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: C.soft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tab,
          indicator: BoxDecoration(
            color: C.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: C.textGrey,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 13),
          dividerColor: Colors.transparent,
          padding: const EdgeInsets.all(3),
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
  final _locCtrl  = TextEditingController();
  final _descCtrl = TextEditingController();

  final _cats = const [
    _Cat('🗣️', 'Verbal',    C.amber),
    _Cat('✊',  'Fisik',     C.rose),
    _Cat('👛',  'Pencurian', C.primary),
    _Cat('⚠️',  'Kekerasan', C.rose),
    _Cat('🎭',  'Penipuan',  Color(0xFF3D82FF)),
    _Cat('···', 'Lainnya',   C.textGrey),
  ];

  @override
  void dispose() {
    _locCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _buildSuccess();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnonToggle(),
          const SizedBox(height: 22),

          _sectionLabel('Kategori Kejadian'),
          const SizedBox(height: 12),
          _buildCatGrid(),
          const SizedBox(height: 22),

          _sectionLabel('Lokasi'),
          const SizedBox(height: 10),
          _buildLocField(),
          const SizedBox(height: 22),

          _sectionLabel('Ceritakan Kejadiannya'),
          const SizedBox(height: 10),
          _buildDescField(),
          const SizedBox(height: 14),

          _buildPhotoBtn(),
          const SizedBox(height: 24),
          _buildSubmitBtn(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _sectionLabel(String t) => Text(t,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 14, fontWeight: FontWeight.w700, color: C.textDark));

  Widget _buildAnonToggle() {
    return GestureDetector(
      onTap: () => setState(() => _anon = !_anon),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _anon ? C.soft : C.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _anon ? C.primary.withOpacity(0.4) : C.border),
        ),
        child: Row(
          children: [
            Icon(
              _anon ? Icons.person_off_rounded : Icons.person_rounded,
              color: _anon ? C.primary : C.textGrey,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_anon ? 'Mode Anonim Aktif' : 'Dengan Identitas',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: _anon ? C.primary : C.textDark)),
                  Text(_anon
                    ? 'Namamu tidak akan muncul di laporan'
                    : 'Namamu terlihat di laporan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, color: C.textGrey)),
                ],
              ),
            ),
            // Switch visual
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44, height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _anon ? C.primary : C.border,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                alignment: _anon ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 18, height: 18,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.15,
      ),
      itemCount: _cats.length,
      itemBuilder: (_, i) {
        final c = _cats[i];
        final sel = _cat == c.label;
        return GestureDetector(
          onTap: () => setState(() => _cat = c.label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            decoration: BoxDecoration(
              color: sel ? c.color.withOpacity(0.12) : C.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: sel ? c.color.withOpacity(0.5) : C.border,
                width: sel ? 1.5 : 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.icon, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 6),
                Text(c.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                    color: sel ? c.color : C.textGrey)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocField() {
    return Container(
      decoration: BoxDecoration(
        color: C.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Icon(Icons.location_on_rounded, color: C.rose, size: 20)),
          Expanded(
            child: TextField(
              controller: _locCtrl,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14, color: C.textDark),
              decoration: InputDecoration(
                hintText: 'Nama jalan atau tempat...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14, color: C.textGrey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 12),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(
              () => _locCtrl.text = 'Jl. Sudirman, Jakarta Pusat'),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: C.soft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                const Icon(Icons.my_location_rounded,
                  color: C.primary, size: 13),
                const SizedBox(width: 3),
                Text('GPS', style: GoogleFonts.plusJakartaSans(
                  fontSize: 11, color: C.primary,
                  fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescField() {
    return Container(
      decoration: BoxDecoration(
        color: C.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.border),
      ),
      child: TextField(
        controller: _descCtrl,
        maxLines: 4,
        style: GoogleFonts.plusJakartaSans(fontSize: 14, color: C.textDark),
        decoration: InputDecoration(
          hintText: 'Ceritakan apa yang terjadi...',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14, color: C.textGrey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _buildPhotoBtn() {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        await picker.pickImage(source: ImageSource.gallery);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.border),
        ),
        child: Row(children: [
          const Icon(Icons.add_photo_alternate_outlined,
            color: C.primary, size: 20),
          const SizedBox(width: 10),
          Text('Lampirkan Foto (opsional)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13, color: C.textGrey)),
          const Spacer(),
          Text('Pilih',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12, color: C.primary,
              fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    final canSend = _cat != null;
    return GestureDetector(
      onTap: canSend
        ? () { FocusScope.of(context).unfocus(); setState(() => _done = true); }
        : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: canSend ? C.primary : C.border,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text('Kirim Laporan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15, fontWeight: FontWeight.w700,
              color: canSend ? Colors.white : C.textGrey)),
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.tealSoft,
                border: Border.all(color: C.teal.withOpacity(0.35), width: 2),
              ),
              child: const Icon(Icons.check_rounded, color: C.teal, size: 48),
            ),
            const SizedBox(height: 24),
            Text('Laporan Terkirim!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22, fontWeight: FontWeight.w800,
                color: C.textDark)),
            const SizedBox(height: 10),
            Text(
              'Laporanmu sedang diverifikasi tim SafeHer ID.\nMakasih udah bantu komunitas! 💜',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14, color: C.textGrey, height: 1.6)),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => setState(() {
                _done = false; _cat = null;
                _locCtrl.clear(); _descCtrl.clear(); _anon = true;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 13, horizontal: 28),
                decoration: BoxDecoration(
                  color: C.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('Buat Laporan Lain',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: Colors.white)),
              ),
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
      _H('Pelecehan Verbal', 'Jl. Sudirman', '10 Mar 2024',
        'Diverifikasi', C.teal),
      _H('Pencurian', 'Stasiun Gambir', '28 Feb 2024',
        'Dalam Review', C.amber),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (_, i) => _HistoryCard(h: list[i]),
    );
  }
}

class _H {
  final String title, loc, date, status;
  final Color color;
  const _H(this.title, this.loc, this.date, this.status, this.color);
}

class _Cat {
  final String icon, label;
  final Color color;
  const _Cat(this.icon, this.label, this.color);
}

class _HistoryCard extends StatelessWidget {
  final _H h;
  const _HistoryCard({super.key, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: C.soft,
              borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.description_rounded,
              color: C.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(h.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: C.textDark)),
                const SizedBox(height: 3),
                Text('${h.loc} · ${h.date}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: C.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: h.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: h.color.withOpacity(0.3)),
            ),
            child: Text(h.status,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10, fontWeight: FontWeight.w700,
                color: h.color)),
          ),
        ],
      ),
    );
  }
}
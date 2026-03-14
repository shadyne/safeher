import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  int _step = 0; // 0=intro, 1=dokumen, 2=selfie, 3=done
  bool _docUploaded = false;
  bool _selfieUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      appBar: _appBar(),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, anim) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: _stepContent(),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: C.surface,
      elevation: 0,
      leading: _step > 0
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: C.textSec,
                size: 22,
              ),
              onPressed: () => setState(() => _step--),
            )
          : null,
      title: Text(_stepTitle(), style: TS.h(17)),
      centerTitle: true,
      bottom: _step > 0 && _step < 3
          ? PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: _ProgressBar(step: _step, total: 2),
            )
          : null,
    );
  }

  String _stepTitle() {
    switch (_step) {
      case 0:
        return 'Verifikasi Identitas';
      case 1:
        return 'Upload Dokumen';
      case 2:
        return 'Foto Selfie';
      case 3:
        return 'Verifikasi Terkirim';
      default:
        return '';
    }
  }

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return _introStep();
      case 1:
        return _docStep();
      case 2:
        return _selfieStep();
      case 3:
        return _doneStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _introStep() {
    final benefits = [
      _Benefit(
        Icons.verified_rounded,
        'Akun Terverifikasi',
        'Badge khusus di profilmu',
      ),
      _Benefit(
        Icons.lock_open_rounded,
        'Akses Penuh',
        'Buka semua fitur komunitas & chat',
      ),
      _Benefit(
        Icons.shield_moon_rounded,
        'Lebih Aman',
        'Komunitas hanya anggota terverifikasi',
      ),
      _Benefit(
        Icons.how_to_vote_rounded,
        'Laporan Prioritas',
        'Laporanmu diproses lebih cepat',
      ),
    ];

    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ilustrasi
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [C.pinkSoft, Colors.transparent],
                ),
                border: Border.all(color: C.pink.withOpacity(0.2), width: 1.5),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: C.pink,
                size: 52,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Center(child: Text('Kenapa perlu verifikasi?', style: TS.h(18))),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Verifikasi identitas memastikan komunitas\nSafeHer ID aman dan terpercaya.',
              textAlign: TextAlign.center,
              style: TS.r(13, h: 1.55),
            ),
          ),
          const SizedBox(height: 26),
          ...benefits.map((b) => _BenefitTile(b: b)),
          const SizedBox(height: 22),
          // Dokumen yang diterima
          DCard(
            borderColor: C.warning.withOpacity(0.25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: C.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dokumen yang diterima',
                      style: TS.b(12, c: C.warning),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _DocType(Icons.badge_rounded, 'KTM (Kartu Tanda Mahasiswa)'),
                const SizedBox(height: 6),
                _DocType(
                  Icons.credit_card_rounded,
                  'KTP (Kartu Tanda Penduduk)',
                ),
                const SizedBox(height: 6),
                _DocType(Icons.school_rounded, 'Kartu Pelajar aktif'),
              ],
            ),
          ),
          const SizedBox(height: 26),
          PinkBtn(
            label: 'Mulai Verifikasi',
            icon: Icons.arrow_forward_rounded,
            onTap: () => setState(() => _step = 1),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Privasi terjamin · Data dienkripsi AES-256',
              style: TS.r(11, c: C.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _docStep() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload foto dokumen', style: TS.h(18)),
          const SizedBox(height: 6),
          Text(
            'Pastikan dokumen jelas, tidak buram, dan semua tulisan terbaca.',
            style: TS.r(13, h: 1.5),
          ),
          const SizedBox(height: 24),

          // Upload area
          GestureDetector(
            onTap: () async {
              final p = ImagePicker();
              final img = await p.pickImage(source: ImageSource.gallery);
              if (img != null) setState(() => _docUploaded = true);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: _docUploaded ? C.safe.withOpacity(0.06) : C.surface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _docUploaded ? C.safe.withOpacity(0.5) : C.border,
                  width: _docUploaded ? 1.5 : 1,
                  style: _docUploaded ? BorderStyle.solid : BorderStyle.solid,
                ),
              ),
              child: _docUploaded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: C.safe,
                          size: 42,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Dokumen berhasil dipilih!',
                          style: TS.b(14, c: C.safe),
                        ),
                        const SizedBox(height: 4),
                        Text('Tap untuk ganti foto', style: TS.r(12)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: C.pinkSoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.upload_file_rounded,
                            color: C.pink,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('Tap untuk pilih foto', style: TS.b(14)),
                        const SizedBox(height: 4),
                        Text('JPG, PNG · Maks. 5 MB', style: TS.r(12)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          DCard(
            padding: const EdgeInsets.all(14),
            borderColor: C.info.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.camera_enhance_rounded,
                      color: C.info,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text('Tips foto yang baik', style: TS.b(12, c: C.info)),
                  ],
                ),
                const SizedBox(height: 10),
                ...[
                  'Gunakan pencahayaan yang cukup',
                  'Hindari pantulan cahaya / glare',
                  'Semua sudut dokumen terlihat',
                  'Jangan dipotong atau diedit',
                ].map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: C.info,
                          size: 13,
                        ),
                        const SizedBox(width: 7),
                        Text(t, style: TS.r(12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          PinkBtn(
            label: 'Lanjut ke Selfie',
            icon: Icons.arrow_forward_rounded,
            onTap: _docUploaded ? () => setState(() => _step = 2) : null,
          ),
          if (!_docUploaded) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Upload dokumen dulu ya',
                style: TS.r(12, c: C.textMuted),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _selfieStep() {
    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Foto selfie', style: TS.h(18)),
          const SizedBox(height: 6),
          Text(
            'Ambil foto wajahmu untuk mencocokkan dengan dokumen.',
            style: TS.r(13, h: 1.5),
          ),
          const SizedBox(height: 24),

          Center(
            child: GestureDetector(
              onTap: () async {
                final p = ImagePicker();
                final img = await p.pickImage(source: ImageSource.camera);
                if (img != null) setState(() => _selfieUploaded = true);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selfieUploaded
                      ? C.safe.withOpacity(0.08)
                      : C.surface2,
                  border: Border.all(
                    color: _selfieUploaded
                        ? C.safe.withOpacity(0.6)
                        : C.pink.withOpacity(0.35),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _selfieUploaded
                          ? C.safe.withOpacity(0.15)
                          : C.pinkGlow.withOpacity(0.15),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: _selfieUploaded
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: C.safe,
                        size: 64,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_front_rounded,
                            color: C.pink,
                            size: 52,
                          ),
                          const SizedBox(height: 10),
                          Text('Tap untuk kamera', style: TS.r(12)),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          _GuideRow(
            icon: Icons.face_rounded,
            color: C.info,
            text: 'Hadapkan wajah langsung ke kamera',
          ),
          const SizedBox(height: 8),
          _GuideRow(
            icon: Icons.wb_sunny_rounded,
            color: C.warning,
            text: 'Pastikan wajah cukup terang & terlihat jelas',
          ),
          const SizedBox(height: 8),
          _GuideRow(
            icon: Icons.do_not_disturb_on_rounded,
            color: C.danger,
            text: 'Jangan pakai masker, kacamata, atau topi',
          ),
          const SizedBox(height: 28),

          PinkBtn(
            label: _selfieUploaded ? 'Kirim Verifikasi' : 'Ambil Foto Sekarang',
            icon: _selfieUploaded ? Icons.send_rounded : Icons.camera_rounded,
            onTap: _selfieUploaded
                ? () => setState(() => _step = 3)
                : () async {
                    final p = ImagePicker();
                    final img = await p.pickImage(source: ImageSource.camera);
                    if (img != null) setState(() => _selfieUploaded = true);
                  },
          ),
        ],
      ),
    );
  }

  Widget _doneStep() {
    return Center(
      key: const ValueKey(3),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular check
            SizedBox(
              width: 110,
              height: 110,
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
                  const Icon(Icons.check_rounded, color: C.safe, size: 48),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Verifikasi Terkirim!', style: TS.h(22)),
            const SizedBox(height: 10),
            Text(
              'Tim SafeHer ID akan memeriksa dokumenmu\ndalam 1×24 jam. Kamu akan mendapat\nnotifikasi saat verifikasi selesai.',
              textAlign: TextAlign.center,
              style: TS.r(14, h: 1.65),
            ),
            const SizedBox(height: 30),
            DCard(
              child: Column(
                children: [
                  _StatusRow(
                    icon: Icons.upload_rounded,
                    label: 'Dokumen diterima',
                    color: C.safe,
                    done: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: SizedBox(
                      height: 10,
                      child: VerticalDivider(color: C.border, width: 1),
                    ),
                  ),
                  _StatusRow(
                    icon: Icons.search_rounded,
                    label: 'Sedang direview tim',
                    color: C.warning,
                    done: false,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: SizedBox(
                      height: 10,
                      child: VerticalDivider(color: C.border, width: 1),
                    ),
                  ),
                  _StatusRow(
                    icon: Icons.verified_rounded,
                    label: 'Badge diberikan',
                    color: C.textMuted,
                    done: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            PinkBtn(
              label: 'Kembali ke Beranda',
              icon: Icons.home_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int step, total;
  const _ProgressBar({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: const BoxDecoration(color: C.surface3),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: step / total,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [C.pinkLight, C.pinkDark]),
          ),
        ),
      ),
    );
  }
}

class _Benefit {
  final IconData icon;
  final String title, sub;
  const _Benefit(this.icon, this.title, this.sub);
}

class _BenefitTile extends StatelessWidget {
  final _Benefit b;
  const _BenefitTile({required this.b});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: C.pinkSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(b.icon, color: C.pink, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.title, style: TS.b(13)),
                Text(b.sub, style: TS.r(11)),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: C.pink, size: 16),
        ],
      ),
    );
  }
}

class _DocType extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DocType(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: C.textMuted, size: 15),
        const SizedBox(width: 8),
        Text(label, style: TS.r(12)),
      ],
    );
  }
}

class _GuideRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _GuideRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TS.r(13, h: 1.4))),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool done;
  const _StatusRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TS.b(13, c: done ? C.textPri : C.textMuted),
          ),
        ),
        if (done)
          const Icon(Icons.check_rounded, color: C.safe, size: 16)
        else
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.5),
            ),
          ),
      ],
    );
  }
}

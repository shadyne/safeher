import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});
  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen>
    with TickerProviderStateMixin {
  _PState _st = _PState.idle;
  int _cd = 3;
  Timer? _timer;

  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _ringCtrl;
  late Animation<double> _ringAnim;

  late AnimationController _blinkCtrl;
  late Animation<double> _blinkAnim;

  final _contacts = [
    _Con('Mama', '+62 812-3456-7890', Icons.person_rounded),
    _Con('Polisi', '110', Icons.local_police_rounded),
    _Con('Ambulans', '119', Icons.medical_services_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.07,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _ringAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));

    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _blinkAnim = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _blinkCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordTimer?.cancel();
    _pulseCtrl.dispose();
    _ringCtrl.dispose();
    _blinkCtrl.dispose();
    super.dispose();
  }

  void _onHold(LongPressStartDetails _) {
    if (_st != _PState.idle) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _st = _PState.counting;
      _cd = 3;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _cd--);
      HapticFeedback.lightImpact();
      if (_cd <= 0) {
        t.cancel();
        _activate();
      }
    });
  }

  void _onRelease(LongPressEndDetails _) {
    if (_st == _PState.counting) _cancel();
  }

  void _activate() {
    HapticFeedback.heavyImpact();
    setState(() => _st = _PState.active);
    _pulseCtrl.repeat(reverse: true);
    _ringCtrl.repeat();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _st == _PState.active) {
        setState(() => _isRecording = true);
        _blinkCtrl.repeat(reverse: true);
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) setState(() => _recordSeconds++);
        });
      }
    });
  }

  void _cancel() {
    _timer?.cancel();
    _recordTimer?.cancel();
    _pulseCtrl.stop();
    _pulseCtrl.reset();
    _ringCtrl.stop();
    _ringCtrl.reset();
    _blinkCtrl.stop();
    _blinkCtrl.reset();
    setState(() {
      _st = _PState.idle;
      _cd = 3;
      _isRecording = false;
      _recordSeconds = 0;
    });
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final active = _st == _PState.active;
    return Scaffold(
      backgroundColor: active ? const Color(0xFF140010) : C.bg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _contactBox(),
            const Spacer(),
            _button(),
            const SizedBox(height: 14),
            _hint(),
            const Spacer(),
            _quickDial(),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return AppTopBar(
      title: 'Panic Button',
      actions: [
        GestureDetector(
          onTap: () => _showAddContact(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: C.pinkSoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.pink.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.add_rounded, color: C.pink, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Kontak',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: C.pink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.contacts_rounded, color: C.pink, size: 16),
              const SizedBox(width: 6),
              Text('Kontak Darurat', style: TS.b(13)),
            ],
          ),
          const SizedBox(height: 12),
          ..._contacts.map((c) => _ConRow(con: c)),
        ],
      ),
    );
  }

  Widget _button() {
    return GestureDetector(
      onLongPressStart: _onHold,
      onLongPressEnd: _onRelease,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Transform.scale(
          scale: _st == _PState.active ? _pulseAnim.value : 1.0,
          child: child,
        ),
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_st == _PState.active)
                AnimatedBuilder(
                  animation: _ringAnim,
                  builder: (_, _) => Container(
                    width: 220 * _ringAnim.value,
                    height: 220 * _ringAnim.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: C.pink.withOpacity(0.4 * (1 - _ringAnim.value)),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: C.pink.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: C.pink.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                width: 148,
                height: 148,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _st == _PState.active
                        ? [C.pinkLight, C.pinkDark]
                        : [
                            C.pinkLight.withOpacity(0.9),
                            C.pinkDark.withOpacity(0.9),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: C.pinkGlow,
                      blurRadius: _st == _PState.active ? 40 : 20,
                      spreadRadius: _st == _PState.active ? 8 : 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _st == _PState.counting
                      ? [
                          Text('$_cd', style: TS.h(56)),
                          Text('detik', style: TS.r(12, c: Colors.white70)),
                        ]
                      : [
                          Text(
                            'SOS',
                            style: GoogleFonts.inter(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _st == _PState.active ? '● AKTIF' : 'TAHAN',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                              letterSpacing: _st == _PState.active ? 1 : 2,
                            ),
                          ),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hint() {
    if (_st == _PState.active) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: C.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: C.pink.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _ProcessRow(label: 'Mengirim lokasi', done: true),
                const SizedBox(height: 8),
                _ProcessRow(label: 'Notif ke kontak', done: true),
                const SizedBox(height: 8),
                _RecordingRow(
                  isRecording: _isRecording,
                  duration: _formatDuration(_recordSeconds),
                  blinkAnim: _blinkAnim,
                ),
              ],
            ),
          ),
          if (_isRecording) ...[
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: C.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.danger.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _blinkAnim,
                    builder: (_, __) => Opacity(
                      opacity: _blinkAnim.value,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: C.danger,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Sedang merekam...',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: C.danger,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDuration(_recordSeconds),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: C.danger,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: 160,
            child: PinkBtn(
              label: 'Stop',
              onTap: _cancel,
              icon: Icons.stop_circle_rounded,
            ),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Text(
        _st == _PState.counting
            ? 'Lepas untuk membatalkan...'
            : 'Tahan tombol 3 detik untuk kirim sinyal darurat',
        textAlign: TextAlign.center,
        style: TS.r(13, h: 1.5),
      ),
    );
  }

  Widget _quickDial() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: _DialBtn(
              icon: Icons.local_police_rounded,
              label: 'Polisi',
              number: '110',
              color: C.info,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DialBtn(
              icon: Icons.medical_services_rounded,
              label: 'Ambulans',
              number: '119',
              color: C.safe,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContact(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: C.surface2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddSheet(),
    );
  }
}

enum _PState { idle, counting, active }

class _Con {
  final String name, number;
  final IconData icon;
  const _Con(this.name, this.number, this.icon);
}

class _ConRow extends StatelessWidget {
  final _Con con;
  const _ConRow({required this.con});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: C.pinkSoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: C.pink.withOpacity(0.2)),
            ),
            child: Icon(con.icon, color: C.pink, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(con.name, style: TS.b(13)),
                Text(con.number, style: TS.r(11)),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: C.safe.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.phone_rounded, color: C.safe, size: 16),
          ),
        ],
      ),
    );
  }
}

class _ProcessRow extends StatelessWidget {
  final String label;
  final bool done;
  const _ProcessRow({required this.label, required this.done});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: TS.r(12))),
        SizedBox(
          width: 20,
          height: 20,
          child: done
              ? const Icon(Icons.check_circle_rounded, color: C.safe, size: 20)
              : CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: C.pink,
                  backgroundColor: C.surface3,
                ),
        ),
      ],
    );
  }
}

class _RecordingRow extends StatelessWidget {
  final bool isRecording;
  final String duration;
  final Animation<double> blinkAnim;
  const _RecordingRow({
    required this.isRecording,
    required this.duration,
    required this.blinkAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('Rekam audio/video', style: TS.r(12))),
        if (!isRecording)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: C.pink,
              backgroundColor: C.surface3,
            ),
          )
        else
          Row(
            children: [
              Text(
                duration,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: C.danger,
                ),
              ),
              const SizedBox(width: 6),
              AnimatedBuilder(
                animation: blinkAnim,
                builder: (_, __) => Opacity(
                  opacity: blinkAnim.value,
                  child: const Icon(
                    Icons.fiber_manual_record_rounded,
                    color: C.danger,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _DialBtn extends StatelessWidget {
  final IconData icon;
  final String label, number;
  final Color color;
  const _DialBtn({
    required this.icon,
    required this.label,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(label, style: TS.r(11, c: C.textSec)),
            Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddSheet extends StatelessWidget {
  final _nameCtrl = TextEditingController();
  final _numCtrl = TextEditingController();
  _AddSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: C.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Tambah Kontak Darurat', style: TS.h(17)),
          const SizedBox(height: 18),
          _DarkField('Nama', 'Contoh: Mama', _nameCtrl),
          const SizedBox(height: 10),
          _DarkField(
            'Nomor HP',
            '+62 812-xxxx',
            _numCtrl,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: PinkBtn(
              label: 'Simpan Kontak',
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  final String label, hint;
  final TextEditingController ctrl;
  final TextInputType type;
  const _DarkField(
    this.label,
    this.hint,
    this.ctrl, {
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TS.r(12)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: type,
          style: GoogleFonts.inter(color: C.textPri, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: C.textMuted, fontSize: 14),
            filled: true,
            fillColor: C.surface3,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: C.pink, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

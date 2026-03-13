import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart' show C;


class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen>
    with SingleTickerProviderStateMixin {

  _State _st = _State.idle;
  int _cd = 3;
  Timer? _timer;

  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  final _contacts = [
    _Contact('Mama',    '+62 812-3456-7890', '👩'),
    _Contact('Polisi',  '110',               '🚔'),
    _Contact('Ambulans','119',               '🚑'),
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _hold(_) {
    if (_st != _State.idle) return;
    HapticFeedback.mediumImpact();
    setState(() { _st = _State.counting; _cd = 3; });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _cd--);
      HapticFeedback.lightImpact();
      if (_cd <= 0) { t.cancel(); _activate(); }
    });
  }

  void _release(_) {
    if (_st == _State.counting) _cancel();
  }

  void _activate() {
    HapticFeedback.heavyImpact();
    setState(() => _st = _State.active);
    _pulse.repeat(reverse: true);
  }

  void _cancel() {
    _timer?.cancel();
    _pulse.stop(); _pulse.reset();
    setState(() { _st = _State.idle; _cd = 3; });
  }

  @override
  Widget build(BuildContext context) {
    final active = _st == _State.active;
    return Scaffold(
      backgroundColor: active ? const Color(0xFFFFF0F3) : C.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildContactBox(),
            const Spacer(),
            _buildButton(),
            const SizedBox(height: 16),
            _buildHint(),
            const Spacer(),
            _buildQuickDial(),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Text('Panic Button',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20, fontWeight: FontWeight.w800,
              color: C.textDark)),
          const Spacer(),
          GestureDetector(
            onTap: () => _showAddContact(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: C.soft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_rounded, color: C.primary, size: 16),
                  const SizedBox(width: 4),
                  Text('Kontak',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, color: C.primary,
                      fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kontak Darurat',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: C.textDark)),
          const SizedBox(height: 12),
          ..._contacts.map((c) => _ContactRow(contact: c)),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onLongPressStart: _hold,
      onLongPressEnd: _release,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Transform.scale(
          scale: _st == _State.active ? _pulseAnim.value : 1.0,
          child: child,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 210, height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: C.rose.withOpacity(0.2), width: 2),
              ),
            ),
            Container(
              width: 175, height: 175,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: C.rose.withOpacity(0.35), width: 2),
              ),
            ),
            Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _st == _State.active
                    ? C.rose
                    : _st == _State.counting
                        ? C.rose.withOpacity(0.85)
                        : C.rose,
                boxShadow: [
                  BoxShadow(
                    color: C.rose.withOpacity(
                      _st == _State.active ? 0.45 : 0.25),
                    blurRadius: _st == _State.active ? 32 : 16,
                    spreadRadius: _st == _State.active ? 6 : 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_st == _State.counting)
                    Text('$_cd',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 52, fontWeight: FontWeight.w800,
                        color: Colors.white))
                  else ...[
                    Text('SOS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 34, fontWeight: FontWeight.w900,
                        color: Colors.white, letterSpacing: 4)),
                    const SizedBox(height: 4),
                    Text(_st == _State.active ? 'AKTIF' : 'TAHAN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: Colors.white70, letterSpacing: 2)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHint() {
    if (_st == _State.active) {
      return Column(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: C.roseSoft,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.rose.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_rounded, color: C.rose, size: 16),
              const SizedBox(width: 6),
              Text('Sinyal darurat sedang dikirim',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: C.rose,
                  fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _cancel,
          child: Text('Batalkan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: C.textGrey,
              fontWeight: FontWeight.w600)),
        ),
      ]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Text(
        _st == _State.counting
            ? 'Lepas untuk membatalkan...'
            : 'Tahan tombol 3 detik untuk kirim sinyal darurat',
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13, color: C.textGrey, height: 1.5),
      ),
    );
  }

  Widget _buildQuickDial() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _DialBtn('🚔  Polisi', '110', C.primary)),
          const SizedBox(width: 12),
          Expanded(child: _DialBtn('🚑  Ambulans', '119', C.teal)),
        ],
      ),
    );
  }

  void _showAddContact(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: C.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _AddContactSheet(),
    );
  }
}

enum _State { idle, counting, active }

class _Contact {
  final String name, number, emoji;
  const _Contact(this.name, this.number, this.emoji);
}

class _ContactRow extends StatelessWidget {
  final _Contact contact;
  const _ContactRow({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: C.soft,
              borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(contact.emoji,
              style: const TextStyle(fontSize: 17))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: C.textDark)),
                Text(contact.number,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: C.textGrey)),
              ],
            ),
          ),
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: C.tealSoft,
              borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.phone_rounded,
              color: C.teal, size: 16),
          ),
        ],
      ),
    );
  }
}

class _DialBtn extends StatelessWidget {
  final String label, number;
  final Color color;
  const _DialBtn(this.label, this.number, this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: C.textDark)),
            const SizedBox(height: 2),
            Text(number,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15, fontWeight: FontWeight.w800,
                color: color)),
          ],
        ),
      ),
    );
  }
}

class _AddContactSheet extends StatelessWidget {
  final _nameCtrl = TextEditingController();
  final _numCtrl  = TextEditingController();
  _AddContactSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: C.border,
              borderRadius: BorderRadius.circular(2)),
          )),
          const SizedBox(height: 20),
          Text('Tambah Kontak Darurat',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17, fontWeight: FontWeight.w800,
              color: C.textDark)),
          const SizedBox(height: 20),
          _Field('Nama', 'Contoh: Mama', _nameCtrl),
          const SizedBox(height: 12),
          _Field('Nomor HP', '+62 812-xxxx-xxxx', _numCtrl,
            type: TextInputType.phone),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: C.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('Simpan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15, fontWeight: FontWeight.w700,
                  color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label, hint;
  final TextEditingController ctrl;
  final TextInputType type;
  const _Field(this.label, this.hint, this.ctrl,
    {this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(
          fontSize: 12, color: C.textGrey,
          fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: C.textGrey, fontSize: 14),
            filled: true, fillColor: C.soft,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: C.primary)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
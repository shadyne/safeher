import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  // Dummy chat rooms
  final _rooms = [
    _Room(
      'Komunitas SafeHer Bandung',
      'Ada yang tau rute aman dari Dago ke Dipatiukur?',
      '12:34',
      true,
      3,
      'assets/g1.png',
    ),
    _Room(
      'Mahasiswi UNPAD 2024',
      'Terima kasih semua sudah peduli 💜',
      '11:05',
      false,
      0,
      null,
    ),
    _Room(
      'Hotline Darurat',
      'Layanan aktif 24/7 · Respon < 2 menit',
      '09:00',
      true,
      1,
      null,
    ),
    _Room(
      'Tips & Berbagi',
      'Tina: Ini screenshot kondisi halte jam 10 mlm',
      '08:22',
      false,
      5,
      null,
    ),
  ];

  final _dms = [
    _Dm('Siti Rahayu', 'Makasih ya tadi sudah dibantu!', '14:02', true, 2),
    _Dm('Admin SafeHer', 'Laporanmu sudah diverifikasi ✅', '10:30', false, 0),
    _Dm('Relawan 081xxx', 'Baik, saya segera ke lokasi.', '09:11', false, 0),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() {}));
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
      appBar: AppBar(
        backgroundColor: C.surface,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: C.textSec,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Row(
          children: [
            const Icon(Icons.chat_bubble_rounded, color: C.pink, size: 20),
            const SizedBox(width: 8),
            Text('Komunitas & Chat', style: TS.h(20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: C.textSec, size: 20),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            color: C.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
                  Tab(text: 'Komunitas'),
                  Tab(text: 'Pesan Langsung'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _RoomList(rooms: _rooms),
          _DmList(dms: _dms),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChat(context),
        backgroundColor: C.pink,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.edit_rounded, size: 22),
      ),
    );
  }

  void _showNewChat(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: C.surface2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
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
            Text('Mulai Chat Baru', style: TS.h(17)),
            const SizedBox(height: 20),
            _NewChatBtn(
              icon: Icons.groups_rounded,
              title: 'Bergabung Komunitas',
              sub: 'Temukan grup di kotamu',
              color: C.info,
              onTap: () => Navigator.pop(ctx),
            ),
            const SizedBox(height: 10),
            _NewChatBtn(
              icon: Icons.person_search_rounded,
              title: 'Cari Relawan',
              sub: 'Hubungi relawan terdekat',
              color: C.safe,
              onTap: () => Navigator.pop(ctx),
            ),
            const SizedBox(height: 10),
            _NewChatBtn(
              icon: Icons.support_agent_rounded,
              title: 'Hubungi Admin',
              sub: 'Butuh bantuan? Kami siap',
              color: C.pink,
              onTap: () => Navigator.pop(ctx),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _RoomList extends StatelessWidget {
  final List<_Room> rooms;
  const _RoomList({required this.rooms});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: rooms.length,
      itemBuilder: (_, i) => _RoomTile(
        room: rooms[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatRoomScreen(roomName: rooms[i].name),
          ),
        ),
      ),
    );
  }
}

class _DmList extends StatelessWidget {
  final List<_Dm> dms;
  const _DmList({required this.dms});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dms.length,
      itemBuilder: (_, i) => _DmTile(
        dm: dms[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatRoomScreen(roomName: dms[i].name),
          ),
        ),
      ),
    );
  }
}

class _Room {
  final String name, preview, time;
  final bool unread;
  final int badge;
  final String? avatar;
  const _Room(
    this.name,
    this.preview,
    this.time,
    this.unread,
    this.badge,
    this.avatar,
  );
}

class _Dm {
  final String name, preview, time;
  final bool unread;
  final int badge;
  const _Dm(this.name, this.preview, this.time, this.unread, this.badge);
}

class _RoomTile extends StatelessWidget {
  final _Room room;
  final VoidCallback onTap;
  const _RoomTile({required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: C.border, width: 0.5)),
        ),
        child: Row(
          children: [
            // Avatar grup
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF533AB7), C.pink],
                ),
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          style: room.unread
                              ? TS.b(14)
                              : TS.r(14, c: C.textPri),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(room.time, style: TS.r(11)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.preview,
                          style: TS.r(12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (room.badge > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: C.pink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${room.badge}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DmTile extends StatelessWidget {
  final _Dm dm;
  final VoidCallback onTap;
  const _DmTile({required this.dm, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials = dm.name
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2)
        .join();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: C.border, width: 0.5)),
        ),
        child: Row(
          children: [
            // Avatar dengan inisial
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: C.pinkSoft,
                border: Border.all(color: C.pink.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(initials, style: TS.h(16, c: C.pink)),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dm.name,
                          style: dm.unread ? TS.b(14) : TS.r(14, c: C.textPri),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(dm.time, style: TS.r(11)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dm.preview,
                          style: TS.r(12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (dm.badge > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: C.pink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${dm.badge}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewChatBtn extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final Color color;
  final VoidCallback onTap;
  const _NewChatBtn({
    required this.icon,
    required this.title,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TS.b(13)),
                  Text(sub, style: TS.r(11)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: C.textMuted, size: 14),
          ],
        ),
      ),
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  final String roomName;
  const ChatRoomScreen({super.key, required this.roomName});
  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  final _msgs = <_Msg>[
    _Msg(
      'Admin SafeHer',
      'Selamat datang di komunitas! Silakan berbagi info rute aman 💜',
      false,
      '09:00',
    ),
    _Msg(
      'Kirana',
      'Halo semua! Ada yang tau jalur aman dari UNPAD ke Dipatiukur malam hari?',
      true,
      '10:15',
    ),
    _Msg(
      'Siti',
      'Lewat jalan Ir. H. Djuanda lebih aman kak, ada banyak warkop yang buka.',
      false,
      '10:17',
    ),
    _Msg('Kirana', 'Makasih Siti! Sangat membantu 🙏', true, '10:18'),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() => _msgs.add(_Msg('Kamu', t, true, _now())));
    _ctrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _now() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.roomName, style: TS.b(14)),
            Text('34 anggota · 5 online', style: TS.r(11, c: C.safe)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: C.textSec,
              size: 22,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _msgs.length,
              itemBuilder: (_, i) => _MsgBubble(msg: _msgs[i]),
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 14,
      ),
      decoration: BoxDecoration(
        color: C.surface,
        border: Border(top: BorderSide(color: C.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: C.surface2,
              shape: BoxShape.circle,
              border: Border.all(color: C.border),
            ),
            child: const Icon(Icons.add_rounded, color: C.textMuted, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: C.surface2,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: C.border),
              ),
              child: TextField(
                controller: _ctrl,
                style: GoogleFonts.inter(color: C.textPri, fontSize: 14),
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: GoogleFonts.inter(
                    color: C.textMuted,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [C.pinkLight, C.pinkDark]),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String sender, text, time;
  final bool isMe;
  const _Msg(this.sender, this.text, this.isMe, this.time);
}

class _MsgBubble extends StatelessWidget {
  final _Msg msg;
  const _MsgBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        child: Column(
          crossAxisAlignment: msg.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!msg.isMe)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 3),
                child: Text(msg.sender, style: TS.r(10, c: C.pink)),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: msg.isMe
                    ? const LinearGradient(
                        colors: [C.pinkLight, C.pinkDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: msg.isMe ? null : C.surface2,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: msg.isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: msg.isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
                border: msg.isMe
                    ? null
                    : Border.all(color: C.border, width: 0.5),
              ),
              child: Text(
                msg.text,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: msg.isMe ? Colors.white : C.textPri,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
              child: Text(msg.time, style: TS.r(10)),
            ),
          ],
        ),
      ),
    );
  }
}

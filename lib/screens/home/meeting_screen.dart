import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_conference/screens/auth/splash_wrapper.dart';
import 'package:intl/intl.dart';

class MeetingScreen extends StatelessWidget {
  final String meetingId;

  MeetingScreen({super.key, required this.meetingId});
  String meetingTitle = "Team Sync Meeting";
  late DateTime meetingDate = DateTime.now();
  late Duration callDuration = Duration(minutes: 30);
  late List<String> peers = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Frank",
    "Grace",
    "Heidi",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add your drawer content here
        child: Center(child: Text("Drawer content")),
      ),
      appBar: _buildAppBar(context),
      body: MainContainer(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // 2. Call Info (duration + meeting ID)
                  _buildCallInfo(),

                  // 3. Peers Grid
                  Expanded(child: _buildPeersLayout()),
                  // 4. Fixed Bottom Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Custom AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Color.fromRGBO(242, 242, 242, 1), // icon color
        ),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            meetingTitle,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            DateFormat('MMM dd, yyyy').format(meetingDate),
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Color.fromRGBO(242, 242, 242, 1), // icon color
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ),
      ],
    );
  }

  // 2. Call Duration + Copy Meeting ID
  Widget _buildCallInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _badge(
            "${callDuration.inMinutes.remainder(60)}:${(callDuration.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: meetingId));
            },
            child: _badge(meetingId, icon: Icons.copy),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.black)),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, color: Colors.blue, size: 14),
          ],
        ],
      ),
    );
  }

  // 3. Peers Layout
  Widget _buildPeersLayout() {
    final int count = peers.length;

    if (count == 1) {
      return _peerTile(peers[0], isMain: true);
    } else if (count == 4) {
      return Column(
        children: [
          Expanded(
            child: Row(children: [_peerTile(peers[0]), _peerTile(peers[1])]),
          ),
          Expanded(
            child: Row(children: [_peerTile(peers[2]), _peerTile(peers[3])]),
          ),
        ],
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: peers.map((p) => _peerTile(p)).toList(),
        ),
      );
    }
  }

  Widget _peerTile(String peerId, {bool isMain = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(peerId, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  // 4. Fixed Bottom Buttons
  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionButton(icon: Icons.mic),
          _ActionButton(icon: Icons.videocam),
          _ActionButton(icon: Icons.message),
          _ActionButton(icon: Icons.fiber_manual_record),
          _ActionButton(icon: Icons.more_horiz),
          IconButton(
            style: IconButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  14,
                ), // Square with slight rounding
              ),
            ),
            onPressed: () {},
            icon: Icon(Icons.call_end, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final bool isDanger;

  const _ActionButton({required this.icon, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1), // icon color
      ),
      onPressed: () {},
      icon: Icon(icon, color: isDanger ? Colors.white : Colors.black),
    );
  }
}

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_conference/core/services/agora_service.dart';
import 'package:flutter_video_conference/screens/auth/splash_wrapper.dart';
import 'package:intl/intl.dart';

class JoinMeetingScreen extends StatefulWidget {
  final String meetingId;

  const JoinMeetingScreen({super.key, required this.meetingId});

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  final AgoraService _agoraService = AgoraService();
  bool _isInitialized = false;
  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    await _agoraService.initAgora();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _agoraService.dispose();
    super.dispose();
  }

  String meetingTitle = "Team Sync Meeting";

  late DateTime meetingDate = DateTime.now();

  late Duration callDuration = Duration(minutes: 30);

  // late List<String> peers = ["Alice", "Bob"];

  late Map<int, String> peers = {
    0: "Alice",
    1: "Bob",
    2: "Charlie",
    3: "David",
    // 5: "Eve",
    // 6: "Frank",
    // 7: "Grace",
    // 8: "Heidi",
  };

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
              // 2. Call Info (duration + meeting ID)
              _isInitialized
                  ? Column(
                      children: [
                        _buildCallInfo(),
                        // 3. Peers Grid
                        Expanded(child: _buildPeersLayout()),
                        // 4. Fixed Bottom Action Buttons
                        _buildActionButtons(context),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
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
              Clipboard.setData(ClipboardData(text: widget.meetingId));
            },
            child: _badge(widget.meetingId, icon: Icons.copy),
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
    final entries = peers.entries.toList();

    if (_agoraService.engine == null) {
      return Center(
        child: Text(
          "Agora Engine not initialized",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (entries.length == 1) {
      return _peerTile(entries[0].key, isMain: true);
    }
    if (entries.length == 2) {
      return Column(
        children: [
          _peerTile(entries[0].key, isMain: true),
          _peerTile(entries[1].key),
        ],
      );
    }
    if (entries.length == 3) {
      return Column(
        children: [
          _peerTile(entries[0].key, isMain: true),
          Expanded(
            child: Row(
              children: [_peerTile(entries[1].key), _peerTile(entries[2].key)],
            ),
          ),
        ],
      );
    } else if (entries.length == 4) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _peerTile(entries[0].key, isMain: true),
                _peerTile(entries[1].key),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [_peerTile(entries[2].key), _peerTile(entries[3].key)],
            ),
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
          children: entries.map((entry) {
            print(
              "Peer ID: ${entry.key}, Name: ${entry.value}, isMain: ${entry.key == 0}",
            );
            return _peerTile(entry.key, isMain: entry.key == 0);
          }).toList(),
        ),
      );
    }
  }

  Widget _peerTile(int peerId, {bool isMain = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            peerId.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Widget _peerTile(int peerId, {bool isMain = false}) {
  //   return Container(
  //     margin: const EdgeInsets.all(4),
  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
  //     child: isMain
  //         ? AgoraVideoView(
  //             controller: VideoViewController(
  //               rtcEngine: _agoraService.engine!,
  //               canvas: VideoCanvas(
  //                 uid: peerId,
  //                 renderMode: RenderModeType.renderModeHidden,
  //               ),
  //             ),
  //           )
  //         : AgoraVideoView(
  //             controller: VideoViewController.remote(
  //               connection: RtcConnection(
  //                 channelId: widget.meetingId,
  //                 localUid: peerId,
  //               ),
  //               rtcEngine: _agoraService.engine!,
  //               canvas: VideoCanvas(
  //                 uid: peerId,
  //                 renderMode: RenderModeType.renderModeFit,
  //               ),
  //             ),
  //           ),
  //   );
  // }

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

  const _ActionButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1), // icon color
      ),
      onPressed: () {},
      icon: Icon(icon, color: Colors.black),
    );
  }
}

// lib/services/agora_service.dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  static const String _appId = "30d443b8b89b4e2ab2db81a116720deb";
  static const String _channelName = "test_channel";
  static const String _token = ""; // أو token صالح إذا خدمتي به

  RtcEngine? _engine;

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine?.initialize(RtcEngineContext(appId: _appId));

    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("Joined channel: ${connection.channelId}");
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("Remote user joined: $remoteUid");
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("Remote user left: $remoteUid");
        },
      ),
    );

    await _engine?.enableVideo();
    await _engine?.startPreview();
    await _engine?.joinChannel(
      token: _token,
      channelId: _channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  RtcEngine? get engine => _engine;

  Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
  }
}

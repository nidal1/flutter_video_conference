import 'package:flutter/material.dart';
import 'package:flutter_video_conference/models/meeting_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'positioned_avatar.dart';
import 'more_participants_avatar.dart';

class MeetingCard extends StatelessWidget {
  final MeetingModel meetingData;
  const MeetingCard({super.key, required this.meetingData});

  Color get cardColor {
    switch (meetingData.cardColor) {
      case 'blue':
        return const Color(0xFF694cf1);
      case 'orange':
        return const Color(0xFFFFCF5B);
      case 'green':
        return const Color(0xFFDCE98C);
      case 'black':
        return const Color(0xFF1e1e1e);
      default:
        return Colors.white;
    }
  }

  Color get textColor {
    switch (meetingData.cardColor) {
      case 'blue':
      case 'black':
        return Colors.white;
      case 'orange':
      case 'green':
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    int lastIndex = 0;

    final duration = meetingData.startTime!.difference(DateTime.now());
    final hours = duration.inHours;

    return Card(
      elevation: 1,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top badges (date + time)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildBadge(
                      context,
                      DateFormat('MMM, d').format(meetingData.startTime!),
                    ),

                    const SizedBox(width: 8),
                    _buildBadge(
                      context,
                      '${DateFormat('HH:mm').format(meetingData.startTime!)}-${DateFormat('HH:mm').format(meetingData.endTime!)}',
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              meetingData.title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${meetingData.owner} meeting room",
                  style: TextStyle(
                    color: textColor.withAlpha((0.7 * 255).toInt()),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "Start in $hours hours",
                  style: TextStyle(
                    color: textColor.withAlpha((0.7 * 255).toInt()),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Bottom badges (participants + duration)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  height: 34,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    fit: StackFit.loose,
                    children: [
                      ...(meetingData.participants?.map((p) {
                            lastIndex++;
                            return PositionedAvatar(
                              imagePath: 'assets/images/$p.png',
                              left: meetingData.participants!.indexOf(p) * 16.0,
                              border: Border.all(
                                color: Colors.black45,
                                width: 1,
                              ),
                            );
                          }).toList() ??
                          []),

                      MoreParticipantsAvatar(
                        left: lastIndex * 16.0,
                        label: '+5',
                        backgroundColor: const Color(0xFF263238),
                        border: Border.all(color: Colors.black45, width: 1),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    context.push('/meeting/${meetingData.id}');
                  },
                  label: Text(
                    "Join Now",
                    style: TextStyle(color: Colors.black),
                  ),
                  icon: Icon(
                    Icons.arrow_right_alt_rounded,
                    color: Colors.black,
                  ),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Meeting ID",
                  style: TextStyle(
                    color: textColor.withAlpha((0.7 * 255).toInt()),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  meetingData.id!,
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MeetingCard extends StatelessWidget {
  const MeetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top badges (date + time)
            Row(
              children: [
                _buildBadge(context, 'May 25'),
                const SizedBox(width: 8),
                _buildBadge(context, '18:00'),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Weekly meetings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Murad's Hossain meeting room",
                  style: TextStyle(color: Colors.grey),
                ),
                Text("Start in 3 hours", style: TextStyle(color: Colors.blue)),
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
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

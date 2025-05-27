import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_video_conference/models/meeting_model.dart';

class MeetingService {
  final CollectionReference meetings = FirebaseFirestore.instance.collection(
    'meetings',
  );

  Future<List<MeetingModel>> fetchMeetingsByStatus(String status) async {
    final snapshot = await meetings.where('status', isEqualTo: status).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Include the document ID
      return MeetingModel.fromMap(data);
    }).toList();
  }
}

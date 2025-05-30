import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingModel {
  String? id;
  String? title;
  String? owner;
  DateTime? startTime;
  DateTime? endTime;
  String? status; // e.g. 'ongoing', 'upcoming', etc.
  String? cardColor;
  List<Participant>? participants;

  MeetingModel({
    this.id,
    this.title,
    this.owner,
    this.startTime,
    this.endTime,
    this.status,
    this.cardColor,
    this.participants,
  });

  factory MeetingModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return MeetingModel(
      id: id ?? map['id'],
      title: map['title'],
      owner: map['owner'],
      status: map['status'],
      cardColor: map['cardColor'],
      startTime: (map['startTime'] as Timestamp?)?.toDate(),
      endTime: (map['endTime'] as Timestamp?)?.toDate(),
      participants: (map['participants'] as List<dynamic>?)
          ?.map((e) => Participant.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'owner': owner,
      'status': status,
      'cardColor': cardColor,
      'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'participants': participants?.map((e) => e.toMap()).toList(),
    };
  }
}

class Participant {
  final String uid;
  final String avatar;

  Participant({required this.uid, required this.avatar});

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(uid: map['uid'], avatar: map['avatar']);
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'avatar': avatar};
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingModel {
  String? id;
  String? title;
  String? owner;
  DateTime? startTime;
  DateTime? endTime;
  String? status; // Optional field for meeting status
  String? cardColor; // Optional field for card color
  List<String>? participants;

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

  // Factory method to create a MeetingModel from a map
  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
      id: map['id'],
      title: map['title'],
      owner: map['owner'],
      startTime: map['startTime'] is Timestamp
          ? (map['startTime'] as Timestamp).toDate()
          : map['startTime'] is String
          ? DateTime.parse(map['startTime'])
          : map['startTime'] as DateTime?,
      endTime: map['endTime'] is Timestamp
          ? (map['endTime'] as Timestamp).toDate()
          : map['endTime'] is String
          ? DateTime.parse(map['endTime'])
          : map['endTime'] as DateTime?,
      cardColor: map['cardColor'],
      participants: List<String>.from(map['participants'] ?? []),
    );
  }

  // Method to convert MeetingModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'owner': owner,
      'status': status, // Optional field for meeting status
      'cardColor': cardColor, // Optional field for card color
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'participants': participants,
    };
  }
}

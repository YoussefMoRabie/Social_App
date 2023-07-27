// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String message;
  final String senderName;
  final Timestamp timestamp;
  Message({
    required this.senderId,
    required this.senderName,
    required this.recieverId,
    required this.message,
    required this.timestamp,
  });

  Message copyWith({
    String? senderId,
    String? recieverId,
    String? senderName,
    String? message,
    Timestamp? timestamp,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      recieverId: recieverId ?? this.recieverId,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp,
    };
  }

  // factory Message.fromMap(Map<String, dynamic> map) {
  //   return Message(
  //     senderId: map['senderId'] as String,
  //     recieverId: map['recieverId'] as String,
  //     message: map['message'] as String,
  //     timestamp: Timestamp as String,
  //   );
  // }

  @override
  String toString() {
    return 'Message(senderId: $senderId, recieverId: $recieverId, message: $message, timestamp: $timestamp)';
  }
}

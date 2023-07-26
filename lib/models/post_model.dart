// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PostModel {
  final String id;
  final String content;
  final String createdAt;
  final String userId;
  final List<String> likes;
  final int commentCount;
  PostModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.likes,
    required this.commentCount,
  });

   

  PostModel copyWith({
    String? id,
    String? content,
    String? createdAt,
    String? userId,
    List<String>? likes,
    int? commentCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'createdAt': createdAt,
      'userId': userId,
      'likes': likes,
      'commentCount': commentCount,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      content: map['content'] as String,
      createdAt: map['createdAt'] as String,
      userId: map['userId'] as String,
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      commentCount: map['commentCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, content: $content, createdAt: $createdAt, userId: $userId, likes: $likes, commentCount: $commentCount)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.content == content &&
      other.createdAt == createdAt &&
      other.userId == userId &&
      listEquals(other.likes, likes) &&
      other.commentCount == commentCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      userId.hashCode ^
      likes.hashCode ^
      commentCount.hashCode;
  }
}

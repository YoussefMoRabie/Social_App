import 'dart:convert';

import 'package:flutter/foundation.dart';

class PostModel {
  final String id;
  final String content;
  final String createdAt;
  final String userId;
  final List<String> likes;
  final List<String> comments;
  PostModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.likes,
    required this.comments,
  });

  PostModel copyWith({
    String? id,
    String? content,
    String? createdAt,
    String? userId,
    List<String>? likes,
    List<String>? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'createdAt': createdAt,
      'userId': userId,
      'likes': likes,
      'comments': comments,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      content: map['content'] as String,
      createdAt: map['createdAt'] as String,
      userId: map['userId'] as String,
      likes: List<String>.from(map['likes'] as List<String>),
      comments: List<String>.from(
        (map['comments'] as List<String>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, content: $content, createdAt: $createdAt, userId: $userId, likes: $likes, comments: $comments)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.userId == userId &&
        listEquals(other.likes, likes) &&
        listEquals(other.comments, comments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        userId.hashCode ^
        likes.hashCode ^
        comments.hashCode;
  }
}

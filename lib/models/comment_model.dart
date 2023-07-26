// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CommentModel {
  final String id;
  final String imageUrl;
  final String userId;
  final String postId;
  final String createdAt;
  final String username;
  final List<String> upvotes;
  final List<String> downvotes;
  CommentModel({
    required this.id,
    required this.imageUrl,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.username,
    required this.upvotes,
    required this.downvotes,
  });


  CommentModel copyWith({
    String? id,
    String? imageUrl,
    String? userId,
    String? postId,
    String? createdAt,
    String? username,
    List<String>? upvotes,
    List<String>? downvotes,
  }) {
    return CommentModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'userId': userId,
      'postId': postId,
      'createdAt': createdAt,
      'username': username,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      userId: map['userId'] as String,
      postId: map['postId'] as String,
      createdAt: map['createdAt'] as String,
      username: map['username'] as String,
      upvotes: List<String>.from((map['upvotes'] as List<dynamic>)),
      downvotes: List<String>.from((map['downvotes'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, imageUrl: $imageUrl, userId: $userId, postId: $postId, createdAt: $createdAt, username: $username, upvotes: $upvotes, downvotes: $downvotes)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.imageUrl == imageUrl &&
      other.userId == userId &&
      other.postId == postId &&
      other.createdAt == createdAt &&
      other.username == username &&
      listEquals(other.upvotes, upvotes) &&
      listEquals(other.downvotes, downvotes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      imageUrl.hashCode ^
      userId.hashCode ^
      postId.hashCode ^
      createdAt.hashCode ^
      username.hashCode ^
      upvotes.hashCode ^
      downvotes.hashCode;
  }
}

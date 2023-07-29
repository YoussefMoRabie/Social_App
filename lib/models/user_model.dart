import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String profilePic;
  final String uid;
  final int score;
  final List<String> followers;
  final List<String> following;
  final int validityOfKey;
  final String key;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.score,
    required this.followers,
    required this.following,
    required this.validityOfKey,
    required this.key,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? uid,
    int? score,
    List<String>? followers,
    List<String>? following,
    int? validityOfKey,
    String? key,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      score: score ?? this.score,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      validityOfKey: validityOfKey ?? this.validityOfKey,
      key: key ?? this.key,
    );
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'score': score,
      'followers': followers,
      'following': following,
      'validityOfKey': validityOfKey,
      'key': key,
    };
  }

  factory UserModel.empty() {
    return UserModel(
      name: "",
      profilePic: "https://firebasestorage.googleapis.com/v0/b/chatt-a11a8.appspot.com/o/users%2Fdefault-image.png?alt=media&token=2a5597cf-a117-4da7-8acc-26632fa815c2",
      uid: "",
      score: 0,
      followers: [],
      following: [],
      validityOfKey: 0,
      key: "",
    );
  }


  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      score: map['score'] as int,
      followers: List<String>.from((map['followers'] as List<dynamic>)),
      following: List<String>.from((map['following'] as List<dynamic>)),
      validityOfKey: map['validityOfKey'] as int,
      key: map['key'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, uid: $uid, score: $score, followers: $followers, following: $following, validityOfKey: $validityOfKey, key: $key)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePic == profilePic &&
        other.uid == uid &&
        other.score == score &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.validityOfKey == validityOfKey &&
        other.key == key;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        uid.hashCode ^
        score.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        validityOfKey.hashCode ^
        key.hashCode;
  }
}

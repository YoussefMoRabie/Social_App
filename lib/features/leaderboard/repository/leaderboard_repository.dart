import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/models/user_model.dart';

import '../../../core/providers/firebase_providers.dart';

final leaderboardRepositoryProvider = Provider(
  (ref) => LeaderboardRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

class LeaderboardRepository {
  final FirebaseFirestore _firestore;
  LeaderboardRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<UserModel>> getLeaderboard() {
    return _firestore
        .collection('users')
        .orderBy('score', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }
}

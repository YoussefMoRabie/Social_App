import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:social_app/core/common/firebase_constants.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/providers/firebase_providers.dart';
import 'package:social_app/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firebaseAuth: ref.read(authProvider),
    firebaseFirestore: ref.read(firestoreProvider)));

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthRepository(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

  //sign in
  FutureEither<UserModel> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      UserModel user = await getUserData(userCredential.user!.uid);
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //sign up
  FutureEither<UserModel> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel user = UserModel(
          name: userCredential.user!.displayName ?? "",
          profilePic: userCredential.user!.photoURL ?? "",
          uid: userCredential.user!.uid,
          score: 0);
      await _users.doc(userCredential.user!.uid).set(user.toMap());
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel> getUserData(String uid) async {
    final snapshot = await _users.doc(uid).get();
    UserModel userModel =
        UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    return userModel;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:social_app/core/common/firebase_constants.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/providers/firebase_providers.dart';
import 'package:social_app/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    ref: ref,
    firebaseAuth: ref.read(authProvider),
    firebaseFirestore: ref.read(firestoreProvider)));

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final Ref _ref;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required Ref ref,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _ref = ref;

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  //sign in
  FutureEither<UserModel> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      UserModel user = await getUserData(userCredential.user!.uid).first;
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

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  void logout() async {
    await _firebaseAuth.signOut();
  }
}

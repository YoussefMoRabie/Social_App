import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:social_app/core/common/firebase_constants.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/core/providers/firebase_providers.dart';
import 'package:social_app/core/types/key_exception.dart';
import 'package:social_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    ref: ref,
    firebaseAuth: ref.read(authProvider),
    firebaseFirestore: ref.read(firestoreProvider)));

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required Ref ref,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();
  Uuid uuid = const Uuid();

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
  FutureEither<UserModel> signUp(
      String name , String email, String password, String key,) async {
    try {
      //First: look for a friend who has this key
      final foundUser =
          await _users.where("key", isEqualTo: key).limit(1).get();
      UserModel friendData =
          UserModel.fromMap(foundUser.docs[0].data() as Map<String, dynamic>);
      if (friendData.validityOfKey > 0) {
        friendData =
            friendData.copyWith(validityOfKey: friendData.validityOfKey - 1);
        _users.doc(friendData.uid).update(friendData.toMap());
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel user = UserModel(
          name: userCredential.user!.displayName ?? name,
          profilePic: userCredential.user!.photoURL ?? "",
          uid: userCredential.user!.uid,
          followers: [],
          following: [],
          key: uuid.v1(),
          validityOfKey: 2,
          score: 0,
        );
        await _users.doc(userCredential.user!.uid).set(user.toMap());
        return right(user);
      } else {
        throw KeyException(
            "This key is not valid, try to ask a friend to give you a key");
      }
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

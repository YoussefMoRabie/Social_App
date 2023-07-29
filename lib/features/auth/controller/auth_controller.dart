import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/core/providers/storage_repository_provider.dart';
import 'package:social_app/features/auth/repository/auth_repository.dart';
import 'package:social_app/models/user_model.dart';
import 'package:uuid/uuid.dart';
import '../../../core/common/error_snackbar.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.read(authRepositoryProvider),
        ref: ref,
        storageRepository: ref.watch(storageRepositoryProvider)));

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  AuthController(
      {required AuthRepository authRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _authRepository = authRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void signIn(BuildContext context, String email, String password) async {
    state = true;
    final data = await _authRepository.signIn(email, password);
    data.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).state = r);
    state = false;
  }

  void signUp(BuildContext context, String name, String email, String password,
      String key) async {
    state = true;
    final data = await _authRepository.signUp(name, email, password, key);

    data.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).state = r);
    state = false;
  }

  void updateUsername(
    UserModel currentUser,
    String username,
    BuildContext context,
  ) async {
    state = true;
    final user = UserModel(
        name: username,
        profilePic: currentUser.profilePic,
        uid: currentUser.uid,
        score: currentUser.score,
        followers: currentUser.followers,
        following: currentUser.following,
        validityOfKey: currentUser.validityOfKey,
        key: currentUser.key);

    final data = await _authRepository.updateUsername(user);
    state = false;
    data.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);

      context.pop();
    });
  }

  void updateImg(File? img, BuildContext context, UserModel currentUser) async {
    state = true;
    if (img != null) {
      final imageUpload = await _storageRepository.storeFile(
        path: 'users/${currentUser.uid}',
        id: const Uuid().v4(),
        file: img,
      );
      final imageUrl = imageUpload.fold(
        (l) => "",
        (r) => r,
      );
      final user = UserModel(
        name: currentUser.name,
        profilePic: imageUrl,
        uid: currentUser.uid,
        score: currentUser.score,
        followers: currentUser.followers,
        following: currentUser.following,
        validityOfKey: currentUser.validityOfKey,
        key: currentUser.key,
      );

      final data = await _authRepository.updateImg(user);
      state = false;
      data.fold((l) => showSnackBar(context, l.message), (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        context.pop();
      });
    }
  }

  void logout() {
    _authRepository.logout();
    _ref.read(userProvider.notifier).update((state) => null);
  }
}

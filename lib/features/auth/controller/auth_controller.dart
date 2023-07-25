import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/auth/repository/auth_repository.dart';
import 'package:social_app/models/user_model.dart';
import '../../../core/common/error_snackbar.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = Provider((ref) =>
    AuthController(authRepository: ref.read(authRepositoryProvider), ref: ref));

class AuthController {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref;

  void signIn(BuildContext context, String email, String password) async {
    final data = await _authRepository.signIn(email, password);
    data.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).state = r);
  }

  void signUp(BuildContext context, String email, String password) async {
    final data = await _authRepository.signUp(email, password);
    data.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).state = r);
  }
}

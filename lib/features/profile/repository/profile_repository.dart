import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/models/user_model.dart';

import '../../auth/controller/auth_controller.dart';

final profileRepositoryProvider = Provider((ref) =>
    ProfileRepository(currentUser: ref.read(userProvider.notifier).state!));

class ProfileRepository {
  final UserModel _currentUser;
  ProfileRepository({required UserModel currentUser})
      : _currentUser = currentUser;

  void updateProfile() {
    print(_currentUser.uid);
  }
}

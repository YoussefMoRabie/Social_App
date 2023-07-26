import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/profile/repository/profile_repository.dart';

final profileControllerProvider =
    Provider((ref) => ProfileController(ref.read(profileRepositoryProvider)));

class ProfileController {
  final ProfileRepository _profileRepository;

  ProfileController(ProfileRepository profileRepository)
      : _profileRepository = profileRepository;
  void prompt() {
    _profileRepository.updateProfile();
  }
}

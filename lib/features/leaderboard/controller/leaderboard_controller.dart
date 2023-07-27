import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/leaderboard/repository/leaderboard_repository.dart';

import '../../../models/user_model.dart';

final leaderboardControllerProvider =
    StateNotifierProvider<LeaderboardController, bool>((ref) {
  final leaderboardRepository = ref.watch(leaderboardRepositoryProvider);
  return LeaderboardController(
    leaderboardRepository: leaderboardRepository,
  );
});

final leaderboardProvider = StreamProvider<List<UserModel>>((ref) {
  final controller = ref.watch(leaderboardControllerProvider.notifier);
  return controller.getLeaderboard();
});

class LeaderboardController extends StateNotifier<bool> {
  final LeaderboardRepository _leaderboardRepository;
  LeaderboardController({
    required LeaderboardRepository leaderboardRepository,
  })  : _leaderboardRepository = leaderboardRepository,
        super(false);

  Stream<List<UserModel>> getLeaderboard() {
    return _leaderboardRepository.getLeaderboard();
  }
}

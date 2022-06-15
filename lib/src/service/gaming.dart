import 'package:games_services/games_services.dart';
import 'package:minesweeper/src/model/board_data.dart';

const _leaderboardIDs = {
  '9x9_10': 'CgkIg52nveAVEAIQAQ',
};

class GamingService {
  static GamingService? _instance;

  GamingService._();

  factory GamingService() {
    _instance ??= GamingService._();
    return _instance!;
  }

  Future<void> _signIn() async {
    final isSignedIn = await GamesServices.isSignedIn;
    if (!isSignedIn) {
      await GamesServices.signIn();
    }
  }

  bool canSubmitScore(BoardData boardData) =>
      _leaderboardIDs.containsKey(boardData.boardStr);

  Future<void> saveScore(int score, BoardData boardData) async {
    await _signIn();
    final leaderboardID = _leaderboardIDs[boardData.boardStr];
    if (leaderboardID != null) {
      await GamesServices.submitScore(
        score: Score(
          androidLeaderboardID: leaderboardID,
          value: score,
        ),
      );
    }
  }
}

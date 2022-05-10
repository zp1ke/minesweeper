import 'package:games_services/games_services.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _gamingIDKey = 'gamingID';
const _leaderboardTime_9x9_10ID = 'CgkIg52nveAVEAIQAQ';

class GamingService {
  static GamingService? _instance;

  String? _gamingID;

  GamingService._();

  factory GamingService() {
    _instance ??= GamingService._();
    return _instance!;
  }

  Future<void> init() async {
    if (_gamingID == null) {
      final preferences = await SharedPreferences.getInstance();
      _gamingID = preferences.getString(_gamingIDKey);
      _gamingID ??= await GamesServices.signIn();
    }
  }

  Future<void> saveScore(int score, BoardData boardData) async {
    final leaderboardID = _leaderboardID(boardData);
    if (leaderboardID != null) {
      await GamesServices.submitScore(
        score: Score(
          androidLeaderboardID: leaderboardID,
          value: score,
        ),
      );
    }
  }

  _leaderboardID(BoardData boardData) {
    switch (boardData.boardStr) {
      case '9x9_10': return _leaderboardTime_9x9_10ID;
    }
    return null;
  }
}

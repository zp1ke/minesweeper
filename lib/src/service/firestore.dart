import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minezweeper/src/model/user_score.dart';

const _scoresKey = 'scores';
const _usersScoresKey = 'users-scores';
const _topTenKey = 'top-ten';

/// Reads and writes score documents.
class FirestoreService {
  /// Returns the process-wide Firestore service.
  factory FirestoreService() {
    _instance ??= FirestoreService._();
    return _instance!;
  }
  FirestoreService._();

  static FirestoreService? _instance;

  /// Board keys that already have a score list.
  Future<List<String>> fetchScoresIDs() async {
    final db = FirebaseFirestore.instance;
    final scoresIDs = db.collection(_scoresKey);
    final data = await scoresIDs.get();
    return data.docs.map((e) => e.id).toList();
  }

  /// Top scores for [scoreID], fastest first.
  Future<List<UserScore>> fetchScores(String scoreID) async {
    final db = FirebaseFirestore.instance;
    final data = await db
        .collection(_scoresKey)
        .doc(scoreID)
        .collection(_topTenKey)
        .get();
    final list = <UserScore>[];
    for (final snapshot in data.docs) {
      final userScore = UserScore.parse(snapshot.id, snapshot.data());
      if (userScore != null) {
        list.add(userScore);
      }
    }
    list.sort((a, b) => a.score.compareTo(b.score));
    return list;
  }

  /// This user's saved time for [scoreID], if any.
  Future<UserScore?> fetchUserScore({
    required String userID,
    required String scoreID,
  }) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection(_usersScoresKey)
        .doc(userID)
        .collection(_scoresKey)
        .doc(scoreID)
        .get();
    if (snapshot.exists) {
      return UserScore.parse(snapshot.id, snapshot.data());
    }
    return null;
  }

  /// Saves a personal best and updates the top-ten list.
  Future<void> saveScore(
    UserScore userScore,
    String scoreID, {
    int limit = 10,
  }) async {
    await _saveUserScore(userScore, scoreID);
    await _saveBestScore(userScore, scoreID, limit);
  }

  Future<void> _saveUserScore(UserScore userScore, String scoreID) async {
    final prevScore = await fetchUserScore(
      userID: userScore.uid,
      scoreID: scoreID,
    );
    if (prevScore == null || prevScore.score > userScore.score) {
      final db = FirebaseFirestore.instance;
      await db.collection(_usersScoresKey).doc(userScore.uid).set({
        UserScore.nameKey: userScore.name,
      });
      await db
          .collection(_usersScoresKey)
          .doc(userScore.uid)
          .collection(_scoresKey)
          .doc(scoreID)
          .set(userScore.map);
    }
  }

  Future<void> _saveBestScore(
    UserScore userScore,
    String scoreID,
    int limit,
  ) async {
    final db = FirebaseFirestore.instance;
    await db.collection(_scoresKey).doc(scoreID).set({
      UserScore.scoreIDKey: scoreID,
    });
    final boardTopTen = db
        .collection(_scoresKey)
        .doc(scoreID)
        .collection(_topTenKey);
    final data = await boardTopTen.get();
    final list = <UserScore>[];
    for (final snapshot in data.docs) {
      final userScore = UserScore.parse(snapshot.id, snapshot.data());
      if (userScore != null) {
        list.add(userScore);
      }
    }
    list
      ..add(userScore)
      ..sort((a, b) => a.score.compareTo(b.score));
    final toSave = (list.length > limit ? list.sublist(0, limit) : list).where(
      (element) => element.id == null,
    );
    for (final userScore in toSave) {
      await boardTopTen.add(userScore.map);
    }
    final toDelete = (list.length > limit ? list.sublist(limit) : <UserScore>[])
        .where((element) => element.id != null);
    for (final userScore in toDelete) {
      await boardTopTen.doc(userScore.id).delete();
    }
  }
}

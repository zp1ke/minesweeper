import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minesweeper/src/model/user_score.dart';

const _scoresKey = 'scores';
const _topTenKey = 'top-ten';

class FirestoreService {
  static FirestoreService? _instance;

  FirestoreService._();

  factory FirestoreService() {
    _instance ??= FirestoreService._();
    return _instance!;
  }

  Future<List<String>> fetchScoresIDs() async {
    final db = FirebaseFirestore.instance;
    final scoresIDs = db.collection(_scoresKey);
    final data = await scoresIDs.get();
    return data.docs.map((e) => e.id).toList();
  }

  Future<List<UserScore>> fetchScores(String scoreID) async {
    final db = FirebaseFirestore.instance;
    final data = await db
        .collection(_scoresKey)
        .doc(scoreID)
        .collection(_topTenKey)
        .get();
    final list = data.docs.map((e) => UserScore.parse(e)).toList();
    list.sort((a, b) => a.score.compareTo(b.score));
    return list;
  }

  Future<void> saveScore(UserScore userScore, String scoreID,
      {int limit = 10}) async {
    final db = FirebaseFirestore.instance;
    await db.collection(_scoresKey).doc(scoreID).set({'scoreID': scoreID});
    final boardTopTen =
        db.collection(_scoresKey).doc(scoreID).collection(_topTenKey);
    final data = await boardTopTen.get();
    final list = data.docs.map((e) => UserScore.parse(e)).toList();
    list.add(userScore);
    list.sort((a, b) => a.score.compareTo(b.score));
    var toSave = list.length > limit ? list.sublist(0, limit) : list;
    toSave = toSave.where((element) => element.id == null).toList();
    for (var userScore in toSave) {
      await boardTopTen.add(userScore.map);
    }
    var toDelete = list.length > limit ? list.sublist(limit) : [];
    toDelete = toDelete.where((element) => element.id != null).toList();
    for (var userScore in toDelete) {
      await boardTopTen.doc(userScore.id).delete();
    }
  }
}

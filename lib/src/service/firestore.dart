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

  Future<List<UserScore>> fetchTopTen(String scoreID) async {
    final db = FirebaseFirestore.instance;
    final boardTopTen =
        db.collection(_scoresKey).doc(scoreID).collection(_topTenKey);
    final data = await boardTopTen.get();
    return data.docs.map((e) => UserScore.parse(e)).toList();
  }

  Future<void> saveTopTen(UserScore userScore, String scoreID) async {
    final db = FirebaseFirestore.instance;
    final boardTopTen =
        db.collection(_scoresKey).doc(scoreID).collection(_topTenKey);
    final data = await boardTopTen.get();
    final list = data.docs.map((e) => UserScore.parse(e)).toList();
    list.add(userScore);
    list.sort((a, b) => a.score.compareTo(b.score));
    var toSave = list.length > 10 ? list.sublist(0, 10) : list;
    toSave = toSave.where((element) => element.id == null).toList();
    for (var userScore in toSave) {
      await boardTopTen.add(userScore.map);
    }
    var toDelete = list.length > 10 ? list.sublist(10) : [];
    toDelete = toDelete.where((element) => element.id != null).toList();
    for (var userScore in toDelete) {
      await boardTopTen.doc(userScore.id).delete();
    }
  }
}

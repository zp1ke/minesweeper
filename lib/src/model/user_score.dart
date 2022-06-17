import 'package:cloud_firestore/cloud_firestore.dart';

class UserScore {
  String? id;
  String uid;
  String name;
  int score;
  DateTime datetime;

  UserScore({
    this.id,
    required this.uid,
    required this.name,
    required this.score,
    DateTime? datetime,
  }) : datetime = datetime ?? DateTime.now();

  factory UserScore.parse(
          QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
      UserScore(
        id: snapshot.id,
        uid: snapshot.get('uid'),
        name: snapshot.get('name'),
        score: snapshot.get('score'),
        datetime: DateTime.fromMillisecondsSinceEpoch(snapshot.get('datetime')),
      );

  Map<String, dynamic> get map => {
        'uid': uid,
        'name': name,
        'score': score,
        'datetime': datetime.millisecondsSinceEpoch,
      };
}

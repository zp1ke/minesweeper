const _uidKey = 'uid';
const _nameKey = 'name';
const _scoreKey = 'score';
const _datetimeKey = 'datetime';

class UserScore {
  static const nameKey = _nameKey;
  static const scoreIDKey = 'scoreID';

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

  static UserScore? parse(String id, Map<String, dynamic>? data) {
    if (data != null) {
      if (data[_uidKey] is String &&
          data[_nameKey] is String &&
          data[_scoreKey] is int &&
          data[_datetimeKey] is int) {
        return UserScore(
          id: id,
          uid: data[_uidKey],
          name: data[_nameKey],
          score: data[_scoreKey],
          datetime: DateTime.fromMillisecondsSinceEpoch(data[_datetimeKey]),
        );
      }
    }
    return null;
  }

  Map<String, dynamic> get map => {
        _uidKey: uid,
        _nameKey: name,
        _scoreKey: score,
        _datetimeKey: datetime.millisecondsSinceEpoch,
      };
}

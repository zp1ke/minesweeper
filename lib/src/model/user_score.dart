const _uidKey = 'uid';
const _nameKey = 'name';
const _scoreKey = 'score';
const _datetimeKey = 'datetime';

/// One finished-game time stored in Firestore.
class UserScore {
  /// Creates a score. [datetime] defaults to now.
  UserScore({
    required this.uid,
    required this.name,
    required this.score,
    this.id,
    DateTime? datetime,
  }) : datetime = datetime ?? DateTime.now();

  /// Firestore field for the display name.
  static const String nameKey = _nameKey;

  /// Firestore field for the board key.
  static const scoreIDKey = 'scoreID';

  /// Firestore document id, when this score was loaded.
  String? id;

  /// Firebase user id.
  String uid;

  /// Name shown on the scores list.
  String name;

  /// Elapsed seconds. Lower is better.
  int score;

  /// When the score was submitted.
  DateTime datetime;

  /// Parses a Firestore document, or null when fields are missing.
  static UserScore? parse(String id, Map<String, dynamic>? data) {
    if (data != null) {
      if (data[_uidKey] is String &&
          data[_nameKey] is String &&
          data[_scoreKey] is int &&
          data[_datetimeKey] is int) {
        return UserScore(
          id: id,
          uid: data[_uidKey] as String,
          name: data[_nameKey] as String,
          score: data[_scoreKey] as int,
          datetime: DateTime.fromMillisecondsSinceEpoch(
            data[_datetimeKey] as int,
          ),
        );
      }
    }
    return null;
  }

  /// Firestore field map for this score.
  Map<String, dynamic> get map => {
    _uidKey: uid,
    _nameKey: name,
    _scoreKey: score,
    _datetimeKey: datetime.millisecondsSinceEpoch,
  };
}

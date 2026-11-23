import 'package:flutter_test/flutter_test.dart';
import 'package:minezweeper/src/extension/datetime.dart';
import 'package:minezweeper/src/extension/number.dart';
import 'package:minezweeper/src/model/user_score.dart';

void main() {
  test('seconds format as mm:ss and hh:mm:ss', () {
    expect(0.secondsFormatted(), '00:00');
    expect(9.secondsFormatted(), '00:09');
    expect(75.secondsFormatted(), '01:15');
    expect(3661.secondsFormatted(), '01:01:01');
    expect(7.twoDigits(), '07');
    expect(12.twoDigits(), '12');
  });

  test('same day ignores the clock', () {
    final morning = DateTime(2026, 11, 23, 1);
    final evening = DateTime(2026, 11, 23, 23, 59);
    expect(morning.isSameDay(evening), isTrue);
    expect(morning.isSameDay(evening.add(const Duration(hours: 2))), isFalse);
  });

  test('score parse rejects incomplete documents', () {
    expect(UserScore.parse('id', null), isNull);
    expect(UserScore.parse('id', {'uid': 'u'}), isNull);

    final parsed = UserScore.parse('doc', {
      'uid': 'user-1',
      'name': 'Ada',
      'score': 42,
      'datetime': 1_700_000_000_000,
    });

    expect(parsed, isNotNull);
    expect(parsed!.id, 'doc');
    expect(parsed.uid, 'user-1');
    expect(parsed.name, 'Ada');
    expect(parsed.score, 42);
    expect(parsed.map['score'], 42);
    expect(parsed.map.containsKey('id'), isFalse);
  });
}

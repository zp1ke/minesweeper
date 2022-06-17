import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/provider.dart';
import 'package:minesweeper/src/model/board_data.dart';

class GamingService {
  static GamingService? _instance;

  GamingService._();

  factory GamingService() {
    _instance ??= GamingService._();
    return _instance!;
  }

  Future<bool> saveScore(WidgetRef ref, int score, BoardData boardData) async {
    final userState = ref.read(AppProvider().userProvider.notifier);
    var user = userState.user;
    user ??= await userState.googleSignIn();
    if (user != null) {
      print("ALMOST THERE"); // fixme
      return true;
    }
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:minesweeper/src/extension/datetime.dart';
import 'package:minesweeper/src/extension/number.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/user_score.dart';
import 'package:minesweeper/src/service/firestore.dart';

class TopTenWidget extends StatefulWidget {
  const TopTenWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TopTenWidgetState();
}

class TopTenWidgetState extends State<TopTenWidget> {
  var _scoreID = BoardData().boardStr;
  var _list = <UserScore>[];
  var _loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadList);
  }

  void _loadList() async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
      _list = await FirestoreService().fetchTopTen(_scoreID);
      _loading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Column(
      children: _list
          .map((userScore) => ListTile(
                leading: Text(userScore.score.secondsFormatted()),
                title: Text(userScore.name),
                subtitle: Text(userScore.datetime.formatted(l10n)),
              ))
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:minesweeper/src/event/handler.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/game_event.dart';
import 'package:minesweeper/src/model/nav_item.dart';
import 'package:minesweeper/src/widget/board.dart';
import 'package:minesweeper/src/widget/navbar.dart';
import 'package:minesweeper/src/widget/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _navItems = <NavItem>[];
  final _eventHandler = EventHandler();
  final _pageController = PageController();

  var _selectedIndex = 0;
  NavItem? _navItem;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _createItems);
  }

  void _createItems() {
    final l10n = L10n.of(context);
    _navItems.addAll([
      NavItem(
        title: l10n.appTitle,
        body: BoardWidget(
          eventHandler: _eventHandler,
        ),
        icon: Icons.border_all_sharp,
        actions: [
          IconButton(
            onPressed: () {
              _eventHandler.trigger(GameEvent.boardReload);
            },
            icon: const Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      NavItem(
        title: l10n.settings,
        body: const SettingsWidget(),
        icon: Icons.settings_sharp,
      ),
    ]);
    _onNav(0);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(_navItem?.title ?? L10n.of(context).appTitle),
            actions: _navItem?.actions,
          ),
          body: _body(),
          bottomNavigationBar: _navItem != null
              ? NavBar(
                  selectedIndex: _selectedIndex,
                  navItems: _navItems,
                  onChangeIndex: _onNav,
                )
              : null,
        ),
        onWillPop: () {
          if (_selectedIndex > 0) {
            _onNav(0);
            return Future.value(false);
          }
          return Future.value(true);
        },
      );

  Widget _body() {
    if (_navItem == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    return PageView.builder(
      onPageChanged: _onNav,
      controller: _pageController,
      itemBuilder: (_, __) => _navItem!.body,
      itemCount: _navItems.length,
    );
  }

  void _onNav(int index) {
    setState(() {
      _selectedIndex = index;
      _navItem = _navItems[index];
    });
  }
}

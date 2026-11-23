import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import 'package:minezweeper/src/l10n/app_l10n.g.dart';
import 'package:minezweeper/src/model/event.dart';
import 'package:minezweeper/src/model/game_event.dart';
import 'package:minezweeper/src/model/nav_item.dart';
import 'package:minezweeper/src/widget/navbar.dart';
import 'package:minezweeper/src/widget/view/board.dart';
import 'package:minezweeper/src/widget/view/scores.dart';
import 'package:minezweeper/src/widget/view/settings.dart';

const _scoresKey = ValueKey<String>('scores');

/// App shell: game, scores, and settings.
class HomeScreen extends StatefulWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

/// State for [HomeScreen].
class HomeScreenState extends State<HomeScreen> implements EventListener {
  final _navItems = <NavItem>[];
  final _eventHandler = EventHandler();
  final _pageController = PageController();

  var _selectedIndex = 0;
  NavItem? _navItem;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _createNavItems);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
    _eventHandler.addListener(this);
  }

  void _createNavItems() {
    final l10n = L10n.of(context);
    _navItems.addAll([
      NavItem(
        title: l10n.appTitle,
        body: BoardWidget(eventHandler: _eventHandler),
        icon: FontAwesomeIcons.chessBoard,
        actions: [
          IconButton(
            onPressed: () {
              _eventHandler.trigger(GameEvent.boardReload);
            },
            icon: const FaIcon(FontAwesomeIcons.rotateLeft),
          ),
        ],
      ),
      NavItem(
        key: _scoresKey,
        title: l10n.scores,
        body: ScoresWidget(eventHandler: _eventHandler),
        icon: FontAwesomeIcons.fireFlameSimple,
        actions: [
          IconButton(
            onPressed: () {
              _eventHandler.trigger(GameEvent.reloadScores);
            },
            icon: const FaIcon(FontAwesomeIcons.rotateRight),
          ),
        ],
      ),
      NavItem(
        title: l10n.settings,
        body: const SettingsWidget(),
        icon: FontAwesomeIcons.sliders,
      ),
    ]);
    _onNav(0);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _selectedIndex == 0,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) {
        _onNav(0);
      }
    },
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
  );

  Widget _body() {
    if (_navItem == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return PageView.builder(
      onPageChanged: _onNav,
      controller: _pageController,
      itemBuilder: (_, index) => _navItems[index].body,
      itemCount: _navItems.length,
    );
  }

  void _onNav(int index) {
    if (index < 0 || index >= _navItems.length) {
      return;
    }
    setState(() {
      _selectedIndex = index;
      _navItem = _navItems[index];
    });
    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.jumpToPage(index);
    }
  }

  @override
  void onEvent(GameEvent event) {
    if (event == GameEvent.checkScores) {
      final scoresIndex = _navItems.indexWhere(
        (item) => item.key == _scoresKey,
      );
      _onNav(scoresIndex);
    }
  }
}

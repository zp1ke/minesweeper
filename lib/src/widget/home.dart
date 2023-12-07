import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../l10n/app_l10n.g.dart';
import '../model/event.dart';
import '../model/game_event.dart';
import '../model/nav_item.dart';
import 'navbar.dart';
import 'view/board.dart';
import 'view/scores.dart';
import 'view/settings.dart';

const _scoresKey = ValueKey<String>('scores');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

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
        body: BoardWidget(
          eventHandler: _eventHandler,
        ),
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
        body: ScoresWidget(
          eventHandler: _eventHandler,
        ),
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
        onPopInvoked: (didPop) {
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
    if (index >= 0 && index < _navItems.length) {
      setState(() {
        _selectedIndex = index;
        _navItem = _navItems[index];
      });
    }
  }

  @override
  void onEvent(GameEvent event) {
    if (event == GameEvent.checkScores) {
      final scoresIndex =
          _navItems.indexWhere((item) => item.key == _scoresKey);
      _onNav(scoresIndex);
    }
  }
}

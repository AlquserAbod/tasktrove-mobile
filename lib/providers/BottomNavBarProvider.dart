import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BottomNavBarProvider extends ChangeNotifier {
  PersistentTabController? _controller;

  PersistentTabController? get controller => _controller;

  Future<void> init(PersistentTabController _controllerIns) async {
    _controller = _controllerIns;
  }
}

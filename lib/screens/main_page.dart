import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kt_drawer_menu/kt_drawer_menu.dart';
import 'package:todolist/helpers/datebase_helper.dart';
import 'package:todolist/res.dart';
import 'package:todolist/screens/home.dart';

class MainPage extends StatelessWidget {
  // ignore: close_sinks
  final StreamController<DrawerItemEnum> _streamController =
      StreamController<DrawerItemEnum>.broadcast(sync: true);

  @override
  Widget build(BuildContext context) {
    return KTDrawerMenu(
      width: MediaQuery.of(context).size.width * 0.5, //360
      radius: 50.0,
      scale: 0.8, //0.6
      shadow: 20.0,
      duration: Duration(milliseconds: 360),
      shadowColor: Colors.black, //black12
      drawer: DrawerPage(streamController: _streamController),
      content: Home(streamController: _streamController),
    );
  }
}

enum DrawerItemEnum {
  DASHBOARD,
  MESSAGE,
  SETTINGS,
  ABOUT,
  HELP,
}

// ignore: must_be_immutable
class DrawerPage extends StatelessWidget {
  final StreamController<DrawerItemEnum> streamController;
  DrawerItemEnum selected;

  DrawerPage({Key key, this.streamController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DrawerItemEnum>(
      stream: streamController.stream,
      initialData: DrawerItemEnum.DASHBOARD,
      builder: (context, snapshot) {
        selected = snapshot.data;
        return Container(
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getMenu(context, DrawerItemEnum.DASHBOARD),
                    _getMenu(context, DrawerItemEnum.MESSAGE),
                    _getMenu(context, DrawerItemEnum.SETTINGS),
                    _getMenu(context, DrawerItemEnum.ABOUT),
                    _getMenu(context, DrawerItemEnum.HELP),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _getMenu(BuildContext context, DrawerItemEnum menu) {
    switch (menu) {
      case DrawerItemEnum.DASHBOARD:
        return _buildItem(context, menu, "Dashboard", Icons.dashboard, () {});
      case DrawerItemEnum.MESSAGE:
        return _buildItem(context, menu, "Messages", Icons.message, () {});
      case DrawerItemEnum.SETTINGS:
        return _buildItem(context, menu, "Settings", Icons.settings, () {});
      case DrawerItemEnum.ABOUT:
        return _buildItem(context, menu, "About", Icons.info, () {});
      case DrawerItemEnum.HELP:
        return _buildItem(context, menu, "Help", Icons.help_outline, () {});
      default:
        return Container();
    }
  }

  Widget _buildItem(
    BuildContext context,
    DrawerItemEnum menu,
    String title,
    IconData icon,
    Function onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          streamController.sink.add(menu);
          KTDrawerMenu.of(context).closeDrawer();
          onPressed();
        },
        child: Container(
          height: size60,
          padding: EdgeInsets.only(left: size25),
          child: Row(
            children: [
              Icon(icon,
                  color: selected == menu ? Colors.black : Colors.black87,
                  size: 24),
              SizedBox(width: size15),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: selected == menu ? size18 : size15,
                  fontWeight:
                      selected == menu ? FontWeight.w900 : FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

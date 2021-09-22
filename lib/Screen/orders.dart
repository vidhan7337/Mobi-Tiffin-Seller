import 'package:flutter/material.dart';
import 'package:tiffin_app/Screen/menueditor.dart';
import 'package:tiffin_app/Screen/orders/completed.dart';
import 'package:tiffin_app/Screen/orders/incoming.dart';
import 'package:tiffin_app/Screen/orders/preparing.dart';
import 'package:tiffin_app/Screen/profile.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ContainedTabBarView(
        tabs: [
          Tab(
            icon: Icon(Icons.menu_open),
            text: AppLocalizations.of(context).incoming,
          ),
          Tab(
            icon: Icon(Icons.restaurant),
            text: AppLocalizations.of(context).preparing,
          ),
          Tab(
            icon: Icon(Icons.local_restaurant),
            text: AppLocalizations.of(context).completed,
          ),
        ],
        tabBarProperties: TabBarProperties(
          height: 70.0,
          background: Container(
            decoration: BoxDecoration(color: carrotOrange),
          ),
          indicatorColor: valhalla,
          indicatorWeight: 6.0,
          labelColor: valhalla,
          unselectedLabelColor: solitude,
        ),
        views: [Incoming(), Preparing(), Completed()],
        onChange: (index) => print(index),
      ),
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffin_app/Authentication/authenication.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:tiffin_app/DialogBox/errorDialog.dart';
import 'package:tiffin_app/Screen/contactus.dart';
import 'package:tiffin_app/Screen/language.dart';
import 'package:tiffin_app/Screen/menueditor.dart';
import 'package:tiffin_app/Screen/orders.dart';
import 'package:tiffin_app/Screen/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:tiffin_app/Widgets/loadingWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiffin_app/Widgets/myDrawer.dart';
// import 'package:e_shop/Admin/adminShiftOrders.dart';
// import 'package:e_shop/Widgets/loadingWidget.dart';
import '../main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;

  // String productId = getproductid();

  bool available;

  bool uploading = false;
  int _selectedIndex = 0;
  final List<Widget> _children = [
    Orders(),
    MenuEditor(),
    Profile(),
  ];

//  bool getdata() async {
//    var x=await Firestore.instance.collection('serviceprovider').document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).get();
//
//    var y=x.data['available'];
//    return y;
//  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void toggleSwitch(bool value) {
    if (EcommerceApp.sharedPreferences.getBool(EcommerceApp.kitchenstatus) ==
        false) {
      setState(() {
        available = true;
        EcommerceApp.sharedPreferences
            .setBool(EcommerceApp.kitchenstatus, true);
        Firestore.instance
            .collection("serviceprovider")
            .document(
                EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
            .updateData({'available': true});
      });
      print('Switch Button is ON');
      print(EcommerceApp.sharedPreferences.getBool(EcommerceApp.kitchenstatus));
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: AppLocalizations.of(context).youareavailable,
            );
          });
    } else {
      setState(() {
        available = false;
        EcommerceApp.sharedPreferences
            .setBool(EcommerceApp.kitchenstatus, false);
        Firestore.instance
            .collection("serviceprovider")
            .document(
                EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
            .updateData({'available': false});
      });
      print('Switch Button is OFF');

      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: AppLocalizations.of(context).youarenotavailable,
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;

    final List<String> _appbartitle = [
      AppLocalizations.of(context).manageorder,
      AppLocalizations.of(context).yourweeklymenu,
      AppLocalizations.of(context).profile
    ];
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(_appbartitle[_selectedIndex],
            style: TextStyle(
              color: valhalla,
            )),
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: new BoxDecoration(color: carrotOrange),
        ),
        actions: [
          Container(
            width: screenwidth / 3,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                AppLocalizations.of(context).available,
                style: TextStyle(color: valhalla),
              ),
              Switch(
                onChanged: toggleSwitch,
                value: EcommerceApp.sharedPreferences
                    .getBool(EcommerceApp.kitchenstatus),
                activeColor: Colors.green,
                activeTrackColor: Colors.lightGreenAccent,
                inactiveThumbColor: Colors.redAccent,
                inactiveTrackColor: Colors.red,
              )
            ]),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Image.network(
              "https://i.pinimg.com/736x/27/9f/bf/279fbf90a26a2c8c73b3dec0db1692cb.jpg",
              fit: BoxFit.cover,
            )),
            ListTile(
              leading: Icon(
                Icons.home,
                color: valhalla,
              ),
              title: Text(AppLocalizations.of(context).home),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: valhalla,
              ),
              title: Text(AppLocalizations.of(context).language),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Language()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.contact_mail,
                color: valhalla,
              ),
              title: Text(AppLocalizations.of(context).contactus),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: valhalla,
              ),
              title: Text(AppLocalizations.of(context).logout),
              onTap: () async {
                await EcommerceApp.sharedPreferences
                    .setString(EcommerceApp.userUID, null);
                await EcommerceApp.sharedPreferences
                    .setString(EcommerceApp.weekday, null);
                await EcommerceApp.sharedPreferences
                    .setString(EcommerceApp.mealtime, null);
                await EcommerceApp.sharedPreferences
                    .setString(EcommerceApp.avg_rating, null);

                await EcommerceApp.sharedPreferences
                    .setString(EcommerceApp.userEmail, null);
                await EcommerceApp.sharedPreferences
                    .setString(EcommerceApp.userpassword, null);
                await EcommerceApp.sharedPreferences
                    .setString(EcommerceApp.userName, null);
                await EcommerceApp.sharedPreferences
                    .setString(EcommerceApp.userAvatarUrl, null);

                EcommerceApp.auth.signOut().then((c) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/auth', (Route<dynamic> route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(AppLocalizations.of(context).logoutsuccesfully),
                  ));
                });
              },
            ),
          ],
        ),
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // this will be set when a new tab is tapped
        backgroundColor: carrotOrange,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.food_bank),
            title: new Text(AppLocalizations.of(context).order),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.menu_book),
            title: new Text(AppLocalizations.of(context).menueditor),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(AppLocalizations.of(context).profile))
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: valhalla,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),
    );
  }
}

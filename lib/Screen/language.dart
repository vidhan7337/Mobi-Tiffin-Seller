import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiffin_app/Screen/contactus.dart';
import 'package:tiffin_app/Screen/home.dart';

import 'package:tiffin_app/Screen/profile.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:tiffin_app/Widgets/loadingWidget.dart';
import 'package:tiffin_app/Widgets/mydrawer.dart';
import 'package:tiffin_app/main.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

enum Tongue { english, hindi, gujarati }

class _LanguageState extends State<Language> {
  Tongue _tongue;

  @override
  void initState() {
    // TODO: implement initState
    if (EcommerceApp.sharedPreferences.getString(EcommerceApp.language) ==
        "English") {
      _tongue = Tongue.english;
    } else if (EcommerceApp.sharedPreferences
            .getString(EcommerceApp.language) ==
        "Hindi") {
      _tongue = Tongue.hindi;
    } else {
      _tongue = Tongue.gujarati;
    }
    super.initState();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return loading
        ? circularProgress()
        : Scaffold(
            appBar: AppBar(
              // automaticallyImplyLeading: false,
              title: Text(AppLocalizations.of(context).language,
                  style: TextStyle(
                    color: valhalla,
                  )),
              iconTheme: IconThemeData(color: Colors.black),
              flexibleSpace: Container(
                decoration: new BoxDecoration(color: carrotOrange),
              ),
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
                          .setString(EcommerceApp.userEmail, null);
                      await EcommerceApp.sharedPreferences
                          .setString(EcommerceApp.weekday, null);
                      await EcommerceApp.sharedPreferences
                          .setString(EcommerceApp.mealtime, null);
                      await EcommerceApp.sharedPreferences
                          .setString(EcommerceApp.avg_rating, null);
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
                          content: Text(
                              AppLocalizations.of(context).logoutsuccesfully),
                        ));
                      });
                    },
                  ),
                ],
              ),
            ),
            body: Container(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        AppLocalizations.of(context).selectyourlanguage,
                        style: TextStyle(
                            fontSize: 19.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: screenwidth / 6,
                          child: Radio<Tongue>(
                            value: Tongue.english,
                            autofocus: true,
                            activeColor: tyrianPurple,
                            groupValue: _tongue,
                            onChanged: (Tongue value) {
                              setState(() {
                                _tongue = value;
                                EcommerceApp.sharedPreferences.setString(
                                    EcommerceApp.language, "English");
                              });
                            },
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).english,
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: screenwidth / 6,
                          child: Radio<Tongue>(
                            value: Tongue.hindi,
                            autofocus: true,
                            activeColor: tyrianPurple,
                            groupValue: _tongue,
                            onChanged: (Tongue value) {
                              setState(() {
                                _tongue = value;
                                EcommerceApp.sharedPreferences
                                    .setString(EcommerceApp.language, "Hindi");
                              });
                            },
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).hindi,
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: screenwidth / 6,
                          child: Radio<Tongue>(
                            value: Tongue.gujarati,
                            autofocus: true,
                            activeColor: tyrianPurple,
                            groupValue: _tongue,
                            onChanged: (Tongue value) {
                              setState(() {
                                _tongue = value;
                                EcommerceApp.sharedPreferences.setString(
                                    EcommerceApp.language, "Gujarati");
                              });
                            },
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).gujrati,
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: screenwidth - 150.0,
                        decoration: BoxDecoration(
                            color: tyrianPurple,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              loading = true;
                            });
                            if (_tongue == Tongue.english) {
                              MyApp.of(context).setLocale(
                                  Locale.fromSubtags(languageCode: 'en'));
                            } else if (_tongue == Tongue.hindi) {
                              MyApp.of(context).setLocale(
                                  Locale.fromSubtags(languageCode: 'hi'));
                            } else {
                              MyApp.of(context).setLocale(
                                  Locale.fromSubtags(languageCode: 'gu'));
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                          child: Text(
                            AppLocalizations.of(context).apply,
                            style: TextStyle(
                                color: white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

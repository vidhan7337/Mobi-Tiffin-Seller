import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_shop/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:tiffin_app/models/menuitemdinner.dart';
import 'package:tiffin_app/models/menuitemlunch.dart';
import 'Authentication/authenication.dart';
// import 'package:e_shop/Config/config.dart';
// import 'Authentication/authenication.dart';
import 'Config/config.dart';
import 'Screen/home.dart';
// import 'Config/config.dart';
// import 'Counters/cartitemcounter.dart';
// import 'Counters/changeAddresss.dart';
// import 'Counters/totalMoney.dart';
// import 'Store/storehome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  MenuItemdinner.sharedPreferences = await SharedPreferences.getInstance();
  MenuItemlunch.sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (EcommerceApp.sharedPreferences.getString(EcommerceApp.language) ==
        "English") {
      _locale = Locale.fromSubtags(languageCode: 'en');
    } else if (EcommerceApp.sharedPreferences
            .getString(EcommerceApp.language) ==
        "Hindi") {
      _locale = Locale.fromSubtags(languageCode: 'hi');
    } else {
      Locale.fromSubtags(languageCode: 'gu');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiffin App',
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // AppStrings.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('es', ''),
        const Locale('gu', ''),
        const Locale('hi', ''),
      ],
      locale: _locale,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => UploadPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/auth': (context) => AuthenticScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.green, fontFamily: 'Montserrat'),
      home:
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) != null
              ? UploadPage()
              : AuthenticScreen(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tiffin App',
//       initialRoute: '/',
//       routes: {
//         // When navigating to the "/" route, build the FirstScreen widget.
//         '/home': (context) => UploadPage(),
//         // When navigating to the "/second" route, build the SecondScreen widget.
//         '/auth': (context) => AuthenticScreen(),
//       },
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primaryColor: Colors.green, fontFamily: 'Montserrat'),
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     displaySplash();
//   }

//   void displaySplash() {
//     Timer(Duration(seconds: 5), () async {
//       if (await EcommerceApp.auth.currentUser != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => UploadPage()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => AuthenticScreen()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         child: Container(
//       decoration: new BoxDecoration(
//           gradient: new LinearGradient(
//         colors: [white, white],
//         begin: const FractionalOffset(0.0, 0.0),
//         end: const FractionalOffset(1.0, 0.0),
//         stops: [0.0, 1.0],
//         tileMode: TileMode.clamp,
//       )),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("images/Untitled.png"),
//             SizedBox(
//               height: 20.0,
//             ),
//             // Text(
//             //   "Welcome to Online Tiffin Service",
//             //   style: TextStyle(
//             //       color: Colors.black,
//             //       fontWeight: FontWeight.bold,
//             //       fontSize: 20.0),
//             // )
//           ],
//         ),
//       ),
//     ));
//   }
// }

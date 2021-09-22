import 'package:flutter/material.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:tiffin_app/Screen/home.dart';
import 'package:tiffin_app/Screen/language.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiffin_app/Widgets/customTextField.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController msg = TextEditingController();
  TextEditingController topic = TextEditingController();

  sendmsg() async {
    var url = "mailto:contacttiffinservice@gmail.com?subject=" +
        topic.text +
        "&body=" +
        msg.text +
        "%0A%0AFrom%2C%0A" +
        name.text;

    if (await canLaunch(url) != null) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

    setState(() {
      topic.clear();
      msg.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    name.text = EcommerceApp.sharedPreferences.getString(EcommerceApp.userName);
    email.text =
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail);
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context).contactus,
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
                    content:
                        Text(AppLocalizations.of(context).logoutsuccesfully),
                  ));
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: screenwidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(10.0),
                  child: TextField(
                    readOnly: true,
                    controller: name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context).yourname,
                        hintText: AppLocalizations.of(context).name),
                  ),
                ),
                Container(
                  width: screenwidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(10.0),
                  child: TextField(
                    readOnly: true,
                    controller: email,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context).youremail,
                        hintText: AppLocalizations.of(context).email),
                  ),
                ),
                Container(
                  width: screenwidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: topic,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).topicforcontacting,
                        hintText: AppLocalizations.of(context).enterurtopic),
                  ),
                ),
                Container(
                  width: screenwidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: msg,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context).yourmsg,
                        hintText: AppLocalizations.of(context).yourmsg),
                  ),
                ),
                Container(
                  width: screenwidth - 100.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: tyrianPurple,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: () {
                      msg.text.isNotEmpty && topic.text.isNotEmpty
                          ? sendmsg()
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)
                                  .plswritesomething),
                            ));
                    },
                    child: Text(
                      AppLocalizations.of(context).sendmail,
                      style: TextStyle(
                          color: white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: screenwidth - 50.0,
                  height: 5.0,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: tyrianPurple,
                  ),
                ),
                Container(
                  width: screenwidth,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(10.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: valhalla)),
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        AppLocalizations.of(context).ucancallushere,
                        style: TextStyle(fontSize: 18.0, color: valhalla),
                      )),
                      Container(
                        width: screenwidth - 100.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: tyrianPurple,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.all(10.0),
                        child: TextButton(
                          onPressed: () async {
                            var url = 'tel:+916351659433';
                            if (await canLaunch(url) != null) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context).call,
                            style: TextStyle(
                                color: white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

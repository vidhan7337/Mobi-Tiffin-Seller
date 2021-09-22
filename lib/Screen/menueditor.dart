import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:tiffin_app/DialogBox/errorDialog.dart';
import 'package:tiffin_app/Screen/dailymenuedit/itemedit.dart';
import 'package:tiffin_app/Screen/updatingscreen/dailymenuadd.dart';
import 'package:tiffin_app/Screen/updatingscreen/editingmenu.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiffin_app/Widgets/loadingWidget.dart';
import 'package:tiffin_app/models/menuitemdinner.dart';
import 'package:tiffin_app/models/menuitemlunch.dart';

class MenuEditor extends StatefulWidget {
  @override
  _MenuEditorState createState() => _MenuEditorState();
}

String a = "Lunch";
String b = "Dinner";
Map<dynamic, dynamic> dinnermodel;
Map<dynamic, dynamic> lunchmodel;
DocumentSnapshot lunch;
DocumentSnapshot dinner;

var date = DateTime.now();
String dropdownValue = DateFormat('EEEE').format(date);

class _MenuEditorState extends State<MenuEditor> {
  List listItem = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      EcommerceApp.sharedPreferences
          .setString(EcommerceApp.weekday, dropdownValue);

      getdatadinner();
      getdatalunch();
    });
    super.initState();
  }

  getdatalunch() async {
    lunch = await Firestore.instance
        .collection('weeklymenu')
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                a +
                EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday))
        .get();

    setState(() {
      lunchmodel = lunch.data;
    });
  }

  getdatadinner() async {
    dinner = await Firestore.instance
        .collection('weeklymenu')
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                b +
                EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday))
        .get();

    setState(() {
      dinnermodel = dinner.data;
    });
  }

  void toggleSwitch(bool value) {
    if (dinnermodel['status'] == false) {
      setState(() {
        dinnermodel['status'] = true;
        Firestore.instance
            .collection('weeklymenu')
            .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID) +
                b +
                EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday))
            .updateData({'status': true});
      });
      print('Switch Button is ON');
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: AppLocalizations.of(context).dinneron,
            );
          });
    } else {
      setState(() {
        dinnermodel['status'] = false;
        Firestore.instance
            .collection('weeklymenu')
            .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID) +
                b +
                EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday))
            .updateData({'status': false});
      });
      print('Switch Button is OFF');
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: AppLocalizations.of(context).dinneroff,
            );
          });
    }
  }

  void toggleSwitch1(bool value) {
    if (lunchmodel['status'] == false) {
      setState(() {
        lunchmodel['status'] = true;
        Firestore.instance
            .collection('weeklymenu')
            .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID) +
                a +
                EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday))
            .updateData({'status': true});
      });
      print('Switch Button is ON');
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: AppLocalizations.of(context).lunchon,
            );
          });
    } else {
      setState(() {
        lunchmodel['status'] = false;
        Firestore.instance
            .collection('weeklymenu')
            .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID) +
                a +
                EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday))
            .updateData({'status': false});
      });
      print('Switch Button is OFF');
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: AppLocalizations.of(context).lunchoff,
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      AppLocalizations.of(context).todayspecial,
                      style: TextStyle(
                          fontSize: 19.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: DropdownButton(
                      // value: dropdownValue,
                      underline: Text(""),
                      icon: Icon(Icons.filter_list),
                      onChanged: (newValue) async {
                        setState(() {
                          dropdownValue = newValue;

                          EcommerceApp.sharedPreferences
                              .setString(EcommerceApp.weekday, dropdownValue);

                          getdatalunch();
                          getdatadinner();
                        });
                      },
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: screenwidth - 100.0,
                      child: Card(
                        elevation: 5.0,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Text(
                                    dropdownValue + ' ' + ' ' + 'Lunch',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: valhalla),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: lunchmodel == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Center(
                                            child: Image.network(
                                              'https://icon-library.com/images/no-data-icon/no-data-icon-10.jpg',
                                              height: screenwidth / 5,
                                              width: screenwidth / 5,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              SizedBox(
                                                width: 2.0,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    lunchmodel['thumbnailUrl'],
                                                    fit: BoxFit.cover,
                                                    height: screenwidth / 5,
                                                    width: screenwidth / 5,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.0,
                                              ),
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        lunchmodel['title'],
                                                        overflow:
                                                            TextOverflow.clip,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17.0,
                                                            color: valhalla),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        lunchmodel[
                                                            'Description'],
                                                        style: TextStyle(
                                                            fontSize: 17.0),
                                                        overflow:
                                                            TextOverflow.clip,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    Text(
                                                      '₹' +
                                                          lunchmodel['price']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17.0,
                                                          color: valhalla),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ])),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: lunchmodel == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                            // Text(
                                            //     AppLocalizations.of(context).add),
                                            // SizedBox(
                                            //   width: 20.0,
                                            // ),
                                            IconButton(
                                                icon: Icon(
                                                    Icons.add_circle_outline),
                                                onPressed: () {
                                                  EcommerceApp.sharedPreferences
                                                      .setString(
                                                          EcommerceApp.mealtime,
                                                          a);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Editmenu()),
                                                  );
                                                }),
                                            SizedBox(
                                              width: 30.0,
                                            ),
                                          ])
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // Text(AppLocalizations.of(context)
                                                //     .status),
                                                // SizedBox(
                                                //   width: 20.0,
                                                // ),
                                                Switch(
                                                  onChanged: toggleSwitch1,
                                                  value: lunchmodel['status'],
                                                  activeColor: Colors.green,
                                                  activeTrackColor:
                                                      Colors.lightGreenAccent,
                                                  inactiveThumbColor:
                                                      Colors.redAccent,
                                                  inactiveTrackColor:
                                                      Colors.red,
                                                )
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // Text(AppLocalizations.of(context)
                                                //     .add),
                                                // SizedBox(
                                                //   width: 20.0,
                                                // ),
                                                IconButton(
                                                    icon: Icon(Icons
                                                        .add_circle_outline),
                                                    onPressed: () {
                                                      EcommerceApp
                                                          .sharedPreferences
                                                          .setString(
                                                              EcommerceApp
                                                                  .mealtime,
                                                              a);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Editmenu()));
                                                    }),
                                              ])
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 2.0,
                      right: 2.0,
                      bottom: 2.0,
                    ),
                    child: Container(
                      width: screenwidth - 100.0,
                      child: Card(
                        elevation: 5.0,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Text(
                                    dropdownValue + ' ' + ' ' + 'Dinner',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: valhalla),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: dinnermodel == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Center(
                                            child: Image.network(
                                              'https://icon-library.com/images/no-data-icon/no-data-icon-10.jpg',
                                              height: screenwidth / 5,
                                              width: screenwidth / 5,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              SizedBox(
                                                width: 2.0,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    dinnermodel['thumbnailUrl'],
                                                    fit: BoxFit.cover,
                                                    height: screenwidth / 5,
                                                    width: screenwidth / 5,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.0,
                                              ),
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        dinnermodel['title'],
                                                        overflow:
                                                            TextOverflow.clip,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17.0,
                                                            color: valhalla),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        dinnermodel[
                                                            'Description'],
                                                        style: TextStyle(
                                                            fontSize: 17.0),
                                                        overflow:
                                                            TextOverflow.clip,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    Text(
                                                      '₹' +
                                                          dinnermodel['price']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17.0,
                                                          color: valhalla),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ])),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: dinnermodel == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                            // Text(
                                            //     AppLocalizations.of(context).add),

                                            IconButton(
                                                icon: Icon(
                                                    Icons.add_circle_outline),
                                                onPressed: () {
                                                  EcommerceApp.sharedPreferences
                                                      .setString(
                                                          EcommerceApp.mealtime,
                                                          b);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Editmenu()),
                                                  );
                                                }),
                                            SizedBox(
                                              width: 30.0,
                                            ),
                                          ])
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // Text(AppLocalizations.of(context)
                                                //     .status),
                                                // SizedBox(
                                                //   width: 20.0,
                                                // ),
                                                Switch(
                                                  onChanged: toggleSwitch,
                                                  value: dinnermodel['status'],
                                                  activeColor: Colors.green,
                                                  activeTrackColor:
                                                      Colors.lightGreenAccent,
                                                  inactiveThumbColor:
                                                      Colors.redAccent,
                                                  inactiveTrackColor:
                                                      Colors.red,
                                                )
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // Text(AppLocalizations.of(context)
                                                //     .add),
                                                // SizedBox(
                                                //   width: 20.0,
                                                // ),
                                                IconButton(
                                                    icon: Icon(Icons
                                                        .add_circle_outline),
                                                    onPressed: () {
                                                      EcommerceApp
                                                          .sharedPreferences
                                                          .setString(
                                                              EcommerceApp
                                                                  .mealtime,
                                                              b);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Editmenu()),
                                                      );
                                                    }),
                                              ])
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     Card(
            //       child: Column(
            //         children: [
            //           Container(
            //             child: Text(
            //               "Set Pre Booking time for Lunch",
            //               overflow: TextOverflow.clip,
            //               softWrap: true,
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //     Card(
            //       child: Column(
            //         children: [
            //           Container(
            //             child: Text(
            //               "Set Pre Booking time for Lunch",
            //               overflow: TextOverflow.clip,
            //               softWrap: true,
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 10.0, left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).urdailyitem,
                    style:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DailyMenu()),
                        );
                      })
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('serviceprovider')
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection("dailymenu")
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                if (!dataSnapshot.hasData) {
                  return circularProgress();
                } else {
                  return Column(
                    children: [
                      for (int i = 0;
                          i < dataSnapshot.data.documents.length;
                          i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: screenwidth,
                            child: Card(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            dataSnapshot.data.documents[i]
                                                .data['thumbnailUrl'],
                                            height: screenwidth / 5,
                                            width: screenwidth / 5,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: screenwidth / 2.3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dataSnapshot.data.documents[i]
                                                    .data['title'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0),
                                              ),
                                              SizedBox(
                                                height: 2.0,
                                              ),
                                              Text(
                                                dataSnapshot.data.documents[i]
                                                    .data['Description'],
                                                style:
                                                    TextStyle(fontSize: 17.0),
                                                overflow: TextOverflow.clip,
                                                softWrap: true,
                                              ),
                                              SizedBox(
                                                height: 2.0,
                                              ),
                                              Text(
                                                '₹' +
                                                    dataSnapshot
                                                        .data
                                                        .documents[i]
                                                        .data['price']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                              icon: Icon(Icons.edit_outlined),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ItemEdit(
                                                            item: dataSnapshot
                                                                .data
                                                                .documents[i]
                                                                .data,
                                                            id: dataSnapshot
                                                                .data
                                                                .documents[i]
                                                                .documentID,
                                                          )),
                                                );
                                              }),
                                          Switch(
                                            onChanged: (bool newValue) {
                                              setState(() {
                                                Firestore.instance
                                                    .collection(
                                                        "serviceprovider")
                                                    .document(EcommerceApp
                                                        .sharedPreferences
                                                        .getString(EcommerceApp
                                                            .userUID))
                                                    .collection("dailymenu")
                                                    .document(dataSnapshot
                                                        .data
                                                        .documents[i]
                                                        .documentID)
                                                    .updateData({
                                                  "status": newValue,
                                                });
                                              });
                                            },
                                            value: dataSnapshot.data
                                                .documents[i].data['status'],
                                            activeColor: Colors.green,
                                            activeTrackColor:
                                                Colors.lightGreenAccent,
                                            inactiveThumbColor:
                                                Colors.redAccent,
                                            inactiveTrackColor: Colors.red,
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget build(BuildContext context) {
//   return new StreamBuilder(
//       stream: Firestore.instance
//           .collection("weeklymenu")
//           .document(EcommerceApp.sharedPreferences
//                   .getString(EcommerceApp.userUID) +
//               EcommerceApp.sharedPreferences.getString(EcommerceApp.mealtime) +
//               EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday))
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return new Text("Loading");
//         }
//         var userDocument = snapshot.data;
//         return userDocument;
//       });
// }

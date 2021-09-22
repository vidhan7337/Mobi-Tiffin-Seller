import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:tiffin_app/DialogBox/errorDialog.dart';
import 'package:tiffin_app/Screen/orders/orderdetails.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiffin_app/Widgets/color.dart';

class Preparing extends StatefulWidget {
  @override
  _PreparingState createState() => _PreparingState();
}

class _PreparingState extends State<Preparing> {
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Orders')
          .orderBy("publishedDate", descending: true)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Container(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 100.0,
                  ),
                  Image.network(
                    'https://icon-library.com/images/no-data-icon/no-data-icon-10.jpg',
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    AppLocalizations.of(context).orderpreparingwillappearhere,
                    style: TextStyle(fontSize: 19.0),
                  )
                ],
              ),
            ),
          );
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).orderpreparingwillappearhere,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: dataSnapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Column(
                        children: [
                          dataSnapshot.data.documents[i].data['sp_id'] ==
                                  EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userUID)
                              ? dataSnapshot.data.documents[i]
                                          .data['order_status'] ==
                                      "2"
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: screenwidth,
                                        child: Card(
                                          elevation: 4.0,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetail(
                                                          order: dataSnapshot
                                                              .data
                                                              .documents[i]
                                                              .data,
                                                          id: dataSnapshot
                                                              .data
                                                              .documents[i]
                                                              .documentID,
                                                        )),
                                              );
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0,
                                                          top: 10.0),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                            .orderid +
                                                        dataSnapshot
                                                            .data
                                                            .documents[i]
                                                            .documentID,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width:
                                                            screenwidth / 1.8,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                for (int j = 0;
                                                                    j <
                                                                        dataSnapshot
                                                                            .data
                                                                            .documents[i]
                                                                            .data['order_item']
                                                                            .length;
                                                                    j++)
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                8.0,
                                                                            right:
                                                                                8.0,
                                                                            top:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          dataSnapshot
                                                                              .data
                                                                              .documents[i]
                                                                              .data['order_item'][j]['order_itemtitle'],
                                                                          style: TextStyle(
                                                                              color: tyrianPurple,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15.0),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                8.0,
                                                                            right:
                                                                                8.0,
                                                                            top:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          AppLocalizations.of(context).quantity +
                                                                              dataSnapshot.data.documents[i].data['order_item'][j]['order_itemquantity'].toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 15.0),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0),
                                                              child: Text(
                                                                "₹" +
                                                                    dataSnapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data[
                                                                            'order_totalprice']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0),
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                            context)
                                                                        .time +
                                                                    dataSnapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data['time_slot'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0),
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                            context)
                                                                        .address +
                                                                    " " +
                                                                    dataSnapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data['c_address'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: screenwidth / 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  top: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .orderstatus,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .prepaing,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                height: 50.0,
                                                              ),
                                                              Text(
                                                                DateFormat
                                                                        .yMMMd()
                                                                    .add_jm()
                                                                    .format(DateTime.parse(dataSnapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data[
                                                                            'publishedDate']
                                                                        .toDate()
                                                                        .toString())),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Container(
                                                      width: screenwidth / 2,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: valhalla),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0)),
                                                      child: FlatButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ErrorAlertDialog(
                                                                    message: AppLocalizations.of(context)
                                                                            .order +
                                                                        " " +
                                                                        dataSnapshot
                                                                            .data
                                                                            .documents[
                                                                                i]
                                                                            .documentID +
                                                                        " " +
                                                                        AppLocalizations.of(context)
                                                                            .givenfordelivery,
                                                                  );
                                                                });
                                                            Firestore.instance
                                                                .collection(
                                                                    'Orders')
                                                                .document(dataSnapshot
                                                                    .data
                                                                    .documents[
                                                                        i]
                                                                    .documentID)
                                                                .updateData({
                                                              "order_status":
                                                                  "4"
                                                            });
                                                          },
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .givenfordelivery)),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : dataSnapshot.data.documents[i]
                                              .data['order_status'] ==
                                          "4"
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: screenwidth,
                                            child: Card(
                                              elevation: 4.0,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderDetail(
                                                              order: dataSnapshot
                                                                  .data
                                                                  .documents[i]
                                                                  .data,
                                                              id: dataSnapshot
                                                                  .data
                                                                  .documents[i]
                                                                  .documentID,
                                                            )),
                                                  );
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0,
                                                              top: 10.0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                    context)
                                                                .orderid +
                                                            dataSnapshot
                                                                .data
                                                                .documents[i]
                                                                .documentID,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: screenwidth /
                                                                1.8,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    for (int j =
                                                                            0;
                                                                        j < dataSnapshot.data.documents[i].data['order_item'].length;
                                                                        j++)
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 8.0,
                                                                                right: 8.0,
                                                                                top: 8.0),
                                                                            child:
                                                                                Text(
                                                                              dataSnapshot.data.documents[i].data['order_item'][j]['order_itemtitle'],
                                                                              style: TextStyle(color: tyrianPurple, fontWeight: FontWeight.bold, fontSize: 15.0),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 8.0,
                                                                                right: 8.0,
                                                                                top: 8.0),
                                                                            child:
                                                                                Text(
                                                                              AppLocalizations.of(context).quantity + dataSnapshot.data.documents[i].data['order_item'][j]['order_itemquantity'].toString(),
                                                                              style: TextStyle(fontSize: 15.0),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0),
                                                                  child: Text(
                                                                    "₹" +
                                                                        dataSnapshot
                                                                            .data
                                                                            .documents[i]
                                                                            .data['order_totalprice']
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15.0),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0),
                                                                  child: Text(
                                                                    AppLocalizations.of(context)
                                                                            .time +
                                                                        dataSnapshot
                                                                            .data
                                                                            .documents[i]
                                                                            .data['time_slot'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15.0),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0),
                                                                  child: Text(
                                                                    AppLocalizations.of(context)
                                                                            .address +
                                                                        ": " +
                                                                        dataSnapshot
                                                                            .data
                                                                            .documents[i]
                                                                            .data['c_address'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15.0),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                screenwidth / 4,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      top: 8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .orderstatus,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .outfordelivery,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        50.0,
                                                                  ),
                                                                  Text(
                                                                    DateFormat.yMMMd().add_jm().format(DateTime.parse(dataSnapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data[
                                                                            'publishedDate']
                                                                        .toDate()
                                                                        .toString())),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Container(
                                                          width:
                                                              screenwidth / 2,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      valhalla),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0)),
                                                          child: FlatButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return ErrorAlertDialog(
                                                                        message: AppLocalizations.of(context).order +
                                                                            " " +
                                                                            dataSnapshot.data.documents[i].documentID +
                                                                            " " +
                                                                            AppLocalizations.of(context).delivered,
                                                                      );
                                                                    });
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Orders')
                                                                    .document(dataSnapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .documentID)
                                                                    .updateData({
                                                                  "order_status":
                                                                      "5"
                                                                });
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Orders')
                                                                    .document(dataSnapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .documentID)
                                                                    .updateData({
                                                                  "payment_status":
                                                                      "Done"
                                                                });
                                                              },
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .delivered)),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(0.0))
                              : Padding(padding: EdgeInsets.all(0.0)),
                        ],
                      );
                    }),
              ),
            ],
          );
        }
      },
    );
  }
}

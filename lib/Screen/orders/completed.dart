import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:tiffin_app/Screen/orders/orderdetails.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
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
                    AppLocalizations.of(context).completedpastorderwillappear,
                    style: TextStyle(fontSize: 20.0),
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
                  AppLocalizations.of(context).completedpastorderwillappear,
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
                                          "5" ||
                                      dataSnapshot.data.documents[i]
                                              .data['order_status'] ==
                                          "3"
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
                                                                    ": " +
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
                                                              dataSnapshot
                                                                          .data
                                                                          .documents[
                                                                              i]
                                                                          .data['order_status'] ==
                                                                      "5"
                                                                  ? Text(
                                                                      AppLocalizations.of(
                                                                              context)
                                                                          .delivered,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          color:
                                                                              green,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  : Text(
                                                                      AppLocalizations.of(
                                                                              context)
                                                                          .reject,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          color:
                                                                              red,
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                dataSnapshot.data.documents[i]
                                                                    .data[
                                                                'order_rating'] !=
                                                            null &&
                                                        dataSnapshot
                                                                    .data
                                                                    .documents[i]
                                                                    .data[
                                                                'order_status'] ==
                                                            '5'
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10.0,
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(AppLocalizations
                                                                    .of(context)
                                                                .rating),
                                                            SmoothStarRating(
                                                              color:
                                                                  tyrianPurple,
                                                              borderColor:
                                                                  tyrianPurple,
                                                              isReadOnly: true,
                                                              rating: dataSnapshot
                                                                      .data
                                                                      .documents[i]
                                                                      .data[
                                                                  'order_rating'],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding: EdgeInsets.all(
                                                            0.0)),
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

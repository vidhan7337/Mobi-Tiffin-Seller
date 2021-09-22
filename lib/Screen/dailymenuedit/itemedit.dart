import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:tiffin_app/DialogBox/errorDialog.dart';
import 'package:tiffin_app/Screen/home.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiffin_app/Widgets/loadingWidget.dart';

class ItemEdit extends StatefulWidget {
  final Map<dynamic, dynamic> item;
  final String id;
  ItemEdit({this.item, this.id});
  @override
  _ItemEditState createState() => _ItemEditState();
}

class _ItemEditState extends State<ItemEdit> {
  TextEditingController _menuitem = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();
  var file;

  var b;
  String menu_id = DateTime.now().millisecondsSinceEpoch.toString();

  clearFormInfo() {
    setState(() {
      file = null;
      b = null;
      _menuitem.clear();
      _price.clear();
      _description.clear();
    });
  }

  Future<void> uploadImageAndSaveItemInfo() async {
    if (b == null) {
      saveItemInfo(file);
    } else {
      String imageDownloadUrl = await uploadItemImage(b);

      saveItemInfo(imageDownloadUrl);
    }
  }

  Future<void> _selectandPickImage() async {
    var imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      b = imagefile;
    });
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("dailymenu");
    StorageUploadTask uploadTask =
        storageReference.child("menu_$menu_id.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("serviceprovider");
    itemsRef
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("dailymenu")
        .document(widget.id)
        .setData({
      "title": widget.item["title"],
      "Description": widget.item["Description"],
      "price": widget.item["price"],
      "publishedDate": DateTime.now(),
      "status": true,
      "thumbnailUrl": downloadUrl,
      "uid": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
    });

    setState(() {
      file = null;
      // uploading = false;
      // productId = DateTime.now().millisecondsSinceEpoch.toString();
      menu_id = DateTime.now().millisecondsSinceEpoch.toString();
      _menuitem.clear();
      _price.clear();
      _description.clear();
      // loading = false;
    });
    showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(
            message: AppLocalizations.of(context).menuadd,
          );
        });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UploadPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;

    file = widget.item['thumbnailUrl'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // clearFormInfo();
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: new BoxDecoration(color: carrotOrange),
        ),
        title: Text(
          AppLocalizations.of(context).edititem,
          style: TextStyle(color: valhalla),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 230.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: b == null
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          child: Image.network(
                            file,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(b), fit: BoxFit.cover)),
                        ),
                      ),
                    ),
            ),
            Padding(padding: EdgeInsets.only(top: 12.0)),
            Center(
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  child: Text(
                    AppLocalizations.of(context).addimagefood,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: white,
                        fontWeight: FontWeight.bold),
                  ),
                  color: tyrianPurple,
                  onPressed: () {
                    // print(EcommerceApp.sharedPreferences
                    //     .getString(EcommerceApp.mealtime));
                    // print(EcommerceApp.sharedPreferences
                    //     .getString(EcommerceApp.weekday));
                    // showDialog(
                    //     context: context,
                    //     builder: (ctx) => AlertDialog(
                    //           title: Text("Food Dish Image"),
                    //           actions: <Widget>[
                    //             FlatButton(
                    //               onPressed: () {
                    //                 _selectandPickImage();
                    //               },
                    //               child: Text("Select From Gallery"),
                    //             ),
                    //             FlatButton(
                    //               onPressed: () {
                    //                 capturePhotoWithCamera();
                    //               },
                    //               child: Text("Select From Camera"),
                    //             ),
                    //             FlatButton(
                    //               onPressed: () {
                    //                 Navigator.of(ctx).pop();
                    //               },
                    //               child: Text("Cancel"),
                    //             ),
                    //           ],
                    //         ));
                    _selectandPickImage();
                    // takeImage(context);
                  }),
            ),
            ListTile(
              leading: Icon(
                Icons.menu_open,
                color: tyrianPurple,
              ),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  style: TextStyle(color: valhalla),
                  initialValue: widget.item['title'],
                  // controller: _menuitem,
                  onChanged: (value) {
                    setState(() {
                      widget.item['title'] = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).title,
                    hintStyle: TextStyle(color: valhalla),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(
              color: tyrianPurple,
            ),
            ListTile(
              leading: Icon(
                Icons.money,
                color: tyrianPurple,
              ),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  style: TextStyle(color: valhalla),
                  initialValue: widget.item['price'].toString(),
                  // controller: _price,
                  onChanged: (value) {
                    setState(() {
                      widget.item['price'] = value;
                    });
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    WhitelistingTextInputFormatter(new RegExp(('[0-9.]')))
                  ],
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).itemprice,
                    hintStyle: TextStyle(color: valhalla),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(
              color: tyrianPurple,
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: tyrianPurple,
              ),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  style: TextStyle(color: valhalla),
                  // controller: _description,
                  initialValue: widget.item["Description"],
                  onChanged: (value) {
                    setState(() {
                      widget.item["Description"] = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).description,
                    hintStyle: TextStyle(color: valhalla),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(
              color: tyrianPurple,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: screenwidth - 100.0,
                child: FlatButton(
                  onPressed: () {
                    widget.item["Description"] != "" &&
                            widget.item["price"] != "" &&
                            widget.item["title"] != ""
                        ? file == null
                            ? showDialog(
                                context: context,
                                builder: (context) {
                                  return ErrorAlertDialog(
                                    message: AppLocalizations.of(context)
                                        .plsselectimagefile,
                                  );
                                })
                            : uploadImageAndSaveItemInfo()
                        : showDialog(
                            context: context,
                            builder: (context) {
                              return ErrorAlertDialog(
                                message: AppLocalizations.of(context)
                                    .youhavenotaddedmenu,
                              );
                            });
                  },
                  color: tyrianPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  child: Text(
                    AppLocalizations.of(context).edit,
                    style: TextStyle(
                      color: white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Container(
                width: screenwidth - 100.0,
                child: FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return AlertDialog(
                            content:
                                Text(AppLocalizations.of(context).suredelete),
                            actions: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  Firestore.instance
                                      .collection("serviceprovider")
                                      .document(EcommerceApp.sharedPreferences
                                          .getString(EcommerceApp.userUID))
                                      .collection("dailymenu")
                                      .document(widget.id)
                                      .delete();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                color: red,
                                child: Center(
                                  child: Text(AppLocalizations.of(context).yes),
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: green,
                                child: Center(
                                  child: Text(AppLocalizations.of(context).no),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  color: tyrianPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  child: Text(
                    AppLocalizations.of(context).delete,
                    style: TextStyle(
                      color: white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

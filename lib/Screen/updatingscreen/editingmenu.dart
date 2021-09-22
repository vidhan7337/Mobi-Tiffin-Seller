// import 'dart:html';

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiffin_app/Config/config.dart';
import 'package:tiffin_app/DialogBox/errorDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiffin_app/DialogBox/loadingDialog.dart';
import 'package:tiffin_app/Screen/home.dart';
import 'package:tiffin_app/Screen/menueditor.dart';
import 'package:tiffin_app/Widgets/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiffin_app/Widgets/loadingWidget.dart';

class Editmenu extends StatefulWidget {
  @override
  _EditmenuState createState() => _EditmenuState();
}

class _EditmenuState extends State<Editmenu>
    with AutomaticKeepAliveClientMixin<Editmenu> {
  bool get wantKeepAlive => true;
  TextEditingController _menuitem = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();
  var file;
  bool uploading = false;

  String menu_id = DateTime.now().millisecondsSinceEpoch.toString();

  // takeImage(mContext) {
  //   return showDialog(
  //       context: mContext,
  //       builder: (con) {
  //         return SimpleDialog(
  //           title: Text(
  //             "Item Image",
  //             style:
  //                 TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
  //           ),
  //           children: [
  //             SimpleDialogOption(
  //               child: Text("Capture with Camera",
  //                   style: TextStyle(
  //                     color: Colors.green,
  //                   )),
  //               onPressed: capturePhotoWithCamera,
  //             ),
  //             SimpleDialogOption(
  //               child: Text("Select from Gallery",
  //                   style: TextStyle(
  //                     color: Colors.green,
  //                   )),
  //               onPressed: pickPhotoFromGallery,
  //             ),
  //             SimpleDialogOption(
  //               child: Text("Cancel",
  //                   style: TextStyle(
  //                     color: Colors.green,
  //                   )),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }

  // pickPhotoFromGallery() async {
  //   Navigator.pop(context);
  //   var imageFile = await ImagePicker.pickImage(
  //     source: ImageSource.gallery,
  //   );

  //   setState(() {
  //     file = imageFile;
  //   });
  // }

  clearFormInfo() {
    setState(() {
      file = null;
      _menuitem.clear();
      _price.clear();
      _description.clear();
    });
  }

  Future<void> uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    if (file == null) {
    } else {
      String imageDownloadUrl = await uploadItemImage(file);

      saveItemInfo(imageDownloadUrl);
    }
  }

  Future<void> _selectandPickImage() async {
    var imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imagefile;
    });
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("weeklymenu");
    StorageUploadTask uploadTask =
        storageReference.child("menu_$menu_id.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("weeklymenu");
    itemsRef
        .document(EcommerceApp.sharedPreferences
                .getString(EcommerceApp.userUID) +
            EcommerceApp.sharedPreferences.getString(EcommerceApp.mealtime) +
            EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday))
        .setData({
      "title": _menuitem.text.trim(),
      "Description": _description.text.trim(),
      "price": int.parse(_price.text),
      "publishedDate": DateTime.now(),
      "status": true,
      "thumbnailUrl": downloadUrl,
      "weekday": EcommerceApp.sharedPreferences.getString(EcommerceApp.weekday),
      "mealtime":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.mealtime),
      "uid": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
    });

    setState(() {
      file = null;
      uploading = false;
      // productId = DateTime.now().millisecondsSinceEpoch.toString();
      menu_id = DateTime.now().millisecondsSinceEpoch.toString();
      _menuitem.clear();
      _price.clear();
      _description.clear();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            clearFormInfo();
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: new BoxDecoration(color: carrotOrange),
        ),
        title: Text(
          AppLocalizations.of(context).updatemenu,
          style: TextStyle(color: valhalla),
        ),
      ),
      body: uploading
          ? LoadingAlertDialog(
              message: "Uploading....",
            )
          : Container(
              child: ListView(
                children: [
                  Container(
                    height: 230.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: file == null
                        ? Center(
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                decoration: BoxDecoration(),
                              ),
                            ),
                          )
                        : Center(
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(file),
                                        fit: BoxFit.cover)),
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
                          print(EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.mealtime));
                          print(EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.weekday));
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
                      child: TextField(
                        style: TextStyle(color: valhalla),
                        controller: _menuitem,
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
                      child: TextField(
                        style: TextStyle(color: valhalla),
                        controller: _price,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
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
                      child: TextField(
                        style: TextStyle(color: valhalla),
                        controller: _description,
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
                          _menuitem.text.isNotEmpty &&
                                  _description.text.isNotEmpty &&
                                  _price.text.isNotEmpty
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
                          AppLocalizations.of(context).update,
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

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffin_app/Authentication/register2.dart';
import 'package:tiffin_app/Screen/home.dart';
import 'package:tiffin_app/Widgets/color.dart';
import '../Widgets/customTextField.dart';
import '../DialogBox/errorDialog.dart';
import '../DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import '../Store/storehome.dart';
import '../Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordtextEditingController =
      TextEditingController();
  final TextEditingController _phonetextEditingController =
      TextEditingController();
  final TextEditingController _addresstextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenwidth * 0.15,
                backgroundColor: white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenwidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            // Container(
            //   alignment: Alignment.bottomCenter,
            //   child: Image.asset(
            //     "images/register.png",
            //     height: 120.0,
            //     width: 500.0,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).selectlogo,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nametextEditingController,
                    data: Icons.person,
                    hintText: AppLocalizations.of(context).kitchenname,
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailtextEditingController,
                    data: Icons.email,
                    hintText: AppLocalizations.of(context).email,
                    isObsecure: false,
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _phonetextEditingController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(new RegExp(('[0-9]'))),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      obscureText: false,
                      cursorColor: valhalla,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: valhalla,
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        hintText: AppLocalizations.of(context).phone,
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: Icons.vpn_key_outlined,
                    hintText: AppLocalizations.of(context).password,
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cpasswordtextEditingController,
                    data: Icons.vpn_key,
                    hintText: AppLocalizations.of(context).confirmpass,
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _addresstextEditingController,
                    data: Icons.location_city,
                    hintText: AppLocalizations.of(context).address,
                    isObsecure: false,
                  ),
                ],
              ),
            ),
            Container(
              width: _screenwidth - 100.0,
              decoration: BoxDecoration(
                  color: tyrianPurple,
                  borderRadius: BorderRadius.circular(10.0)),
              child: TextButton(
                onPressed: () {
                  uploadAndSaveImage();
                  // _passwordtextEditingController.text ==
                  //         _cpasswordtextEditingController.text
                  //     ? _emailtextEditingController.text.isNotEmpty &&
                  //             _passwordtextEditingController.text.isNotEmpty &&
                  //             _nametextEditingController.text.isNotEmpty &&
                  //             _cpasswordtextEditingController.text.isNotEmpty &&
                  //             _phonetextEditingController.text.isNotEmpty &&
                  //             _addresstextEditingController.text.isNotEmpty
                  //         ? _registerUser()
                  //         : displayDialog("Please fill required information")
                  //     : displayDialog("Password do not match");
                },
                child: Text(
                  AppLocalizations.of(context).signup,
                  style: TextStyle(
                      color: white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 4.0,
              width: _screenwidth * 0.8,
              color: tyrianPurple,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: AppLocalizations.of(context).plsselectimagefile,
            );
          });
    } else {
      _passwordtextEditingController.text ==
              _cpasswordtextEditingController.text
          ? _emailtextEditingController.text.isNotEmpty &&
                  _passwordtextEditingController.text.isNotEmpty &&
                  _nametextEditingController.text.isNotEmpty &&
                  _cpasswordtextEditingController.text.isNotEmpty &&
                  _phonetextEditingController.text.isNotEmpty &&
                  _addresstextEditingController.text.isNotEmpty
              ? _phonetextEditingController.text.length == 10
                  ? uploadToStorage()
                  : displayDialog(
                      AppLocalizations.of(context).plswritephnnumber)
              : displayDialog(AppLocalizations.of(context).pleasefillinfo)
          : displayDialog(AppLocalizations.of(context).passwordnotmatch);
    }
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: AppLocalizations.of(context).registering,
          );
        });

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: AppLocalizations.of(context).authenticating,
          );
        });
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailtextEditingController.text.trim(),
            password: _passwordtextEditingController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => UploadPage());
        Navigator.pushReplacement(context, route);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).registersucc),
        ));
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance
        .collection("serviceprovider")
        .document(fUser.uid)
        .setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "available": false,
      "Kitchen Name": _nametextEditingController.text.trim(),
      "password": _passwordtextEditingController.text.trim(),
      "Mobile_no": _phonetextEditingController.text.trim(),
      "Address": _addresstextEditingController.text.trim(),
      "url": userImageUrl,
    });
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userUID, fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nametextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userphone, _phonetextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.addressID, _addresstextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(
        EcommerceApp.userpassword, _passwordtextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setBool(EcommerceApp.kitchenstatus, false);

    print(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName));
    // await EcommerceApp.sharedPreferences
    //     .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}

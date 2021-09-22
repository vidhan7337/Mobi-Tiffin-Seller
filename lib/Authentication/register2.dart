// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tiffin_app/Screen/home.dart';
// import '../Widgets/customTextField.dart';
// import '../DialogBox/errorDialog.dart';
// import '../DialogBox/loadingDialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// // import '../Store/storehome.dart';
// import '../Config/config.dart';
// import 'register.dart';

// class Register2 extends StatefulWidget {
//   @override
//   _Register2State createState() => _Register2State();
// }

// class _Register2State extends State<Register2> {
//   final TextEditingController _tiffintextEditingController =
//       TextEditingController();
//   final TextEditingController _phonetextEditingController =
//       TextEditingController();
//   final TextEditingController _lunchbookingtime1 = TextEditingController();
//   final TextEditingController _lunchbookingtime2 = TextEditingController();
//   final TextEditingController _dinnerbookingtime1 = TextEditingController();
//   final TextEditingController _dinnerbookingtime2 = TextEditingController();
//   final TextEditingController _lunchpricetextEditingController =
//       TextEditingController();
//   // final TextEditingController _dinnertimetextEditingController =
//   //     TextEditingController();
//   final TextEditingController _dinnerpricetextEditingController =
//       TextEditingController();
//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   String userImageUrl = "";
//   File _imageFile;
//   @override
//   Widget build(BuildContext context) {
//     double _screenwidth = MediaQuery.of(context).size.width,
//         _screenheight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Online Tiffin",
//           style: TextStyle(
//               fontSize: 55.0, color: white, fontFamily: "Signatra"),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         height: _screenheight,
//         width: _screenwidth,
//         decoration: new BoxDecoration(
//             gradient: new LinearGradient(
//           colors: [Colors.blueGrey, Colors.yellowAccent],
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//         )),
//         child: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 InkWell(
//                   onTap: _selectAndPickImage,
//                   child: CircleAvatar(
//                     radius: _screenwidth * 0.15,
//                     backgroundColor: white,
//                     backgroundImage:
//                         _imageFile == null ? null : FileImage(_imageFile),
//                     child: _imageFile == null
//                         ? Icon(
//                             Icons.add_photo_alternate,
//                             size: _screenwidth * 0.15,
//                             color: Colors.grey,
//                           )
//                         : null,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8.0,
//                 ),
//                 Form(
//                   key: _formkey,
//                   child: Column(
//                     children: [
//                       CustomTextField(
//                         controller: _tiffintextEditingController,
//                         data: Icons.person,
//                         hintText: "Your Kitchen Name",
//                         isObsecure: false,
//                       ),
//                       CustomTextField(
//                         controller: _phonetextEditingController,
//                         data: Icons.email,
//                         hintText: "Phone",
//                         isObsecure: false,
//                       ),
//                       // CustomTextField(
//                       //   controller: _lunchtimetextEditingController,
//                       //   data: Icons.person,
//                       //   hintText: "Timing to order lunch",
//                       //   isObsecure: false,
//                       // ),
//                       // Row(
//                       //   children: [
//                       //     CustomTextField(
//                       //       controller: _lunchbookingtime1,
//                       //       data: Icons.alarm,
//                       //       hintText: "Lunch Booking Start Time",
//                       //       isObsecure: false,
//                       //     ),
//                       //     Text("To"),
//                       //     CustomTextField(
//                       //       controller: _lunchbookingtime2,
//                       //       data: Icons.alarm,
//                       //       hintText: "Lunch Booking End Time",
//                       //       isObsecure: false,
//                       //     ),
//                       //   ],
//                       // ),
//                       CustomTextField(
//                         controller: _lunchpricetextEditingController,
//                         data: Icons.person,
//                         hintText: "Price of lunch",
//                         isObsecure: false,
//                       ),
//                       // CustomTextField(
//                       //   controller: _dinnertimetextEditingController,
//                       //   data: Icons.person,
//                       //   hintText: "Timing to order dinner",
//                       //   isObsecure: false,
//                       // ),
//                       CustomTextField(
//                         controller: _dinnerpricetextEditingController,
//                         data: Icons.person,
//                         hintText: "price of dinner",
//                         isObsecure: false,
//                       ),
//                     ],
//                   ),
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     uploadAndSaveImage();
//                   },
//                   color: Colors.pink,
//                   child: Text(
//                     "Update details",
//                     style: TextStyle(color: white),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30.0,
//                 ),
//                 Container(
//                   height: 4.0,
//                   width: _screenwidth * 0.8,
//                   color: Colors.pink,
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectAndPickImage() async {
//     _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//   }

//   Future<void> uploadAndSaveImage() async {
//     if (_imageFile == null) {
//       showDialog(
//           context: context,
//           builder: (c) {
//             return ErrorAlertDialog(
//               message: "Please select an image file..",
//             );
//           });
//     } else {
//       if (_tiffintextEditingController.text.isNotEmpty &&
//           _phonetextEditingController.text.isNotEmpty &&
//           // _lunchtimetextEditingController.text.isNotEmpty &&
//           _lunchpricetextEditingController.text.isNotEmpty &&
//           // _dinnertimetextEditingController.text.isNotEmpty &&
//           _dinnerpricetextEditingController.text.isNotEmpty) {
//         uploadToStorage();
//       } else {
//         displayDialog("Please fill required information");
//       }
//     }
//   }

//   displayDialog(String msg) {
//     showDialog(
//         context: context,
//         builder: (c) {
//           return ErrorAlertDialog(
//             message: msg,
//           );
//         });
//   }

//   uploadToStorage() async {
//     showDialog(
//         context: context,
//         builder: (c) {
//           return LoadingAlertDialog(
//             message: "authenticating wait...",
//           );
//         });
//     String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

//     StorageReference storageReference =
//         FirebaseStorage.instance.ref().child(imageFileName);

//     StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

//     StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

//     await taskSnapshot.ref.getDownloadURL().then((urlImage) {
//       userImageUrl = urlImage;

//       if (EcommerceApp.auth.currentUser != null) {
//         saveUserInfoToFireStore().then((value) {
//           Navigator.pop(context);
//           Route route = MaterialPageRoute(builder: (c) => UploadPage());
//           Navigator.push(context, route);
//         });
//       } else {
//         print("not");
//       }
//     });
//   }

//   // FirebaseAuth _auth = FirebaseAuth.instance;
//   // void _registerUser() async {
//   //   // FirebaseUser firebaseUser;
//   //   // firebaseUser = EcommerceA
//   //   // await _auth
//   //   //     .createUserWithEmailAndPassword(
//   //   //         email: _emailtextEditingController.text.trim(),
//   //   //         password: _passwordtextEditingController.text.trim())
//   //   //     .then((auth) {
//   //   //   firebaseUser = auth.user;
//   //   // }).catchError((error) {
//   //   //   Navigator.pop(context);
//   //   //   showDialog(
//   //   //       context: context,
//   //   //       builder: (c) {
//   //   //         return ErrorAlertDialog(
//   //   //           message: error.message.toString(),
//   //   //         );
//   //   //       });

//   //   EcommerceApp.auth.currentUser();

//   //   if (EcommerceApp.auth.currentUser() != null) {
//   //     saveUserInfoToFireStore(EcommerceApp.user).then((value) {
//   //       Navigator.pop(context);
//   //       Route route = MaterialPageRoute(builder: (c) => Home());
//   //       Navigator.push(context, route);
//   //     });
//   //   }
//   // }

//   Future saveUserInfoToFireStore() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String id = pref.getString(EcommerceApp.userUID);
//     await Firestore.instance
//         .collection("serviceprovider")
//         .document(id)
//         .collection("Kitchen Details")
//         .document(_tiffintextEditingController.text.trim())
//         .setData({
//       "kitchenname": _tiffintextEditingController.text.trim(),
//       "phone": _phonetextEditingController.text.trim(),
//       // "lunchtime": _lunchtimetextEditingController.text.trim(),
//       "lunchprice": _lunchpricetextEditingController.text.trim(),
//       // "dinnertime": _dinnertimetextEditingController.text.trim(),
//       "dinnerprice": _dinnerpricetextEditingController.text.trim(),
//       "url": userImageUrl,
//       // EcommerceApp.userCartList: ["garbageValue"],
//     });
//     await EcommerceApp.sharedPreferences
//         .setString(EcommerceApp.userkitchen, _tiffintextEditingController.text);
//     await EcommerceApp.sharedPreferences
//         .setString(EcommerceApp.userphone, _phonetextEditingController.text);
//     // await EcommerceApp.sharedPreferences.setString(
//     //     EcommerceApp.userlunchtime, _lunchtimetextEditingController.text);
//     await EcommerceApp.sharedPreferences.setString(
//         EcommerceApp.userlunchprice, _lunchpricetextEditingController.text);
//     // await EcommerceApp.sharedPreferences.setString(
//     //     EcommerceApp.userdinnertime, _dinnertimetextEditingController.text);
//     await EcommerceApp.sharedPreferences.setString(
//         EcommerceApp.userdinnerprice, _dinnerpricetextEditingController.text);
//     await EcommerceApp.sharedPreferences
//         .setString(EcommerceApp.userAvatarUrl, userImageUrl);
//   }
// }

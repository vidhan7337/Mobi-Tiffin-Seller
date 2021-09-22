import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuItemlunch {
  static SharedPreferences sharedPreferences;
  static final String title = 'title';
  static final String mealtime = 'mealtime';
  static final String weekday = 'weekday';
  static final String publishedDate = '';
  static final String thumbnailUrl = 'thumbnailUrl';
  static final String description = 'description';
  static final String status = 'status';
  static final int price = 7;

//   MenuItem(
//       {this.title,
//       this.mealtime,
//       this.weekday,
//       this.uid,
//       this.publishedDate,
//       this.thumbnailUrl,
//       this.description,
//       this.status,
//       this.price});

//   MenuItem.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     mealtime = json['mealtime'];
//     weekday = json['weekday'];
//     uid = json['uid'];
//     publishedDate = json['publishedDate'];
//     thumbnailUrl = json['thumbnailUrl'];
//     description = json['description'];
//     status = json['status'];
//     price = json['price'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['mealtime'] = this.mealtime;
//     data['weekday'] = this.weekday;
//     data['price'] = this.price;
//     data['uid'] = this.uid;
//     if (this.publishedDate != null) {
//       data['publishedDate'] = this.publishedDate;
//     }
//     data['thumbnailUrl'] = this.thumbnailUrl;
//     data['description'] = this.description;
//     data['status'] = this.status;
//     return data;
//   }
// }

// class PublishedDate {
//   String date;

//   PublishedDate({this.date});

//   PublishedDate.fromJson(Map<String, dynamic> json) {
//     date = json['$date'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$date'] = this.date;
//     return data;
//   }
}

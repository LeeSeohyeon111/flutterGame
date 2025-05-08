// import 'package:my_flutter_application/constants.dart';
// import 'package:uuid/uuid.dart';

// import 'invite_model.dart';


// // class UserModel {
// //   String uid;
// //   String name;
// //   String email;
// //   String image;
// //   String createdAt;
// //   int playerRating;
// //   String uuid;
// //   String? color;
// //   List<Invite> invites = [];

// //   UserModel({
// //     required this.uid,
// //     required this.name,
// //     required this.email,
// //     this.image,
// //     required this.createdAt,
// //     required this.playerRating,
// //     required this.uuid,
// //     this.color,
// //     });
//   class UserModel {
//   String uid;
//   String name;
//   String email;
//   String? image;         // ✅ nullable
//   String? createdAt;     // ✅ nullable
//   int? playerRating;     // ✅ nullable
//   String uuid;
//   String? color;
//   List<Invite> invites = [];

//   UserModel({
//     required this.uid,
//     required this.name,
//     required this.email,
//     this.image,
//     this.createdAt,
//     this.playerRating,
//     required this.uuid,
//     this.color,
//   });

//   factory UserModel.fromRTDB(Map<String, dynamic> data) {
//     return UserModel(
//       // data['username'],
//       // data['uuid'],
//       // data['color'],
//       uid: data['uid'] ?? '',
//       name: data['username'] ?? '',
//       email: data['email'] ?? '',
//       image: data['image'] ?? '',
//       createdAt: data['createdAt'] ?? '',
//       playerRating: data['playerRating'] ?? 1200,
//       uuid: data['uuid'] ?? '',
//       color: data['color'],

//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       Constants.uid: uid,
//       Constants.name: name,
//       Constants.email: email,
//       Constants.image: image,
//       Constants.createdAt: createdAt,
//       Constants.playerRating: playerRating,
//       'uuid': uuid,
//       if (color != null) 'color': color,
//     };
//   }
//   Map<String, dynamic> toJson({bool includeColor = true}) {
//     final data = {
//       'username': name,
//       'uuid': uuid,
//     };
//     if (includeColor && color != null) {
//       data['color'] = color!;
//     }
//     return data;
//   }
//   factory UserModel.fromMap(Map<String, dynamic> data) {
    // return UserModel(
    //   uid: data[Constants.uid] ?? '',
    //   name: data[Constants.name] ?? '',
    //   email: data[Constants.email] ?? '',
    //   image: data[Constants.image] ?? '',
    //   createdAt: data[Constants.createdAt] ?? '',
    //   playerRating: data[Constants.playerRating] ?? 1200,
    //   uuid: data['uuid'] ?? '',
    //   // color: data['color'],
    // );
//   }
// }

import 'package:my_flutter_application/constants.dart';
import 'invite_model.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String image;
  String createdAt;
  int playerRating;
  String uuid;
  String? color;                 // ✅ nullable
  List<Invite> invites = [];

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.createdAt,
    required this.playerRating,
    required this.uuid,
    this.color,
  });

  factory UserModel.fromRTDB(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      createdAt: data['createdAt'] ?? '',
      playerRating: data['playerRating'] ?? 1200,
      uuid: data['uuid'] ?? '',
      color: data['color'], // nullable 허용
    );
  }

  Map<String, dynamic> toMap() {
    final data = {
      Constants.uid: uid,
      Constants.name: name,
      Constants.email: email,
      Constants.image: image,
      Constants.createdAt: createdAt,
      Constants.playerRating: playerRating,
      'uuid': uuid,
    };
    if (color != null) data['color'] ='color';
    return data;
  }

  Map<String, dynamic> toJson({bool includeColor = true}) {
    final data = {
      'username': name,
      'uuid': uuid,
    };
    if (includeColor && color != null) {
      data['color'] = color!;
    }
    return data;
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data[Constants.uid] ?? '',
      name: data[Constants.name] ?? '',
      email: data[Constants.email] ?? '',
      image: data[Constants.image] ?? '',
      createdAt: data[Constants.createdAt] ?? '',
      playerRating: data[Constants.playerRating] ?? 1200,
      uuid: data['uuid'] ?? '',
      color: data['color'], // nullable 허용
    );
  }
}

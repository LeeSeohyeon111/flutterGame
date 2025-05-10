import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/room_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  final DatabaseReference database = //FirebaseDatabase.instance.ref();
  FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://my-flutter-app-f4e1c-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();
  
  static const kUsersPath = 'users';
  static const kRoomsPath = 'rooms';
  static const kGamesPath = 'games';

  Future<void> addUserToDB(UserModel user) async {
    final usersRef = database.child(kUsersPath);
    try {
      await usersRef
          .child(user.uuid)
          .set({'username': user.name, 'uuid': user.uuid});
    } catch (e) {
      throw Exception(e);
    }
  }

  //Future<void> addGameToTheRoomInDB

  Future<void> addRoomToDB(Room room) async {
    final roomsRef = database.child(kRoomsPath);
    try {
      await roomsRef.child(room.roomId).set({
        'room_id': room.roomId,
        'room_name': room.roomName,
        'owner': {'username': room.owner.name, 'uuid': room.owner.uuid},
        'guest': {
          'username': null,
          'uuid': null,
        },
      });
    } on FirebaseException catch (e) {
      print('Firebase Exception: $e');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateRoomInDB(Room room) async {
    final roomsRef = database.child(kRoomsPath);
    //print(room.toJson());
    try {
      await roomsRef.child(room.roomId).update(room.toJson());
    } on FirebaseException catch (e) {
      print('Firebase Exception: $e');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  //유저 RTDB에서 get하기기
  Future<UserModel?> getUserFromRTDB(String uuid) async {
  try {
    final snapshot = await database.child('users/$uuid').once();
    final data = snapshot.snapshot.value;

    if (data != null && data is Map) {
      final userData = Map<String, dynamic>.from(data);

      return UserModel(
        uid: userData['uid'] ?? '',
        name: userData['username'] ?? '',
        email: userData['email'] ?? '',
        image: userData['image'] ?? '',
        createdAt: userData['createdAt'] ?? '',
        playerRating: userData['playerRating'] ?? 1200,
        uuid: userData['uuid'] ?? '',
        color: userData['color'],
      );
    }
  } catch (e) {
    print('🔥 Failed to fetch user from RTDB: $e');
  }
  return null;
}


  
}

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_flutter_application/services/firebase_RTDB_service.dart';
import 'package:uuid/uuid.dart';

import '../../models/invite_model.dart';
import '../../models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserModel? _user;
  UserModel? get user => _user;

  List<Invite> _invites = [];
  List<Invite> get invites => _invites;

  //late StreamSubscription _invitesSubscription;

  final _firebaseDb = //FirebaseDatabase.instance.ref();
  FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://my-flutter-app-f4e1c-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();
  UserCubit() : super(UserNotRegistered());

  // Future<void> addUser(String username) async {
  //   emit(UserBeingRegistered());
  //   try {
  //     final UserModel newUser = UserModel(name, Uuid().v4());
  //     await DatabaseService().addUserToDB(newUser);
  //     _user = newUser;
  //     //_listenToInvitesForCurrentUser();
  //     emit(UserRegistered(newUser));
  //   } on FirebaseException catch (e) {
  //     print('FireException: $e');
  //     emit(UserRegistrationError(e.toString()));
  //   } catch (e) {
  //     emit(UserRegistrationError(e.toString()));
  //   }
  //   //print(user?.username);
  // }
Future<void> addUser(UserModel authUser) async {
  emit(UserBeingRegistered());
  try {
    final UserModel newUser = UserModel(
      uid: authUser.uid,
      name: authUser.name,
      email: authUser.email,
      image: authUser.image,
      createdAt: authUser.createdAt,
      playerRating: authUser.playerRating,
      uuid: authUser.uuid,
      color: authUser.color,
    );

    await DatabaseService().addUserToDB(newUser);
    _user = newUser;
    emit(UserRegistered(newUser));
  } catch (e) {
    emit(UserRegistrationError(e.toString()));
  }
}



  // void _listenToInvitesForCurrentUser() async {
  //   _invitesSubscription = _firebaseDb
  //       .child('users/${user?.uuid}/invites')
  //       .onValue
  //       .listen((event) {
  //     print('something changed in invites');
  //   });
  // }
}

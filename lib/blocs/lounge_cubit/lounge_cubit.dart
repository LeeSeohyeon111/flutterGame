import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/room_model.dart';
///대기실 화면시 방목록 보여줌.
//Cubit이라는 상태관리 클래스를 상속받고, Room 객체들의 목록(List<Room>)을 상태로 관리
class LoungeCubit extends Cubit<List<Room>> {
  List<Room> _lounge = [];
  final _firebaseDb = //FirebaseDatabase.instance.ref(); //realtime db연결. 위치는는 root가리킴
  FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://my-flutter-app-e0c99-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();
  List<Room> get lounge => _lounge; //getter

  static const kRoomsPath = 'rooms';

  late StreamSubscription _loungeStream;

  LoungeCubit() : super([]) { //생성자. 초기상태는 빈방.
    _listenToLoungeUpdates(); 
  }

  void _listenToLoungeUpdates() { //변화생길때마다 _lounge업데이트. 
    _loungeStream = _firebaseDb.child(kRoomsPath).onValue.listen((event) { //rooms 실시간 감시시
      if (event.snapshot.value != null) { //room데이터 존재시시
        final allRooms =
            Map<String, dynamic>.from(event.snapshot.value as dynamic);  // Firebase에서 가져온 데이터를 Map<String, dynamic> 형태로 변환합니다.
        _lounge = allRooms.values//이값을 room객ㅊ체로 바꿈
            .map((lobbyAsJSON) => Room.fromRTDB(Map<String, dynamic>.from(
                Map<String, dynamic>.from(lobbyAsJSON))))
            .toList(); //리스트로 lounge에 저장.
      } else {
        _lounge = []; //비엇으면 lounge도 빈리스트로로
      }
      emit(_lounge); //화면 새로갱신.
    });
  }
}

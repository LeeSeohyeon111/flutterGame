
import 'package:equatable/equatable.dart';
import 'package:my_flutter_application/models/game_model.dart';
import 'package:my_flutter_application/models/user_model.dart';
import 'package:my_flutter_application/services/firebase_RTDB_service.dart';

class Room extends Equatable {
  final UserModel owner;
  final String roomName;
  final String roomId;
  final UserModel? guest;
  final Game? game;
  final DatabaseService _databaseService = DatabaseService();

  Room({
    required this.owner,
    required this.roomName,
    required this.roomId,
    this.guest,
    this.game,
  });

  factory Room.fromRTDB(Map<String, dynamic> data) {
    String roomId = data['room_id'];
    String roomName = data['room_name'];

    // UserModel user = UserModel(data['owner']['username'], data['owner']['uuid']);
    Map<String, dynamic> ownerData = Map<String, dynamic>.from(data['owner']);
    UserModel user = UserModel.fromRTDB(ownerData);

    UserModel? guest;
    if (data['guest'] != null) {
      Map<String, dynamic> guestData = Map<String, dynamic>.from(data['guest']);
      guest = UserModel.fromRTDB(guestData);
    }

    Game? game;
    if (data['game'] != null) {
      game = Game.fromRTDB(data);
    }

    return Room(
      owner: user,
      guest: guest,
      roomName: roomName,
      roomId: roomId,
      game: game,
    );
  }

  // Method to create a copy of Room with updated fields
  Room copyWith({
    UserModel? owner,
    String? roomName,
    String? roomId,
    UserModel? guest,
    Game? game,
  }) {
    return Room(
      owner: owner ?? this.owner,
      roomName: roomName ?? this.roomName,
      roomId: roomId ?? this.roomId,
      guest: guest ?? this.guest,
      game: game ?? this.game,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner': owner.toJson(includeColor: false),
      'room_name': roomName,
      'room_id': roomId,
      'guest': guest?.toJson(includeColor: false),
      'game': game?.toJson(),
    };
  }

  @override
  List<Object?> get props => [owner, roomName, roomId, guest, game];
}
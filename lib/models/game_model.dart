
import 'package:equatable/equatable.dart';
import 'package:my_flutter_application/models/user_model.dart';


class Game extends Equatable {
  final Map<String, UserModel> players;
  final String status;
  final String currentMove;
  final String fen;
  final bool isCheckmate;
  final bool isDraw;
  final UserModel? winner;

  const Game({
    required this.players,
    required this.status,
    required this.currentMove,
    required this.fen,
    this.isCheckmate = false,
    this.isDraw = false,
    this.winner,
  });

  factory Game.fromRTDB(Map<String, dynamic> data) {
    Map<String, UserModel> players = {};

    //print('from Game.fromRTDB: ${data['game'].toString()}');

    data['game']['players'].forEach((key, value) {
      players[key] = UserModel.fromRTDB(Map<String, dynamic>.from({
        'username': value['name'],
        'color': value['color'],
        'uuid': value['uuid'],
      }));
    });

    UserModel? winner;
    if (data['game']['winner'] != null) {
      winner = UserModel.fromRTDB(Map<String, dynamic>.from(data['game']['winner']));
    }

    return Game(
      players: players,
      status: data['game']['status'],
      currentMove: data['game']['current_move'],
      fen: data['game']['fen'],
      isCheckmate: data['game']['is_checkmate'],
      isDraw: data['game']['is_draw'],
      winner: winner,
    );

    //data[roomId]['game']
  }

  Game copyWith({
    Map<String, UserModel>? players,
    String? status,
    String? currentMove,
    String? fen,
    bool? isCheckmate,
    bool? isDraw,
    UserModel? winner,
  }) {
    return Game(
      players: players ?? this.players,
      status: status ?? this.status,
      currentMove: currentMove ?? this.currentMove,
      fen: fen ?? this.fen,
      isCheckmate: isCheckmate ?? this.isCheckmate,
      isDraw: isDraw ?? this.isDraw,
      winner: winner ?? this.winner,
    );
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'players': players.map((key, user) => MapEntry(key, user.toJson())),
        'status': status,
        'current_move': currentMove,
        'fen': fen,
        'is_checkmate': isCheckmate,
        'is_draw': isDraw,
        'winner': winner?.toJson(includeColor: false),
      };
    } on Exception catch (e) {
      print('Game.toJson Exceptio?: ${e.toString()}');
      throw Exception('Game.toJson Exceptio?: ${e.toString()}');
    }
  }

  @override
  List<Object?> get props =>
      [players, status, currentMove, fen, isCheckmate, isDraw, winner];
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_application/blocs/room_cubit.dart/room_cubit.dart';
import 'package:my_flutter_application/main_screens/game_screen.dart';
import 'package:my_flutter_application/main_screens/home_screen.dart';
import '../blocs/user_cubit/user_cubit.dart';
import '../models/room_model.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  RoomCubit? _roomCubit;
  //bool _hasNavigated = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _roomCubit = context.read<RoomCubit>();
    _roomCubit?.cancelRoomGuestUpdates(); //  이전 리스너 해제
    _roomCubit?.cancelRoomGameUpdates(); //이전 리스너 해제
    _roomCubit!.listenToRoomGuestUpdates(widget.room.roomId);
    _roomCubit!.listenToRoomGameUpdates(widget.room.roomId);
  }
  
  @override
  Widget build(BuildContext context) {
    // Ensure we are listening for updates to the guest in the room
    return Scaffold(
      appBar: AppBar(
        title: Text('Find your opponent'),
      ),
      body: BlocConsumer<RoomCubit, RoomState>(
        listener: (context, roomState) {
          if (roomState is GameLoaded) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(
                          room: roomState.room,
                        )));
          }
        },
        builder: (context, roomState) {
          Room updatedRoom = widget.room;
          if (roomState is RoomLoaded) {
            updatedRoom = roomState.room;
            if (updatedRoom.guest != null) {
              print('Grabbed it yey!: ${updatedRoom.guest?.name}');
            }
          }
          else if(roomState is RoomExit){
            print('RoomExit');
              WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            });
          } 

          return Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon(
                  //   FontAwesomeIcons.chessBoard,
                  //   size: 100.0,
                  //   color: Colors.blue,
                  // ),
                  SizedBox(height: 20.0),
                  Column(
                    children: [
                      Text(
                        'Host: ${updatedRoom.owner.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      updatedRoom.guest != null
                          ? Column(
                              children: [
                                Text(
                                  'Guest: ${updatedRoom.guest?.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                Text('Waiting host to start the game'),
                                SizedBox(height: 10.0),
                                CircularProgressIndicator(),
                                SizedBox(height: 25.0),
                                updatedRoom.owner.uuid !=
                                        context.read<UserCubit>().user!.uuid
                                    ? ElevatedButton(
                                        onPressed: () {
                                          context.read<RoomCubit>().leaveRoom(
                                              updatedRoom, updatedRoom.guest!);
                                        },
                                        child: Text('Leave room'),
                                      )
                                    : Container()
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Waiting opponent:   ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                CircularProgressIndicator(),
                              ],
                            ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      if (userState is UserRegistered &&
                          userState.user.uuid == updatedRoom.owner.uuid) {
                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: updatedRoom.guest != null
                                  ? () {
                                      print('Host wants to start');
                                      context
                                          .read<RoomCubit>()
                                          .initializeGameInTheRoom(updatedRoom);
                                    }
                                  : null,
                              child: Text('Start Game'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<RoomCubit>()
                                    .leaveRoom(updatedRoom, userState.user);
                              },
                              child: Text('Leave room'),
                            )
                          ],
                        );
                      } else if (userState is UserRegistered &&
                          updatedRoom.guest == null) {
                        return ElevatedButton(
                          onPressed: () {
                            context
                                .read<RoomCubit>()
                                .updateRoomGuest(updatedRoom, userState.user);
                          },
                          child: Text('Join Room'),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

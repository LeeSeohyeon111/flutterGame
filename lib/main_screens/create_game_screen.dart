import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_application/blocs/room_cubit.dart/room_cubit.dart';
import 'package:my_flutter_application/blocs/user_cubit/user_cubit.dart';
import 'package:my_flutter_application/main_screens/room_detail_screen.dart';
import 'package:my_flutter_application/models/room_model.dart';
import 'package:my_flutter_application/models/user_model.dart';
import 'package:uuid/uuid.dart';

class CreateGameScreen extends StatelessWidget {
  CreateGameScreen({super.key});

  final TextEditingController _roomNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create room'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Icon(
              //   FontAwesomeIcons.solidChessKnight,
              //   size: 100.0,
              //   color: Colors.blue,
              // ),
              Column(
                children: [
                  TextField(
                    controller: _roomNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter room name',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: BlocConsumer<RoomCubit, RoomState>(
                          listener: (context, roomState) {
                            if (roomState is RoomLoaded) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoomDetailScreen(
                                          room: roomState.room)));
                            } else if (roomState is RoomError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(roomState.message)),
                              );
                            }
                          },
                          builder: (context, roomState) {
                            if (roomState is RoomLoading) {
                              return ElevatedButton(
                                  onPressed: null,
                                  child: CircularProgressIndicator());
                            }
                            return ElevatedButton(
                              onPressed: () async {
                                final userCubit = context.read<UserCubit>();
                                final UserModel? user = userCubit.user;
                                final String roomName =
                                    _roomNameController.text.trim();
                                  

                                final RegExp roomNamePattern =
                                    RegExp(r'^[a-zA-Z0-9]+$');
                                   if(user==null) print('user is null!!');
                                  
                                if (user != null &&
                                    roomNamePattern.hasMatch(roomName)) {
                                  final Room room = Room(
                                    owner: user,
                                    roomName: roomName,
                                    roomId: Uuid().v4(),
                                  );
                                  context.read<RoomCubit>().createRoom(room);
                                } else {
final userCubit = context.read<UserCubit>();
print('UserCubit 상태: ${userCubit.state}');
print('User: ${userCubit.user}');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Room name must contain only letters and numbers'),
                                    ),
                                  );
                                }
                              },
                              child: Text('Create Room'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

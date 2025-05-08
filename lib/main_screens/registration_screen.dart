import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_application/blocs/user_cubit/user_cubit.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameInputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Don\'t be liar!'),
      ),
      body: Center(
         child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Icon(
              //   //FontAwesomeIcons.solidChessRook,
              //   //size: 100.0,
              //   //color: Colors.blue,
              // ),
              Column(
                children: [
                  TextField(
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: _usernameInputController,
                    decoration:
                        InputDecoration(hintText: '유저이름을 입력하세요'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  BlocConsumer<UserCubit, UserState>(
                    listener: (context, userState) {
                      if (userState is UserRegistered) {
                        Navigator.pushReplacementNamed(context, '/main-screen');
                      } else if (userState is UserRegistrationError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(userState.message),
                          ),
                        );
                      }
                    },
                    builder: (context, userState) {
                      if (userState is UserBeingRegistered) {
                        return CircularProgressIndicator();
                      } else if (userState is UserNotRegistered ||
                          userState is UserRegistrationError) {
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final String username =
                                      _usernameInputController.text.trim();
                                  final RegExp usernamePattern =
                                      RegExp(r'^[a-zA-Z0-9]+$');
                                  if (username.isNotEmpty &&
                                      usernamePattern.hasMatch(username)) {
                                    await context
                                        .read<UserCubit>();
                                        //.addUser(username);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '숫자와 영문으로만 입력할 수 있습니다')),
                                    );
                                  }
                                },
                                child: Text('가입'),
                              ),
                            ),
                          ],
                        );
                      } else if (userState is UserRegistered) {
                        return Text(
                            'User already registered, redirecting to main screen');
                      } else {
                        return Text('ERROR: Unexpected User State'); //
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_application/blocs/room_cubit.dart/room_cubit.dart';
import 'package:my_flutter_application/blocs/user_cubit/user_cubit.dart';
import 'package:my_flutter_application/models/room_model.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final Room room;
  const GameScreen({super.key, required this.room});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameEndDialog();
        _dialogShown = true;
      });
    }
  }

  void _showGameEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: const Text("이 방은 게임 없이 종료되었습니다."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 닫기
              Navigator.of(context).pop(); // 방 나가기 (GameScreen pop)
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Room')),
      body: const Center(
        child: Text('게임 없이 종료된 방입니다.'),
      ),
    );
  }
}

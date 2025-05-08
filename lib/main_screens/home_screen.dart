import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_application/main_screens/create_game_screen.dart';
import 'package:my_flutter_application/main_screens/invites_screen.dart';
import 'package:my_flutter_application/main_screens/lounge_screen.dart';
import 'package:my_flutter_application/providers/game_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
      final gameProvider = context.read<GameProvider>();
      return DefaultTabController(
      length: 3,
      child: Scaffold(
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Lounge'),
              Tab(icon: Icon(Icons.add), text: 'Create game'),
              Tab(icon: Icon(Icons.local_post_office), text: 'Invites'),
            ],
          ),
          body: TabBarView(
            children: [LoungeScreen(), CreateGameScreen(), InvitesScreen()],
          )),
    );
     }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_application/authentication/landing_screen.dart';
import 'package:my_flutter_application/authentication/login_screen.dart';
import 'package:my_flutter_application/authentication/sign_up_screen.dart';
import 'package:my_flutter_application/blocs/lounge_cubit/lounge_cubit.dart';
import 'package:my_flutter_application/blocs/room_cubit.dart/room_cubit.dart';
import 'package:my_flutter_application/blocs/user_cubit/user_cubit.dart';
import 'package:my_flutter_application/constants.dart';
import 'package:my_flutter_application/main_screens/game_screen.dart';
import 'package:my_flutter_application/main_screens/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import 'game_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// void main() {
//   runApp(MaterialApp(
//     title: 'Cards',
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//       useMaterial3: true,
//     ),
//     home: HomePage(),
//   ));
// }

// class HomePage extends HookWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final games = {
//       // 'Tower Of Hanoi': TowerOfHanoi(),
//       // 'War': War(
//       //   numPlayers: 4,
//       // ),
//       // 'Memory Match': MemoryMatch(),
//       // 'Golf Solitaire': GolfSolitaire(),
//       'Solitaire': Solitaire(),
//     };
//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           children: ListTile.divideTiles(
//             context: context,
//             tiles: games.entries.map(
//               (entry) {
//                 return ListTile(
//                   title: Text(entry.key),
//                   onTap: () =>
//                       Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameView(cardGame: entry.value))),
//                   trailing: Icon(Icons.chevron_right),
//                 );
//               },
//             ).toList(),
//           ).toList(),
//         ),
//       ),
//     );
//   }
// }
void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'my-flutter-application',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    Firebase.app(); // 이미 초기화된 앱을 사용
  }
  runApp(
    MultiProvider(providers: [
      BlocProvider(create: (context) => UserCubit()),
      BlocProvider(create: (context) => LoungeCubit()),
      BlocProvider(create: (context) => RoomCubit()),
      ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chess',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        brightness: Brightness.light,
      ),
      initialRoute: Constants.landingScreen,
      routes: {
        Constants.homeScreen: (context) => const HomeScreen(),
        Constants.loginScreen: (context) => const LoginScreen(),
        Constants.signUpScreen: (context) => const SignUpScreen(),
        Constants.landingScreen: (context) => const LandingScreen(),
        //Constants.gameScreen: (context) => const GameScreen(),
      },
    );
  }
}




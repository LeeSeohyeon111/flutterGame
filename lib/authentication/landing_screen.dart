import 'package:flutter/material.dart';
import 'package:my_flutter_application/blocs/user_cubit/user_cubit.dart';
import 'package:my_flutter_application/constants.dart';
import 'package:my_flutter_application/providers/authentication_provider.dart';
import 'package:my_flutter_application/services/firebase_RTDB_service.dart';
import 'package:provider/provider.dart';


class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // check authenticationState - if isSignedIn or not
  void checkAuthenticationState() async {
    final authProvider = context.read<AuthenticationProvider>();
final userCubit = context.read<UserCubit>();

    if (await authProvider.checkIsSignedIn()) {
      // 1. get user data from firestore
      await authProvider.getUserDataFromFireStore();

      // 2. save user data to shared preferences
      await authProvider.saveUserDataToSharedPref();
      //  Firestore에서 가져온 userModel을 RTDB에 저장
      final uuid =authProvider.userModel?.uuid;
      if (uuid !=null) {
        final userModel = await DatabaseService().getUserFromRTDB(uuid);  
        if (userModel != null) {
          await userCubit.addUser(userModel);
          print('landing get good');
        }else{
          print('landing screen error');
        } 
      }
      navigate(isSignedIn: true);
    } else {
      // navigate to the sign screen
      navigate(isSignedIn: false);
    }
  }

  @override
  void initState() {
    checkAuthenticationState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: CircleAvatar(
        //   radius: 50,
        //   backgroundImage: AssetImage(AssetsManager.chessIcon),
        // ),
      ),
    );
  }

  void navigate({required bool isSignedIn}) {
    if (isSignedIn) {
      Navigator.pushReplacementNamed(context, Constants.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, Constants.loginScreen);
    }
  }
}

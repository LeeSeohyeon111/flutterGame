import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_flutter_application/constants.dart';
import 'package:my_flutter_application/models/user_model.dart';
import 'package:my_flutter_application/services/firebase_RTDB_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSignedIn = false;
  String? _uid;
  UserModel? _userModel;

  // getters
  bool get isLoading => _isLoading;
  bool get isSignIn => _isSignedIn;

  UserModel? get userModel => _userModel;
  String? get uid => _uid;

  void setIsLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
 // final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    _uid = userCredential.user!.uid;
    notifyListeners();

    return userCredential;
  }

  // sign in user with email and password
  Future<UserCredential?> signInUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try{
        UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
          _uid = userCredential.user!.uid;
        notifyListeners();
        return userCredential;
    }on FirebaseAuthException catch (e) {
        throw Exception(_handleFirebaseAuthError(e.code));
    }finally {
        _isLoading = false;
        notifyListeners();
    }
  }

  String _handleFirebaseAuthError(String code) {
  switch (code) {
    case 'invalid-email':
      return '잘못된 이메일 형식입니다.';
    case 'user-disabled':
      return '이 계정은 비활성화되었습니다.';
    case 'user-not-found':
      return '존재하지 않는 사용자입니다.';
    case 'wrong-password':
      return '비밀번호가 틀렸습니다.';
    default:
      return '로그인에 실패했습니다. 다시 시도해주세요.';
    }
  }

  // check if user exist
  Future<bool> checkUserExist() async {
    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection(Constants.users).doc(uid).get();

    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  // get user data from firestore
  Future getUserDataFromFireStore() async {
    await firebaseFirestore
        .collection(Constants.users)
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {    
      _userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      _uid = _userModel!.uid;
      notifyListeners();
    });
  }

  // store user data to shared preferences
  Future saveUserDataToSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        Constants.userModel, jsonEncode(userModel!.toMap()));
  }

  // get user data to shared preferences
  Future getUserDataToSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString(Constants.userModel) ?? '';

    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;

    notifyListeners();
  }

  // set user as signIn
  Future setSignedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(Constants.isSinedIn, true);
    _isSignedIn = true;
    notifyListeners();
  }

  // set user as signIn
  Future<bool> checkIsSignedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isSignedIn = sharedPreferences.getBool(Constants.isSinedIn) ?? false;
    notifyListeners();
    return _isSignedIn;
  }

  // save user data to firestore
  void saveUserDataToFireStore({
    required UserModel currentUser,
    required File? fileImage,
    required Function onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      // check if the fileImage is not null
      // if (fileImage != null) {
      //   // upload the image firestore storage
      //   String imageUrl = await storeFileImageToStorage(
      //     ref: '${Constants.userImages}/$uid.jpg',
      //     file: fileImage,
      //   );

      //   currentUser.image = imageUrl;
      // }

      currentUser.createdAt = DateTime.now().microsecondsSinceEpoch.toString();
      // if (currentUser.uuid.isEmpty) {
      //   currentUser.uuid = const Uuid().v4();
      // }
      _userModel = currentUser;

      // save data to fireStore
      await firebaseFirestore
          .collection(Constants.users)
          .doc(currentUser.uid)
          .set(currentUser.toMap());

      onSuccess();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      onFail(e.toString());
    }
  }

  // store image to storage and return the download url
  // Future<String> storeFileImageToStorage({
  //   required String ref,
  //   required File file,
  // }) async {
  //   UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
  //   TaskSnapshot taskSnapshot = await uploadTask;
  //   String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  // sign out user
  Future<void> signOutUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await firebaseAuth.signOut();
    _isSignedIn = false;
    sharedPreferences.clear();
    notifyListeners();
  }
  
 Future<void> signInWithGoogle({
    required Function onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      setIsLoading(value: true);

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setIsLoading(value: false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      _uid = userCredential.user!.uid;

      final isUserExist = await checkUserExist();

      if (isUserExist) {
        await getUserDataFromFireStore();
        await saveUserDataToSharedPref();
      } else {
        // 1. Firestore에 새 사용자 생성
        UserModel newUser = UserModel(
          uid: _uid!,
          name: googleUser.displayName ?? '사용자',
          email: googleUser.email,
          image: googleUser.photoUrl ?? '',
          createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
          playerRating: 1200,
          uuid: const Uuid().v4(), // RTDB는 uuid 기준으로 저장
          color: null,
        );

        _userModel = newUser;

        // 2. Firestore 저장
        await firebaseFirestore
            .collection(Constants.users)
            .doc(_uid)
            .set(newUser.toMap());

        // 3. RTDB 저장
        final databaseService = DatabaseService();
        await databaseService.addUserToDB(newUser); // ✅ 여기가 핵심!

        // 4. SharedPreferences 저장
        await saveUserDataToSharedPref();
      }

      await setSignedIn();
      onSuccess();
    } catch (e) {
      onFail(e.toString());
    } finally {
      setIsLoading(value: false);
    }
  }

}

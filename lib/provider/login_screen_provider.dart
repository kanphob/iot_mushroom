import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siwat_mushroom/API/api_call.dart';
import 'package:siwat_mushroom/Constant/field_master.dart';
import 'package:siwat_mushroom/Screen/home_page.dart';
import 'package:siwat_mushroom/passcode_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreenProvider with ChangeNotifier {
  final BuildContext context;
  LoginScreenProvider({required this.context}) {
    checkLoggedIn();
  }

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late SharedPreferences prefs;
  bool isShowSignInID = false, obscureText = true, isInAsyncCall = false;
  FocusNode fnUserID = FocusNode(), fnUserPassword = FocusNode();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController userEmailController = TextEditingController(text: ''),
                        userPasswordController = TextEditingController(text: ''),
                        userIotIDController = TextEditingController(text: 'Mushroom'),
                        userIotPasswordController = TextEditingController(text: '1234');


  checkLoggedIn() async{
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final firebaseUID = user!.uid;

     prefs = await SharedPreferences.getInstance();
     String sSharePrefEmail = prefs.getString(FieldMaster.sharedPreferenceEmail)!;
     if(firebaseUID.isNotEmpty && sSharePrefEmail.isNotEmpty) {
       print(sSharePrefEmail);
       Navigator.push(context, CupertinoPageRoute(builder: (context)=> const HomePage()));
     }
  }

  onSubmitLoginFirebase() async {
    if (userEmailController.text.isNotEmpty &&
        userPasswordController.text.isNotEmpty) {
      String sEmail = userEmailController.text, sPassword = userPasswordController.text;
      isInAsyncCall = true;
      notifyListeners();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: sEmail,
            password: sPassword
        );

        String sToken = '';
        sToken = await userCredential.user!.getIdToken();
        if (sToken.isNotEmpty) {
          String? sEmail = userCredential.user!.email?? "";
          // Map<String,dynamic>? mapUserProfile = userCredential.additionalUserInfo!.profile;
          await prefs.setString(FieldMaster.sharedPreferenceEmail, sEmail);
          isInAsyncCall = false;
          notifyListeners();
          return 'Success';
        } else {
          isInAsyncCall = false;
          notifyListeners();
          return 'Fail';
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          if (kDebugMode) {
            print('No user found for that email.');
          }
        } else if (e.code == 'wrong-password') {
          if (kDebugMode) {
            print('Wrong password provided for that user.');
          }
        }
      }
      isInAsyncCall = false;
      notifyListeners();
      return 'Fail';
    }
  }

  setUpScreenInitState(BuildContext context) async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Future.delayed(const Duration(seconds: 5, milliseconds: 0), () async {
      if (userEmailController.text.isNotEmpty) {
        isShowSignInID = true;
        notifyListeners();
        if (userEmailController.text.isNotEmpty) {
          Future.delayed(const Duration(seconds: 2, milliseconds: 0), () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PasscodeScreen()));
          });
        }
      }
    });
  }

  onTapObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  onSubmitLogin() async {
    FocusScope.of(context).unfocus();
    isInAsyncCall = true;
    notifyListeners();

    String sResult = await APICall.httpGetForSignIn(
        sUsername: userIotIDController.text,
        sPassword: userPasswordController.text);
    String sFirebaseSignInStatus = 'Fail';

    if (sResult == 'Success') {
      isInAsyncCall = false;
      notifyListeners();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID ผู้ใช้งาน หรือ รหัสผ่านไม่ถูกต้อง'),
        ),
      );
    }

  }




}

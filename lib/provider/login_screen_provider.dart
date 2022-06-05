import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_mushroom/API/api_call.dart';
import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Screen/home_page.dart';
import 'package:iot_mushroom/passcode_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot_mushroom/provider/home_page_provider.dart';
import 'package:iot_mushroom/provider/home_page_statistic_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenProvider with ChangeNotifier {
  final BuildContext context;

  LoginScreenProvider({required this.context}) {
    // checkLoggedIn();
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

  checkLoggedIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final firebaseUID = user!.uid;
    final navigator = Navigator.of(context);
    prefs = await SharedPreferences.getInstance();
    String sSharePrefEmail =
        prefs.getString(FieldMaster.sharedPreferenceEmail)!;
    if (firebaseUID.isNotEmpty && sSharePrefEmail.isNotEmpty) {
      if (kDebugMode) {
        print(sSharePrefEmail);
      }
      navigator
          .push(CupertinoPageRoute(builder: (context) => const HomePage()));
    }
  }

  onSubmitLoginFirebase(ScaffoldMessengerState scaffold) async {
    if (userEmailController.text.isNotEmpty &&
        userPasswordController.text.isNotEmpty) {
      String sEmail = userEmailController.text,
          sPassword = userPasswordController.text;
      isInAsyncCall = true;
      notifyListeners();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: sEmail, password: sPassword);

        String sToken = '';
        sToken = await userCredential.user!.getIdToken();
        if (sToken.isNotEmpty) {
          String? sEmail = userCredential.user!.email ?? "";
          // Map<String,dynamic>? mapUserProfile = userCredential.additionalUserInfo!.profile;
          prefs = await SharedPreferences.getInstance();
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
          scaffold.showSnackBar(
            const SnackBar(
              content: Text('ไม่พบ email ผู้ใช้งานนี้ในระบบ'),
            ),
          );
        } else if (e.code == 'wrong-password') {
          if (kDebugMode) {
            print('Wrong password provided for that user.');
          }
          scaffold.showSnackBar(
            const SnackBar(
              content: Text('รหัสผ่านไม่ถูกต้อง'),
            ),
          );
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PasscodeScreen()));
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
    final navigator = Navigator.of(context);
    final scaffold = ScaffoldMessenger.of(context);
    String sResult = await APICall.httpGetForSignIn(
        sUsername: userIotIDController.text,
        sPassword: userPasswordController.text);

    if (sResult == 'Success') {
      isInAsyncCall = false;
      notifyListeners();
      navigator.push(MaterialPageRoute(
          builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => HomePageProvider(context: context),
                    ),
                    ChangeNotifierProvider(
                      create: (_) =>
                          HomePageStatisticProvider(context: context),
                    ),
                  ],
                  builder: (context, child) {
                    return const HomePage();
                  })));
    } else {
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('ID ผู้ใช้งาน หรือ รหัสผ่านไม่ถูกต้อง'),
        ),
      );
    }
  }
}

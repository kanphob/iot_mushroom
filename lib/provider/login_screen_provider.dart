import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:siwat_mushroom/API/api_call.dart';
import 'package:siwat_mushroom/Screen/home_page.dart';
import 'package:siwat_mushroom/passcode_screen.dart';

class LoginScreenProvider with ChangeNotifier{
   LoginScreenProvider({Key? key}) : super();

   final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

   bool isShowSignInID = false;
   bool obscureText = false;
   bool isInAsyncCall = false;

   TextEditingController userIDController = TextEditingController();
   TextEditingController userPasswordController = TextEditingController();

   FocusNode fnUserID = FocusNode();
   FocusNode fnUserPassword = FocusNode();

   setUpScreenInitState(BuildContext context) async{
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown,
     ]);
     Future.delayed(const Duration(seconds: 5, milliseconds: 0), () async {
       if (userIDController.text.isNotEmpty) {
         isShowSignInID = true;
         notifyListeners();
         if (userIDController.text.isNotEmpty) {
           Future.delayed(const Duration(seconds: 2, milliseconds: 0), () async {
             Navigator.push(context,
                 MaterialPageRoute(builder: (context) => PasscodeScreen()));
           });
         }
       }
     });
   }

  onTapObscureText(){
    obscureText = !obscureText;
    notifyListeners();
  }

  onSubmitLogin(BuildContext context) async{
    FocusScope.of(context).unfocus();
      isInAsyncCall = true;
      notifyListeners();

    String sResult = await APICall.httpGetForSignIn(
        sUsername: userIDController.text,
        sPassword: userPasswordController.text);

    if (sResult.isNotEmpty) {

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const HomePage()));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'ID ผู้ใช้งาน หรือ รหัสผ่านไม่ถูกต้อง'),
        ),
      );
      isInAsyncCall = false;
      notifyListeners();
    }

  }


}

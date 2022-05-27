import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class RegisterScreenProvider with ChangeNotifier {
  BuildContext context;
  RegisterScreenProvider({required this.context});

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  String sEmailValidateText = '', sPasswordValidateText = '';
  bool isShowSignInID = false, obscureText = true, isInAsyncCall = false;
  FocusNode fnUserID = FocusNode(), fnUserPassword = FocusNode();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController userEmailController = TextEditingController(text: ''),
                        userPasswordController = TextEditingController(text: ''),
                        userConfirmPasswordController = TextEditingController(text: '');

  createAccountFirebaseAuth() async {
    if(userEmailController.text.isNotEmpty && userPasswordController.text.isNotEmpty) {
      String sEmail = userEmailController.text, sPassword = userPasswordController.text;
      isInAsyncCall = true;
      notifyListeners();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: sEmail,
            password: sPassword
        );
        String sToken = '';
        sToken = await userCredential.user!.getIdToken();
        if (sToken.isNotEmpty) {
          isInAsyncCall = false;
          notifyListeners();
          return 'Success';
        } else {
          isInAsyncCall = false;
          notifyListeners();
          return 'Fail';
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {

          sPasswordValidateText = 'จำนวนรหัสผ่านไม่ปลอดภัย';
          loginFormKey.currentState!.validate();
          if (kDebugMode) {
            print('The password provided is too weak.');
          }
        } else if (e.code == 'email-already-in-use') {
          sEmailValidateText = 'Email นี้เป็นผู้ใช้งานในระบบอยู่แล้ว';
          loginFormKey.currentState!.validate();
          if (kDebugMode) {
            print('The account already exists for that email.');
          }
        }
        isInAsyncCall = false;
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      isInAsyncCall = false;
      notifyListeners();
      return 'Fail';
    }
  }

  onTapObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

}
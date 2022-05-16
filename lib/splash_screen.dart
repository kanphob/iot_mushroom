import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siwat_mushroom/Utils/model_progress_hud.dart';
import 'package:siwat_mushroom/API/api_call.dart';
import 'package:siwat_mushroom/Screen/home_page.dart';
import 'package:siwat_mushroom/passcode_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TextEditingController userIDController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  FocusNode fnUserID = FocusNode();
  FocusNode fnUserPassword = FocusNode();
  bool isShowSignInID = false;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool _obscureText = false;
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Future.delayed(const Duration(seconds: 5, milliseconds: 0), () async {
      if (userIDController.text.isNotEmpty) {
        isShowSignInID = true;
        setState(() {});
        if (userIDController.text.isNotEmpty) {
          Future.delayed(const Duration(seconds: 2, milliseconds: 0), () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PasscodeScreen()));
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Image.asset('assets/images/mushroom.png',
                            height: 180,
                            width: 200,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'ระบบควบคุมปัจจัย\nการผลิตเห็ดด้วย IoT',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    buildLoginForm(context),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // run the validators on reload to process async results
    loginFormKey.currentState?.validate();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Form(
          child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade100
                            ],
                            begin: const FractionalOffset(0.3, 0.1),
                            end: const FractionalOffset(1.0, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 60,
                        ),
                        child: Form(
                          autovalidateMode: AutovalidateMode.disabled,
                          key: loginFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: userIDController,
                                        autofocus: true,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xff3e4a59),
                                        ),
                                        decoration: InputDecoration(
                                            labelText: "ID ผู้ใช้งาน*",
                                            errorStyle:
                                                const TextStyle(fontSize: 10),
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            icon: Image.asset(
                                              "assets/images/user_icon3.png",
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.scaleDown,
                                            )),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        // onSaved: (val) => this.sEmail = val,
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: userPasswordController,
                                      readOnly: false,
                                      onTap: () async {
                                        // String sPassword = await Navigator.push(context, CupertinoPageRoute(builder: (context)=> PasscodeScreen()));
                                        // if(sPassword.isNotEmpty){
                                        //   userPasswordController.text = sPassword;
                                        // }
                                      },
                                      autofocus: true,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xff3e4a59),
                                      ),
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        labelText: "รหัสผ่าน*",
                                        errorStyle:
                                            const TextStyle(fontSize: 11),
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        icon: Image.asset(
                                          "assets/images/password_icon.png",
                                          height: 40.0,
                                          width: 40.0,
                                          fit: BoxFit.scaleDown,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          child: Icon(!_obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
//                                        validator: (val)=> val.length == 0 ? "Please specify Email.":null,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Card(
                                      elevation: 8.0,
                                      color: const Color(0xffffffff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xffb2dfdb)
                                                  .withOpacity(0.3),
                                              blurRadius: 4,
                                              spreadRadius: 2,
                                            )
                                          ],
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.green.shade400,
                                                Colors.green.shade100
                                              ],
                                              begin: const FractionalOffset(
                                                  0.3, 0.1),
                                              end: const FractionalOffset(
                                                  1.0, 1.0),
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                        ),
                                        child: MaterialButton(
                                          highlightColor:
                                              const Color(0x00000000),
                                          splashColor: const Color(0xFFB2EBF2),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 35.0),
                                            child: Text(
                                              "เข้าสู่ระบบ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {

                                            setState(() {
                                              _isInAsyncCall = true;
                                            });

                                            String sResult =
                                                await APICall.httpGetForSignIn(
                                                    sUsername:
                                                        userIDController.text,
                                                    sPassword:
                                                        userPasswordController
                                                            .text);

                                            if (sResult.isNotEmpty) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomePage()));
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('ID ผู้ใช้งาน หรือ รหัสผ่านไม่ถูกต้อง'),
                                                ),
                                              );
                                            }

                                            setState(() {
                                              _isInAsyncCall = false;
                                            });

                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //End widget
                            ],
                          ),
                        )),
                  ],
                )),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
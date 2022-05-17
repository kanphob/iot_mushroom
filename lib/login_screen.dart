import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siwat_mushroom/Utils/model_progress_hud.dart';
import 'package:siwat_mushroom/provider/login_screen_provider.dart';

class LoginScreen extends StatelessWidget {
  late LoginScreenProvider loginProvider;
  late BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<LoginScreenProvider>(builder: (context, data, widget) {
        ctx = context;
        loginProvider = data;
        return ModalProgressHUD(
            inAsyncCall: loginProvider.isInAsyncCall,
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
                      buildLoginForm(),
                    ],
                  ),
                ),
              ),
            ));
      }),
    );
  }

  Widget buildLoginForm() {
    loginProvider.loginFormKey.currentState?.validate();
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
                buildTextFieldLoginContent(),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget buildTextFieldLoginContent() {
    return Center(
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
                colors: [Colors.green.shade400, Colors.green.shade100],
                begin: const FractionalOffset(0.3, 0.1),
                end: const FractionalOffset(1.0, 1),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5)),
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
              key: loginProvider.loginFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: loginProvider.userIDController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xff3e4a59),
                      ),
                      decoration: InputDecoration(
                          labelText: "ID ผู้ใช้งาน*",
                          errorStyle: const TextStyle(fontSize: 10),
                          hintStyle: const TextStyle(fontSize: 12),
                          icon: Image.asset(
                            "assets/images/user_icon3.png",
                            height: 40.0,
                            width: 40.0,
                            fit: BoxFit.scaleDown,
                          )),
                      keyboardType: TextInputType.emailAddress,
                      // onSaved: (val) => this.sEmail = val,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: loginProvider.userPasswordController,
                          readOnly: false,
                          onTap: () async {},
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color(0xff3e4a59),
                          ),
                          obscureText: loginProvider.obscureText,
                          decoration: InputDecoration(
                            labelText: "รหัสผ่าน*",
                            errorStyle: const TextStyle(fontSize: 11),
                            hintStyle: const TextStyle(fontSize: 12),
                            icon: Image.asset(
                              "assets/images/password_icon.png",
                              height: 40.0,
                              width: 40.0,
                              fit: BoxFit.scaleDown,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                loginProvider.onTapObscureText();
                              },
                              child: Icon(!loginProvider.obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
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
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xffb2dfdb).withOpacity(0.3),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                )
                              ],
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade100
                                  ],
                                  begin: const FractionalOffset(0.3, 0.1),
                                  end: const FractionalOffset(1.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: MaterialButton(
                              highlightColor: const Color(0x00000000),
                              splashColor: const Color(0xFFB2EBF2),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 35.0),
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
                                await loginProvider.onSubmitLogin(ctx);
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
    ));
  }
}

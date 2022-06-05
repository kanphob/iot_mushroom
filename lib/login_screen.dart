import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_mushroom/provider/home_page_provider.dart';
import 'package:iot_mushroom/provider/home_page_statistic_provider.dart';
import 'package:provider/provider.dart';
import 'package:iot_mushroom/Screen/home_page.dart';
import 'package:iot_mushroom/Utils/model_progress_hud.dart';
import 'package:iot_mushroom/provider/login_screen_provider.dart';
import 'package:iot_mushroom/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LoginScreenProvider(context: context),
          ),
        ],
        child: SafeArea(
          child:
              Consumer<LoginScreenProvider>(builder: (context, data, widget) {
            return ModalProgressHUD(
                inAsyncCall: data.isInAsyncCall,
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
                              GestureDetector(
                                onTap: () {
                                  // showDialog(context: context, builder: (_){
                                  //  return STDWidget().loginIotDialog(onSubmitLogin: data.onSubmitLogin);
                                  // });
                                },
                                child: Image.asset('assets/images/mushroom.png',
                                    height: 180,
                                    width: 200,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover),
                              ),
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
                          buildLoginForm(context, data),
                        ],
                      ),
                    ),
                  ),
                ));
          }),
        ));
  }

  Widget buildLoginForm(BuildContext context, LoginScreenProvider data) {
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
                buildTextFieldLoginContent(context, data),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget buildTextFieldLoginContent(
      BuildContext context, LoginScreenProvider data) {
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
                  stops: const [0.0, 1.0],
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
                top: 80,
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: data.loginFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        controller: data.userEmailController,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Color(0xff3e4a59),
                        ),
                        decoration: InputDecoration(
                            labelText: "Email ผู้ใช้งาน*",
                            errorStyle: const TextStyle(fontSize: 10),
                            hintStyle: const TextStyle(fontSize: 12),
                            icon: Image.asset(
                              "assets/images/email_icon.png",
                              height: 40.0,
                              width: 40.0,
                              fit: BoxFit.scaleDown,
                              filterQuality: FilterQuality.medium,
                            )),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณาระบุ Email';
                          }
                          return null;
                        },
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
                            controller: data.userPasswordController,
                            readOnly: false,
                            onTap: () async {},
                            autofocus: true,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Color(0xff3e4a59),
                            ),
                            obscureText: data.obscureText,
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
                                  data.onTapObscureText();
                                },
                                child: Icon(!data.obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณาระบุรหัสผ่าน';
                              } else {
                                if (value.length < 6) {
                                  return 'รหัสผ่านต้องมีอย่างน้อย 6 หลักขึ้นไป';
                                }
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              List<String> listUser = [];
                              BuildContext ctx = context;
                              final navigator = Navigator.of(context);
                              final scaffold = ScaffoldMessenger.of(context);
                              listUser = await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()));
                              if (listUser.isNotEmpty) {
                                data.userEmailController.text = listUser[0];
                                data.userPasswordController.text = listUser[1];
                                String sResult =
                                    await data.onSubmitLoginFirebase(scaffold);
                                if (sResult == 'Success') {
                                  navigator.push(CupertinoPageRoute(
                                      builder: (context) => MultiProvider(
                                              providers: [
                                                ChangeNotifierProvider(
                                                  create: (_) =>
                                                      HomePageProvider(
                                                          context: context),
                                                ),
                                                ChangeNotifierProvider(
                                                  create: (_) =>
                                                      HomePageStatisticProvider(
                                                          context: context),
                                                ),
                                              ],
                                              builder: (context, child) {
                                                return const HomePage();
                                              })));
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "สร้างบัญชีใหม่",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Card(
                            elevation: 8.0,
                            color: const Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
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
                                    begin: const FractionalOffset(0.3, 0.1),
                                    end: const FractionalOffset(1.0, 1.0),
                                    stops: const [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: MaterialButton(
                                highlightColor: const Color(0x00000000),
                                splashColor: const Color(0xFFB2EBF2),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 35.0),
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
                                  if (data.loginFormKey.currentState!
                                      .validate()) {
                                    final navigator = Navigator.of(context);
                                    final scaffold =
                                        ScaffoldMessenger.of(context);
                                    String sResult = await data
                                        .onSubmitLoginFirebase(scaffold);
                                    if (sResult == 'Success') {
                                      navigator.push(CupertinoPageRoute(
                                          builder: (context) => MultiProvider(
                                                providers: [
                                                  ChangeNotifierProvider(
                                                      create: (_) =>
                                                          HomePageProvider(
                                                              context:
                                                                  context)),
                                                  ChangeNotifierProvider(
                                                      create: (_) =>
                                                          HomePageStatisticProvider(
                                                              context:
                                                                  context)),
                                                ],
                                                child: const HomePage(),
                                              )));
                                    }
                                  }
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
      ),
    );
  }
}

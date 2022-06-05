import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iot_mushroom/provider/register_screen_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RegisterScreenProvider(context: context),
          ),
        ],
        child: SafeArea(child:
            Consumer<RegisterScreenProvider>(builder: (context, data, widget) {
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.green,
                title: const Text(
                  "สร้างบัญชีใหม่",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: buildBodyRegister(context, data));
        })));
  }

  buildBodyRegister(BuildContext context, RegisterScreenProvider data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
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
                            if (data.sEmailValidateText.isEmpty) {
                              if (value!.isEmpty) {
                                return 'กรุณาระบุ Email';
                              }
                            } else {
                              String sText = data.sEmailValidateText;
                              data.sEmailValidateText = '';
                              return sText;
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
                                if (data.sPasswordValidateText.isEmpty) {
                                  if (value!.isEmpty) {
                                    return 'กรุณาระบุรหัสผ่าน';
                                  } else {
                                    if (value.length < 6) {
                                      return 'รหัสผ่านต้องมีอย่างน้อย 6 หลักขึ้นไป';
                                    }
                                  }
                                } else if (data.userConfirmPasswordController
                                        .text.isNotEmpty &&
                                    value !=
                                        data.userConfirmPasswordController
                                            .text) {
                                  return 'กรุณาระบุรหัสผ่านและยืนยันรหัสผ่านให้ตรงกัน';
                                } else {
                                  String sText = data.sPasswordValidateText;
                                  data.sPasswordValidateText = '';
                                  return sText;
                                }

                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
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
                              controller: data.userConfirmPasswordController,
                              readOnly: false,
                              onTap: () async {},
                              autofocus: true,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Color(0xff3e4a59),
                              ),
                              obscureText: data.obscureText,
                              decoration: InputDecoration(
                                labelText: "ยืนยันรหัสผ่าน*",
                                errorStyle: const TextStyle(fontSize: 11),
                                hintStyle: const TextStyle(fontSize: 12),
                                icon: Opacity(
                                  opacity: 0,
                                  child: Image.asset(
                                    "assets/images/password_icon.png",
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.scaleDown,
                                  ),
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
                                  return 'กรุณาระบุยืนยันรหัสผ่าน';
                                } else {
                                  if (data.userPasswordController.text
                                          .isNotEmpty &&
                                      value !=
                                          data.userPasswordController
                                              .text) {
                                    return 'กรุณาระบุรหัสผ่านและยืนยันรหัสผ่านให้ตรงกัน';
                                  }
                                }

                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                    "สร้างบัญชีใหม่",
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
                                    String sResult =
                                        await data.createAccountFirebaseAuth();
                                    if (sResult == 'Success') {
                                      String sEmail = data.userEmailController.text;
                                      String sPassword = data.userPasswordController.text;
                                      List<String> listUser = [sEmail,sPassword];
                                      navigator.pop(listUser);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
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
      ),
    );
  }
}

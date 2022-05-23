import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';

class STDWidget {
  final SizedBox h10 = const SizedBox(
    height: 10,
  );
  final SizedBox w5 = const SizedBox(
    width: 5,
  );
  final EdgeInsets edgeAll8 = const EdgeInsets.all(8.0);
  final Duration duration400m = const Duration(milliseconds: 400);

  Widget waitCenter() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget loginIotDialog({
      bool obscureText = false,
      VoidCallback? onTapObscureText,
      required VoidCallback? onSubmitLogin,
      }) {
     TextEditingController userIDController = TextEditingController();
     TextEditingController userPasswordController = TextEditingController();
    GlobalKey<FormState> loginFormKey = GlobalKey();
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Padding(
          padding: const EdgeInsets.only(
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
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: userIDController,
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
                        controller: userPasswordController,
                        readOnly: false,
                        onTap: () async {},
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Color(0xff3e4a59),
                        ),
                        obscureText: obscureText,
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
                              onTapObscureText!();
                            },
                            child: Icon(!obscureText
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xffb2dfdb).withOpacity(0.3),
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
                               onSubmitLogin!();
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
    );
  }

  // OutlineList Product
  Widget outlineListProd({
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: duration400m,
      margin: edgeAll8,
      padding: edgeAll8,
      child: child,
      decoration: BoxDecoration(
        color: Colors.blue.shade800.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Image Icon
  Widget imageIcon(String path) {
    return Image.asset(
      path,
      height: 50,
      width: 50,
      filterQuality: FilterQuality.medium,
      fit: BoxFit.contain,
    );
  }

  Widget outlineListItem({
    required Widget child,
    double? height,
  }) {
    return AnimatedContainer(
      duration: duration400m,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      padding: edgeAll8,
      width: double.infinity,
      height: height,
      child: child,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.blue.shade800,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Form
  Widget rowCol2({
    Widget? child,
    double width1 = 100,
    Widget? child2,
  }) {
    return Padding(
      padding: edgeAll8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: width1,
            child: child,
          ),
          w5,
          Expanded(child: child2!),
        ],
      ),
    );
  }

  Widget rowCol3({
    Widget? child,
    double width1 = 150,
    Widget? child2,
    Widget? child3,
  }) {
    return Padding(
      padding: edgeAll8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: width1,
            child: child,
          ),
          w5,
          Expanded(child: child2!),
        ],
      ),
    );
  }

  Widget txtBlack16({
    String? sText,
    TextAlign textAlign = TextAlign.end,
  }) {
    return Tooltip(
      showDuration: duration400m,
      message: sText,
      child: Text(
        sText!,
        style: FontThai.text16BlackNormal,
        textAlign: textAlign,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

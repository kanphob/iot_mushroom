import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';

class STDWidget {
  final SizedBox h10 = const SizedBox(
    height: 10,
  );
  final SizedBox w5 = const SizedBox(
    width: 5,
  );

  final SizedBox w3 = const SizedBox(
    width: 3,
  );
  final EdgeInsets edgeAll8 = const EdgeInsets.all(8.0);
  final Duration duration400m = const Duration(milliseconds: 400);
  final Duration duration200m = const Duration(milliseconds: 200);

  final Divider divider = Divider(
    color: Colors.blue.shade800,
    thickness: 5.0,
    height: 0,
    endIndent: 8,
    indent: 8,
  );

  Widget waitCenter() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget loginIotDialog({
    bool obscureText = false,
    VoidCallback? onTapObscureText,
    VoidCallback? onSubmitLogin,
    required TextEditingController txtID,
    required TextEditingController txtPW,
  }) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Padding(
          padding: const EdgeInsets.only(
            top: 60,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: txtID,
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
                      controller: txtPW,
                      readOnly: false,
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
                          onTap: onTapObscureText,
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
                          onPressed: onSubmitLogin,
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
          )),
    );
  }

  // OutlineList Product
  Widget outlineHeadProd({
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: duration400m,
      margin: edgeAll8,
      padding: edgeAll8,
      child: child,
      decoration: BoxDecoration(
        color: Colors.indigo.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget outlineHeadList({
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: duration400m,
      margin: edgeAll8,
      padding: edgeAll8,
      child: child,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget outlineInItem({
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: duration400m,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: edgeAll8,
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

  // Image Icon
  Widget imageIcon(
    String path, {
    bool small = false,
  }) {
    return Image.asset(
      path,
      height: !small ? 50 : 30,
      width: !small ? 50 : 30,
      filterQuality: FilterQuality.medium,
      fit: BoxFit.contain,
    );
  }

  Widget outlineListItem({
    required Widget child,
    double? width,
    double? height,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      padding: edgeAll8,
      width: width,
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

  Widget selectItem({
    VoidCallback? onTap,
    required Widget child,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.blue.shade300,
        splashColor: Colors.blue,
        child: child,
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

  Widget txtBlue16({
    String? sText,
    TextAlign textAlign = TextAlign.end,
  }) {
    return Tooltip(
      showDuration: duration400m,
      message: sText,
      child: Text(
        sText!,
        style: FontThai.text16BlueBold,
        textAlign: textAlign,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget txtWhite16({
    String? sText,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Tooltip(
      showDuration: duration400m,
      message: sText,
      child: Text(
        sText!,
        style: FontThai.text16WhiteNormal,
        textAlign: textAlign,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  RichText richText({
    required TextSpan text,
  }) {
    return RichText(
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      text: text,
    );
  }

  TextSpan spanBlack16({
    String? sText,
    TextAlign textAlign = TextAlign.start,
    List<TextSpan>? list,
  }) {
    return TextSpan(
      text: sText!,
      style: FontThai.text16BlackNormal,
      children: list,
    );
  }

  Widget btnViewData({
    VoidCallback? onPress,
  }) {
    return ElevatedButton.icon(
      onPressed: onPress,
      label: txtWhite16(
        sText: 'ดูข้อมูล',
      ),
      icon: const Icon(
        Icons.description,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget btnEditData({
    VoidCallback? onPress,
  }) {
    return ElevatedButton.icon(
      onPressed: onPress,
      label: txtWhite16(
        sText: 'แก้ไข',
      ),
      icon: const Icon(
        Icons.edit,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget btnADItem({
    VoidCallback? onPressed,
    IconData icon = Icons.add,
    Color? color,
    String? txt,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color ?? Colors.indigo.shade900,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: txtWhite16(
        sText: txt,
      ),
    );
  }

  Widget btnSaveDoc({
    VoidCallback? onPressed,
  }) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.save,
          size: 30,
          color: Colors.green,
        ),
      ),
    );
  }
}

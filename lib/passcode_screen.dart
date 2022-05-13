import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:siwat_mushroom/Screen/home_page.dart';

class PasscodeScreen extends StatefulWidget {
  final String sShopContactID;
  final bool isToCreatePin;

  PasscodeScreen(
      {Key? key, this.sShopContactID = '', this.isToCreatePin = false})
      : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  final StreamController<bool> _verificationNotifier =
  StreamController<bool>.broadcast();
  String sPassCode = "";
  String sMyOldPassCode = "";
  String sDescription = "ระบุรหัสผ่าน 6 หลัก";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    super.initState();
  }

  _onPasscodeEntered(String sPassCode) async{
    HapticFeedback.vibrate();
    if(sPassCode == '123456'){
        Navigator.pop(context,sPassCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasscodeInput(
        digits: [],
        bottomWidget: Container(),
        isValidCallback: (){

        },
        title: Text(
          sDescription,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        passwordEnteredCallback: _onPasscodeEntered,
        circleUIConfig:
        CircleUIConfig(borderColor: Colors.black, fillColor: Colors.black),
        keyboardUIConfig: KeyboardUIConfig(
          digitFillColor: Colors.white,
          digitTextStyle: TextStyle(color: Colors.black, fontSize: 16),
          primaryColor: Colors.black,
        ),
        passwordDigits: 6,
        deleteButton: Container(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.red,
          ),
        ),
        cancelButton: Container(
          child: Text(
            "ยกเลิก",
            style: TextStyle(color: Colors.blue.shade800, fontSize: 16),
          ),
        ),
        cancelCallback: () {
          Navigator.pop(context);
        },
        shouldTriggerVerification: _verificationNotifier.stream,
      ),
    );
  }
}




typedef PasswordEnteredCallback = void Function(String text);
typedef IsValidCallback = void Function();
typedef CancelCallback = void Function();

class PasscodeInput extends StatefulWidget {
  final Widget title;
  final int passwordDigits;
  final Color backgroundColor;
  final PasswordEnteredCallback passwordEnteredCallback;

  //isValidCallback will be invoked after passcode screen will pop.
  final IsValidCallback isValidCallback;
  final CancelCallback cancelCallback;

  // Cancel button and delete button will be switched based on the screen state
  final Widget cancelButton;
  final Widget deleteButton;
  final Stream<bool> shouldTriggerVerification;
  final Widget bottomWidget;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;
  final List<String> digits;

  PasscodeInput({
    Key? key,
    required this.title,
    this.passwordDigits = 6,
    required this.passwordEnteredCallback,
    required this.cancelButton,
    required this.deleteButton,
    required this.shouldTriggerVerification,
    required this.isValidCallback,
    required CircleUIConfig circleUIConfig,
    required KeyboardUIConfig keyboardUIConfig,
    required this.bottomWidget,
    this.backgroundColor = Colors.black,
    required this.cancelCallback,
    required this.digits,
  })  : circleUIConfig =
  circleUIConfig == null ? const CircleUIConfig() : circleUIConfig,
        keyboardUIConfig = keyboardUIConfig == null
            ?  KeyboardUIConfig()
            : keyboardUIConfig,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PasscodeInputState();
}

class _PasscodeInputState extends State<PasscodeInput>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool> streamSubscription;
  String enteredPasscode = '';
  late AnimationController controller;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();
    streamSubscription = widget.shouldTriggerVerification
        .listen((isValid) => _showValidation(isValid));
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> curve =
    CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation = Tween(begin: 0.0, end: 10.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            enteredPasscode = '';
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor.withOpacity(0.8),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildPortraitPasscodeScreen()
                : _buildLandscapePasscodeScreen();
          },
        ),
      ),
    );
  }

  _buildPortraitPasscodeScreen() => Stack(
    children: [
      Positioned(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.title,
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildCircles(),
                ),
              ),
              _buildKeyboard(),
              widget.bottomWidget != null
                  ? widget.bottomWidget
                  : Container()
            ],
          ),
        ),
      ),
      Positioned(
        child: Align(
          alignment: Alignment.bottomRight,
          child: _buildDeleteButton(),
        ),
      ),
    ],
  );

  _buildLandscapePasscodeScreen() => Stack(
    children: [
      Positioned(
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.title,
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildCircles(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.bottomWidget != null
                        ? Positioned(
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: widget.bottomWidget),
                    )
                        : Container()
                  ],
                ),
              ),
              _buildKeyboard(),
            ],
          ),
        ),
      ),
      Positioned(
        child: Align(
          alignment: Alignment.bottomRight,
          child: _buildDeleteButton(),
        ),
      )
    ],
  );

  _buildKeyboard() => Container(
    child: Keyboard(
      onKeyboardTap: _onKeyboardButtonPressed,
      keyboardUIConfig: widget.keyboardUIConfig,
      digits: widget.digits,
    ),
  );

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    var config = widget.circleUIConfig;
    var extraSize = animation.value;
    for (int i = 0; i < widget.passwordDigits; i++) {
      list.add(
        Container(
          margin: EdgeInsets.all(8),
          child: Circle(
            filled: i < enteredPasscode.length,
            circleUIConfig: config,
            extraSize: extraSize,
          ),
        ),
      );
    }
    return list;
  }

  _onDeleteCancelButtonPressed() {
    if (enteredPasscode.length > 0) {
      setState(() {
        enteredPasscode =
            enteredPasscode.substring(0, enteredPasscode.length - 1);
      });
    } else {
      if (widget.cancelCallback != null) {
        widget.cancelCallback();
      }
    }
  }

  _onKeyboardButtonPressed(String text) {
    setState(() {
      if (enteredPasscode.length < widget.passwordDigits) {
        enteredPasscode += text;
        if (enteredPasscode.length == widget.passwordDigits) {
          widget.passwordEnteredCallback(enteredPasscode);
        }
      }
    });
  }

  @override
  didUpdateWidget(PasscodeInput old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerVerification != old.shouldTriggerVerification) {
      streamSubscription.cancel();
      streamSubscription = widget.shouldTriggerVerification
          .listen((isValid) => _showValidation(isValid));
    }
  }

  @override
  dispose() {
    controller.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  _showValidation(bool isValid) {
    if (isValid) {
      Navigator.maybePop(context).then((pop) => _validationCallback());
    } else {
      controller.forward();
    }
  }

  _validationCallback() {
    if (widget.isValidCallback != null) {
      widget.isValidCallback();
    } else {
      print(
          "You didn't implement validation callback. Please handle a state by yourself then.");
    }
  }

  Widget _buildDeleteButton() {
    return Container(
      child: CupertinoButton(
        onPressed: _onDeleteCancelButtonPressed,
        child: Container(
          margin: widget.keyboardUIConfig.digitInnerMargin,
          child: enteredPasscode.length == 0
              ? widget.cancelButton
              : widget.deleteButton,
        ),
      ),
    );
  }
}

class CircleUIConfig {
  final Color borderColor;
  final Color fillColor;
  final double borderWidth;
  final double circleSize;

  const CircleUIConfig(
      {this.borderColor = Colors.white,
        this.borderWidth = 1,
        this.fillColor = Colors.white,
        this.circleSize = 20});
}

class Circle extends StatelessWidget {
  final bool filled;
  final CircleUIConfig circleUIConfig;
  double extraSize = 0;

  Circle(
      {Key? key,
        this.filled = false,
        required this.circleUIConfig,
        this.extraSize = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: extraSize),
      width: circleUIConfig.circleSize,
      height: circleUIConfig.circleSize,
      decoration: BoxDecoration(
          color: filled ? circleUIConfig.fillColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: circleUIConfig.borderColor,
              width: circleUIConfig.borderWidth)),
    );
  }
}

class KeyboardUIConfig {
  //Digits have a round thin borders, [digitBorderWidth] define their thickness
  final double digitBorderWidth;
  final TextStyle digitTextStyle;
  final TextStyle deleteButtonTextStyle;
  final Color primaryColor;
  final Color digitFillColor;
  final EdgeInsetsGeometry keyboardRowMargin;
  final EdgeInsetsGeometry digitInnerMargin;

  //Size for the keyboard can be define and provided from the app. If it will not be provided the size will be adjusted to a screen size.
  final Size keyboardSize;

  const KeyboardUIConfig({
    this.digitBorderWidth = 1,
    this.keyboardRowMargin = const EdgeInsets.only(top: 15, left: 4, right: 4),
    this.digitInnerMargin = const EdgeInsets.all(24),
    this.primaryColor = Colors.white,
    this.digitFillColor = Colors.transparent,
    this.digitTextStyle = const TextStyle(fontSize: 30, color: Colors.white),
    this.deleteButtonTextStyle =
    const TextStyle(fontSize: 16, color: Colors.white),
    this.keyboardSize = const Size.fromHeight(300),
  });
}

typedef KeyboardTapCallback = void Function(String text);

class Keyboard extends StatelessWidget {
  final KeyboardUIConfig keyboardUIConfig;
  final KeyboardTapCallback onKeyboardTap;

  //should have a proper order [1...9, 0]
  final List<String> digits;

  Keyboard({
    Key? key,
    required this.keyboardUIConfig,
    required this.onKeyboardTap,
    required this.digits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildKeyboard(context);

  Widget _buildKeyboard(BuildContext context) {
    List<String> keyboardItems = List.filled(10, '0');
    if (digits == null || digits.isEmpty) {
      keyboardItems = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    } else {
      keyboardItems = digits;
    }
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = screenSize.height > screenSize.width
        ? screenSize.height / 2
        : screenSize.height - 80;
    final keyboardWidth = keyboardHeight * 3 / 4;
    final keyboardSize = this.keyboardUIConfig.keyboardSize != null
        ? this.keyboardUIConfig.keyboardSize
        : Size(keyboardWidth, keyboardHeight);
    return Container(
      width: keyboardSize.width,
      height: keyboardSize.height,
      margin: EdgeInsets.only(top: 16),
      child: AlignedGrid(
        keyboardSize: keyboardSize,
        children: List.generate(10, (index) {
          return _buildKeyboardDigit(keyboardItems[index]);
        }),
      ),
    );
  }

  Widget _buildKeyboardDigit(String text) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
            onTap: () {
              onKeyboardTap(text);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: keyboardUIConfig.primaryColor,
                    width: keyboardUIConfig.digitBorderWidth),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: keyboardUIConfig.digitFillColor,
                ),
                child: Center(
                  child: Text(
                    text,
                    style: keyboardUIConfig.digitTextStyle,
                    semanticsLabel: text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlignedGrid extends StatelessWidget {
  final double runSpacing = 4;
  final double spacing = 4;
  final int listSize;
  final columns = 3;
  final List<Widget> children;
  final Size keyboardSize;

  const AlignedGrid(
      {Key? key, required this.children, required this.keyboardSize})
      : listSize = children.length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final primarySize = keyboardSize.width > keyboardSize.height
        ? keyboardSize.height
        : keyboardSize.width;
    final itemSize = (primarySize - runSpacing * (columns - 1)) / columns;
    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: children
          .map((item) => Container(
        width: itemSize,
        height: itemSize,
        child: item,
      ))
          .toList(growable: false),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    //t from 0.0 to 1.0
    return sin(t * 2.5 * pi).abs();
  }
}


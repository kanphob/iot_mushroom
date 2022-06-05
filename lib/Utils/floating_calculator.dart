
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot_mushroom/Constant/globals.dart';

//ignore: must_be_immutable
class FloatCalculator extends StatefulWidget {
  String valueInit = "";
  String sTextDescription = "";
  FloatCalculator({
     Key? key,required this.valueInit
  }) : super(key: key);



  @override
  _FloatCalculatorState createState() => _FloatCalculatorState();
}

class _FloatCalculatorState extends State<FloatCalculator> {

  String answer = "";
  String answerTemp = "";
  String beforeAnswer = "";
  String inputFull = "";
  String operator = "";
  bool calculateMode = false;
  bool isNewNumber = false;
  String valueInit = "0";

  @override
  void initState() {
    if(widget.valueInit.isNotEmpty) {
      valueInit = widget.valueInit;
    }
      answer = valueInit;
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned(
        top: Globals.dYPosition,
        left: Globals.dXPosition,
        child: GestureDetector(
          onPanUpdate: (tapInfo) {
            setState(() {
              Globals.dXPosition += tapInfo.delta.dx;
              Globals.dYPosition += tapInfo.delta.dy;
            });
          },
          child: Container(
            child: _getContent(),
          ),
        ),
      )
    ],);
  }

  _getContent() {
    return CupertinoAlertDialog(
      actions: <Widget>[
        FlatButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            label: const Text(
              "ปิด",
              style: TextStyle(color: Colors.black),
            )),
        FlatButton.icon(
            onPressed: () {
              calculate();
              Navigator.pop(context,answer);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
            label: const Text(
              "บันทึก",
              style: TextStyle(
                  color:  Colors.green),
            ))
      ],
      content:  Column(
        children: <Widget>[
          buildAnswerWidget(),
          buildNumPadWidget(),
        ],
      ),
    );
  }

  Widget buildAnswerWidget() {
    return Container(
        padding: const EdgeInsets.all(5),
        color: const Color(0xffdbdbdb),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(beforeAnswer,
                      style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(inputFull + " " + operator,
                      style: const TextStyle(fontSize: 14)),
                  Text(answer,
                      style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ])));
  }

  Widget buildNumPadWidget() {
    return Container(
        color: const Color(0xffdbdbdb),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(children: <Widget>[
              buildNumberButton("1", onTap: () {
                addNumberToAnswer(1);
              }),
              buildNumberButton("2", onTap: () {
                addNumberToAnswer(2);
              }),
              buildNumberButton("3", onTap: () {
                addNumberToAnswer(3);
              }),
            ]),
            Row(children: <Widget>[
              buildNumberButton("4", onTap: () {
                addNumberToAnswer(4);
              }),
              buildNumberButton("5", onTap: () {
                addNumberToAnswer(5);
              }),
              buildNumberButton("6", onTap: () {
                addNumberToAnswer(6);
              }),
            ]),
            Row(children: <Widget>[
              buildNumberButton("7", onTap: () {
                addNumberToAnswer(7);
              }),
              buildNumberButton("8", onTap: () {
                addNumberToAnswer(8);
              }),
              buildNumberButton("9", onTap: () {
                addNumberToAnswer(9);
              }),
            ]),
            Row(children: <Widget>[
              buildNumberButton(".", numberButton: false, onTap: () {
                addDotToAnswer();
              }),
              buildNumberButton("0", onTap: () {
                addNumberToAnswer(0);
              }),
              buildNumberButton("⌫", numberButton: false, onTap: () {
                removeAnswerLast();
              }),
            ]),
          ],
        ));
  }

  void toggleNegative() {
    setState(() {
      if (answer.isNotEmpty && answer != "0") {
        if (answer.contains("-")) {
          answer = answer.replaceAll("-", "");
        } else {
          answer = "-" + answer;
        }
      }
    });
  }

  void clearAnswer() {
    setState(() {
      answer = "0";
    });
  }

  void clearAll() {
    setState(() {
      answer = "0";
      inputFull = "";
      calculateMode = false;
      operator = "";
    });
  }

  void calculate() {
    setState(() {
      if (calculateMode) {
        bool decimalMode = false;
        double value = 0;
        if (answer.contains(".") || answerTemp.contains(".")) {
          decimalMode = true;
        }

        if (operator == "+") {
          value = (double.parse(answerTemp) + double.parse(answer));
        } else if (operator == "-") {
          value = (double.parse(answerTemp) - double.parse(answer));
        } else if (operator == "×") {
          value = (double.parse(answerTemp) * double.parse(answer));
        } else if (operator == "÷") {
          value = (double.parse(answerTemp) / double.parse(answer));
        }

        if (!decimalMode) {
          answer = value.toInt().toString();
        } else {
          answer = value.toString();
        }
        answerTemp = answer;
//        calculateMode = false;
//        operator = "";
//        answerTemp = "";
//        inputFull = "";
//        berforAnswer = "";

      }
    });
  }

  void addOperatorToAnswer(String op) {
    setState(() {
      if (answer != "0" && !calculateMode) {
        calculateMode = true;
        answerTemp = answer;
        inputFull += operator + " " + answerTemp;
        operator = op;
        answer = "0";
      } else if (calculateMode) {
        if (answer.isNotEmpty && answerTemp.isNotEmpty) {
          inputFull += operator + " " + answer;
          calculate();
          operator = op;
          isNewNumber = true;
//          answerTemp = answer;
//          inputFull = "";
//          operator = "";
        } else {
          operator = op;
          answerTemp = answer;
          beforeAnswer = answerTemp;
          answer = "";
        }
      }
    });
  }

  void addDotToAnswer() {
    setState(() {
      if (!answer.contains(".")) {
        answer = answer + ".";
      }
    });
  }

  void addNumberToAnswer(int number) {
    setState(() {
      if (number == 0 && answer == "0") {
        // Not do anything.
      } else if (number != 0 && answer == "0") {
        answer = number.toString();
      } else if (isNewNumber) {
        answer = number.toString();
        isNewNumber = false;
      } else {
        answer += number.toString();
      }
//      } else {
//        answer += number.toString();
//      }
    });
  }

  void removeAnswerLast() {
    if (answer == "0") {
      // Not do anything.
    } else {
      setState(() {
        if (answer.length > 1) {
          answer = answer.substring(0, answer.length - 1);
          if (answer.length == 1 && (answer == "." || answer == "-")) {
            answer = "0";
          }
        } else {
          answer = "0";
        }
      });
    }
  }

  Widget buildNumberButton(String str,
      {@required Function()? onTap, bool numberButton = true}) {
    Widget widget;
    if (numberButton) {
      widget = Container(
          margin: const EdgeInsets.all(1),
          child: Material(
              color: Colors.white,
              child: InkWell(
                  onTap: onTap,
                  splashColor: Colors.blue,
                  child: SizedBox(
                      height: 50,
                      child: Center(
                          child: Text(str,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)))))));
    } else {
      widget = Container(
          margin: const EdgeInsets.all(1),
          child: Material(
              color: const Color(0xffecf0f1),
              child: InkWell(
                  onTap: onTap,
                  splashColor: Colors.blue,
                  child: SizedBox(
                      height: 50,
                      child: Center(
                          child: Text(str, style: const TextStyle(fontSize: 20)))))));
    }

    return Expanded(child: widget);
  }
}
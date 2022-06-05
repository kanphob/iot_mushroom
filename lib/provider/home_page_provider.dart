import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot_mushroom/Model/model_homepage_menu_item.dart';
import 'package:iot_mushroom/Screen/cost_material/cost_material_list_screen.dart';
import 'package:iot_mushroom/Screen/expense/expense_list_screen.dart';
import 'package:iot_mushroom/Screen/home_page.dart';
import 'package:iot_mushroom/Screen/income/income_list_screen.dart';
import 'package:iot_mushroom/Screen/iot_hw/iot_hw_list.dart';
import 'package:iot_mushroom/Screen/product/daily_product_list_screen.dart';
import 'package:iot_mushroom/login_screen.dart';

class HomePageProvider with ChangeNotifier {
  BuildContext context;
  HomePageProvider({required this.context}){
    setDataInit();
  }
  List<Widget> listWidget = [];
  String sUserEmail = '';
  String sUserUid = '';

  List<ModelHomePageMenuItem> listMenuItem = [
    ModelHomePageMenuItem(
        sImageUrl: 'assets/images/production.png',
        sMenuName: "จัดการรอบการผลิต",
        index: 0),
    ModelHomePageMenuItem(
        sImageUrl: 'assets/images/packaging.png',
        sMenuName: "บริหารจัดการต้นทุน",
        index: 1),
    ModelHomePageMenuItem(
        sImageUrl: 'assets/images/iot.png',
        sMenuName: "ระบบควบคุมปัจจัย",
        index: 2),
    ModelHomePageMenuItem(
        sImageUrl: 'assets/images/profits.png',
        sMenuName: "คำนวณรายได้",
        index: 3),
    ModelHomePageMenuItem(
        sImageUrl: 'assets/images/crisis.png',
        sMenuName: "คำนวณค่าใช้จ่าย",
        index: 4),
    ModelHomePageMenuItem(
        sImageUrl: 'assets/images/settings.png',
        sMenuName: "ตั้งค่า",
        index: 5),
  ];

  setDataInit(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final firebaseUID = user!.email;
    sUserEmail = firebaseUID ?? "";
    sUserUid = user.uid;
    setListMenu();
  }

  Future<void> signOut() async {
    final navigator = Navigator.of(context);
    await FirebaseAuth.instance.signOut();
    navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  checkOnTapMenu(int index) async {
    switch (index) {
      case 0:
        await navigator(DailyProdListScreen(sUserID: sUserUid));
        break;
      case 1:
        await navigator(CostMatListScreen(
          sUserID: sUserUid,
        ));
        break;
      case 2:
        await navigator(const IOTHwListPage());
        break;
      case 3:
        await navigator(IncomeListScreen(
          sUserID: sUserUid,
        ));
        break;
      case 4:
        await navigator(ExpenseListScreen(
          sUserID: sUserUid,
        ));
        break;
      case 5:
        null;
        break;
    }
  }

  Future<dynamic> navigator(Widget page) async {
    Route route;
    if (Platform.isAndroid) {
      route = MaterialPageRoute(
        builder: (context) => page,
      );
    } else {
      route = CupertinoPageRoute(
        builder: (context) => page,
      );
    }
    return await Navigator.push(context, route);
  }

  setListMenu() {
    listWidget.clear();

    for (int i = 0; i < 6; i++) {
      listWidget.add(
        GestureDetector(
            onTap: () async {
              checkOnTapMenu(i);
            },
            child: SizedBox(
              height: 250,
              width: 200,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Image.asset(
                      listMenuItem[i].sImageUrl,
                      width: 200,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      listMenuItem[i].sMenuName,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )),
      );
    }
  }

}
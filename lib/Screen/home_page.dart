import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Screen/cost_calculate_create.dart';
import 'package:siwat_mushroom/Screen/daily_condition_create.dart';
import 'package:siwat_mushroom/Screen/product/daily_product_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> listWidget = [];
  String sUserEmail = '';
  String sUserUid = '';
  List<ModelMenuItem> listMenuItem = [
    ModelMenuItem(
        sImageUrl: 'assets/images/production.png',
        sMenuName: "จัดการรอบการผลิต",
        index: 0),
    ModelMenuItem(
        sImageUrl: 'assets/images/packaging.png',
        sMenuName: "บริหารจัดการต้นทุน",
        index: 1),
    ModelMenuItem(
        sImageUrl: 'assets/images/iot.png',
        sMenuName: "ระบบควบคุมปัจจัย",
        index: 2),
    ModelMenuItem(
        sImageUrl: 'assets/images/profits.png',
        sMenuName: "คำนวณรายได้",
        index: 3),
    ModelMenuItem(
        sImageUrl: 'assets/images/crisis.png',
        sMenuName: "คำนวณค่าใช้จ่าย",
        index: 4),
    ModelMenuItem(
        sImageUrl: 'assets/images/settings.png',
        sMenuName: "ตั้งค่า",
        index: 5),
  ];

  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final firebaseUID = user!.email;
    sUserEmail = firebaseUID ?? "";
    sUserUid = user.uid;
    setListMenu();
    super.initState();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  checkOnTapMenu(int index) {
    switch (index) {
      case 0:
        null;
        break;
      case 1:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const CostCalculateCreate()));
        break;
      case 2:
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => DailyProdListScreen(sUserID: sUserUid),
          ),
        );
        break;
      case 3:
        null;
        break;
      case 4:
        null;
        break;
      case 5:
        null;
        break;
    }
  }

  setListMenu() {
    listWidget.clear();

    for (int i = 0; i < 6; i++) {
      listWidget.add(GestureDetector(
        onTap: () async {
          checkOnTapMenu(i);
        },
        child: SizedBox(
            width: 180,
            height: 80,
            child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Image.asset(
                  listMenuItem[i].sImageUrl,
                  filterQuality: FilterQuality.medium,
                  height: 100,
                  width: 200,
                ),
                subtitle: Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    listMenuItem[i].sMenuName,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ))),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.account_box),
                const SizedBox(width: 5,),
                Text(sUserEmail,style: const TextStyle(fontWeight: FontWeight.w600),),
              ],),
              FlatButton.icon(
                  onPressed: () {
                    _signOut();
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.blue.shade700,
                  ),
                  label: Text(
                    "ออกจากระบบ",
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600),
                  ))
            ],
          ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "เมนูหลัก",
                  style: TextStyle(fontSize: 32, color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: listWidget.length,
            itemBuilder: (context, index) {
              return listWidget[index];
            },
          )
        ],
      ),
    );
  }
}

class ModelMenuItem {
  String sImageUrl;
  String sMenuName;
  int index;
  ModelMenuItem(
      {required this.sImageUrl, required this.sMenuName, required this.index});
}

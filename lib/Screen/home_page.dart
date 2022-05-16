import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Screen/cost_calculate_create.dart';
import 'package:siwat_mushroom/Screen/daily_condition_create.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> listWidget = [];
  List<ModelMenuItem> listMenuItem = [
    ModelMenuItem(sImageUrl: 'assets/images/production.png',sMenuName: "จัดการรอบการผลิต",index: 0),
    ModelMenuItem(sImageUrl: 'assets/images/packaging.png',sMenuName:  "บริหารจัดการต้นทุน",index: 1),
    ModelMenuItem(sImageUrl: 'assets/images/iot.png',sMenuName:  "ระบบควบคุมปัจจัย",index: 2),
    ModelMenuItem(sImageUrl: 'assets/images/profits.png',sMenuName:  "คำนวณรายได้",index: 3),
    ModelMenuItem(sImageUrl: 'assets/images/crisis.png',sMenuName:  "คำนวณค่าใช้จ่าย",index: 4),
    ModelMenuItem(sImageUrl: 'assets/images/settings.png',sMenuName:  "ตั้งค่า",index: 5),
  ];

  @override
  void initState() {
    setListMenu();
    super.initState();
  }

  checkOnTapMenu(int index) {
    switch (index){
      case 0: null;
      break;
      case 1: Navigator.push(context, CupertinoPageRoute(builder: (context)=> CostCalculateCreate()));
      break;
      case 2: Navigator.push(context, CupertinoPageRoute(builder: (context)=> DailyConditionCreate()));
      break;
      case 3: null;
      break;
      case 4: null;
      break;
      case 5: null;
      break;
    }
  }

  setListMenu() {
  listWidget.clear();

  for(int i = 0; i < 6;i++) {
    listWidget.add(  GestureDetector(
      onTap: () async {
        checkOnTapMenu(i);
      },
      child: Container(
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
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  listMenuItem[i].sMenuName,
                  style: TextStyle(fontSize: 18, color: Colors.black),
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
        children: [
          SizedBox(height: 55,),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Text("เมนูหลัก",style: TextStyle(fontSize: 32,color: Colors.green),),
          ],),
          SizedBox(height: 10,),
          GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            shrinkWrap: true,
            itemCount: listWidget.length,
            itemBuilder: (context, index){
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
  ModelMenuItem({required this.sImageUrl,required this.sMenuName,required this.index});
}

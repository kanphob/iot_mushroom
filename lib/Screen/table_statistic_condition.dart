import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_condition.dart';

class TableStatisticCondition extends StatefulWidget {
  const TableStatisticCondition({Key? key}) : super(key: key);

  @override
  _TableStatisticConditionState createState() => _TableStatisticConditionState();
}

class _TableStatisticConditionState extends State<TableStatisticCondition> {
  final myController = TextEditingController();
  List<List<ModelCondition>> listMD = [];

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    listMD.addAll(Globals.listCondition);

    if (listMD.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("ระบบบันทึกข้อมูลรายวัน",style: TextStyle(color: Colors.white),),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  controller: myController,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search,color: Colors.black,size: 30,),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey.shade700,
                    hintText: 'search',
                    hintStyle: const TextStyle(fontSize: 14,color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red.shade600),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
            itemCount: listMD.length,
            itemBuilder: (context, index) {
              return buildListCondition(listMD[index], index);
            }),
      ),
    ));
  }

  buildListCondition(List<ModelCondition> listMd, int index) {
    return Column(
      children: [
        Card(
          color: Colors.green.shade900,
          child: index == 0 ? buildHeaderTable(listMd) : Container(),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          color: Colors.green.shade900,
          child: buildBodyTable(listMd, index),
        ),
      ],
    );
  }

  buildHeaderTable(List<ModelCondition> listMd) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      leading: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
            color: Colors.green.shade600,
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "วันที่",
              style: TextStyle(color: Colors.white),
            ),
          )),
      title: Align(
        alignment: const Alignment(-1.2, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buildHeaderRow(listMd),
        ),
      ),
    );
  }

  buildHeaderRow(List<ModelCondition> listMd) {
    List<Widget> listWidget = [];
    for (int i = 0; i < 4; i++) {
      listWidget.add(
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Image.asset(listMd[i].sIconPath, height: 35, width: 35, filterQuality: FilterQuality.medium, fit: BoxFit.cover),
                Text(
                  listMd[i].sConditionName,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ),
        )
      );
    }
    return listWidget;
  }

  buildBodyTable(List<ModelCondition> listMd, int index) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        leading: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(25),
              color: Colors.green.shade600,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                (index + 1).toString() + "/01",
                style: const TextStyle(color: Colors.white),
              ),
            )),
        title: Align(
          alignment: const Alignment(-1.2, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buildBodyRow(listMd),
          ),
        ));
  }

  buildBodyRow(List<ModelCondition> listMd) {
    List<Widget> listWidget = [];
    for (int i = 0; i < 4; i++) {
      listWidget.add(Expanded(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
              color: Colors.orange,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                listMd[i].sAmount,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ),
      ));
    }
    return listWidget;
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_cost_material.dart';

class TableStatisticCost extends StatefulWidget {
  const TableStatisticCost({Key? key}) : super(key: key);
  @override
  _TableStatisticCostState createState() => _TableStatisticCostState();
}

class _TableStatisticCostState extends State<TableStatisticCost> {
  final myController = TextEditingController();
  List<ModelTotalCost> listCostByDate = [];
  List<ModelCostMaterial> listMD = [];
  final dateFormatUser = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    listCostByDate = [];
    listMD = [];
    listMD.addAll(Globals.listCostMaterial);
    listMD.sort((a, b) {
      return a.sDateTime.compareTo(b.sDateTime);
    });
    String sDateTimeTemp = "";
    List<String> listCheckDate = [];
    List<ModelCostMaterial> listDataModel = [];
    for (var element in listMD) {
      listCheckDate.add(element.sDateTime);
    }
    listCheckDate = listCheckDate.toSet().toList();

    for (int i = 0; i < listCheckDate.length; i++) {
      String sDateTimeCheck = listCheckDate[i];
      int iQty = 0;
      double dTotalCost = 0;
      for (int j = 0; j < listMD.length; j++) {
        if (listMD[j].sDateTime == sDateTimeCheck) {
          iQty += int.parse(listMD[j].sAmount);
          dTotalCost += double.parse(listMD[j].sCostValue);
          listDataModel.add(listMD[j]);
        }
      }
      listCostByDate.add(ModelTotalCost(
          sDateTime: sDateTimeCheck,
          sTotalQty: iQty.toString(),
          sTotalCost: dTotalCost.round().toString(),
          listMd: listDataModel));
      listDataModel = [];
    }

    if (listCostByDate.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "ระบบบันทึกข้อมูลรายวัน",
          style: TextStyle(color: Colors.white),
        ),
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
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 30,
                    ),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey.shade700,
                    hintText: 'search',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
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
        padding: const EdgeInsets.all(5),
        color: Colors.black,
        child: ListView.builder(
            itemCount: listCostByDate.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.all(5),
                  child: buildListCost(listCostByDate[index], index));
            }),
      ),
    ));
  }

  buildListCost(ModelTotalCost listMdByDate, int index) {
    DateTime dateTime =
        DateTime.parse(listMdByDate.sDateTime.replaceAll('/', '-'));
    String sDateTime = dateFormatUser.format(dateTime);
    return ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      backgroundColor: Colors.green.shade900,
      collapsedBackgroundColor: Colors.green.shade900,
      tilePadding: const EdgeInsets.all(0),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "วันที่ $sDateTime",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "${listMdByDate.listMd.length} รายการ",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "จำนวน ${listMdByDate.sTotalQty}",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "ราคารวม ${listMdByDate.sTotalCost}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],)
      ),
      children: <Widget>[
        Card(
          color: Colors.green.shade900,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: listMdByDate.listMd.length,
              itemBuilder: (context, index) {
                return buildBodyTable(listMdByDate.listMd[index], index);
              }),
        ),
      ],
    );
  }

  buildHeaderTable(ModelCostMaterial md) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10),
      leading: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
            color: Colors.green.shade600,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: const Text(
                "#",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )),
      title: Align(
        alignment: const Alignment(-1.2, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildHeaderRow("รายการ", 4),
            const SizedBox(
              width: 5,
            ),
            buildHeaderRow("จำนวน", 2),
            const SizedBox(
              width: 5,
            ),
            buildHeaderRow("ราคา", 3),
          ],
        ),
      ),
    );
  }

  buildHeaderRow(String sHeaderName, int iFlex) {
    return Expanded(
      flex: iFlex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(25),
          color: Colors.green.shade600,
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Text(
              sHeaderName,
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  buildBodyTable(ModelCostMaterial md, int index) {
    return Column(
      children: [
        index == 0 ? buildHeaderTable(md) : Container(),
        ListTile(
            contentPadding: const EdgeInsets.only(left: 10),
            leading: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.green.shade600,
                ),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))),
            title: Align(
              alignment: const Alignment(-1.2, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildBodyRow(md.sMaterialName, 4),
                  buildBodyRow(md.sAmount, 2),
                  buildBodyRow(md.sCostValue, 3)
                ],
              ),
            )),
      ],
    );
  }

  buildBodyRow(String sValue, int iFlex) {
    return Expanded(
      flex: iFlex,
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
            color: Colors.orange,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              sValue,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}

class ModelTotalCost {
  String sDateTime = "";
  String sTotalQty = "";
  String sTotalCost = "";
  List<ModelCostMaterial> listMd = [];

  ModelTotalCost(
      {required this.sDateTime,
      required this.sTotalQty,
      required this.sTotalCost,
      required this.listMd});
}

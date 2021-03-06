import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Model/model_expense.dart';
import 'package:iot_mushroom/Utils/font_thai.dart';
import 'package:iot_mushroom/provider/expense/expense_list_provider.dart';

class ExpenseListScreen extends StatelessWidget {
  final String sUserID;
  const ExpenseListScreen({Key? key,required this.sUserID,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ExpenseListProvider(
              context: context,
              sUserID: sUserID,
            ),
          ),
        ],
        builder: (context, _) {
          return Consumer<ExpenseListProvider>(
            builder: (context,data,_){
              if (data.bFirst) {
              return Scaffold(
              body: data.widget.waitCenter(),
              );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'ระบบคำนวณค่าใช้จ่าย',
                      style: FontThai.text18WhiteBold,
                    ),
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildSearch(data),
                      data.widget.h10,
                      data.widget.divider,
                      data.widget.h10,
                      Flexible(child: _buildItem(data)),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => data.onTapAdd(),
                    child: const Icon(Icons.add),
                  ),
                );
              }
            },
          );
        });
  }

  Widget _buildSearch(ExpenseListProvider data) {
    return Padding(
      padding: data.widget.edgeAll8,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: data.txtSearch,
              decoration: InputDecoration(
                hintText: 'ค้นหาชื่อรายการ หรือ วว/ดด/ปป(คศ)',
                suffixIcon: data.txtSearch.text.isEmpty?null: IconButton(onPressed: (){
                  data.txtSearch.clear();
                  data.notifyListeners();
                }, icon: const Icon(Icons.close,color: Colors.red,)),
              ),
              onChanged: (val) => data.notifyListeners(),
              style: FontThai.text16BlackNormal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(ExpenseListProvider data) {
    if (data.bLoadList) {
      return data.widget.outlineListItem(
        width: MediaQuery.of(data.context).size.width,
        child: data.widget.waitCenter(),
      );
    } else {
      if (data.listItem.isNotEmpty) {
        return data.widget.outlineListItem(
          child: Scrollbar(
            controller: data.scrList,
            child: ListView.separated(
              controller: data.scrList,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, index) => const Divider(),
              itemCount: data.listItem.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                if (data.listItem[index].sSaveDateTime
                    .contains(data.txtSearch.text) ||
                data.listItem[index].sItem
                    .contains(data.txtSearch.text)) {
                  return _item(
                    data: data,
                    md: data.listItem[index],
                    index: index,
                  );
                } else {
                  return  Center(
                      child: data.widget.txtBlack16(
                        sText: 'ไม่พบข้อมูลที่ค้นหา',
                        textAlign: TextAlign.center,
                      ),
                  );
                }
              },
            ),
          ),
        );
      } else {
        return data.widget.outlineListItem(
          width: MediaQuery.of(data.context).size.width,
          height: 100,
          child: Center(
            child: data.widget.txtBlack16(
              sText: 'ยังไม่มีข้อมูลบน Server',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  Widget _item({
    required ExpenseListProvider data,
    required int index,
    required ModelExpense md,
  }) {
    TextAlign align = TextAlign.start;
    Map<String, String> map = data.valFormType(md);
    return ExpansionTile(
      childrenPadding: EdgeInsets.zero,
      title: data.widget.richText(
        text: data.widget.spanBlack16(
          sText: 'วันที่ : ',
          list: [
            data.widget.spanBlack16(
              sText: md.sSaveDateTime,
            ),
          ],
        ),
      ),
      subtitle: data.widget.richText(
        text: data.widget.spanBlack16(
          sText: 'เวลาที่บันทึก : ',
          list: [
            data.widget.spanBlack16(
              sText: md.sSaveTimeStamp,
            ),
          ],
        ),
      ),
      children: [
        data.widget.rowCol2(
          width1: 150,
          child: data.widget.txtBlack16(
            sText: 'ประเภท :',
          ),
          child2: data.widget.txtBlack16(
            sText: map[FieldMaster.sExpenseType],
            textAlign: align,
          ),
        ),
        data.widget.rowCol2(
          width1: 150,
          child: data.widget.txtBlack16(
            sText: 'รวมจำนวนเงิน :',
          ),
          child2: data.widget.txtBlue16(
            sText: md.sTotalAmt,
            textAlign: align,
          ),
        ),
        data.widget.h10,
        _rowBtnItem(
          prov: data,
          md: md,
        ),
      ],
    );
  }

  Widget _rowBtnItem({
    required ExpenseListProvider prov,
    required ModelExpense md,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          prov.widget.btnViewData(onPress: () => prov.onTapView(md: md)),
          prov.widget.w5,
          prov.widget.btnEditData(
            onPress: () => prov.onTapEdit(md: md),
          ),
        ],
      ),
    );
  }

}

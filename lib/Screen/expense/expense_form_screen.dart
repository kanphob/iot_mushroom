
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_expense.dart';
import 'package:siwat_mushroom/Model/model_item.dart';
import 'package:siwat_mushroom/Utils/drop_down_model.dart';
import 'package:siwat_mushroom/Utils/field_custom.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';
import 'package:siwat_mushroom/provider/expense/expense_form_provider.dart';

class ExpenseFormScreen extends StatelessWidget {
  final String sUserID;
  final ModelExpense? model;
  final String? sMode;

  const ExpenseFormScreen({
    Key? key,
    required this.sUserID,
    this.model,
    this.sMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseFormProvider(
            context: context,
            sUserID: sUserID,
            model: model,
            sMode: sMode,
          ),
        ),
      ],
      builder: (context, _) {
        return Consumer<ExpenseFormProvider>(builder: (context, data, _) {
          if (data.bFirst) {
            return Scaffold(
              body: data.widget.waitCenter(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () => data.pop(),
                ),
                title: Text(
                  'ระบบคำนวณรายจ่าย',
                  style: FontThai.text18WhiteBold,
                ),
                actions: [
                  if (sMode != Globals.sModeVIEW)
                    data.widget.btnSaveDoc(
                      onPressed: () => data.onTapSave(),
                    ),
                  if (sMode != Globals.sModeVIEW) data.widget.w5,
                ],
              ),
              body: Scrollbar(
                controller: data.scrollBody,
                child: SingleChildScrollView(
                  controller: data.scrollBody,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildDateSave(data),
                      _buildTypeExpense(data),
                      data.widget.h10,
                      data.widget.divider,
                      _buildHeadProd(data),
                      _buildItem(data),
                      _btnAddDelete(data),
                      _buildSum(data),
                    ],
                  ),
                ),
              ),
            );
          }
        });
      },
    );
  }

  _buildDateSave(ExpenseFormProvider data) {
    return data.widget.rowCol2(
      child: data.widget.txtBlack16(
        sText: 'วันที่',
      ),
      child2: TextField(
        controller: data.txtDateSave,
        style: FontThai.text16BlackNormal,
        readOnly: true,
        onTap: () => data.onTapPickDate(),
      ),
    );
  }

  _buildTypeExpense(ExpenseFormProvider data) {
    return data.widget.rowCol2(
      child: data.widget.txtBlack16(
        sText: 'รายได้',
      ),
      child2: DropDownModel.dropDown(
        items: data.listType,
        valDrop: data.iType,
        onChange: (index) => data.onChangeType(index!),
      ),
    );
  }

  _buildHeadProd(ExpenseFormProvider data) {
    return data.widget.outlineHeadProd(
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: data.widget.txtWhite16(
              sText: 'ลำดับ',
            ),
          ),
          data.widget.w3,
          Expanded(
            flex: 2,
            child: data.widget.txtWhite16(
              sText: 'รายการ',
            ),
          ),
          data.widget.w3,
          Expanded(
            child: data.widget.txtWhite16(
              sText: 'จำนวน',
            ),
          ),
          data.widget.w3,
          Expanded(
            child: data.widget.txtWhite16(
              sText: 'ราคา',
            ),
          ),
          data.widget.w3,
          Expanded(
            child: data.widget.txtWhite16(
              sText: 'รวม',
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(ExpenseFormProvider data) {
    return data.widget.outlineListItem(
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, index) => const Divider(),
        itemCount: data.listItem.length,
        itemBuilder: (_, index) {
          return _item(
            data: data,
            index: index,
            item: data.listItem[index],
          );
        },
      ),
    );
  }

  _item({
    required ExpenseFormProvider data,
    required ModelItem item,
    required int index,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: data.widget.txtBlack16(
            sText: '${index + 1}',
          ),
        ),
        data.widget.w3,
        Expanded(
          flex: 2,
          child: FieldCustom.item(
            ctrl: item.txtName,
            textAlign: TextAlign.start,
          ),
        ),
        data.widget.w3,
        Expanded(
          child: FieldCustom.item(
            ctrl: item.txtQty,
            fn: item.fnQty,
            inputType: TextInputType.number,
            onChange: (val) => data.onChangeQTY(val, item),
          ),
        ),
        data.widget.w3,
        Expanded(
          child: FieldCustom.item(
            ctrl: item.txtPrice,
            fn: item.fnPrice,
            inputType: TextInputType.number,
            onChange: (val) => data.onChangePrice(val, item),
          ),
        ),
        data.widget.w3,
        Expanded(
          child: FieldCustom.item(
            ctrl: item.txtPriceAmt,
            read: true,
          ),
        ),
      ],
    );
  }

  _btnAddDelete(ExpenseFormProvider data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.00),
      child: Row(
        children: [
          Flexible(
            child: data.widget.btnADItem(
              txt: 'เพิ่ม',
              color: Colors.teal.shade900,
              onPressed: () => data.addItem(),
            ),
          ),
          data.widget.w5,
          Flexible(
            child: data.widget.btnADItem(
              txt: 'ลบ',
              icon: Icons.remove,
              color: Colors.red,
              onPressed: () => data.deleteItem(),
            ),
          ),
        ],
      ),
    );
  }

  _buildSum(ExpenseFormProvider data) {
    return data.widget.outlineListItem(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: RichText(
              text: TextSpan(
                text: 'รวมจำนวนเงิน : ',
                style: FontThai.text18BlackBold,
                children: [
                  TextSpan(
                    text: data.mdHead.sTotalAmt,
                    style: FontThai.text18BlueBold,
                  ),
                  TextSpan(
                    text: ' บาท',
                    style: FontThai.text18BlackBold,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

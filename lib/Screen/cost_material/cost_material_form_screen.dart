//25/05/2565 ByBird

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_cost_material.dart';
import 'package:siwat_mushroom/Model/model_item.dart';
import 'package:siwat_mushroom/Utils/drop_down_model.dart';
import 'package:siwat_mushroom/Utils/field_custom.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';
import 'package:siwat_mushroom/provider/cost_material/cost_material_form_provider.dart';

class CostMatFormScreen extends StatelessWidget {
  final String sUserID;
  final ModelCostMat? model;
  final String? sMode;

  const CostMatFormScreen({
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
          create: (_) => CostMatFormProvider(
            context: context,
            sUserID: sUserID,
            model: model,
            sMode: sMode,
          ),
        ),
      ],
      builder: (context, _) {
        return Consumer<CostMatFormProvider>(builder: (context, prov, _) {
          if (prov.bFirst) {
            return Scaffold(
              body: prov.widget.waitCenter(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () => prov.pop(),
                ),
                title: Text(
                  'ระบบคำนวณต้นทุน',
                  style: FontThai.text18WhiteBold,
                ),
                actions: [
                  if (sMode != Globals.sModeVIEW)
                    prov.widget.btnSaveDoc(
                      onPressed: () => prov.onTapSave(),
                    ),
                  if (sMode != Globals.sModeVIEW) prov.widget.w5,
                ],
              ),
              body: Scrollbar(
                controller: prov.scrollBody,
                child: SingleChildScrollView(
                  controller: prov.scrollBody,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildDateSave(prov),
                      _buildTypeCost(prov),
                      _buildCost(prov),
                      prov.widget.h10,
                      prov.widget.divider,
                      _buildHeadProd(prov),
                      _buildItem(prov),
                      _btnAddDelete(prov),
                      _buildSum(prov),
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

  _buildDateSave(CostMatFormProvider prov) {
    return prov.widget.rowCol2(
      child: prov.widget.txtBlack16(
        sText: 'วันที่',
      ),
      child2: TextField(
        controller: prov.txtDateSave,
        style: FontThai.text16BlackNormal,
        readOnly: true,
        onTap: () => prov.onTapPickDate(),
      ),
    );
  }

  _buildTypeCost(CostMatFormProvider prov) {
    return prov.widget.rowCol2(
      child: prov.widget.txtBlack16(
        sText: 'ประเภท',
      ),
      child2: DropDownModel.dropDown(
        items: prov.listType,
        valDrop: prov.iType,
        onChange: (index) => prov.onChangeType(index!),
      ),
    );
  }

  _buildCost(CostMatFormProvider prov) {
    return prov.widget.rowCol2(
      child: prov.widget.txtBlack16(
        sText: 'ต้นทุน',
      ),
      child2: DropDownModel.dropDown(
        items: prov.listCost,
        valDrop: prov.iCost,
        onChange: (index) => prov.onChangeCost(index!),
      ),
    );
  }

  _buildHeadProd(CostMatFormProvider prov) {
    return prov.widget.outlineHeadProd(
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: prov.widget.txtWhite16(
              sText: 'ลำดับ',
            ),
          ),
          prov.widget.w3,
          Expanded(
            flex: 2,
            child: prov.widget.txtWhite16(
              sText: 'รายการ',
            ),
          ),
          prov.widget.w3,
          Expanded(
            child: prov.widget.txtWhite16(
              sText: 'จำนวน',
            ),
          ),
          prov.widget.w3,
          Expanded(
            child: prov.widget.txtWhite16(
              sText: 'ราคา',
            ),
          ),
          prov.widget.w3,
          Expanded(
            child: prov.widget.txtWhite16(
              sText: 'รวม',
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(CostMatFormProvider prov) {
    return prov.widget.outlineListItem(
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, index) => const Divider(),
        itemCount: prov.listItem.length,
        itemBuilder: (_, index) {
          return _item(
            prov: prov,
            index: index,
            item: prov.listItem[index],
          );
        },
      ),
    );
  }

  _item({
    required CostMatFormProvider prov,
    required ModelItem item,
    required int index,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: prov.widget.txtBlack16(
            sText: '${index + 1}',
          ),
        ),
        prov.widget.w3,
        Expanded(
          flex: 2,
          child: FieldCustom.item(
            ctrl: item.txtName,
            textAlign: TextAlign.start,
          ),
        ),
        prov.widget.w3,
        Expanded(
          child: FieldCustom.item(
            ctrl: item.txtQty,
            fn: item.fnQty,
            inputType: TextInputType.number,
            onChange: (val) => prov.onChangeQTY(val, item),
          ),
        ),
        prov.widget.w3,
        Expanded(
          child: FieldCustom.item(
            ctrl: item.txtPrice,
            fn: item.fnPrice,
            inputType: TextInputType.number,
            onChange: (val) => prov.onChangePrice(val, item),
          ),
        ),
        prov.widget.w3,
        Expanded(
          child: FieldCustom.item(
            ctrl: item.txtPriceAmt,
            read: true,
          ),
        ),
      ],
    );
  }

  _btnAddDelete(CostMatFormProvider prov) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.00),
      child: Row(
        children: [
          Flexible(
            child: prov.widget.btnADItem(
              txt: 'เพิ่ม',
              color: Colors.teal.shade900,
              onPressed: () => prov.addItem(),
            ),
          ),
          prov.widget.w5,
          Flexible(
            child: prov.widget.btnADItem(
              txt: 'ลบ',
              color: Colors.red,
              onPressed: () => prov.deleteItem(),
            ),
          ),
        ],
      ),
    );
  }

  _buildSum(CostMatFormProvider prov) {
    return prov.widget.outlineListItem(
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
                    text: prov.mdHead.sTotalAmt,
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

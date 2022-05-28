import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siwat_mushroom/Constant/field_master.dart';
import 'package:siwat_mushroom/Model/model_cost_material.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';
import 'package:siwat_mushroom/provider/cost_material/cost_material_list_provider.dart';

class CostMatListScreen extends StatelessWidget {
  final String sUserID;

  const CostMatListScreen({
    Key? key,
    required this.sUserID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CostMatListProvider(
            context: context,
            sUserID: sUserID,
          ),
        ),
      ],
      builder: (context, _) {
        return Consumer<CostMatListProvider>(
          builder: (context, prov, _) {
            if (prov.bFirst) {
              return Scaffold(
                body: prov.widget.waitCenter(),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'ระบบคำนวณต้นทุน',
                    style: FontThai.text18WhiteBold,
                  ),
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildSearch(prov),
                    prov.widget.h10,
                    prov.widget.divider,
                    prov.widget.h10,
                    Flexible(child: _buildItem(prov)),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => prov.onTapAdd(),
                  child: const Icon(Icons.add),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildSearch(CostMatListProvider prov) {
    return Padding(
      padding: prov.widget.edgeAll8,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: prov.txtSearch,
              decoration: InputDecoration(
                hintText: 'ค้นหาชื่อรายการ หรือ วว/ดด/ปป(คศ)',
                suffixIcon: prov.txtSearch.text.isEmpty?null: IconButton(onPressed: (){
                  prov.txtSearch.clear();
                  prov.notifyListeners();
                }, icon: const Icon(Icons.close,color: Colors.red,)),
              ),
              onChanged: (val) => prov.onChangeSearch(),
              style: FontThai.text16BlackNormal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(CostMatListProvider prov) {
    if (prov.bLoadList) {
      return prov.widget.outlineListItem(
        width: MediaQuery.of(prov.context).size.width,
        child: prov.widget.waitCenter(),
      );
    } else {
      if (prov.lmShow.isNotEmpty) {
        return prov.widget.outlineListItem(
          child: Scrollbar(
            controller: prov.scrList,
            child: ListView.separated(
              controller: prov.scrList,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, index) => const Divider(),
              itemCount: prov.lmShow.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return _item(
                  prov: prov,
                  md: prov.lmShow[index],
                  index: index,
                );
              },
            ),
          ),
        );
      } else {
        return prov.widget.outlineListItem(
          width: MediaQuery.of(prov.context).size.width,
          height: 100,
          child: Center(
            child: prov.widget.txtBlack16(
              sText: 'ยังไม่มีข้อมูลบน Server',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  Widget _item({
    required CostMatListProvider prov,
    required int index,
    required ModelCostMat md,
  }) {
    TextAlign align = TextAlign.start;
    Map<String, String> map = prov.valFormType(md);
    return ExpansionTile(
      childrenPadding: EdgeInsets.zero,
      title: prov.widget.richText(
        text: prov.widget.spanBlack16(
          sText: 'วันที่ : ',
          list: [
            prov.widget.spanBlack16(
              sText: md.sSaveDateTime,
            ),
          ],
        ),
      ),
      subtitle: prov.widget.richText(
        text: prov.widget.spanBlack16(
          sText: 'เวลาที่บันทึก : ',
          list: [
            prov.widget.spanBlack16(
              sText: md.sSaveTimeStamp,
            ),
          ],
        ),
      ),
      children: [
        prov.widget.rowCol2(
          width1: 150,
          child: prov.widget.txtBlack16(
            sText: 'ประเภท :',
          ),
          child2: prov.widget.txtBlack16(
            sText: map[FieldMaster.sMatTypeCost],
            textAlign: align,
          ),
        ),
        prov.widget.rowCol2(
          width1: 150,
          child: prov.widget.txtBlack16(
            sText: 'ต้นทุน :',
          ),
          child2: prov.widget.txtBlack16(
            sText: map[FieldMaster.sMatCost],
            textAlign: align,
          ),
        ),
        prov.widget.rowCol2(
          width1: 150,
          child: prov.widget.txtBlack16(
            sText: 'รวมจำนวนเงิน :',
          ),
          child2: prov.widget.txtBlue16(
            sText: md.sTotalAmt,
            textAlign: align,
          ),
        ),
        prov.widget.h10,
        _rowBtnItem(
          prov: prov,
          md: md,
        ),
      ],
    );
  }

  Widget _rowBtnItem({
    required CostMatListProvider prov,
    required ModelCostMat md,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          prov.widget.btnViewData(
            onPress: () => prov.onTapView(md: md),
          ),
          prov.widget.w5,
          prov.widget.btnEditData(
            onPress: () => prov.onTapEdit(md: md),
          ),
        ],
      ),
    );
  }
}

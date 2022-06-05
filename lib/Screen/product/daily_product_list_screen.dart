//17/05/2565 ByBird
import 'package:flutter/material.dart';
import 'package:iot_mushroom/Model/model_product.dart';
import 'package:iot_mushroom/Utils/font_thai.dart';
import 'package:iot_mushroom/provider/product/daily_product_list_provider.dart';
import 'package:provider/provider.dart';

class DailyProdListScreen extends StatelessWidget {
  final String sUserID;

  const DailyProdListScreen({
    Key? key,
    required this.sUserID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DailyProdListProvider(
            context: context,
            sUserID: sUserID,
          ),
        ),
      ],
      builder: (context, _) {
        return Consumer<DailyProdListProvider>(
          builder: (context, prov, _) {
            if (prov.bFirst) {
              return Scaffold(
                body: prov.widget.waitCenter(),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'ระบบบันทึกข้อมูลรายวัน',
                    style: FontThai.text18WhiteBold,
                  ),
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildSearch(prov),
                    // _buildHead(prov),
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

  Widget _buildSearch(DailyProdListProvider prov) {
    return Padding(
      padding: prov.widget.edgeAll8,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: prov.txtSearch,
              decoration: const InputDecoration(
                hintText: 'ค้นหา วว/ดด/ปป(คศ)',
              ),
              onChanged: (val) => prov.onChangeSearch(),
              style: FontThai.text16BlackNormal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(DailyProdListProvider prov) {
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
    required DailyProdListProvider prov,
    required int index,
    required ModelProduct md,
  }) {
    TextAlign align = TextAlign.center;
    return ExpansionTile(
      childrenPadding: EdgeInsets.zero,
      title: prov.widget.richText(
        text: prov.widget.spanBlack16(
          sText: 'วันที่ : ',
          list: [
            prov.widget.spanBlack16(
              sText: md.sDateSave,
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
        prov.widget.outlineHeadList(
          child: Row(
            children: [
              Expanded(
                child: prov.widget.imageIcon(
                  'assets/images/temperature.png',
                  small: true,
                ),
              ),
              Expanded(
                child: prov.widget.imageIcon(
                  'assets/images/rainfall.png',
                  small: true,
                ),
              ),
              Expanded(
                child: prov.widget.imageIcon(
                  'assets/images/sunny.png',
                  small: true,
                ),
              ),
              Expanded(
                child: prov.widget.imageIcon(
                  'assets/images/co2.png',
                  small: true,
                ),
              ),
              const Expanded(
                child: Icon(
                  Icons.spa,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const Expanded(
                child: Icon(
                  Icons.scale_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        prov.widget.outlineInItem(
          child: Row(
            children: [
              Expanded(
                child: prov.widget.txtBlack16(
                  sText: md.sTemperature,
                  textAlign: align,
                ),
              ),
              Expanded(
                child: prov.widget.txtBlack16(
                  sText: md.sMoisture,
                  textAlign: align,
                ),
              ),
              Expanded(
                child: prov.widget.txtBlack16(
                  sText: md.sLight,
                  textAlign: align,
                ),
              ),
              Expanded(
                child: prov.widget.txtBlack16(
                  sText: md.sCO2,
                  textAlign: align,
                ),
              ),
              Expanded(
                child: prov.widget.txtBlack16(
                  sText: '${md.iNumFlower}',
                  textAlign: align,
                ),
              ),
              Expanded(
                child: prov.widget.txtBlack16(
                  sText: '${md.iQuantityProduced}',
                  textAlign: align,
                ),
              ),
            ],
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
    required DailyProdListProvider prov,
    required ModelProduct md,
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

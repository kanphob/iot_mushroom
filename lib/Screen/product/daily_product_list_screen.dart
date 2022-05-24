//17/05/2565 ByBird
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Model/model_product.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';
import 'package:siwat_mushroom/provider/product/daily_product_list_provider.dart';
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
                    _buildHead(prov),
                    _buildItem(prov),
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

  Widget _buildHead(DailyProdListProvider prov) {
    return prov.widget.outlineListProd(
      child: Row(
        children: [
          Expanded(
            child: Text(
              'วันที่',
              style: FontThai.text16WhiteNormal,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: prov.widget.imageIcon('assets/images/temperature.png'),
          ),
          Expanded(
            child: prov.widget.imageIcon('assets/images/rainfall.png'),
          ),
          Expanded(
            child: prov.widget.imageIcon('assets/images/sunny.png'),
          ),
          Expanded(
            child: prov.widget.imageIcon('assets/images/co2.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(DailyProdListProvider prov) {
    if (prov.bLoadList) {
      return prov.widget.outlineListItem(
        child: prov.widget.waitCenter(),
      );
    } else {
      if (prov.lmShow.isNotEmpty) {
        return prov.widget.outlineListItem(
          child: ListView.separated(
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
        );
      } else {
        return prov.widget.outlineListItem(
          child: prov.widget.txtBlack16(
            sText: 'NoData',
            textAlign: TextAlign.center,
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
    return prov.widget.selectItem(
      onTap: () => prov.onTapEdit(md: md),
      child: Row(
        children: [
          Expanded(
            child: prov.widget.txtBlack16(
              sText: md.sDateSave,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: prov.widget.txtBlack16(
              sText: md.sTemperature,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: prov.widget.txtBlack16(
              sText: md.sMoisture,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: prov.widget.txtBlack16(
              sText: md.sLight,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: prov.widget.txtBlack16(
              sText: md.sCO2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

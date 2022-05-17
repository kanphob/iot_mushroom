//17/05/2565 ByBird
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';
import 'package:siwat_mushroom/provider/product/daily_product_list_provider.dart';
import 'package:provider/provider.dart';

class DailyProdListScreen extends StatelessWidget {
  const DailyProdListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DailyProdListProvider(context: context),
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
            flex: 2,
            child: TextField(
              controller: prov.txtDateStart,
              style: FontThai.text16BlackNormal,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'ถึง',
              style: FontThai.text16BlackNormal,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: prov.txtDateEnd,
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
      if (prov.listItem.isEmpty) {
        return prov.widget.outlineListItem(
          child: Center(
            child: Text(
              'ยังไม่มีข้อมูลบน Server',
              style: FontThai.text18BlackBold,
            ),
          ),
        );
      } else {
        return prov.widget.outlineListItem(
          child: prov.widget.waitCenter(),
        );
      }
    }
  }
}

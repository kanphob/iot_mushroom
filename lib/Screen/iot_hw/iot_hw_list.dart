import 'package:flutter/material.dart';
import 'package:iot_mushroom/Model/model_iot_item.dart';
import 'package:iot_mushroom/provider/iot_hw/iot_hw_head.dart';
import 'package:provider/provider.dart';
import 'package:iot_mushroom/Utils/font_thai.dart';

class IOTHwListPage extends StatelessWidget {
  const IOTHwListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => IOTHwHeader(context: context),
        ),
      ],
      builder: (context, _) {
        return Consumer<IOTHwHeader>(
          builder: (context, prov, _) {
            if (prov.bFirst) {
              return Scaffold(
                body: prov.widget.waitCenter(),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'ระบบควบคุมปัจจัย',
                    style: FontThai.text18WhiteBold,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildDevice(prov),
                      prov.widget.h10,
                      prov.widget.divider,
                      prov.widget.h10,
                      Expanded(child: _buildItem(prov)),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildDevice(IOTHwHeader prov) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ควบคุมอุปกรณ์',
              style: FontThai.text18BlackBold,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'IO1',
              style: FontThai.text18BlackBold,
            ),
            Switch.adaptive(
              value: prov.bIO,
              onChanged: (val) => prov.onChangedIO(val),
            ),
            Text(
              'IO2',
              style: FontThai.text18BlackBold,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ปิด',
              style: FontThai.text18BlackBold,
            ),
            Switch.adaptive(
              value: prov.bOnOffIO,
              onChanged: (val) => prov.onChangedOnOff(val),
            ),
            Text(
              'เปิด',
              style: FontThai.text18BlackBold,
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => prov.onPushDataIO(),
          child: Text(
            prov.sTextIOT,
            style: FontThai.text16WhiteBold,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(IOTHwHeader prov) {
    if (prov.bLoadList) {
      return prov.widget.waitCenter();
    } else {
      if (prov.listItem.isNotEmpty) {
        return Scrollbar(
          controller: prov.scrList,
          child: GridView.builder(
            controller: prov.scrList,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: prov.listItem.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (_, index) {
              return _item(
                prov: prov,
                md: prov.listItem[index],
              );
            },
          ),
        );
      } else {
        return SizedBox(
          height: 100,
          child: Center(
            child: prov.widget.txtBlack16(
              sText: 'ส่งค่าเปิดที่ปุ่ม Device IO',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  Widget _item({
    required IOTHwHeader prov,
    required ModelIotItem md,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.shade800,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade900,
                shape: BoxShape.circle,
              ),
              child: md.child,
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      md.sStatus,
                      style: FontThai.text16BlackBold,
                    ),
                    prov.widget.w5,
                    const Icon(
                      Icons.circle,
                      color: Colors.green,
                    ),
                  ],
                ),
                Text(
                  md.sValue,
                  style: FontThai.text16BlackBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

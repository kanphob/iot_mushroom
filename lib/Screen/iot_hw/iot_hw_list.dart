import 'package:flutter/material.dart';
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
            'ส่งข้อมูล Device IO',
            style: FontThai.text16WhiteBold,
          ),
        ),
      ],
    );
  }
}

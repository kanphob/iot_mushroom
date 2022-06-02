import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';
import 'package:siwat_mushroom/provider/iot_hw/iot_hw_list_provider.dart';

class IOTHwListPage extends StatelessWidget {
  const IOTHwListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => IOTHwListProvider(context: context),
        ),
      ],
      builder: (context, _) {
        return Consumer<IOTHwListProvider>(
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
              );
            }
          },
        );
      },
    );
  }
}

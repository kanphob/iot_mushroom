import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                  children: [
                    _buildSearch(prov),
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
              decoration: const InputDecoration(
                hintText: 'ค้นหา วว/ดด/ปป(คศ)',
              ),
              // onChanged: (val) => prov.onChangeSearch(),
              style: FontThai.text16BlackNormal,
            ),
          ),
        ],
      ),
    );
  }
}

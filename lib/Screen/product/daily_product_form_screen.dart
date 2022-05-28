//17/05/2565 ByBird

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_product.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';
import 'package:siwat_mushroom/provider/product/daily_product_fom_provider.dart';

class DailyProdFormScreen extends StatelessWidget {
  final String sUserID;
  final ModelProduct? model;
  final String? sMode;

  const DailyProdFormScreen({
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
          create: (_) => DailyProdFormProvider(
            context: context,
            sUserID: sUserID,
            model: model,
            sMode: sMode,
          ),
        ),
      ],
      builder: (context, _) {
        return Consumer<DailyProdFormProvider>(
          builder: (context, prov, _) {
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
                    'ระบบบันทึกข้อมูลรายวัน',
                    style: FontThai.text18WhiteBold,
                  ),
                  actions: [
                    if (sMode != Globals.sModeVIEW)
                      prov.widget.btnSaveDoc(
                        onPressed: () => prov.onSave(),
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
                        if (!prov.bLoadData) _buildRound(prov),
                        // _buildDataIOT(prov),
                        prov.widget.h10,
                        prov.widget.divider,
                        _buildTemp(prov),
                        _buildMoisture(prov),
                        _buildLight(prov),
                        _buildCO2(prov),
                        _buildFlower(prov),
                        _buildQP(prov),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  _buildDateSave(DailyProdFormProvider prov) {
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

  _buildRound(DailyProdFormProvider prov) {
    return prov.widget.rowCol2(
      child: prov.widget.txtBlack16(
        sText: 'รอบที่',
      ),
      child2: prov.widget.txtBlack16(
        sText: '${prov.iRound} / ${prov.dtNow.year}',
        textAlign: TextAlign.start,
      ),
    );
  }

  _buildDataIOT(DailyProdFormProvider prov) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () => prov.syncDataIOT(),
              child: Text(
                'โหลดข้อมูล IOT',
                style: FontThai.text16WhiteBold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildTemp(DailyProdFormProvider prov) {
    return prov.widget.rowCol3(
      child: prov.widget.imageIcon(
        'assets/images/temperature.png',
      ),
      child2: TextField(
        controller: prov.txtTemp,
        focusNode: prov.fnTemp,
        textAlign: TextAlign.center,
        style: FontThai.text16BlackNormal,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  _buildMoisture(DailyProdFormProvider prov) {
    return prov.widget.rowCol3(
      child: prov.widget.imageIcon(
        'assets/images/rainfall.png',
      ),
      child2: TextField(
        controller: prov.txtMoi,
        focusNode: prov.fnMoi,
        textAlign: TextAlign.center,
        style: FontThai.text16BlackNormal,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  _buildLight(DailyProdFormProvider prov) {
    return prov.widget.rowCol3(
      child: prov.widget.imageIcon(
        'assets/images/sunny.png',
      ),
      child2: TextField(
        controller: prov.txtLight,
        focusNode: prov.fnLight,
        textAlign: TextAlign.center,
        style: FontThai.text16BlackNormal,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  _buildCO2(DailyProdFormProvider prov) {
    return prov.widget.rowCol3(
      child: prov.widget.imageIcon(
        'assets/images/co2.png',
      ),
      child2: TextField(
        controller: prov.txtCO2,
        focusNode: prov.fnCO2,
        textAlign: TextAlign.center,
        style: FontThai.text16BlackNormal,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  _buildFlower(DailyProdFormProvider prov) {
    return prov.widget.rowCol3(
      child: prov.widget.txtBlack16(
        sText: 'จำนวนดอกไม้ที่ผลิต',
      ),
      child2: TextField(
        controller: prov.txtFlower,
        focusNode: prov.fnFlower,
        textAlign: TextAlign.center,
        style: FontThai.text16BlackNormal,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  _buildQP(DailyProdFormProvider prov) {
    return prov.widget.rowCol3(
      child: prov.widget.txtBlack16(
        sText: 'ปริมาณที่ผลิตได้',
      ),
      child2: TextField(
        controller: prov.txtQP,
        focusNode: prov.fnQP,
        textAlign: TextAlign.center,
        style: FontThai.text16BlackNormal,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}

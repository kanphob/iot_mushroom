class DropDownData {
  final int index;
  final String sLabel;
  final String sVal;

  DropDownData({
    required this.index,
    required this.sLabel,
    required this.sVal,
  });

  static List<DropDownData> getDataTypeCost() {
    List<DropDownData> list = [];
    list.add(
        DropDownData(index: 0, sLabel: 'ต้นทุนด้านวัสดุ/วัตถุดิบ', sVal: 'MC'));
    list.add(DropDownData(index: 1, sLabel: 'ต้นทุนด้านแรงงาน', sVal: 'LC'));
    return list;
  }

  static List<DropDownData> getDataMatCost() {
    List<DropDownData> list = [];
    list.add(DropDownData(index: 0, sLabel: 'วัสดุทางตรง', sVal: 'DMC'));
    list.add(DropDownData(index: 1, sLabel: 'วัสดุทางอ้อม', sVal: 'IMC'));
    return list;
  }

  static List<DropDownData> getDataLaborCost() {
    List<DropDownData> list = [];
    list.add(DropDownData(index: 0, sLabel: 'แรงงานทางตรง', sVal: 'DLC'));
    list.add(DropDownData(index: 1, sLabel: 'แรงงานทางอ้อม', sVal: 'ILC'));
    list.add(DropDownData(index: 2, sLabel: 'ค่าโสหุ้ย', sVal: 'OC'));
    return list;
  }

  static List<DropDownData> getDataIncome() {
    List<DropDownData> list = [];
    list.add(DropDownData(index: 0, sLabel: 'รายได้', sVal: 'INC'));
    return list;
  }

  static List<DropDownData> getDataExpense() {
    List<DropDownData> list = [];
    list.add(DropDownData(index: 0, sLabel: 'ค่าใช้จ่ายตั้งต้น', sVal: 'IEX'));
    list.add(DropDownData(index: 1, sLabel: 'ค่าใช้จ่ายประจำ', sVal: 'REX'));
    return list;
  }

}

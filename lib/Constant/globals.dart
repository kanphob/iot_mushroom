
import 'package:iot_mushroom/Model/model_cost_material.dart';
import 'package:intl/intl.dart';

class Globals {
  static List<ModelCostMaterial> listCostMaterial = [];
  static double dXPosition = 0;
  static double dYPosition = 0;

  static final dateFormatSave = DateFormat('dd/MM/yyyy');
  static final dateFormatTime = DateFormat.Hms();

  static String sTokenIOT = '';

  static String sModeADD = 'add';
  static String sModeEDIT = 'edit';
  static String sModeVIEW = 'view';

  static bool bBarChart = false;
}
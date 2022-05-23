
import 'package:siwat_mushroom/Model/model_condition.dart';
import 'package:siwat_mushroom/Model/model_cost_material.dart';
import 'package:intl/intl.dart';

class Globals {
  static List<List<ModelCondition>> listCondition = [];
  static List<ModelCostMaterial> listCostMaterial = [];
  static double dXPosition = 0;
  static double dYPosition = 0;

  static final dateFormatUser = DateFormat('dd/MM/yyyy');

  static String sTokenIOT = '';
}
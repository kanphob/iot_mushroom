import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:siwat_mushroom/Constant/globals.dart';

class APICall {
  static Future<String> httpGetForSignIn({
    required String sUsername,
    required String sPassword,
  }) async {
    String sPRT = "login";
    String sResult = "";
    var url = Uri(
        scheme: 'http',
        host: 'iot.farmdasia.com',
        path: 'api.aspx',
        queryParameters: {
          'prt': sPRT,
          'user': ' $sUsername',
          'password': sPassword
        });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      Globals.sTokenIOT = jsonResponse['token'];
      if (kDebugMode) {
        print('response : ${response.body}.');
      }
      sResult = jsonResponse['status'] ?? "";
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    return sResult;
  }

  static Future<String> httpGetForDeviceValue({
    required String sDeviceID,
    required String sDeviceKey,
  }) async {
    String sPRT = "drive";
    String sResult = "";
    var url = Uri(
        scheme: 'http',
        host: 'iot.farmdasia.com',
        path: '/apis/drive_io.aspx',
        queryParameters: {
          'prt': sPRT,
          'dev_id': sDeviceID,
          'dev_key': sDeviceKey,
          'status': 'true',
        });
    print('$url');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      if (kDebugMode) {
        print('response : ${response.body}.');
      }
      sResult = jsonResponse['status'] ?? "";
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }

    return sResult;
  }

  static Future<String> httpGetForData() async {
    String sResult = "";
    DateTime dtNow = DateTime.now();
    var url = Uri(
        scheme: 'http',
        host: 'iot.farmdasia.com',
        path: '/apis/get_tm.aspx',
        queryParameters: {
          'dev_id': Globals.sTokenIOT,
          'startTs': dtNow.millisecondsSinceEpoch.toString(),
          'endTs': dtNow.millisecondsSinceEpoch.toString(),
        });
    print('$url');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      if (kDebugMode) {
        print('response : ${response.body}.');
      }
      sResult = jsonResponse['status'] ?? "";
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }

    return sResult;
  }
}

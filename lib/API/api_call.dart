import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:iot_mushroom/Constant/field_master.dart';
import 'dart:convert' as convert;

import 'package:iot_mushroom/Constant/globals.dart';

class APICall {

  static Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': Globals.sTokenIOT
  };


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

  static Future<String> getDeviceValue({String? sDevKey}) async {
    String sPRT = "get";
    String sResult = "";
    var url = Uri(
      scheme: 'http',
      host: 'iot.farmdasia.com',
      path: '/apis/drive_io.aspx',
      queryParameters: {
        'prt': sPRT,
        'dev_id': '466a9d20-832a-11ec-bbb0-65317744a1a2',
        'dev_key': sDevKey,
      },
    );
    if (kDebugMode) {
      print('$url');
    }
    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      sResult = jsonResponse['value'] ?? "";
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }

    return sResult;
  }

  static Future<String> httpCommandOnOff({String? sDevKey,bool bOpen = false}) async {
    String sPRT = "drive";
    String sResult = "";
    String sStatus = "";
    if(bOpen){
      sStatus = 'true';
    }else{
      sStatus = 'false';
    }
    var url = Uri(
      scheme: 'http',
      host: 'iot.farmdasia.com',
      path: '/apis/drive_io.aspx',
      queryParameters: {
        'prt': sPRT,
        'dev_id': '466a9d20-832a-11ec-bbb0-65317744a1a2',
        'dev_key': sDevKey,
        'status': sStatus
      },
    );
    if (kDebugMode) {
      print('$url');
    }
    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print('response : ${response.body}.');
      sResult = jsonResponse['status'] ?? "";
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }

    return sResult;
  }

  static Future<Map<String, dynamic>> deviceIO({
    required String sDevKey,
    required String sStatus,
  }) async {
    String sPRT = "drive";
    Map<String, dynamic> map = {};
    var url = Uri(
      scheme: 'http',
      host: 'iot.farmdasia.com',
      path: '/apis/drive_io.aspx',
      queryParameters: {
        'prt': sPRT,
        'dev_id': '466a9d20-832a-11ec-bbb0-65317744a1a2',
        'dev_key': sDevKey,
        'status': sStatus,
      },
    );
    if (kDebugMode) {
      print('$url');
    }
    var response = await http.post(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print('response : ${response.body}.');
      map[FieldMaster.sApiStatus] = json[FieldMaster.sApiStatus] ?? "";
      map[FieldMaster.sApiValue] = json[FieldMaster.sApiValue] ?? "";
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    return map;
  }

  static Future<String> dataHistory() async {
    String sResult = "";
    DateTime dtNow = DateTime.now();
    String sDevId = "466a9d20-832a-11ec-bbb0-65317744a1a2";
    String sDevKey = "temp_1";
    var url = Uri(
      scheme: 'http',
      host: 'iot.farmdasia.com',
      path: '/apis/get_tm.aspx',
      queryParameters: {
        'dev_id': sDevId,
        'dev_key': sDevKey,
        'startTs': dtNow.millisecondsSinceEpoch.toString(),
        'endTs': dtNow.millisecondsSinceEpoch.toString(),
      },
    );
    if (kDebugMode) {
      print('$url');
    }

    var response = await http.get(
      url,
      headers: requestHeaders
    );
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

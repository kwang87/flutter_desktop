// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

import 'dart:convert';
import 'SGClientConfig.dart';
import 'package:xml/xml.dart';

class SGMaster {
  SGMaster._privateConstructor();

  static final SGMaster _instance = SGMaster._privateConstructor();
  factory SGMaster() {
    return _instance;
  }

  void initSGMaster() {
    obClientConfig = SGClientConfig.createDefaultConfig();
  }

  late SGClientConfig obClientConfig;
  void parseClientInitConifg(String body) {
    dynamic configData = jsonDecode(body);
    dynamic configResponse = configData["data"];
    Map<String, dynamic> configRes = configResponse["response"];

    debugPrint("before from json: ${obClientConfig.manuals}");

    obClientConfig = SGClientConfig.fromJson(configRes);
    debugPrint("after from json: ${obClientConfig.manuals}");
  }

  bool parseInstallClient(String body) {
    XmlDocument? xmlData;
    xmlData = XmlDocument.parse(body);
    clientID =
        xmlData.findAllElements('clientId').map((e) => e.text).toString();
    String resultCode =
        xmlData.findAllElements('resultCode').map((e) => e.text).toString();

    // XmlData
    debugPrint('clientID: $clientID');
    clientID = clientID.substring(1, clientID.length - 1);
    debugPrint('result: $resultCode');
    debugPrint('clientID: $clientID');
    if (resultCode == 'true') {
      return true;
    }

    return false;
  }

  String clientID = '';
}

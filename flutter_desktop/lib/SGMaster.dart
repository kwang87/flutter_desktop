import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'SGClientConfig.dart';
import 'SGHttpReader.dart';
import 'package:xml/xml.dart';

class SGMaster {
  SGMaster._privateConstructor() {
    // SGHttpReader().readClientInitConfig();
  }

  static final SGMaster _instance = SGMaster._privateConstructor();
  factory SGMaster() {
    return _instance;
  }

  void InitSGMaster() {
    obClientConfig = SGClientConfig(
        portForProtocol: "9321|9325",
        clientDebugMode: "N",
        clientConnectTool: "Y,Y,Y,Y",
        clientConfigUse: true,
        integrityCheckOption: "L",
        callSSOActiveXUrlYN: false,
        ssoServiceMethod: "INISAFE_NEXESS_V2_ACTIVEX",
        findPasswordUse: false,
        findPasswordServiceCode: "SMS,EMAIL,MESSENGER",
        customLoginLogoImageBinary: "",
        customTopLogoImageBinary: "",
        autoUpdateUse: true,
        serverConfigOption: "E");
  }

  late SGClientConfig obClientConfig;
  void parseClientInitConifg(String body) {
    obClientConfig = SGClientConfig.fromXMLString(body);
  }

  bool parseInstallClient(String body) {
    XmlDocument? XmlData;
    XmlData = XmlDocument.parse(body);
    clientID =
        XmlData.findAllElements('clientId').map((e) => e.text).toString();
    String result_code =
        XmlData.findAllElements('resultCode').map((e) => e.text).toString();

    // XmlData
    print('clientID: $clientID');
    clientID = clientID.substring(1, clientID.length - 1);
    print('result: $result_code');
    print('clientID: $clientID');
    if (result_code == 'true') {
      return true;
    }

    return false;
  }

  String clientID = '';
}

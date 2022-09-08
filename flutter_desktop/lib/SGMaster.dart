import 'dart:convert';
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

  late SGClientConfig obClientConfig;
  void parseClientInitConifg(String body) {
    obClientConfig = SGClientConfig.fromXMLString(body);
  }

  bool parseInstallClient(String body) {
    XmlDocument? XmlData;
    XmlData = XmlDocument.parse(body);
    clientID = XmlData.findAllElements('clientId').toString();
    String result_code = XmlData.findAllElements('resultCode').toString();

    // XmlData

    print('result: $result_code');
    print('clientID: $clientID');

    if (result_code == 'true') {
      return true;
    }

    return false;
  }

  String clientID = '';
}

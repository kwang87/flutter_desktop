// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:xml/xml.dart';

class SGClientConfig {
  var portForProtocol = "9321|9325";
  var clientDebugMode = "N";
  var clientConnectTool = "Y,Y,Y,Y";
  bool clientConfigUse = true;
  var integrityCheckOption = "L";
  bool callSSOActiveXUrlYN = false;
  bool findPasswordUse = false;
  var findPasswordServiceCode = "SMS,EMAIL,MESSENGER";
  var ssoServiceMethod = "INISAFE_NEXESS_V2_ACTIVEX";
  var customLoginLogoImageBinary = "";
  bool autoUpdateUse = true;
  var customTopLogoImageBinary = "";
  var serverConfigOption = "E";
  List<SGManuals>? manuals;

  SGClientConfig({
    required this.portForProtocol,
    required this.clientDebugMode,
    required this.clientConnectTool,
    required this.clientConfigUse,
    required this.integrityCheckOption,
    required this.callSSOActiveXUrlYN,
    required this.ssoServiceMethod,
    required this.findPasswordUse,
    required this.findPasswordServiceCode,
    required this.customLoginLogoImageBinary,
    required this.customTopLogoImageBinary,
    required this.autoUpdateUse,
    required this.serverConfigOption,
    this.manuals,
  });

  factory SGClientConfig.fromXMLString(String jsonBody) {
    XmlDocument? XmlData;
    XmlData = XmlDocument.parse(jsonBody);

    // var datas = XmlData.findAllElements('clientManuals');
    // for (String att in datas) {
    //   print(att);
    // }
    var manualsList = XmlData.findAllElements('clientManuals')
        .map<SGManuals>((e) => SGManuals.fromXML(e))
        .toList();

    return SGClientConfig(
      portForProtocol: XmlData.findAllElements('portForProtocol2').toString(),
      clientDebugMode: XmlData.findAllElements('clientDebugMode').toString(),
      clientConnectTool:
          XmlData.findAllElements('clientConnectTool').toString(),
      clientConfigUse: XmlData.findAllElements('configUseYN').toString() == "Y"
          ? true
          : false,
      integrityCheckOption:
          XmlData.findAllElements('integrityCheckOption').toString(),
      callSSOActiveXUrlYN:
          XmlData.findAllElements('callSSOActiveXUrlYN').toString() == "Y"
              ? true
              : false,
      findPasswordUse:
          XmlData.findAllElements('findPwdYN').toString() == "Y" ? true : false,
      findPasswordServiceCode: XmlData.findAllElements('servicdCd').toString(),
      ssoServiceMethod: XmlData.findAllElements('ssoServiceMethod').toString(),
      customLoginLogoImageBinary:
          XmlData.findAllElements('customLogoLogin').toString(),
      autoUpdateUse: XmlData.findAllElements('autoUpdateYN').toString() == "Y"
          ? true
          : false,
      customTopLogoImageBinary:
          XmlData.findAllElements('customLogoTop').toString(),
      serverConfigOption:
          XmlData.findAllElements('serverConfigOption').toString(),
      manuals: manualsList,
    );
  }

  factory SGClientConfig.fromString(String jsonBody) {
    Map<String, dynamic> parsedJson = jsonDecode(jsonBody);
    print(parsedJson);
    var list = parsedJson['clientManuals'] as List;
    print(list.runtimeType);

    List<SGManuals> manualsList =
        list.map((i) => SGManuals.fromJson(i)).toList();

    return SGClientConfig(
        portForProtocol: parsedJson['portForProtocol'],
        clientDebugMode: parsedJson['clientDebugMode'].toString(),
        clientConnectTool: parsedJson['clientConnectTool'].toString(),
        clientConfigUse: parsedJson['configUseYN'] == "Y" ? true : false,
        integrityCheckOption: parsedJson['integrityCheckOption'].toString(),
        callSSOActiveXUrlYN:
            parsedJson['callSSOActiveXUrlYN'] == "Y" ? true : false,
        findPasswordUse: parsedJson['findPwdYN'] == "Y" ? true : false,
        findPasswordServiceCode: parsedJson['servicdCd'].toString(),
        ssoServiceMethod: parsedJson['ssoServiceMethod'].toString(),
        customLoginLogoImageBinary: parsedJson['customLogoLogin'].toString(),
        autoUpdateUse: parsedJson['autoUpdateYN'] == "Y" ? true : false,
        customTopLogoImageBinary: parsedJson['customLogoTop'].toString(),
        serverConfigOption: parsedJson['serverConfigOption'].toString(),
        manuals: manualsList);
  }

  factory SGClientConfig.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson);
    var list = parsedJson['clientManuals'] as List;
    print(list.runtimeType);

    List<SGManuals> manualsList =
        list.map((i) => SGManuals.fromJson(i)).toList();

    return SGClientConfig(
        portForProtocol: parsedJson['portForProtocol'],
        clientDebugMode: parsedJson['clientDebugMode'],
        clientConnectTool: parsedJson['clientConnectTool'],
        clientConfigUse: parsedJson['configUseYN'] == "Y" ? true : false,
        integrityCheckOption: parsedJson['integrityCheckOption'],
        callSSOActiveXUrlYN:
            parsedJson['callSSOActiveXUrlYN'] == "Y" ? true : false,
        findPasswordUse: parsedJson['findPwdYN'] == "Y" ? true : false,
        findPasswordServiceCode: parsedJson['servicdCd'],
        ssoServiceMethod: parsedJson['ssoServiceMethod'],
        customLoginLogoImageBinary: parsedJson['customLogoLogin'],
        autoUpdateUse: parsedJson['autoUpdateYN'] == "Y" ? true : false,
        customTopLogoImageBinary: parsedJson['customLogoTop'],
        serverConfigOption: parsedJson['serverConfigOption'],
        manuals: manualsList);
  }
}

class SGManuals {
  var clientManualID;
  var manualName;
  var manualFileSize;
  var manualFileName;

  SGManuals(
      {this.clientManualID,
      this.manualName,
      this.manualFileSize,
      this.manualFileName});

  factory SGManuals.fromJson(Map<String, dynamic> parsedJson) {
    return SGManuals(
      clientManualID: parsedJson['clientManualId'],
      manualName: parsedJson['manualNm'],
      manualFileSize: parsedJson['manualFileSize'],
      manualFileName: parsedJson['manualFileNm'],
    );
  }

  factory SGManuals.fromXML(XmlElement parsedXML) {
    return SGManuals(
      clientManualID: parsedXML.getAttribute('clientManualId'),
      manualName: parsedXML.getAttribute('manualNm'),
      manualFileSize: parsedXML.getAttribute('manualFileSize'),
      manualFileName: parsedXML.getAttribute('manualFileNm'),
    );
  }
}

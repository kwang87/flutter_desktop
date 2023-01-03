// ignore_for_file: avoid_print, file_names, duplicate_ignore
// ignore: file_names

// import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';

class SGClientConfig {
  String portForProtocol = "9321|9325";
  String clientDebugMode = "N";
  String clientConnectTool = "Y,Y,Y,Y";
  bool clientConfigUse = true;
  String integrityCheckOption = "L";
  bool callSSOActiveXUrlYN = false;
  bool findPasswordUse = false;
  String findPasswordServiceCode = "SMS,EMAIL,MESSENGER";
  String ssoServiceMethod = "INISAFE_NEXESS_V2_ACTIVEX";
  String customLoginLogoImageBinary = "";
  bool autoUpdateUse = true;
  String customTopLogoImageBinary = "";
  String serverConfigOption = "E";
  bool useAzureAD = false;
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
    required this.useAzureAD,
    required List<SGManuals>? manuals,
  }) : manuals = manuals ?? [];

  SGClientConfig.createDefaultConfig();

  SGClientConfig.fromJson(Map<String, dynamic> json)
      : portForProtocol = json["portForProtocol"],
        clientDebugMode = json["clientDebugMode"],
        useAzureAD = json["useAzureAD"] == "Y" ? true : false,
        clientConnectTool = json["clientConnectTool"],
        clientConfigUse = json["configUseYN"] == "Y" ? true : false,
        integrityCheckOption = json["integrityCheckOption"],
        callSSOActiveXUrlYN = json["callSSOActiveXUrlYN"] == "Y" ? true : false,
        findPasswordUse =
            json["findPwdOption"]["findPwdYN"] == "Y" ? true : false,
        findPasswordServiceCode = json["findPwdOption"]["serviceCd"],
        ssoServiceMethod = json["ssoServiceMethod"],
        customLoginLogoImageBinary = json["customLogoLogin"],
        serverConfigOption = json["serverConfigOption"],
        manuals = parseManuals(json["clientManuals"]);

  static List<SGManuals>? parseManuals(List<dynamic>? json) {
    if (json != null) {
      List<SGManuals>? manuals;
      for (var map in json) {
        SGManuals obManual = SGManuals.fromJson(map);
        manuals?.add(obManual);
      }
      return manuals;
    }
    return null;
  }
}

class SGManuals {
  String clientManualID;
  String manualName;
  String manualFileSize;
  String manualFileName;

  SGManuals(
      {required this.clientManualID,
      required this.manualName,
      required this.manualFileSize,
      required this.manualFileName});

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
      clientManualID: parsedXML.getAttribute('clientManualId') ?? '0',
      manualName: parsedXML.getAttribute('manualNm') ?? 'empty_manual_name',
      manualFileSize:
          parsedXML.getAttribute('manualFileSize') ?? 'empty_manualfile_size',
      manualFileName:
          parsedXML.getAttribute('manualFileNm') ?? 'empty_manualfile_name',
    );
  }
}

// ignore_for_file: file_names

import 'SGMaster.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:system_clock/system_clock.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'SGHttpErrorCode.dart';
import 'package:encrypt/encrypt.dart' as enc;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class SGHttpReader {
  SGHttpReader._privateConstructor();
  static final SGHttpReader _instance = SGHttpReader._privateConstructor();
  factory SGHttpReader() {
    HttpOverrides.global = MyHttpOverrides();
    return _instance;
  }

  String currentServerIP = "172.24.11.3";
  int currentServerPort = 8443;

  Future<bool> readClientInitConfig() async {
    debugPrint('enter readClientInitConfig');
    String response = await _callAPI('/api/xml/getClientInitConfig');

    debugPrint('val: $response');
    SGMaster().parseClientInitConifg(response);
    return true;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  String generateRandomString2(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  String getEncKey(String strIdKey, String strRandomKey) {
    String strRet = "";
    strRandomKey = String.fromCharCodes(strRandomKey.runes.toList().reversed);
    strRet = strRandomKey.substring(15, 19) +
        strIdKey.substring(21, 25) +
        strIdKey.substring(5, 9) +
        strRandomKey.substring(24, 28) +
        strIdKey.substring(19, 23) +
        strRandomKey.substring(10, 14) +
        strIdKey.substring(10, 14) +
        strRandomKey.substring(2, 6);

    debugPrint('result enckey1: $strRet');
    return strRet;
  }

  Future<bool> requestClientID() async {
    debugPrint("enter requestClientID");
    String uuidStr = const Uuid().v4();
    uuidStr = uuidStr.replaceAll('-', '');
    debugPrint(uuidStr);
    String url = '/api/xml/$uuidStr/clientInstall';

    // make random key.
    String randomKey = generateRandomString2(32);
    String encKey = getEncKey(uuidStr, randomKey);
    // encKey = encKey.substring(0, 17);
    debugPrint('result enckey-final: $encKey');
    var key = utf8.encode(encKey);

    int currenttime = SystemClock.elapsedRealtime().inMilliseconds;
    currenttime = 1387346500;
    String hmac = '$url?rd=$randomKey${currenttime}';
    var hmac_ori_byte = utf8.encode(hmac);
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(hmac_ori_byte);

    var encoded = base64.encode(digest.bytes);

    String hmac2 = encoded.toString().replaceAll('+', '-');
    hmac2 = hmac2.replaceAll('/', '_');
    String param = 'rd=${randomKey}&hmac=${hmac2}&timestamp=${currenttime}';
    String response = await _callPOST(url, param);
    if (_responseIsError(response) == SGHttpErrorCode.successWeb) {
      // do parse data
      debugPrint('val: $response');
    }
    response = response.toString().replaceAll('-', '+');
    response = response.toString().replaceAll('_', '/');
    var basedecd = base64.decode(response);
    //base64 decode

    final deckey = enc.Key.fromUtf8(encKey);
    final encrypter = enc.Encrypter(enc.AES(deckey, mode: enc.AESMode.cbc));

    final iv = enc.IV.fromUtf8(encKey.substring(0, 16));
    final decrypted2 = encrypter.decryptBytes(enc.Encrypted(basedecd), iv: iv);

    print(utf8.decode(decrypted2));
    bool b = SGMaster().parseInstallClient(utf8.decode(decrypted2));

    if (b == true) {
      print('Do after installClient work');
    }
    return true;
  }

  // Future<bool> requestAMLogin(String loginID, String loginPWD) async {
  //   print("enter requestAMLogin");
  //   Future<String> response = _callAPI('/api/xml/getClientInitConfig');

  //   response.then((val) {
  //     // 해당 값을 출력
  //     print('val: $val');
  //     SGMaster().parseClientInitConifg(val);
  //     return true;
  //   }).catchError((error) {
  //     // error가 해당 에러를 출력
  //     print('error: $error');
  //     return false;
  //   });

  //   return false;
  // }

  Future<String> _callAPI(String webUrl) async {
    var url = Uri.parse('https://$currentServerIP:$currentServerPort$webUrl');

    var response = await http.get(url);
    String result = response.body.substring(8, response.body.length - 9);
    return result;
  }

  Future<String> _callPOST(String webUrl, String bodyData) async {
    var url = Uri.parse('https://$currentServerIP:$currentServerPort$webUrl');
    debugPrint('post url: $url');
    debugPrint('post body: $bodyData');
    http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Referer': 'SecureGuardHttps',
          'User-Agent':
              'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)',
          'Cache-Control': 'no-cache'
        },
        body: bodyData);
    if (response.statusCode != HttpStatus.ok) {
      debugPrint('status code: ${response.statusCode}');
      // return '';
    }
    print("response: ${response.body}");
    String result = response.body.substring(8, response.body.length - 9);
    print("result: ${result}");
    return result;
  }

  SGHttpErrorCode _responseIsError(String msg) {
    switch (msg) {
      case 'E01':
        return SGHttpErrorCode.failedParam;
      case 'E02':
        return SGHttpErrorCode.failedClientId;
      case 'E03':
        return SGHttpErrorCode.failedTimestamp;
      case 'E04':
        return SGHttpErrorCode.failedAPIKey;
      case 'E05':
        return SGHttpErrorCode.failedHMAC;
      case 'E06':
        return SGHttpErrorCode.failedAuth;
      case 'E07':
        return SGHttpErrorCode.failedDuplicateLogout;
      case '':
        return SGHttpErrorCode.failedResult;
      default:
        return SGHttpErrorCode.successWeb;
    }
  }

  void makeParams() {}
}

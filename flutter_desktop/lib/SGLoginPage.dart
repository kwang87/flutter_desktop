// ignore_for_file: file_names

import 'package:fluent_ui/fluent_ui.dart';
import 'dart:async';
import 'package:desktop_window/desktop_window.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' as materials;
import 'package:flutter_desktop/SGMaster.dart';
import 'package:window_manager/window_manager.dart';
import 'SGHttpReader.dart';
import 'SGLoadingGif.dart';

Future loginPageNormalMode() async {
  await DesktopWindow.setMinWindowSize(const Size(362, 329));
  await DesktopWindow.setWindowSize(const Size(362, 329));
}

Future loginPageFindPwdSSO() async {
  await DesktopWindow.setMinWindowSize(const Size(362, 419));
  await DesktopWindow.setWindowSize(const Size(362, 419));
}

Future loginPageSSO() async {
  await DesktopWindow.setMinWindowSize(const Size(362, 379));
  await DesktopWindow.setWindowSize(const Size(362, 379));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  //State<MyHomePage> createState() => _MyHomePageState();
  State<MyHomePage> createState() => _SGLoginState();
}
/*
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      home: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image.network(
            //  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
            Image.asset(
              'assets/images/login_logo.png',
              fit: BoxFit.fitWidth,
            ),
            Text('$_counter'),
            IconButton(
              onPressed: _incrementCounter,
              icon: const Icon(FluentIcons.add),
            ),
            TextBox(
              autofocus: true,
              placeholder: "login id",
            ),
            TextBox(
              placeholder: "login password",
            ),
            OutlinedButton(
              child: Text("login button", textAlign: TextAlign.center),
              onPressed: _incrementCounter,
            ),
          ],
        ),
      ),
    );
  }
}*/

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 245, 245, 245),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //MinimizeWindowButton(),
          //MaximizeWindowButton(),
          IconButton(
            icon: const Icon(
              FluentIcons.settings,
              size: 16,
            ),
            onPressed: () => appWindow.minimize(),
          ),
          IconButton(
            icon: const Icon(
              FluentIcons.chrome_minimize,
              size: 16,
            ),
            onPressed: () => appWindow.minimize(),
          ),
          IconButton(
            icon: const Icon(
              FluentIcons.chrome_close,
              size: 16,
            ),
            onPressed: () => appWindow.close(),
          ),
        ],
      ),
    );
  }
}

class LoginTitleBar extends MoveWindow {
  LoginTitleBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: const Color.fromARGB(255, 0, 255, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          SizedBox(
            width: 15,
          ),
          Text("SecureGuard..."),
        ],
      ),
    );
  }
}

Widget createSGStyleTitleBar() {
  return Container(
    color: const Color.fromARGB(255, 245, 245, 245),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 13,
        ),
        Image.asset(
          'assets/images/am_logo.png',
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: appWindow.rect.width - 13 - 16 - (34 * 3),
              height: 35,
              child: Container(
                color: const Color.fromARGB(255, 245, 245, 245),
                child: Column(
                  children: [
                    WindowTitleBarBox(child: MoveWindow()),
                    Expanded(child: Container())
                  ],
                ),
              ),
            ),
          ),
        ),
        const WindowButtons(),
      ],
    ),
  );
}

class _SGLoginState extends State<MyHomePage> with WindowListener {
  String _notiMessage = "";
  TextEditingController loginIDcontroller = TextEditingController();
  TextEditingController loginPwdcontroller = TextEditingController();

  final OverlayExample _example = OverlayExample();

  @override
  void initState() {
    SGMaster().initSGMaster();
    windowManager.addListener(this);

    Future<bool> readInit = SGHttpReader().readClientInitConfig();
    debugPrint("build...!!");
    readInit.then((val) {
      debugPrint(SGMaster().obClientConfig.portForProtocol);
      if (SGMaster().obClientConfig.autoUpdateUse == true) {
        debugPrint("Do Update Check");
      } else {
        debugPrint("bypass update  check");
      }

      if (SGMaster().obClientConfig.findPasswordUse == true &&
          SGMaster().obClientConfig.callSSOActiveXUrlYN == true) {
        debugPrint("find password use");
        // LoginPageRect(362, 419);
        loginPageFindPwdSSO();
      } else if (SGMaster().obClientConfig.findPasswordUse == true ||
          SGMaster().obClientConfig.callSSOActiveXUrlYN == true) {
        debugPrint("sso login use");
        loginPageSSO();
      } else {
        debugPrint("normal");
        loginPageNormalMode();
      }
    }).catchError((error) {
      // error가 해당 에러를 출력
      debugPrint('error: $error');
    });
    debugPrint("init #1");
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowEvent(String eventName) {
    debugPrint('[WindowManager] onWindowEvent: $eventName');
  }

  @override
  void onWindowResize() {
    setState(() {});
  }

  void displayNotiMessage(String msg) {
    _notiMessage = msg;
    setState(() {});
  }

  final BorderSide _kDefaultRoundedBorderSide = const BorderSide(
    style: BorderStyle.solid,
    width: 0.8,
  );

  Future loginPageRect(double w, double h) async {
    final initialSize = Size(w, h);
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  }

  Future<void> requestLogin() async {
    String loginID = loginIDcontroller.text;
    String loginPWD = loginPwdcontroller.text;
    SGHttpReader sgReader = SGHttpReader();
    bool readclientID = await sgReader.requestClientID();

    debugPrint('readclientID: $readclientID');
    if (readclientID == false) {
      return;
    }

    debugPrint(
        'auto update use: ${SGMaster().obClientConfig.autoUpdateUse == true ? "true" : "false"} ');
    debugPrint(
        'callSSOActiveXUrlYN: ${SGMaster().obClientConfig.callSSOActiveXUrlYN == true ? 'true' : 'false'}');
    debugPrint('clientDebugMode: ${SGMaster().obClientConfig.clientDebugMode}');

    // bool readInit = await SGHttpReader().readClientInitConfig();

    // print("build...!!$readInit");
  }

  Widget showLoadingImage() {
    return Image.asset(
      'assets/images/system_loading.gif',
    );
  }

  @override
  Widget build(BuildContext context) {
    _example.context = context;
    return FluentApp(
      title: "fluent ui title test",
      debugShowCheckedModeBanner: false,
      home: Container(
        width: 362,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 170, 170, 170))),
                child: createSGStyleTitleBar()),
            Container(
              padding: const EdgeInsets.only(
                  left: 25, top: 31, bottom: 25, right: 25),
              child: Column(children: [
                Image.asset(
                  'assets/images/login_logo.png',
                  //height: 60,
                  //width: 312,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  // height: 32,
                  color:
                      const Color.fromARGB(255, 255, 255, 255), // Colors.white,
                  child: Text(_notiMessage),
                ),
                TextBox(
                  controller: loginIDcontroller,
                  minHeight: 40,
                  placeholder: 'Input Login ID',
                  textAlignVertical: TextAlignVertical.center,
                  prefix: Image.asset(
                    'assets/images/am_logo.png',
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: _kDefaultRoundedBorderSide,
                      bottom: _kDefaultRoundedBorderSide,
                      left: _kDefaultRoundedBorderSide,
                      right: _kDefaultRoundedBorderSide,
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(3.0)),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                TextBox(
                  controller: loginPwdcontroller,
                  minHeight: 40,
                  placeholder: 'Input Login Password',
                  textAlignVertical: TextAlignVertical.center,
                  prefix: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'assets/images/am_logo.png',
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: _kDefaultRoundedBorderSide,
                        bottom: _kDefaultRoundedBorderSide,
                        left: _kDefaultRoundedBorderSide,
                        right: _kDefaultRoundedBorderSide,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(7.0))),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: materials.ElevatedButton(
                      onPressed: requestLogin,
                      child: const Text("Login", textAlign: TextAlign.center)),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

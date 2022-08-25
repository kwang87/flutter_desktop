import 'package:fluent_ui/fluent_ui.dart';
import 'dart:async';
//import 'package:desktop_window/desktop_window.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' as materials;
import 'package:window_manager/window_manager.dart';
/*
Future testWindowFunctions() async {
  Size size = await DesktopWindow.getWindowSize();
  print(size);
  await DesktopWindow.setMinWindowSize(const Size(362, 329));
}*/

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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 245, 245, 245),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Color.fromARGB(255, 0, 255, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 15,
          ),
          Text("SecureGuard..."),
        ],
      ),
    );
  }
}

Widget CreateSGStyleTitleBar() {
  return Container(
    color: Color.fromARGB(255, 245, 245, 245),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
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
                color: Color.fromARGB(255, 245, 245, 245),
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
        WindowButtons(),
      ],
    ),
  );
}

class _SGLoginState extends State<MyHomePage> with WindowListener {
  String _notiMessage = "test not1234i\ntest\n123124";
  TextEditingController loginIDcontroller = new TextEditingController();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowEvent(String eventName) {
    print('[WindowManager] onWindowEvent: $eventName');
  }

  @override
  void onWindowResize() {
    setState(() {});
  }

  void displayNotiMessage(String msg) {
    _notiMessage = msg;
    setState(() {});
  }

  BorderSide _kDefaultRoundedBorderSide = BorderSide(
    style: BorderStyle.solid,
    width: 0.8,
  );

  Future LoginPageRect(double w, double h) async {
    final initialSize = Size(w, h);
    appWindow.minSize = initialSize;
    //appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  }

  @override
  Widget build(BuildContext context) {
    LoginPageRect(362, 339);
    return FluentApp(
      title: "fluent ui title test",
      debugShowCheckedModeBanner: false,
      home: Container(
        width: 362,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Color.fromARGB(255, 170, 170, 170))),
                child: CreateSGStyleTitleBar()),
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
                  //height: 32,
                  color: Color.fromARGB(255, 255, 255, 255), // Colors.white,
                  child: Text('$_notiMessage'),
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
                          BorderRadius.vertical(top: Radius.circular(3.0))),
                ),
                const SizedBox(
                  height: 14,
                ),
                TextBox(
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
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: materials.ElevatedButton(
                    child: Text("Login", textAlign: TextAlign.center),
                    onPressed: () => setState(
                      () {
                        _notiMessage = loginIDcontroller.text;
                      },
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

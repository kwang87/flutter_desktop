import 'package:fluent_ui/fluent_ui.dart';
import 'dart:async';
//import 'package:desktop_window/desktop_window.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:window_manager/window_manager.dart';
/*
Future testWindowFunctions() async {
  Size size = await DesktopWindow.getWindowSize();
  print(size);
  await DesktopWindow.setMinWindowSize(const Size(362, 329));
}*/

Future testWindowFunctions2() async {
  const initialSize = Size(362, 329);
  appWindow.minSize = initialSize;
  //appWindow.maxSize = initialSize;
  appWindow.size = initialSize;
  appWindow.alignment = Alignment.center;
  appWindow.show();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    testWindowFunctions2();
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
      color: Colors.white,
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
      color: Colors.green,
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

class _SGLoginState extends State<MyHomePage> with WindowListener {
  String _notiMessage = "test noti";

  @override
  void onWindowResize() {
    print('resize!!!!');
    setState(() {});
  }

  SizedBox titleBox = SizedBox();

  Widget CreateSGStyleTitleBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 13,
        ),
        Image.asset(
          'assets/images/am_logo.png',
        ),
        FittedBox(
          //fit: BoxFit.fill,
          child: SizedBox(
            width: appWindow.rect.width - 13 - 16 - (30 * 3),
            height: 35,
            child: Container(
              color: Color.fromARGB(255, 0x42, 0x42, 0x42),
              child: Column(
                children: [
                  WindowTitleBarBox(child: MoveWindow()),
                  Expanded(child: Container())
                ],
              ),
            ),
          ),
        ),
        WindowButtons(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "fluent ui title test",
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Color.fromARGB(255, 194, 194, 194))),
                child: CreateSGStyleTitleBar()),
            Container(
              padding: const EdgeInsets.only(
                  left: 25, top: 31, bottom: 25, right: 25),
              child: Column(children: [
                Image.asset(
                  'assets/images/login_logo.png',
                  height: 60,
                  width: 312,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  color: Colors.white,
                  child: Text('$_notiMessage'),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

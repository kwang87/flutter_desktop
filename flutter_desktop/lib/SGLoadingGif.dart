// import 'package:fluent_ui/fluent_ui.dart';
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: SlideTransition(
            position: _animation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(30)),
                child: const Text(
                  'Alert',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Toast extends StatefulWidget {
  const Toast({Key? key}) : super(key: key);

  @override
  _ToastState createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    _controller.forward().whenComplete(() {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FadeTransition(
            opacity: _animation,
            child: Material(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey),
                  child: const Text('Toast',
                      style: TextStyle(color: Colors.white))),
            ),
          ),
        ),
      ),
    );
  }
}

class OverlayExample {
  late BuildContext context;

  void showAlert() async {
    OverlayEntry overlay = OverlayEntry(builder: (_) => const Alert());

    Navigator.of(context).overlay!.insert(overlay);

    await Future.delayed(const Duration(seconds: 1));
    overlay.remove();
  }

  void toast() async {
    OverlayEntry overlay = OverlayEntry(builder: (_) => const Toast());

    Navigator.of(context).overlay!.insert(overlay);

    await Future.delayed(const Duration(seconds: 2));
    overlay.remove();
  }
}

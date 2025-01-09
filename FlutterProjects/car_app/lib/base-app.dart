import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseApp extends StatelessWidget {
  final Widget child;
  final String title;

  const BaseApp({super.key, required this.child, this.title = 'My App'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Hide the debug banner
      navigatorObservers: [
        _StatusBarHider(),
      ],
      home: child,
    );
  }
}

class _StatusBarHider extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _hideStatusBar();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _hideStatusBar();
  }

  void _hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  }
}
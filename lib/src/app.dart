import 'package:card_input/src/core/router/app_router.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CardInput',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

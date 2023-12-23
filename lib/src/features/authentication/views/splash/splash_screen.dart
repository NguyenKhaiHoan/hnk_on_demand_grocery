import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset("assets/logos/grofast_splash.gif",
              gaplessPlayback: true, fit: BoxFit.fill)),
    );
  }
}

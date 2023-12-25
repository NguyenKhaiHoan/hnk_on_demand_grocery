import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_demand_grocery/src/features/authentication/provider/on_boarding_provider.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/login_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding_screen/on_boarding_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isviewed;

void main() async {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On demand Grocery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        splashIconSize: 5000,
        duration: 5000,
        splash: Center(
            child: Image.asset(
          "assets/logos/grofast_splash.gif",
          gaplessPlayback: true,
          fit: BoxFit.fill,
          height: 400,
          width: 400,
        )),
        nextScreen: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => OnboardingProvider()),
          ],
          child: Consumer<OnboardingProvider>(
            builder: (context, onboardingProvider, child) {
              if (onboardingProvider.isLoading ?? false) {
                return const Center(child: CircularProgressIndicator());
              } else if (onboardingProvider.isViewed ?? true) {
                return const OnboardingScreen();
              } else {
                return const LoginScreen();
              }
            },
          ),
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}

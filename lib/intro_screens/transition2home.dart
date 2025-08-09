import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spotiflow/homepage.dart';

// ignore: camel_case_types 
class transition2Home extends StatelessWidget {
  const transition2Home({super.key});

//stateless widget for the animation between introPage3 and homePage
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: 
    Column(
      children: [
        Center(
          child: LottieBuilder.asset("assets/animations/profsearch.json")
        )
      ],
    ), nextScreen: const HomePage(),
    splashIconSize: 404,
    backgroundColor: Colors.grey.shade900,);
  }
}

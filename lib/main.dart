import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spotiflow/onboarding_screen.dart'; // Ensure OnBoardingScreen is imported
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for text styling



Future<void> main() async{
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 2500, // Duration for the splash screen
        splash: Center( // Center the text horizontally and vertically
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Spoti',
              style: GoogleFonts.inter(
                fontSize: 48, // Adjust font size as needed
                fontWeight: FontWeight.w900,
                color: Colors.white, // "Spoti" is white
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Flow',
                  style: GoogleFonts.inter(
                    fontSize: 48, // Adjust font size as needed
                    fontWeight: FontWeight.w900,
                    color: Colors.blue, // "Flow" is blue
                  ),
                ),
              ],
            ),
          ),
        ),
        nextScreen: const OnBoardingScreen(), //  navigates to OnBoardingScreen after
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.grey.shade900, // Fallback background color
      ),
    );
  }
}

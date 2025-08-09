import 'dart:ui' as ui; // Alias dart:ui
import 'dart:async'; // for da Timer

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  Timer? _initialVisibilityTimer; // timer for delay of swipeLeft animation
  bool _isVisible = false; // opacity of swipeLeft

  @override
  void initState() {
    super.initState();

    // bool continued of timer
    _initialVisibilityTimer = Timer(const Duration(seconds: 4), () { // delay in seconds of swipeLeft appearing
      if (mounted) {
        setState(() {
          _isVisible = true; // makes swipeLeft visible
        });
      }
    });
  }
    
  @override
  void dispose() {
    _initialVisibilityTimer?.cancel(); // Cancel the initial visibility timer 2 prevent memory leakz
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/spotilogo.jpg'), //bg image
            fit: BoxFit.cover,
          ),
        ),
        //blurs bg image
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 30,
            sigmaY: 25,
          ),
          child: Stack( //using Stack so positioning of text isnt dependent
            children: [
              Align( //aligns richText to center, 
                alignment: Alignment.center,
                //Rich text to change colors of certain letters (eg. Flow in SpotiFlow)
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Welcome to ',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      color: const ui.Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w900,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Spoti',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..shader = ui.Gradient.linear(
                              const ui.Offset(0, 0),
                              const ui.Offset(100, 0),
                              <ui.Color>[
                                const ui.Color.fromARGB(255, 140, 195, 251),
                                const ui.Color.fromARGB(255, 255, 255, 255),
                              ],
                            ),
                        ),
                      ),
                      TextSpan(
                        text: 'Flow',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          foreground: Paint()
                            ..shader = ui.Gradient.linear(
                              const ui.Offset(0, 0),
                              const ui.Offset(100, 0),
                              <ui.Color>[
                                const ui.Color.fromARGB(255, 149, 24, 198),
                                const ui.Color.fromARGB(255, 0, 132, 255),
                              ],
                            ),
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          color: const ui.Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned( // animation position relative to the Stack's bounds
                bottom: 200, // Distance from the bottom of the screen
                left: 30,
                right: 0,
                child: Center( // Centers the Lottie animation with respect to positioned
                  child: SizedBox( // Reserves exact space 4 animation
                    width: 150, 
                    height: 150, 
                    child: AnimatedOpacity( // Fades the animation in/out
                      opacity: _isVisible ? 1.0 : 0.0, // Controls visibility based on _isVisible boolean
                      duration: const Duration(milliseconds: 1500), // Duration for the fade effect
                      child: Lottie.asset(
                        'assets/animations/swipeleft.json', // lottie swipeLeft animation file
                        width: 150, // dimensions with respect to sizedbox
                        height: 150,
                        fit: BoxFit.contain,
                        repeat: true, // repeat animation
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

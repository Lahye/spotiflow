import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/intrar.jpg'), //Background img (some Spotify artists)
            fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20, sigmaY: 20 //blurs imgs horizontall, vertically
              ),
              child: Center(
                child: RichText( // RichText to style certain letters differently
                  textAlign: TextAlign.center, // Keeps text centered
                  text: TextSpan(
                    text: 'Find your favorite ', // First part of richtext
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      color: Colors.white, // first part color = white
                      fontWeight: FontWeight.w900
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Spotify', // Turning "Spotify" green
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          color: Colors.greenAccent, // Magic -> spotify word green
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: ' artists in one search.',
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          color: Colors.white, // Back to white
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ),
      );
  }
}

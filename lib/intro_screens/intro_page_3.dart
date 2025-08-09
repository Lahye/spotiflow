import 'dart:ui'; // Required for ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration( // BoxDecoration can hold both image and gradient

        //I ended up just making the bg gray lol...
        gradient: const RadialGradient(
          center: Alignment.center, // Gradient starts from the center
          radius: 1.0, // Extends to the very edges of the container
          colors: [
            Color.fromARGB(255, 40, 39, 39), // grey.shade900 center
            Color.fromARGB(255, 40, 39, 39), // grey.shade900 large portion
            Color.fromARGB(255, 40, 39, 39), // //grey.shade900 around still
            Color.fromARGB(255, 40, 39, 39) // edges
          ],
          
        ),
        // 2. Background Image (will be layered on top of the grey gradient)
        image: const DecorationImage(
          image: AssetImage('assets/images/introthree.png'),
          fit: BoxFit.contain, // Ensures the image covers the entire background
        ),
      ),
      child: BackdropFilter( // blurs everything behind the text
        filter: ImageFilter.blur(
          sigmaX: 8.5, // Horizontal blur 
          sigmaY: 7, // Vertical blur
        ),
        child: Container(
          // ignore: deprecated_member_use
          color: Color.fromARGB(51, 0, 0, 0), // Semi-transparent overlay for text readability
          child: Center(
            child: Text(
              'Give it a try.', // try it for real!
              style: GoogleFonts.inter(
                color: Colors.white, // Text color for contrast
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

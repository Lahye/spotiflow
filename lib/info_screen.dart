import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( //Appbar Text
          'ABOUT',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // makes back-arrow white
        ),
      ),
      backgroundColor: Colors.grey.shade800, // Slightly lighter than normal background
      body: SingleChildScrollView( // Allows scrolling
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centered RichText to make SpotiFlow 2 diff colors
            Center(
              child: RichText(
                textAlign: TextAlign.center, // wraps multiline text 
                text: TextSpan(
                  text: 'Spoti',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white, // "Spoti" = white
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Flow',
                      style: GoogleFonts.inter(
                        fontSize: 28, //
                        fontWeight: FontWeight.w800,
                        color: Colors.blue, // "Flow" = blue
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            //first paragraph
            Text(
              "SpotiFlow is an application built in Flutter dedicated to searching for Spotify artists. It leverages Spotify's Web API, allowing you to seamlessly search & display your favorite artists, their following count, and their associated image.",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color.fromARGB(240, 255, 255, 255),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            //List of features
            Text(
              'Features:',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            //bulletpoints for features
            _buildInfoPoint('• Search for artists by name.'),
            _buildInfoPoint('• View artists image & follow count.'),
            _buildInfoPoint('• Clean & intuitive user interface.'),
            const SizedBox(height: 30),
            Text(
              'Data provided by Spotify Web API, App & Logo created by Lahye Kamara',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(168, 255, 254, 254),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/introthree.png', // my logo !!
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

//Makes it easier to edit all bulletpoints styling @ once
  Widget _buildInfoPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: Color.fromARGB(240, 255, 255, 255),
          height: 1.5,
        ),
      ),
    );
  }
}

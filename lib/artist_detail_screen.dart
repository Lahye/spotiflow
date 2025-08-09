import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For formatting numbers like followers

class ArtistDetailScreen extends StatelessWidget {
  final String artistName;
  final String artistImageUrl;
  final int followers;

  const ArtistDetailScreen({
    super.key,
    required this.artistName,
    required this.artistImageUrl,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    // Format follower count for better readability eg. (987,654,321)
    final NumberFormat formatter = NumberFormat('#,###');
    final String formattedFollowers = formatter.format(followers);

    return Scaffold(
      extendBodyBehindAppBar: true, // Allows body to extend behind now transparent app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // Removes shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.grey.shade900, // Dark background for details
      body: Stack(
        children: [
          // artist background Image (fills width & height)
          Image.network(
            artistImageUrl,
            fit: BoxFit.cover,
            width: double.infinity, // Ensures artist img takes full available width
            height: double.infinity, // Ensure artist img takes full available height
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade900,
              width: double.infinity,
              height: double.infinity,
              child: Icon(Icons.person, color: Color.fromARGB(128, 255, 255, 255), size: 100),
            ),
          ),
          // Gradient Overlay for readability (explicitly fill width and height)
          Container(
            width: double.infinity, // Ensure it takes full available width
            height: double.infinity, // Ensure it takes full available height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(77, 0, 0, 0), // Reduced opacity for a lighter overlay
                  Color.fromARGB(128, 0, 0, 0), // Reduced opacity for a lighter overlay
                ],
              ),
            ),
          ),
          // Artist Details Content
          SafeArea( // Ensures content is not intersected by system UI
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Align content to the bottom
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artistName,
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$formattedFollowers Followers', //Displays follower count, followed by 'Followers'
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(230, 255, 255, 255)
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 40), // Space from bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

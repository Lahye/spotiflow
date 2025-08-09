import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:http/http.dart' as http; // Alias http for convenience
import 'package:spotiflow/artist_detail_screen.dart'; // Import the new detail screen
import 'dart:developer' as developer; // For logging
import 'package:spotiflow/info_screen.dart'; // Import the InfoScreen for navigation

//Never store these in app
final String _clientId = dotenv.env['CLIENT_ID']!;
final String _clientSecret = dotenv.env['CLIENT_SECRET']!;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _artists = []; // list to store fetched artist data
  bool _isLoading = false; // show loading indicator
  String? _accessToken; // Store OAuth access token

  @override
  void initState() {
    super.initState();
    _getAccessToken(); // Get the access token when the page initializes
  }

  // Function to get the Spotify OAuth Access Token
  Future<void> _getAccessToken() async {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching token
    });

    final String credentials = base64Encode(utf8.encode('$_clientId:$_clientSecret'));
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _accessToken = data['access_token'];
        _isLoading = false; // Hide loading indicator
      });
      developer.log('Access Token obtained: $_accessToken', name: 'SpotifyAuth'); // Using developer.log instead of print for notification
    } else {
      developer.log('Failed to get access token: ${response.statusCode} ${response.body}', name: 'SpotifyAuth', level: 1000); // Replaces print for error
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      // Optionally show an error message to the user
      _showSnackBar('Failed to authenticate with Spotify. Please check your credentials.'); //Error message at bottom
    }
  }

  // Function to search for artists on Spotify
  Future<void> _searchArtists(String query) async {
    if (_accessToken == null) {
      _showSnackBar('Access token not available. Please try again.'); //error msg function
      await _getAccessToken(); // retry for token if null
      return;
    }

    //Clear results if query = empty
    if (query.isEmpty) {
      setState(() {
        _artists = []; //
      });
      return;
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    //parse through spotify api search query
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=$query&type=artist&limit=20'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _artists = data['artists']['items'];
          _isLoading = false; // Hide loading indicator
        });
      } else if (response.statusCode == 401) { // refresh expired/invalid token
        developer.log('Access token expired or invalid. Refreshing token...', name: 'SpotifyAuth'); // Using developer.log
        await _getAccessToken();
        await _searchArtists(query); // Retry search after getting new token
      } else {
        developer.log('Failed to search artists: ${response.statusCode} ${response.body}', name: 'SpotifyAPI', level: 1000); // Using developer.log
        setState(() {
          _artists = [];
          _isLoading = false; // Hide loading indicator
        });
        _showSnackBar('Failed to search artists. Please try again later.'); //error msg at bottom
      }
    } catch (e) {
      developer.log('Error searching artists: $e', name: 'SpotifyAPI', level: 1000); // Using developer.log
      setState(() {
        _artists = [];
        _isLoading = false; // Hide loading indicator
      });
      _showSnackBar('An error occurred during search: $e'); //error msg at bottom
    }
  }

  //function to show a SnackBar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row( //row to put items side by side
          mainAxisSize: MainAxisSize.min, // ^ take the minimum amount of space needed
          children: [
            //Rich Text to make SpotiFlow 2 diff colors
            RichText(
              text: TextSpan(
                text: 'Spoti',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 32,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Flow',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      color: Colors.blue,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // color for icons
        ),
        centerTitle: true, // Centers title
        titleSpacing: 59.0,
        actions: [
          InkWell( // makes img clickable
            onTap: () {
              // change to InfoScreen when the image is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoScreen()),
              );
            },
            child: Image.asset( // Image asset itself
              'assets/images/introthree.png', //logo image
              height: 75, //img height
              width: 64.3, // img width
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 2), // spacing to right side
        ],
      ),
      backgroundColor: Colors.grey.shade900, // Dark background for the body
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for artists...', // text behind searchbar
                hintStyle: GoogleFonts.inter(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator( //loading circle
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 98, 255)), //makes loading circle blue like flow in SpotiFlow
                          strokeWidth: 2,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          _searchArtists(''); // Clear results
                        },
                      ),
                // border when the searchbar is unclicked
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade600, width: 1.0), // grey border
                ),

                //border when the TextField is focused (clicked)
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 21, 107, 255), width: 5.0), // Neon blue outline
                ),
                filled: true,
                fillColor: Colors.grey.shade700, //Background color for searchbar
              ),
              onSubmitted: (value) {
                _searchArtists(value);
              },
              onChanged: (value) {
                 //Live search as user types, artists auto appear at 3 chars
                 if (value.length > 2) {
                  _searchArtists(value);
                 } else if (value.isEmpty) {
                   setState(() {
                     _artists = [];
                   });
                 }
              },
            ),
          ),
          Expanded(
            child: _artists.isEmpty && !_isLoading //If you haven't started searching yet:
                ? Center(
                    child: Text(
                      'Use the searchbar to find your favorite artists!', //subtle Body background text
                      style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 98, 255)), // blue loading circle
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading artists...', //Appears when search is entered or when there is 3 chars in searchbar
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _artists.length,
                        itemBuilder: (context, index) {
                          final artist = _artists[index];
                          final imageUrl = artist['images'] != null && artist['images'].isNotEmpty
                              ? artist['images'][0]['url'] // Get the first image
                              : 'https://placehold.co/100x100/333333/FFFFFF?text=No+Image'; // Placeholder from placehold.co if theres no image

                          return Card(
                            color: const Color.fromARGB(255, 21, 107, 255), //background for artist card before its clicked
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            //shaping artist card
                            child: InkWell(
                              onTap: () {
                                // change to ArtistDetailScreen on tap
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArtistDetailScreen(
                                      artistName: artist['name'],
                                      artistImageUrl: imageUrl,
                                      followers: artist['followers']['total'],
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey.shade900,
                                          child: const Icon(Icons.person, color: Color.fromARGB(179, 255, 255, 255)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        artist['name'],
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis, // handle long names by placing 3 dots
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

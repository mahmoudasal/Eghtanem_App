import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

import '../controller/secure_token.dart';
import '../widgets/custom_page_transition.dart';
import 'nav_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Initialize a logger
  final Logger logger = Logger();

  final storageService = SecureStorageService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache images here
    _precacheImages(context);
  }

  void _precacheImages(BuildContext context) {
    // List of images to pre-cache
    final images = [
      'assets/احاديث.webp',
      'assets/المصحف.webp',
      'assets/السيره النبويه.webp',
      'assets/عقيده.webp',
      'assets/الأخلاق الإسلامية.webp',
      'assets/الأدعية والأذكار.webp',
    ];

    for (final imagePath in images) {
      precacheImage(AssetImage(imagePath), context);
    }
    logger.i("Images pre-cached successfully.");
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'https://www.googleapis.com/auth/youtube.force-ssl',
        ],
      ).signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Store the access token securely
      await storageService.write('accessToken', googleAuth.accessToken!);

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      logger.i("User Credential: ${userCredential.user}");

      // Fetch YouTube channel information
      Map<String, dynamic>? youtubeData;
      try {
        youtubeData = await _fetchYouTubeChannelInfo();
      } catch (e, stackTrace) {
        // Handle the exception and proceed
        logger.e("Failed to fetch YouTube channel info: $e", e, stackTrace);
        youtubeData = null; // Proceed without youtubeData
        // Optionally, show a message to the user
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Unable to fetch YouTube data. Some features may be limited.",
              ),
            ),
          );
        }
      }

      // Ensure the context is still valid
      if (!context.mounted) return;

      // Navigate to the next screen with youtubeData (can be null)
      Navigator.of(context).pushReplacement(
        createRoute(NaviagionScreen(youtubeData: youtubeData ?? {})),
      );
    } on FirebaseAuthException catch (e) {
      logger.e("Firebase Auth Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authentication error: ${e.message}")),
        );
      }
    } on SocketException {
      logger.e("Network Error: Check your internet connection");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Network error. Please check your connection.")),
        );
      }
    } catch (e) {
      logger.e("Error during Google Sign-In: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in with Google: $e")),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _fetchYouTubeChannelInfo() async {
    final String? accessToken = await storageService.read('accessToken');

    if (accessToken == null) {
      throw Exception('Access token is missing');
    }

    final response = await _retryHttpRequest(() => http.get(
          Uri.parse(
              'https://www.googleapis.com/youtube/v3/channels?part=snippet,statistics&mine=true'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'].isNotEmpty) {
        return data['items'][0];
      } else {
        throw Exception('No channel found for the user.');
      }
    } else {
      logger.e(
          'Failed to fetch YouTube channel info. Status Code: ${response.statusCode}');
      logger.e('Response body: ${response.body}');
      throw Exception('Failed to fetch YouTube channel info');
    }
  }

  Future<http.Response> _retryHttpRequest(
      Future<http.Response> Function() request) async {
    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final response = await request();
        return response;
      } catch (e) {
        retryCount++;
        if (retryCount == maxRetries) {
          rethrow;
        }
        await Future.delayed(Duration(seconds: 2 ^ retryCount));
      }
    }
    throw Exception('Failed after $maxRetries retries');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image filling the entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/thirdphoto.webp',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay for the background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(160, 0, 0, 0),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
            ),
          ),
          // SafeArea to avoid overlaps with system UI
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                // Ensures content is scrollable on smaller screens
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Spacing at the top
                    SizedBox(height: 0.1.sh),
                    // Logo or main image with adaptive size
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                        'assets/photo3.webp',
                        width: 0.65.sw,
                        colorBlendMode: BlendMode.plus,
                      ),
                    ),
                    // Main title text
                    Text(
                      "إغتنم",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                        color: const Color(0xFFD5CBBF),
                      ),
                    ),
                    SizedBox(height: 0.02.sh),
                    // Button container with padding instead of fixed width
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                      child: BlurryContainer(
                        blur: 20,
                        elevation: 0,
                        color: const Color.fromARGB(118, 0, 0, 0),
                        padding: const EdgeInsets.all(18),
                        borderRadius: BorderRadius.circular(20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(83, 55, 53, 77),
                            shadowColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {
                            _signInWithGoogle(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.02.sh),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const ImageIcon(
                                    AssetImage("assets/google.png")),
                                SizedBox(width: 0.05.sw),
                                Text(
                                  "تسجيل الدخول عبر جوجل",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Additional spacing at the bottom
                    SizedBox(height: 0.1.sh),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

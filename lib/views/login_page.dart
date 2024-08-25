import 'dart:io';
import 'dart:ui' as ui;

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:egtanem_application/views/profile.dart';
import 'package:flutter/foundation.dart';
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

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Initialize a logger
  final Logger logger = Logger();

  final storageService = SecureStorageService();

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
      final youtubeData = await _fetchYouTubeChannelInfo();

      // Ensure the context is still valid
      if (!context.mounted) return;

      // Navigate to the next screen with youtubeData
      Navigator.of(context).pushReplacement(
        createRoute(NaviagionScreen(youtubeData: youtubeData)),
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

  Future<ui.Image> _loadImage(String path) async {
    try {
      return await imageAssets.load(path);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading image: $e");
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<ui.Image>(
            future: _loadImage('assets/thirdphoto.webp'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color.fromARGB(255, 192, 158, 119),
                  child: const Center(
                    child: Icon(Icons.error),
                  ),
                );
              } else if (snapshot.hasData) {
                return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/thirdphoto.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.error),
                  ),
                );
              }
            },
          ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.2.sh,
                width: MediaQuery.of(context).size.width,
              ),
              Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/photo3.webp',
                  width: 0.65.sw,
                  colorBlendMode: BlendMode.plus,
                ),
              ),
              Text(
                "إغتنم",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                  color: const Color(0xFFD5CBBF),
                ),
              ),
              SizedBox(height: 0.02.sh),
              BlurryContainer(
                blur: 20,
                width: 0.8.sw,
                height: 0.1.sh,
                elevation: 0,
                color: const Color.fromARGB(118, 0, 0, 0),
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(83, 55, 53, 77),
                        shadowColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {
                        _signInWithGoogle(context);
                      },
                      child: SizedBox(
                        height: 0.03.sh,
                        width: 0.6.sw,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(AssetImage("assets/google.png")),
                            SizedBox(width: 0.05.sw),
                            Text(
                              "تسجيل الدخول عبر جوجل",
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

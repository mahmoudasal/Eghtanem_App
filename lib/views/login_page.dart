import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';
import '../widgets/custom_page_transition.dart';
import 'nav_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _precacheImages(context);
  }

  void _precacheImages(BuildContext context) {
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
                      style: AppTextSytle.headingsH1,
                    ),
                    SizedBox(height: 0.02.sh),
                    // Button container with padding instead of fixed width
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                      child: Container(
                        color: const Color.fromARGB(118, 0, 0, 0),
                        padding: const EdgeInsets.all(18),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(83, 55, 53, 77),
                            shadowColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              createRoute(
                                  const NavigationScreen(youtubeData: {})),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.02.sh),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const ImageIcon(
                                    AssetImage("assets/google.png")),
                                SizedBox(width: 0.03.sw),
                                Text(
                                  "تسجيل الدخول عبر جوجل",
                                  textDirection: TextDirection.rtl,
                                  style: AppTextSytle.headingsH5,
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

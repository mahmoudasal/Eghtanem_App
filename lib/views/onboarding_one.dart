import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/views/onboarding_two.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_text_styles.dart';
import '../widgets/custom_page_transition.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  late ImageProvider _backgroundImage;
  bool _isImageLoaded = false;
  bool _hasLoadedOnce = false;

  // Add references to other images to pre-cache
  final ImageProvider _secondPageImage =
      const AssetImage("assets/onboarding/onboarding_two.webp");
  final ImageProvider _logoImage =
      const AssetImage("assets/onboarding/onboarding_login.webp");
  final ImageProvider _loginPageImage =
      const AssetImage("assets/logo/logo.webp");

  @override
  void initState() {
    super.initState();
    _backgroundImage =
        const AssetImage("assets/onboarding/onboarding_one.webp");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedOnce) {
      _hasLoadedOnce = true;
      _precacheImages();
    }
  }

  void _precacheImages() async {
    // Check if widget is still mounted before starting
    if (!mounted) return;

    try {
      // Create a list of Future<void> for all precache operations
      final List<Future<void>> precacheFutures = [
        precacheImage(_backgroundImage, context),
        precacheImage(_secondPageImage, context),
        precacheImage(_loginPageImage, context),
        precacheImage(_logoImage, context),
      ];

      // Wait for all images to be precached
      await Future.wait(precacheFutures);

      // Check again if widget is still mounted before updating state
      if (mounted) {
        setState(() {
          _isImageLoaded = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error pre-caching images: $e");
      }
      // Check if mounted before updating state
      if (mounted) {
        setState(() {
          _isImageLoaded = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isImageLoaded
          ? Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _backgroundImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromARGB(80, 0, 0, 0),
                          Colors.black.withValues(alpha: 0.999),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '!مرحباً بك في إغتنم',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingsH1,
                    ),
                    SizedBox(
                      height: 15.h,
                      width: double.infinity,
                    ),
                    SizedBox(
                      width: 0.8.sw,
                      child: Text(
                        'قال رسولُ اللهِ صلَّى اللهُ عليه وسلَّم لرجلٍ وهو يَعِظُه : اغتنِمْ خمسًا قبل خمسٍ : شبابَك قبل هَرَمِك، وصِحَّتَك قبل سَقَمِك، وغناك قبل فقرِك، وفراغَك قبل شُغلِك، وحياتَك قبل موتِك',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headingsH2,
                      ),
                    ),
                    SizedBox(height: 0.12.sh),
                    SizedBox(
                      width: 0.9.sw,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            createRoute(const SecondPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary0,
                        ),
                        child: Text('إستمرار', style: AppTextStyles.headingsH3),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ],
            )
          : Container(
              color: Colors.black,
            ),
    );
  }
}

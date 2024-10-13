import 'package:egtanem_application/views/sec_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final ImageProvider _secondPageImage = const AssetImage("assets/photo2.webp");
  final ImageProvider _logoImage = const AssetImage("assets/photo3.webp");
  final ImageProvider _googlepngImage = const AssetImage("assets/google.png");
  final ImageProvider _loginPageImage =
      const AssetImage("assets/thirdphoto.webp");

  @override
  void initState() {
    super.initState();
    _backgroundImage = const AssetImage("assets/photo1.webp");
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
    try {
      // Pre-cache images
      await precacheImage(_backgroundImage, context);
      await precacheImage(_secondPageImage, context);
      await precacheImage(_loginPageImage, context);
      await precacheImage(_logoImage, context);
      await precacheImage(_googlepngImage, context);

      setState(() {
        _isImageLoaded = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error pre-caching images: $e");
      }
      setState(() {
        _isImageLoaded = false;
      });
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
                          Colors.black.withOpacity(0.999),
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
                      style: TextStyle(
                        fontFamily: "Almarai",
                        fontWeight: FontWeight.w800,
                        fontSize: 24.sp,
                        color: const Color(0xFFFAFAFA),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                      width: double.infinity,
                    ),
                    SizedBox(
                      width: 0.8.sw,
                      child: Text(
                        'قال رسولُ اللهِ صلَّى اللهُ عليه وسلَّم لرجلٍ وهو يَعِظُه : اغتنِمْ خمسًا قبل خمسٍ : شبابَك قبل هَرَمِك، وصِحَّتَك قبل سَقَمِك، وغناك قبل فقرِك، وفراغَك قبل شُغلِك، وحياتَك قبل موتِك.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Almarai",
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          color: const Color(0xFFFAFAFA),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.12.sh),
                    SizedBox(
                      width: 0.9.sw,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            createRoute(const SecondPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF94795B),
                        ),
                        child: Text(
                          'إستمرار',
                          style: TextStyle(
                            fontFamily: "Almarai",
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            color: const Color(0xFFFAFAFA),
                          ),
                        ),
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

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_page_transition.dart';
import 'main_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/thirdphoto.webp'),
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
                        Navigator.of(context)
                            .push(createRoute(const ShortsScreen()));
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

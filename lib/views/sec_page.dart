import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_page_transition.dart';
import 'login_page.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/photo2.webp"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(120, 0, 0, 0),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('زكاة الوقت تأديته في مرضاة الله',
                      textAlign: TextAlign.center,
                      style: AppTextSytle.headingsH1),
                  SizedBox(height: 25.h),
                  Text(
                    'استمتع بمشاهدة و سماع ما ينفعك في دنياك و اخرتك',
                    textAlign: TextAlign.center,
                    style: AppTextSytle.headingsH2,
                  ),
                  SizedBox(height: 120.h),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(createRoute(const LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary0,
                      ),
                      child: Text(
                        'ابدأ المشاهدة',
                        style: AppTextSytle.headingsH2,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

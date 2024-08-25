// ignore_for_file: unused_element

import 'dart:ui' as ui;

import 'package:egtanem_application/views/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_page_transition.dart';
import 'login_page.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});
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
            future: _loadImage("assets/photo2.webp"),
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
                      image: AssetImage("assets/photo2.webp"),
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
                    const Color.fromARGB(120, 0, 0, 0),
                    Colors.black.withOpacity(0.9999),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 0.53.sh,
                width: 1.sw,
              ),
              Text(
                'تابع القنوات الدينية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 25.sp,
                  color: const Color(0xFFF2EEEB),
                ),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              Text(
                'استمتع بمشاهدة فيديوهات قصيرة ومفيدة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 25.sp,
                  color: const Color(0xFFFAFAFA),
                ),
              ),
              SizedBox(
                height: 0.22.sh,
              ),
              SizedBox(
                width: 0.9.sw,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(createRoute(LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF94795B),
                  ),
                  child: Text(
                    'ابدأ المشاهدة',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                      color: const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

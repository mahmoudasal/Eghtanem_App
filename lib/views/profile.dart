import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:asset_cache/asset_cache.dart';

final imageAssets = ImageAssetCache(basePath: '');

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
      backgroundColor: const Color(0xff1D1D1B),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            buildBackground(),
            Column(
              children: [
                SizedBox(height: 0.173.sh, width: 1.sw),
                buildProfilePicture(),
                buildProfileName(),
                buildProfileStats(),
                buildEditProfileButton(),
                buildPreferencesHeader(),
                buildPreferencesDivider(),
                buildPreferencesGrid(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBackground() {
    return ClipPath(
      clipper: CurveUpClipper(),
      child: Stack(
        children: [
          SizedBox(
            width: 1.sw,
            height: 0.25.sh,
            child: FutureBuilder<ui.Image>(
              future: _loadImage('assets/profileBG.webp'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error),
                    ),
                  );
                } else {
                  return RawImage(
                    image: snapshot.data,
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(101, 121, 88, 50),
                    const Color.fromARGB(255, 121, 88, 50).withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfilePicture() {
    return FutureBuilder<ui.Image>(
      future: _loadImage('assets/bilal profile photo.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 100.w,
            height: 100.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xffFFFFFF),
                  Color(0x79583233),
                ],
                end: Alignment.bottomRight,
                begin: Alignment.topLeft,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            width: 100.w,
            height: 100.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xffFFFFFF),
                  Color(0x79583233),
                ],
                end: Alignment.bottomRight,
                begin: Alignment.topLeft,
              ),
            ),
            child: const Center(
              child: Icon(Icons.error),
            ),
          );
        } else {
          return Container(
            width: 100.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xffFFFFFF),
                  Color(0x79583233),
                ],
                end: Alignment.bottomRight,
                begin: Alignment.topLeft,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 47.r,
              child: CircleAvatar(
                backgroundColor: const Color(0xff1D1D1B),
                radius: 45.r,
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.transparent,
                  child: RawImage(
                    image: snapshot.data,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

Widget buildProfileName() {
  return Column(
    children: [
      SizedBox(height: 0.01.sh),
      Text(
        "بلال بخيت",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
          fontSize: 24.sp,
          color: const Color(0xFFF2EEEB),
        ),
      ),
      SizedBox(height: 0.02.sh),
    ],
  );
}

Widget buildProfileStats() {
  return Column(
    children: [
      buildStatsRow(),
      SizedBox(height: 0.03.sh),
    ],
  );
}

Widget buildStatsRow() {
  return Column(
    children: [
      SizedBox(
        width: 0.48.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildStatItem("85"),
            buildStatItem("90"),
          ],
        ),
      ),
      SizedBox(
        width: 0.48.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildStatLabel("إعجاب"),
            buildStatLabel("متابعون"),
          ],
        ),
      ),
    ],
  );
}

Widget buildStatItem(String value) {
  return Text(
    value,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: 'Almarai',
      fontWeight: FontWeight.w700,
      fontSize: 20.sp,
      color: const Color(0xFFF2EEEB),
    ),
  );
}

Widget buildStatLabel(String label) {
  return Text(
    label,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: 'Almarai',
      fontWeight: FontWeight.w400,
      fontSize: 20.sp,
      color: const Color(0xFFF2EEEB),
    ),
  );
}

Widget buildEditProfileButton() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(164, 143, 136, 118),
              shadowColor: const Color.fromARGB(0, 255, 255, 255),
            ),
            child: Text(
              "تعديل الملف الشخصي",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                fontSize: 19.sp,
                color: const Color(0xFFF2EEEB),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 0.05.sh),
    ],
  );
}

Widget buildPreferencesHeader() {
  return Row(
    textDirection: TextDirection.rtl,
    children: [
      SizedBox(width: 0.04.sw),
      Text(
        "تفضيلات",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: const Color(0xFFF2EEEB),
        ),
      ),
    ],
  );
}

Widget buildPreferencesDivider() {
  return Column(
    children: [
      SizedBox(height: 0.012.sh),
      Container(
        width: 1.sw,
        height: 0.0015.sh,
        color: const Color(0x9d9d9b80),
      ),
    ],
  );
}

Widget buildPreferencesGrid() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    ),
  );
}

class CurveUpClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0020000, size.height * 0.0028571);
    path_0.quadraticBezierTo(size.width * -0.0051000, size.height * 0.8547857,
        size.width * -0.0040000, size.height * 0.9985714);
    path_0.cubicTo(
        size.width * 0.4740000,
        size.height * 0.9985714,
        size.width * 0.2869000,
        size.height * 0.6352143,
        size.width * 0.4996000,
        size.height * 0.6382857);
    path_0.cubicTo(
        size.width * 0.7153000,
        size.height * 0.6432143,
        size.width * 0.5222600,
        size.height * 1.0008571,
        size.width * 1.0054200,
        size.height * 1.0001000);
    path_0.quadraticBezierTo(size.width * 1.0043150, size.height * 0.7500750,
        size.width * 1.0010000, 0);

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

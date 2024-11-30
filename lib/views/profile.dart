import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:social_share/social_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
// import 'package:social_share/social_share.dart';

import '../controller/secure_token.dart'; // Import your storage service

final imageAssets = ImageAssetCache(basePath: '');

class Hadith {
  final int number;
  final String hadith;
  final String description;

  Hadith({
    required this.number,
    required this.hadith,
    required this.description,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      number: json['number'],
      hadith: json['hadith'],
      description: json['description'],
    );
  }
}

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? youtubeData;

  const ProfilePage({super.key, required this.youtubeData});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? youtubeData;
  late Future<Hadith?> futureRandomHadith;
  bool isOfflineMode = false; // Flag to indicate offline mode
  final Logger logger = Logger();
  final storageService = SecureStorageService(); // Access storage service

  @override
  void initState() {
    super.initState();
    youtubeData = widget.youtubeData;
    futureRandomHadith = _loadRandomHadith();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (youtubeData == null || youtubeData!.isEmpty) {
      // Delay the call to ensure the platform channels are ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadYoutubeDataFromCache();
      });
    }
  }

  Future<void> _loadYoutubeDataFromCache() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? youtubeDataJson = prefs.getString('youtubeData');
      if (youtubeDataJson != null) {
        setState(() {
          youtubeData = json.decode(youtubeDataJson);
        });
      } else {
        // Handle case where no cached data is available
        // Set isOfflineMode to true to indicate that the app is in offline mode
        setState(() {
          isOfflineMode = true;
        });
      }
    } catch (e) {
      logger.e('Error loading YouTube data from cache: $e');
      setState(() {
        isOfflineMode = true;
      });
    }
  }

  Future<Hadith?> _loadRandomHadith() async {
    try {
      final String response =
          await rootBundle.loadString('assets/quran_metadata/ibn_maja.json');
      final List<dynamic> data = json.decode(response);

      List<Hadith> hadiths = data.map((json) => Hadith.fromJson(json)).toList();

      if (hadiths.isNotEmpty) {
        final random = Random();
        return hadiths[random.nextInt(hadiths.length)];
      }
      return null;
    } catch (e) {
      // Log error and stacktrace for further analysis

      // Optionally, notify the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading Hadith: $e')),
        );
      }
      return null;
    }
  }

  Future<ui.Image> _loadImage(String path) async {
    try {
      return await imageAssets.load(path);
    } catch (e) {
      // Log the error for the image loading issue
      logger.e('Error loading image: $e');
      rethrow;
    }
  }

  // void _shareHadith(String hadithText) async {
  //   try {
  //     await SocialShare.shareOptions(hadithText);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Hadith shared successfully')),
  //     );
  //   } catch (e) {
  //     // Handle sharing errors and notify the user
  //     logger.e('Error sharing Hadith: $e');
  //   }
  // }

  void _supportApp() {
    // Implement the functionality to support the app here
    // You can navigate to a donation page or integrate with a payment gateway like PayPal, Stripe, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('شكراً لدعمك التطبيق')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String channelName =
        youtubeData?['snippet']?['title'] ?? 'وضع عدم الاتصال';
    final String channelPhotoUrl = youtubeData?['snippet']?['thumbnails']
            ?['default']?['url'] ??
        'assets/photo1.webp';

    return Scaffold(
      backgroundColor: const Color(0xff1D1D1B),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            buildBackground(),
            Column(
              children: [
                SizedBox(height: 0.173.sh, width: 1.sw),
                buildProfilePicture(channelPhotoUrl),
                buildProfileName(channelName),
                if (isOfflineMode)
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Text(
                      'وضع عدم الاتصال: بعض الميزات قد تكون غير متوفرة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                SizedBox(height: 0.01.sh),
                _buildRandomHadithSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomHadithSection() {
    return FutureBuilder<Hadith?>(
      future: futureRandomHadith,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading Hadith: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              'No Hadith available.',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          final hadith = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'التذكير اليومي',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: const Color(0xFFF2EEEB),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  textDirection: TextDirection.rtl,
                  hadith.hadith,
                  style: TextStyle(
                    fontFamily: 'ScheherazadeNew',
                    fontSize: 20.sp,
                    color: const Color(0xFFFAFAFA),
                  ),
                ),
                SizedBox(height: 20.h),
                _buildShareButtons(hadith),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildShareButtons(Hadith hadith) {
    final String hadithText = "${hadith.hadith}\n\n${hadith.description}";

    return Column(
      children: [
        // Wide button to share Hadith
        // SizedBox(
        //   width: double.infinity,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: const Color(0xFF94795B),
        //       padding: EdgeInsets.symmetric(vertical: 10.h),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //     onPressed: () => _shareHadith(hadithText),
        //     child: Text(
        //       'شارك الحديث',
        //       style: TextStyle(
        //         fontFamily: 'Almarai',
        //         fontWeight: FontWeight.w700,
        //         fontSize: 20.sp,
        //         color: const Color(0xFFF2EEEB),
        //       ),
        //     ),
        //   ),
        // ),
        SizedBox(height: 10.h),

        // Add Support button
        SizedBox(
          width: 120.w,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF94795B),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _supportApp();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                textDirection: TextDirection.rtl,
                'ادعم التطبيق',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
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
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Icon(Icons.error));
                } else {
                  return RawImage(image: snapshot.data, fit: BoxFit.cover);
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

  Widget buildProfilePicture(String photoUrl) {
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
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 47.r,
        backgroundImage: photoUrl.startsWith('assets/')
            ? AssetImage(photoUrl) as ImageProvider
            : NetworkImage(photoUrl),
      ),
    );
  }

  Widget buildProfileName(String name) {
    return Column(
      children: [
        SizedBox(height: 0.005.sh),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 24.sp,
            color: const Color(0xFFF2EEEB),
          ),
        ),
      ],
    );
  }

  void _retryFetchingData() async {
    setState(() {
      isOfflineMode = false;
    });
    // Attempt to fetch youtubeData again
    try {
      final String? accessToken = await storageService.read('accessToken');
      if (accessToken != null) {
        youtubeData = await _fetchYouTubeChannelInfo(accessToken);
        // Save to cache
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('youtubeData', json.encode(youtubeData));
        setState(() {});
      } else {
        // User needs to sign in again
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الرجاء تسجيل الدخول مرة أخرى')),
          );
          // Optionally, navigate to login page
          // Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      // Handle exception and set offline mode back to true
      setState(() {
        isOfflineMode = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في جلب البيانات: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _fetchYouTubeChannelInfo(
      String accessToken) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/youtube/v3/channels?part=snippet,statistics&mine=true'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'].isNotEmpty) {
        return data['items'][0];
      } else {
        throw Exception('No channel found for the user.');
      }
    } else {
      // Handle error responses
      throw Exception('Failed to fetch YouTube channel info');
    }
  }
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

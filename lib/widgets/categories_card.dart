import 'dart:ui' as ui;
import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './custom_page_transition.dart';

final imageAssets = ImageAssetCache(basePath: '');

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String cardName;
  final Widget Function() pageBuilder;

  const CustomCard({
    super.key,
    required this.imagePath,
    required this.cardName,
    required this.pageBuilder,
  });

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
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(createRoute(pageBuilder()));
      },
      child: Card(
        elevation: 0.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Stack(
          children: [
            FutureBuilder<ui.Image>(
              future: _loadImage(imagePath),
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
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.fill,
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
                      const Color.fromARGB(100, 121, 88, 50),
                      const Color.fromARGB(255, 121, 88, 50).withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 0.15.sh,
                ),
                SizedBox(
                  width: 0.5.sw,
                  child: Center(
                    child: Text(
                      cardName,
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        fontSize: 0.025.sh,
                        height: 1.2,
                        color: const Color(0xFFFAFAFA),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

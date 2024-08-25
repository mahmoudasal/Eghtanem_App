import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../data/azkar_json.dart';

class SupplicationsRemembrances extends StatelessWidget {
  const SupplicationsRemembrances({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff1D1D1B),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100.h,
        centerTitle: true,
        backgroundColor: const Color(0xff1D1D1B),
        shadowColor: const Color(0xff1D1D1B),
        foregroundColor: const Color(0xff1D1D1B),
        title: Text(
          'الادعية و الاذكار',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 25.sp,
            height: 1.2,
            color: const Color(0xFFFAFAFA),
          ),
        ),
        leading: const SizedBox(width: 0.0),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/ui icons/BackButton.svg"),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(
                width: 35.w,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: AdhkarService().loadAdhkar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ExpansionTile(
                  title: Text(
                    category.category,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                  children: category.array.map((dhikr) {
                    return ListTile(
                      title: Text(
                        dhikr.text,
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      subtitle: Text(
                        'Count: ${dhikr.count}',
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        onPressed: () {
                          // Play audio functionality
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            );
          } else {
            return const Center(child: const Text('No data found'));
          }
        },
      ),
    );
  }
}

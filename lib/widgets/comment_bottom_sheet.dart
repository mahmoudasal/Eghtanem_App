import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCommentBottomSheet(BuildContext context, String profilePic) {
  bool isCommentLike = false; // Define locally for the sheet

  showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 46, 46, 46),
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Use StatefulBuilder to handle local state
          return Container(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                Text(
                  "تعليقات",
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    height: 1.2,
                    color: const Color(0xFFFAFAFA),
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  flex: 3,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                child: SvgPicture.asset(
                                  isCommentLike
                                      ? 'assets/ui icons/like on.svg'
                                      : 'assets/ui icons/Like off.svg',
                                  width: 24.w,
                                  height: 24.h,
                                ),
                                onTap: () {
                                  setState(() {
                                    isCommentLike = !isCommentLike;
                                  });
                                },
                              ),
                              Text(
                                "8952",
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  height: 1.2,
                                  color: const Color(0xFFFAFAFA),
                                ),
                              )
                            ],
                          ),
                          title: Text(
                            "اسم الحساب",
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              height: 1.2,
                              color: const Color(0xFFFAFAFA),
                            ),
                          ),
                          subtitle: Text(
                            "التعليق",
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              height: 1.2,
                              color: const Color(0xFFFAFAFA),
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 15.r,
                            backgroundImage: AssetImage(profilePic),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'أضف تعليق ... ',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 74, 74, 74),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

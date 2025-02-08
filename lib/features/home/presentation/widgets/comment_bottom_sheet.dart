import 'package:egtanem_application/features/home/data/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CommentBottomSheet extends StatelessWidget {
  final String videoId;

  const CommentBottomSheet({super.key, required this.videoId, required List<Comment> comments});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        duration: const Duration(milliseconds: 100),
        child: FractionallySizedBox(
          heightFactor: 0.6,
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              color: AppColors.primary1,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(children: [
              Text("تعليقات", style: AppTextStyles.headingsH7),
              SizedBox(height: 10.h),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      ListTile(
                        leading: const CircleAvatar(
                          radius: 8.0,
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/id/1005/200/300',
                          ),
                        ),
                        title: const Text(
                          'ا��م المستخدم',
                        ),
                        subtitle: const Text(
                          'تاريخ التعليق',
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () {},
                      );
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              buildCommentInputField()
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildCommentInputField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: 'أضف تعليق ... ',
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontFamily: 'Almarai',
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 74, 74, 74),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
        ),
      ),
    );
  }
}

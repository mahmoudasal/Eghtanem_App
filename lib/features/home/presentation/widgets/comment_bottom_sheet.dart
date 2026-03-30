import 'package:eghtanem_app/features/home/data/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eghtanem_app/core/theme/app_colors.dart';
import 'package:eghtanem_app/core/theme/app_text_styles.dart';

class CommentBottomSheet extends StatefulWidget {
  final String videoId;
  final List<Comment> comments;

  const CommentBottomSheet({
    super.key,
    required this.videoId,
    required this.comments,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late List<Comment> _comments;
  final TextEditingController _controller = TextEditingController();

  static const List<Color> _avatarColors = [
    Color(0xFF94795B),
    Color(0xFF5B8994),
    Color(0xFF94625B),
    Color(0xFF5B9475),
    Color(0xFF7A5B94),
    Color(0xFF94905B),
  ];

  @override
  void initState() {
    super.initState();
    _comments = List<Comment>.from(widget.comments);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static final _htmlTagRegex = RegExp(r'<[^>]*>');

  void _sendComment() {
    final text = _controller.text.trim().replaceAll(_htmlTagRegex, '');
    if (text.isEmpty) return;
    setState(() {
      _comments.add(Comment(
        id: DateTime.now().millisecondsSinceEpoch,
        userName: 'أنت',
        content: text,
      ));
    });
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  Color _avatarColor(String? name) {
    if (name == null || name.isEmpty) return _avatarColors[0];
    return _avatarColors[name.codeUnitAt(0) % _avatarColors.length];
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0][0];
  }

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
          heightFactor: 0.65,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: const BoxDecoration(
              color: AppColors.primary1,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'التعليقات (${_comments.length})',
                  style: AppTextStyles.headingsH7.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: _comments.isEmpty
                      ? Center(
                          child: Text(
                            'لا توجد تعليقات بعد',
                            style: AppTextStyles.headingsH7.copyWith(
                              color: Colors.white38,
                            ),
                          ),
                        )
                      : Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListView.separated(
                            itemCount: _comments.length,
                            separatorBuilder: (_, __) => Divider(
                              color: Colors.white12,
                              height: 1.h,
                            ),
                            itemBuilder: (context, index) {
                              final comment = _comments[index];
                              final name = comment.userName ?? '';
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: _avatarColor(name),
                                      child: Text(
                                        _initials(name),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontFamily: 'Almarai',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: AppTextStyles.headingsH7
                                                .copyWith(
                                              color: AppColors.primary0,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            comment.content ?? '',
                                            style: AppTextStyles.headingsH7
                                                .copyWith(
                                              color: Colors.white70,
                                              fontSize: 13.sp,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
                SizedBox(height: 10.h),
                _buildCommentInputField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Almarai',
              ),
              decoration: InputDecoration(
                hintText: 'أضف تعليقاً...',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                  fontFamily: 'Almarai',
                ),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 16.w,
                ),
              ),
              onFieldSubmitted: (_) => _sendComment(),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _sendComment,
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary0,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

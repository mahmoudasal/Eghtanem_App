import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubits/comments_cubit/comments_cubit.dart';

class CommentBottomSheet extends StatelessWidget {
  final String videoId;

  const CommentBottomSheet({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommentsCubit()..fetchComments(videoId),
      child: GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // Dismiss keyboard when tapping outside
        child: AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: const Duration(milliseconds: 100),
          child: FractionallySizedBox(
            heightFactor: 0.6, // Adjusted height factor
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 46, 46, 46),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
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
                    child: BlocBuilder<CommentsCubit, CommentsState>(
                      builder: (context, state) {
                        if (state is CommentsLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is CommentsLoaded) {
                          final comments = state.comments;
                          final hasMore = state.hasMore;
                          final isLoadingMore = state.isLoadingMore;

                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!isLoadingMore &&
                                  hasMore &&
                                  scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent &&
                                  !(context.read<CommentsCubit>().isLoading)) {
                                context
                                    .read<CommentsCubit>()
                                    .fetchComments(videoId, loadMore: true);
                              }
                              return false;
                            },
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ListView.builder(
                                itemCount:
                                    comments.length + (isLoadingMore ? 1 : 0),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == comments.length &&
                                      isLoadingMore) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (index >= comments.length) {
                                    return const SizedBox.shrink();
                                  }

                                  final comment = comments[index];
                                  return ListTile(
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          child: SvgPicture.asset(
                                            'assets/ui icons/Like off.svg',
                                            width: 23.w,
                                            height: 23.h,
                                          ),
                                          onTap: () {
                                            // Handle like action for comments if required
                                          },
                                        ),
                                        Text(
                                          comment['likeCount'].toString(),
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
                                      comment['authorDisplayName'],
                                      style: TextStyle(
                                        fontFamily: 'Almarai',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        height: 1.2,
                                        color: const Color(0xFFFAFAFA),
                                      ),
                                    ),
                                    subtitle: Text(
                                      comment['commentText'],
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
                                      backgroundImage: NetworkImage(
                                          comment['authorProfileImageUrl']),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else if (state is CommentsError) {
                          return Center(child: Text(state.errorMessage));
                        } else {
                          return const Center(child: Text('Unknown error'));
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  buildCommentInputField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../cubits/quran_page_slider/cubit/quran_cubit.dart';
import '../../../cubits/quran_page_slider/cubit/quran_state.dart';

class SurahPage extends StatelessWidget {
  final String initialPage;

  const SurahPage({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurahPageCubit(initialPage),
      child: BlocBuilder<SurahPageCubit, SurahPageState>(
        builder: (context, state) {
          final cubit = context.read<SurahPageCubit>();

          if (state is SurahPageError) {
            return Scaffold(
              body: Center(
                child: Text(
                  state.errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 18.sp),
                ),
              ),
            );
          }

          if (state is SurahPageLoaded) {
            return Scaffold(
              body: Stack(
                children: [
                  PageView.builder(
                    reverse: true,
                    controller: cubit.pageController,
                    itemCount: 604, // Fixed count for Quran pages
                    onPageChanged: cubit.onPageChanged,
                    itemBuilder: (context, index) {
                      final int pageIndex = index + 1;

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 35, 0, 25),
                        child: Image.asset(
                          "assets/quran_images/$pageIndex.png",
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Image not found for page $pageIndex',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 18.sp),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 8,
                    left: 20,
                    right: 20,
                    child: Container(
                      color: Colors.transparent,
                      child: Slider(
                        activeColor: const Color.fromARGB(255, 192, 158, 119),
                        value: state.currentPage.toDouble(),
                        min: 0,
                        max: 603, // Maximum value corresponds to page 604
                        divisions: 603, // Divisions for each page
                        label: '${state.currentPage + 1}', // 1-based number
                        onChanged: cubit.onSliderChanged,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

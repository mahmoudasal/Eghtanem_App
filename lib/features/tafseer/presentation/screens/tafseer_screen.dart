// presentation/screens/tafseer/tafseer_screen.dart
import 'package:egtanem_application/core/constants/constant.dart';
import 'package:egtanem_application/core/theme/app_colors.dart';
import 'package:egtanem_application/features/tafseer/data/repositories/tafseer_repository_impl.dart';
import 'package:egtanem_application/features/tafseer/presentation/cubit/tafseer_cubit.dart';
import 'package:egtanem_application/features/tafseer/presentation/widgets/surah_card.dart';

import 'package:egtanem_application/features/tafseer/presentation/widgets/tafseer_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// Updated TafseerScreen
class TafseerScreen extends StatelessWidget {
  const TafseerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TafseerCubit(TafseerRepositoryImpl()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.primary1,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          toolbarHeight: 100.h,
          title: const Text("التفسير"),
          leading: const SizedBox(),
          actions:  [Constants.backButton(context)],
        ),
        body: const TafseerGrid(),
      ),
    );
  }
}


class TafseerGrid extends StatelessWidget {
  const TafseerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TafseerCubit, TafseerState>(
      builder: (context, state) {
        final cubit = context.read<TafseerCubit>();

        if (state is TafseerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TafseerError) {
          return Center(child: Text(state.message));
        }

        return GridView.builder(
          padding: EdgeInsets.all(16.r),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.5,
          ),
          itemCount: Constants.suraNames.length,
          itemBuilder: (context, index) => SurahCard(
            suraIndex: index,
            onTap: () => cubit.showTafseerBottomSheet(context, index),
          ),
        );
      },
    );
  }
}

// Updated TafseerCubit with bottom sheet logic
extension BottomSheetExtension on TafseerCubit {
  void showTafseerBottomSheet(BuildContext context, int suraIndex) {
    if (state is! TafseerLoaded) return;
    
    final suraNumber = suraIndex + 1;
    final suraInterpretations = getSuraInterpretations(suraNumber);

    if (suraInterpretations.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primary1,
      builder: (_) => TafseerBottomSheet(
        suraName: Constants.suraNames[suraIndex],
        interpretations: suraInterpretations,
      ),
    );
  }
}
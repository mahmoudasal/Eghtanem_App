import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'quran_state.dart';

class SurahPageCubit extends Cubit<SurahPageState> {
  late PageController pageController;
  int currentPage;

  SurahPageCubit(String initialPage)
      : currentPage = int.parse(initialPage) - 1,
        super(SurahPageInitial()) {
    pageController = PageController(initialPage: currentPage);
    loadInitialPage();
  }

  void loadInitialPage() {
    try {
      emit(SurahPageLoaded(currentPage));
    } catch (e) {
      emit(const SurahPageError('Failed to load page.'));
    }
  }

  void onPageChanged(int index) {
    currentPage = index;
    emit(SurahPageLoaded(currentPage));
  }

  void onSliderChanged(double value) {
    currentPage = value.toInt();
    pageController.jumpToPage(currentPage);
    emit(SurahPageLoaded(currentPage));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
